---
title: 'TorqueBox 2.x Installable as a Gem'
author: Ben Browning
layout: news
tags: [ installation gems rvm ]
---

[2x-builds]: /2x/builds/
[tb_rvm]: /news/2011/02/25/using-rvm-with-torquebox/
[community]: /community/

# TorqueBox 2.x

If you don't hang out in IRC or on our mailing lists, you may not know
that we've been hard at work on a TorqueBox 2.x release based off of
JBoss AS7 instead of the JBoss AS6 used for our 1.x releases. AS7 is
substantially smaller and faster than AS6 which means TorqueBox 2.x
builds are half the download size of 1.x and boot much faster.

# gem install torquebox-server

Because TorqueBox 2.x is smaller and lighter, you can now install it
as a gem. We haven't made any official releases of the 2.x series yet
so for now you'll need to grab the gem off our gem repository instead
of rubygems.org with a command like below:

    $ gem install torquebox-server --pre --source http://torquebox.org/2x/builds/LATEST/gem-repo/

This will install the latest successful incremental build from our CI
server. Check out our [2.x Incremental Builds][2x-builds] page for
details on the most recent incremental builds.

If all goes well you should see sample output like below:

    Fetching: torquebox-core-2.x.incremental.107-java.gem (100%)
    Fetching: torquebox-messaging-2.x.incremental.107-java.gem (100%)
    Fetching: torquebox-naming-2.x.incremental.107-java.gem (100%)
    Fetching: torquebox-rake-support-2.x.incremental.107.gem (100%)
    Fetching: torquebox-security-2.x.incremental.107-java.gem (100%)
    Fetching: torquebox-vfs-2.x.incremental.107-java.gem (100%)
    Fetching: torquebox-web-2.x.incremental.107-java.gem (100%)
    Fetching: torquebox-2.x.incremental.107.gem (100%)
    Fetching: torquebox-server-2.x.incremental.107-java.gem (100%)
    Successfully installed torquebox-core-2.x.incremental.107-java
    Successfully installed torquebox-messaging-2.x.incremental.107-java
    Successfully installed torquebox-naming-2.x.incremental.107-java
    Successfully installed torquebox-rake-support-2.x.incremental.107
    Successfully installed torquebox-security-2.x.incremental.107-java
    Successfully installed torquebox-vfs-2.x.incremental.107-java
    Successfully installed torquebox-web-2.x.incremental.107-java
    Successfully installed torquebox-2.x.incremental.107
    Successfully installed torquebox-server-2.x.incremental.107-java
    9 gems installed

# Deploy and Run Your Application

After installation you have a new `torquebox` command available

      $ torquebox
      Tasks:
        torquebox cli            # Run the JBoss AS7 CLI
        torquebox deploy ROOT    # Deploy an application to TorqueBox
        torquebox help [TASK]    # Describe available tasks or one specific task
        torquebox run            # Run TorqueBox
        torquebox undeploy ROOT  # Undeploy an application from TorqueBox

Let's deploy a Sinatra application:

    $ torquebox deploy ~/src/sinatra/basic
    Deployed: basic-knob.yml
        into: /Users/bbrowning/.rvm/gems/jruby-1.6.2/gems/torquebox-server-2.x.incremental.107-java/jboss/standalone/deployments

Then run TorqueBox:

    $ torquebox run

A few seconds will pass and you'll see a message like the one below
indicating your TorqueBox is up and accepting requests:

    11:05:06,022 INFO  [org.jboss.as] (MSC service thread 1-8) JBoss AS 7.x.incremental.16 "(TBD)" started in 12151ms - Started 148 of 214 services (66 services are passive or on-demand)

A quick peek at jconsole shows TorqueBox is only using about 50MB of
JVM heap to run this Sinatra application. If you used TorqueBox 1.x,
you'll appreciate how much smaller things are now.

Use `ctrl-c` to kill the server. Then let's undeploy our application:

    $ torquebox undeploy ~/src/sinatra/basic
    Undeployed: basic-knob.yml
          from: /Users/bbrowning/.rvm/gems/jruby-1.6.2/gems/torquebox-server-2.x.incremental.107-java/jboss/standalone/deployments


# First-Class RVM Support

Installing TorqueBox as a gem means you no longer need special
instructions to run [TorqueBox under RVM][tb_rvm]. No matter how you
installed your JRuby the same gem install command should work and if
you'll notice I used RVM in all my examples above.

# Remember, These Are Incremental Builds

These instructions are for installing an incremental build of
TorqueBox 2.x. This branch is evolving very rapidly and, while we feel
it's fairly stable, you may run into bugs and hurdles not present in
our 1.x releases. As always if you run into any issues join us in [IRC
or on the mailing lists][community] and we'll help get things sorted
out.
