---
title: 'Using RVM with TorqueBox'
author: Lance Ball
layout: news
tags: [rvm, setup, installation]
---

[examples]: https://github.com/torquebox/torquebox/tree/master/integration-tests/apps/alacarte
[rvm]: http://rvm.beginrescueend.com/
[rvm-install]: http://rvm.beginrescueend.com/rvm/install/
[ci]: http://torquebox.org/torquebox-dev.zip

# Using RVM With TorqueBox
We've been getting quite a few requests in IRC lately asking how to set up and use [RVM][rvm] with TorqueBox.
In this post, we'll take a look at RVM, talk about why you might want to use it in your development
environment, and show you how to set it up for use with TorqueBox.

## What is RVM and Why Use It?
RVM is a command line tool that helps you keep track of multiple, named ruby environments.  Each
environment can have its own set of gems and has a specific ruby interpreter, such as 
ruby-1.8.7, ree-1.8.7, or jruby-1.5.6.  This makes it very simple to have separate, named gem sets
and ruby interpreters for each of your applications &mdash; isolating them from one another and
potential version conflicts.  This is useful in a number of circumstances.

  * You are working on a few different apps that have a large number of gem dependencies - some with
    conflicting versions, and you'd like to keep them isolated.
  * You have multiple environments for a single application (e.g. development, staging, production)
    and you want to ensure identical runtime environments on each.
  * You want an easy way to test upgrades to your gem dependencies.
  
For these and other reasons, I'm a big fan of RVM and use it in my daily development work.
If you're not already using RVM, you'll need to [install it][rvm-install] if you want to follow along.
Don't worry, the installation is quick and painless.

## Setting Up Your Development Environment
TorqueBox runs on some pretty awesome foundations like JBossAS and JRuby, both of which we ship with the
[continuous integration builds][ci]. With RVM, however, we'll install our own JRuby and use that. It's 
all the same to TorqueBox as long as we twist the right knobs.  First let's install JRuby under RVM &mdash;
TorqueBox requires 1.5.6, so that's what we'll install.

    $ rvm install jruby-1.5.6
    $ rvm use jruby-1.5.6
    $ rvm info
    
This will install the JRuby interpreter, switch your environment to the new install, and show you all
kinds of info about it. About half way down the `rvm info` output, you'll see the "homes" section.
Copy the ruby path, mine looks like this: `ruby: "/Users/lanceball/.rvm/rubies/jruby-1.5.6"`.
Set that as your JRUBY_HOME in your ~/.profile.

    echo "export JRUBY_HOME=/Users/lanceball/.rvm/rubies/jruby-1.5.6" >> ~/.profile

That's all you have to do to get TorqueBox to use RVM's JRuby interpreter &mdash; easy!

## Default Gemsets
Now we've got TorqueBox using RVM's JRuby interpreter, but to run apps under TorqueBox, they need
the TorqueBox gems installed.  So let's ensure that they are always available when we're using JRuby.

    $ rvm use jruby-1.5.6@global
    $ gem install org.torquebox.container-foundation --pre
    $ gem install org.torquebox.messaging-client --pre
    $ gem install org.torquebox.messaging-container --pre
    $ gem install org.torquebox.naming-client --pre
    $ gem install org.torquebox.naming-container --pre
    $ gem install org.torquebox.rake-support --pre
    $ gem install bundler
    $ gem list
    
    *** LOCAL GEMS ***

    bundler (1.0.10)
    org.torquebox.container-foundation (1.0.0.CR1)
    org.torquebox.messaging-client (1.0.0.CR1)
    org.torquebox.messaging-container (1.0.0.CR1)
    org.torquebox.naming-client (1.0.0.CR1)
    org.torquebox.naming-container (1.0.0.CR1)
    org.torquebox.rake-support (1.0.0.CR1)

This installs all of the required TorqueBox gems into the global gemset for JRuby-1.5.6, ensuring their
availability whenever you're using JRuby &mdash; awesome!  I put bundler in there too, because I find it 
essential for all apps.  Be sure to use the `--pre` flag. We're working on the cutting edge here, and if
you're using a continuous integration build you'll want the latest pre-release gems.

## Application Gemsets
To keep separate gem sets for each application, use `rvm gemset`.  I use the app name for my gemset.

    $ rvm gemset create myapp
    $ rvm use jruby-1.5.6@myapp
    
Now you have a local GEM_PATH specific for your app, with the TorqueBox gems already available. To make
life even simpler, do this:

    $ cd myapp
    $ echo "rvm use jruby-1.5.6@myapp" > .rvmrc
    
Now whenever you change to your app directory, your JRuby interpreter and GEM_HOME are set.  Now just add
your application gem dependencies to your Gemfile, run `bundle install` and you'll be in business.




