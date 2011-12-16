---
title: 'TorqueBox 2.x and RVM'
author: Lance Ball
layout: news
tags: [ rvm, setup, installation, torquebox2 ]
---

[rvm]: http://rvm.beginrescueend.com/
[rvm-install]: http://rvm.beginrescueend.com/rvm/install/
[blog post]: /news/2011/02/25/using-rvm-with-torquebox/
[torquebox-server]: https://rubygems.org/gems/torquebox-server
[community]: /community
[resources]: /resources
[@torquebox]: http://twitter.com/torquebox

Back in February I wrote a [blog post] showing how to use RVM with TorqueBox
1.x. Well, we're already a few weeks into the 2.0.beta1 release, and things
have changed quite a lot since the original post.  It's about time I show
you how easy it is to make TorqueBox 2.x and RVM play nicely together. 

# RVM, JRuby, and Gemsets
RVM is a command line tool that helps you keep track of multiple, named ruby
environments with unique gemsets. If you're not familiar with it you might want
to have a [quick read][rvm] first, and then [install it][rvm-install].

TorqueBox 2.0 is built with JRuby 1.6.5, so make sure you have that as one of
your interpreters in RVM. You can check to see if it's already there and if
not, you'll need to install it.

    $ rvm list 

    rvm rubies

       jruby-1.6.0 [ x86_64 ]
       jruby-1.6.1 [ x86_64 ]
       jruby-1.6.2 [ x86_64 ]
       jruby-1.6.3 [ x86_64 ]
       jruby-1.6.4 [ x86_64 ]
       ree-1.8.7-2011.03 [ i686 ]
       ruby-1.8.7-p334 [ i686 ]
       ruby-1.8.7-p352 [ i686 ]
       ruby-1.9.2-p180 [ i386 ]

    
    $ rvm install jruby-1.6.5

Next, create a gemset for torquebox.

    $ # Be sure you are using jruby
    $ rvm jruby-1.6.5
    $ rvm gemset create torquebox-2.0


# Installing TorqueBox
With 2.0 we've introduced [torquebox-server] a gem that makes installation a
breeze, [torquebox-server], which includes all of the torquebox-* gems and a
copy of JBoss AS7.  Because AS7 is pretty large on it's own, you'll need to
tell JRuby to give it a little more memory. And because we're still in beta, be
sure to provide the `--pre` flag.

    $ rvm jruby-1.6.5@torquebox
    $ jruby -J-Xmx1024m -S gem install torquebox-server --pre

That's it - you're done! When you're using TorqueBox, just use the gemset.

    $ rvm jruby-1.6.5@torquebox

## Application Gemsets
Some folks like to have a separate gemset for each application they're working
on even if they're all running under the same Ruby. In that case, it doesn't
really make a lot of sense to install `torquebox-server` in each gemset. Since
each installation includes AS7, you'd be chewing up a lot of disk space. For
this scenario, I recommend installing `torquebox-server` in the global gemset.

    $ rvm jruby-1.6.5@global
    $ jruby -J-Xmx1024m -S gem install torquebox-server --pre

With this, each gemset you create under jruby-1.6.5 will already include the
`torquebox-server` gem.  I typically use the application name for my gemsets.

    $ rvm gemset create mygreatnewapp
    $ rvm use jruby-1.6.5@mygreatnewapp

## Validate Your Installation
With TorqueBox 2.0 you now get a command line which you can use to deploy and
undeploy applications, run the server, open a CLI to AS7, and view your
environment. A quick and easy way to validate your installation is to activate
your `torquebox` gemset and run the command line to view your environment.

    $ rvm jruby-1.6.5@torquebox

    $ torquebox help
    Tasks:
      torquebox deploy ROOT     # Deploy an application to TorqueBox
      torquebox undeploy ROOT   # Undeploy an application from TorqueBox
      torquebox run             # Run TorqueBox
      torquebox cli             # Run the JBoss AS7 CLI
      torquebox env [VARIABLE]  # Display TorqueBox environment variables
      torquebox help [TASK]     # Describe available tasks or one specific task

    $ torquebox env
    TORQUEBOX_HOME=/Users/lanceball/.rvm/gems/jruby-1.6.5/gems/torquebox-server-2.0.0.beta1-java
    JBOSS_HOME=/Users/lanceball/.rvm/gems/jruby-1.6.5/gems/torquebox-server-2.0.0.beta1-java/jboss
    JRUBY_HOME=/Users/lanceball/.rvm/rubies/jruby-1.6.5


## A Note About Production Environments
I love RVM for my development environment. I'm often working with several
projects simultaneously, and RVM is essential for keeping everything organized
and isolated.  But I don't necessarily recommend using it in production.

## More Information
We're really excited about TorqueBox 2.0 and always eager to help people get
the most out of it. Join our [community] if you'd like to keep
up to date, need help getting started, or just want to talk about Justin
Bieber.  Check our [resources] page for links to the latest screencasts and 
presentations.  And follow [@torquebox] on Twitter.
