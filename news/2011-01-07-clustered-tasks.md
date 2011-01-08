---
title: Background Tasks in a TorqueBox Cluster
author: Jim Crossley
layout: news
---

This is the third in a series of articles focused on TorqueBox
clustering.  Yesterday, we deployed a
[simple app demonstrating session replication](/news/2011/01/06/session-replication/)
on [our cluster](/news/2011/01/04/clustering-torquebox/).  Today we
will add a TorqueBox Task to our simple app to demonstrate how easy it
is not only to define and execute asynchronous background jobs but
also to scale them.

Non-trivial web applications are comprised of more than just web
components.  You don't get too far along in the development of your
app before you find yourself needing background processing and
scheduling.  And it shouldn't be too difficult to manage such an
application.  That's what app servers are good for, by golly!  They
offer a more tightly integrated experience in which the non-web
resources your web app requires are provided by the app server itself.

TorqueBox Tasks (along with their lower-level brethren, Queues and
Topics) are one such resource that is pleasantly trivial to use.

# Add a Task to our app

We're going to build on the app we created in the
[previous example](/news/2011/01/06/session-replication/), but as
you'll see, there's no real compelling reason to do so.  It's also
very important to point out that TorqueBox Tasks work not only for
Rails, but any Rack app.

We're going to add three things to our app:

* A dependency on the **org.torquebox.torquebox-messaging-client**
  gem.  You could reasonably argue that our Rails template should do
  this for you.  I wouldn't put up much of a fight.
* A task class (this is the crucial step)
* Another controller to asynchronously invoke the task.

Adding the dependency is trivial.  Just add the following line to your
Gemfile:

    gem "org.torquebox.torquebox-messaging-client" 

And then install it: 

    $ jruby -S bundle install

Ok, now for our totally contrived task class: let's just have it go to
sleep for a few seconds.

Brilliant, right?  Suck it, "Hello World!"  :-)

All task classes must meet three requirements:

* They must extend `TorqueBox::Messaging::Task`
* They must reside in `app/tasks`
* Their name must have the suffix, `Task` in its class name and, to
  benefit from the Rails autoloading feature, `_task.rb` in its file
  name.

So here's our class:  `app/tasks/sleepy_task.rb`

<script src='https://gist.github.com/768846.js'></script>

Note how it expects a `:duration` key in its payload hash.  We'll pass
that from the controller.  Speaking of which:
`app/controllers/sleepy_controller.rb`

<script src='https://gist.github.com/768852.js'></script>

All tasks have that `async` class method, which is how you invoke them
asynchronously.  Its first parameter is a symbol indicating which of
the task's methods you wish to invoke.  The remaining key pairs form
the payload hash that is eventually passed to the method.

Though not shown in our very dumb example, you naturally have all your
Rails model classes available to you within the task method to do your
bidding.

Pretty simple, huh?  No additional processes to manage, no extra
tables needed in your database, and pretty much no configuration
required.  Just a little Ruby class.

Plus, at no extra charge, your tasks will be automatically clustered,
distributed across all the nodes within it.  See for yourself by
redeploying your app to both nodes.  Some changes you make to your app
don't require redeployment, but because we've added a dependency, we
need to this time:

    $ JBOSS_CONF=node1 jruby -S rake torquebox:deploy[/test]
    $ JBOSS_CONF=node2 jruby -S rake torquebox:deploy[/test]

# Test the app

In your shell, try this:

    $ curl http://localhost:8000/test/sleepy/sleep/3

Try it a few times, actually.  Each time try changing the number of
seconds the task should sleep (the number at the end of the URL).
Notice how both the web requests (because we're not saving our
cookies) and the tasks are load-balanced across the cluster.  The node
responding to the web request may or may not be the one executing the
task.  Neat, right?

I should point out that background processing in TorqueBox has no
dependency on clustering whatsoever.  It works whether you cluster or
not.  Clustering merely gives you automatic distribution and hence
scaling of your background tasks.

Tasks are really just higher abstractions for TorqueBox Queues, which
are actually JMS Queues, provided incidentally, by
[HornetQ](http://jboss.org/hornetq/), reportedly the
[fastest JMS implementation available](http://community.jboss.org/wiki/HornetQ-thePerformanceLeaderinEnterpriseMessaging)!
All I know is it seems pretty quick to me.  We'll talk in more detail
about Queues in a future article.

