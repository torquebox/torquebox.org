---
title: 'Install TorqueBox 2.x as a Gem'
author: Ben Browning
layout: news
tags: [ installation gems rvm ]
---

[2x-builds]: /2x/builds/
[tb_rvm]: /news/2011/02/25/using-rvm-with-torquebox/
[community]: /community/

We tried to make TorqueBox 1.x as easy to install as possible but it
still involved downloading and unzipping an archive and setting some
environment variables. And, if you wanted to use an existing JRuby
with TorqueBox 1.x, it required even more steps. Don't you think it
would be so much easier if there was one `gem install` command to
install everything? We sure do!


# gem install torquebox-server

    $ gem install torquebox-server --pre \
      --source http://torquebox.org/2x/builds/LATEST/gem-repo/

That one command installs TorqueBox 2.x. This isn't a crippled
web-only clone of TorqueBox, this is the entire TorqueBox application
server installed as a gem! No environment variables, no symlinks, no
special cases for RVM. All you need is an existing JRuby 1.6.1 or
higher interpreter.

Once we put out an official 2.x release you'll be able to drop the
`--source` and `--pre` arguments from the command. Until then, the
command above installs the latest successful incremental build from
our CI server. Check out our [2.x Incremental Builds][2x-builds] page
for details on the most recent incremental builds.

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
        torquebox deploy ROOT    # Deploy an application to TorqueBox
        torquebox undeploy ROOT  # Undeploy an application from TorqueBox
        torquebox run            # Run TorqueBox
        torquebox cli            # Run the JBoss AS7 CLI
        torquebox help [TASK]    # Describe available tasks or one specific task

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

I mentioned it above but it's worth pointing out again. Installing
TorqueBox as a gem means you no longer need special instructions to
run [TorqueBox under RVM][tb_rvm]. No matter how you installed your
JRuby the same gem install command should work and if you'll notice I
used RVM in all my examples above.


# Remember, These Are Incremental Builds

These instructions are for installing an incremental build of
TorqueBox 2.x. This branch is evolving very rapidly and, while we feel
it's fairly stable, you may run into bugs and hurdles not present in
our 1.x releases. As always if you run into any issues join us in [IRC
or on the mailing lists][community] and we'll help get things sorted
out.


# Stay Tuned for More on 2.x

A simplified installation is only one of the many great new things
about TorqueBox 2.x. We'll talk more over the coming weeks about
TorqueBox 2.x and JBoss AS7 as we march towards our first 2.x release.
