---
title: StompBox
layout: default
---

# TorqueBox StompBox #

StompBox is a simple Sinatra app that can be used to manage deployments on
TorqueBox by accepting commit notifications from GitHub. It provides a user
interface for managing one-click deployment and undeployment of your github
repositories to TorqueBox for specific branches and commit points.  

StompBox is useful for testing and development environments where your code is
changing frequently and you want to quickly deploy working branches and staging
instances. It integrates with your GitHub repositories to enable extremely
quick and simple app deployment of any Rack-based application. And it does all
this on top of the industrial-strength TorqueBox platform.


## Installation ##

StompBox can either be installed and deployed as a gem, or installed directly
from the application sources.  In either case, you will need to have the
current version of TorqueBox installed with the following environment variables
set.

    TORQUEBOX_HOME=/path/to/torquebox/installation
    JRUBY_HOME=$TORQUEBOX_HOME/jruby
    JBOSS_HOME=$TORQUEBOX_HOME/jboss
    PATH=$JRUBY_HOME/bin:$PATH

### As a Gem ###

First, install the gem:

    jruby -S gem install torquebox-stompbox

*Note:* the torquebox-stompbox gem cannot be made available on rubygems.org
until an official release of the torquebox gems is made. Until then, you will
need to check out the source and run `jruby -S rake install` to install the
gem.
    
Then, deploy stompbox using the `stompbox` command. 

    jruby -S stompbox deploy --secure=username:password --setup-db --auto-migrate

This will deploy stompbox to your current TorqueBox deployment directory,
secure the application with JAAS, create the required database, and run a
migration to create the tables and such.  To check if your installation was
successful, you can use the `info` command.

    jruby -S stompbox info

### From the Source ###

Until TorqueBox CR1 has been released, this is the required method for
installation.

Clone the [git repo](https://github.com/torquebox/stompbox),
then run bundler to install the needed gems (listed in the 
[Gemfile](https://github.com/torquebox/stompbox/blob/master/Gemfile)):

    jruby -S gem install bundler # if you haven't done so already
    jruby -S bundle install
    
Once that's done, you can either deploy a deployment descriptor pointing at 
the checked out repo:

    jruby -S rake torquebox:deploy
    
or archive and deploy it as a .knob (zipfile):

    jruby -S rake torquebox:deploy:archive
    
By default, StompBox is deployed to the `/stompbox` context (see the `context:` 
setting in `torquebox.yml`).


## Configuration ##

StompBox's configuration options are typically set when installing 
using the deploy command.  To see the options just run:

    jruby -S stompbox help deploy

That's useful if you're not going to be changing things. But if you'd like 
to change any of these settings after deploying stompbox, you'll need to update
the torquebox-stompbox-knob.yaml file which is created for you on deployment.
You can find this in `$TORQUEBOX_HOME/apps`.


## Usage ##

Once you've got stompbox configured and deployed, you can start by telling
it what repositories and branches you want to track. Then, from GitHub,
browse to the repository admin screen for one of the repositories you specified
in config/stompbox.yml. Select "Service Hooks" -> "Post Receive URLs" and enter
your push URL.  It should look something like this.

    http://mydomain.com/stompbox/push/3821A95D456134214FAD6FA91A2BAFE574D47151

You can find this URL by clicking on the upper right menu item "GitHub Push URL".

*Note:* If your GitHub repository is private, you'll need to ensure that the
running TorqueBox process has read access. This is typically accomplished by
configuring GitHub [deploy keys](http://help.github.com/deploy-keys/).
We'll leave this as an exercise for the reader. But if you get stuck, there 
are lots of ways to get help from the TorqueBox team listed on our 
[community page](http://torquebox.org).

## Contributing ##

Bug reports, feature requests, and patches are always welcome! See our
[community page](http://torquebox.org/community/) on how to get in touch with
the TorqueBox crew.

## License ##

Copyright 2011 [Red Hat, Inc](http://redhat.com/).

Licensed under the [Apache Software License version 2](http://www.apache.org/licenses/LICENSE-2.0).
