---
title: Capistrano and TorqueBox
author: Bob McWhirter
layout: news
---

[capistrano]: https://github.com/capistrano/capistrano/wiki
[jbossas]:    http://jboss.org/jbossas

A lot of folks use [Capistrano][capistrano] to move their code to
production servers.  Using TorqueBox doesn't mean you have to 
change the way you deploy.  We include modifications to the regular 
Capistrano recipes, plus a few extra to make life easier when
deploying to a TorqueBox server.

## Hot Deploy is Cool

TorqueBox is an application server, not simply a set of libraries
to bind your application to HTTP traffic on port 80.

[web-as-library]: http://torquebox.org/documentation/1.0.0.Beta23/images/differences-traditional.png
[app-server]:     http://torquebox.org/documentation/1.0.0.Beta23/images/differences-torquebox.png

![Traditional web-as-library][web-as-library]

Instead, you toss your app at the already-running app-server.  

From TorqueBox's point of view, *your application isn't special*.
It's just yet-another-thing it needs to wire up and make available.
TorqueBox (and JBoss) can serve many applications simultaneously,
adding, removing and redeploying each along its own lifecycle.

![TorqueBox app-server][app-server]

This all happens without restarting the server, using *hot deploy*.
Hot deploy allows the app-server to notice when an application has
been added, removed, or updated, and responds correctly.

This means that Capistrano has slightly less work to perform
when deploying an application.  It'd be bad form to restart
the server, in fact.  TorqueBox ships with adjustments to the
standard recipes to behave appropriately.

## Install Capistrano

TorqueBox ships with support for Capistrano, but Capistrano itself is 
not installed by default.  You'll need to install it into your local 
system (not the system you're deploying to).

Along with the `capistrano` gem, you should also ensure a few other
gems are installed:

    jruby -S gem install jruby-openssl ffi-ncurses capistrano

## Capify your application

Make sure you are in the root of your application's tree, and invoke
`capify` on the current directory:

    jruby -S capify .

## Basic `config/deploy.rb` configuration

The `capify` command above created a new file under `config/` 
named `deploy.rb`.  This is where your Capistrano deployment
is primarily controlled.  

The first thing we need to do is import the TorqueBox recipes
into our `deploy.rb` file.  If your application uses Bundler, 
now is a good time to include Bundler's recipes also.

    require 'org.torquebox.capistrano-support'
    require 'bundler/capistrano'

A few standard variables need to be set to control the general
operation of Capistrano for your application.

    set :application, "testapp"
    set :repository,  "."
    set :user,        "bob"
    set :deploy_to,   "/home/bob/apps/testapp"
    set :deploy_via,  :copy
    set :use_sudo,    false

In the above, my application is named `testapp`, and it will
be deployed simply by copying the contents of my local workspace
across to the server, into the `apps/` directory within my home directory
on the deployment server.  

I've also instructed Capistrano to *not* use sudo. 

You may certainly use repository-based deployment strategies
with Capistrano, having it check code out of a Subversion, Git,
or other repositories.

Also, set up the typical role-to-server mappings so that Capistrano
knows where your application is hosted, and where your database is
kept.  Here, I'm deploying to a linux server named `captest.local`
that is running inside VMware:

    role :web, "captest.local"                          
    role :app, "captest.local"                         
    role :db,  "captest.local", :primary => true

## TorqueBox-specific `config/deploy.rb` configuration

Even though we don't typically restart the server after deploying
your application, we do need to occasionally control the server
and we definitely need to know where we should put deployments.

We need to know the locations of JBoss and JRuby on the remote server. 
If you simply unzipped the TorqueBox distribution somewhere, set
`:torquebox_home` to this location, and we can figure out where
JBoss and JRuby are from there.

    set :torquebox_home,    '/home/bob/torquebox-current'

If you have a non-standard installation, you may set `:jboss_home`
and `:jruby_home` individually.

    set :jboss_home,      '/opt/jboss'
    set :jruby_home,      '/usr/local/jruby'

Remember, all of these `_home` paths reference paths *on the remote 
server*, not your local machine.

## Controlling TorqueBox AS with Capistrano

In the event you do need to start or stop the TorqueBox AS, you have
two options:

* `/etc/init.d` 
* `bin/` scripts

### `/etc/init.d`

JBoss includes a variety of `init.d` scripts in the distribution
in the `$JBOSS_HOME/bin/` directory.  You may find the one
appropriate to your platform and use it under `/etc/init.d/`.

By default, the TorqueBox Capistrano recipes assume an `init.d`
script is used to control the server.  When you issue commands
such as `jruby -S cap deploy:start` or `jruby -S cap deploy:stop`,
instead of trying to manage a pack of mongrels (or whatever),
Capistrano will send the appropriate signals to the `init.d`
script.

If the default init.d script name of `jbossas` is not appropriate
for your deployment strategy, you may adjust the location of the
script using the `:jboss_init_script` variable:

    set :jboss_init_script, '/etc/init.d/my-fancy-jboss'

### `bin/` scripts

Occasionally you might want to control TorqueBox AS not through
`init.d`, but directly using the `bin/run.sh` scripts.  This is
useful on systems where you might not have `root` access.

To use `bin/` script, simply set the `:jboss_control_style` variable:

    set :jboss_control_style, :binscripts

Now, `deploy:start` and `deploy:stop` will use `bin/run.sh` and
`bin/shutdown.sh` to control the server.

## And deploy!

Once you've accomplished the basic setup, deployment to TorqueBox
using Capistrano works as you might expect.

    jruby -S cap deploy

Code will be moved to your production server, the `current` symlink
will be created, a basic `*-rails.yml` will be created.

If your server is already running, then *you're done!*

If your server is not running, that's okay.  You can deploy and
undeploy apps irrespective of the current state of the server.

When you want to start the server, and all apps already deployed
to it:

    jruby -S cap deploy:start

### Don't forget `torquebox.yml`

The recipe to deploy the `*-rails.yml` file writes the barest 
deployment descriptor possible, only setting `RAILS_ROOT`.

Your application should include a `config/torquebox.yml` to
set details for your application, such as `RAILS_ENV` to `production`.
Additionally, web configuration, such as virtual-host or 
context path settings should be included.

When developing locally, and using the `rake torquebox:deploy`
task, these values are generated for you, defaulting to the 
`development` environment.  When using Capistrano to deploy,
you need to ensure that production versions of these values
are used:

    application:
      RAILS_ENV: production
    web
      host: myawesome.com
      context: /

## Everything else

The majority of the adjustments TorqueBox brings to Capistrano
involve deployment of application code and lifecycle-management
of the app-server.

Everything else should work-as-expected, assuming you are using
tyipcal configurations. 

For example, if you have Apache `httpd` in front of your TorqueBox
server, the traditional `mod_rewrite` strategy for controlling
a *maintenance* page still works.

The various steps Capistrano takes to perform a deployment are
still directly invokable for piece-meal execution.

    jruby -S cap deploy:update_code
    jruby -S cap deploy:symlink
    jruby -S cap deploy:migrate
    jruby -S cap deploy:web:enable


