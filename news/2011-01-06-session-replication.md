---
title: Playing with Session Replication
author: Jim Crossley
layout: news
tags: [ clustering, jboss, sessions ]
---

When last we spoke, we learned
[how to easily build a TorqueBox cluster](/news/2011/01/04/clustering-torquebox/)
on our clean-shaven MacBook Pro.  So if you don't have your cluster
running, go re-read that article and fire it up.  Today, we'll build a
very simple Rails app, experiment with a few ways of deploying it to a
cluster, and observe how our session data remains available even
across server restarts without storing it insecurely in the user's
browser or wastefully in a central database.

# Create the application

First we'll create a Rails app using the TorqueBox template:

    $ jruby -S rails new myapp -m $TORQUEBOX_HOME/share/rails/template.rb
    $ cd myapp
    $ jruby -S bundle install

If you're following along at home, you'll notice that our template put
this in `config/initializers/session_store.rb`:

    Myapp::Application.config.session_store( TorqueBox::Session::ServletStore )

That's what puts your session in the care of TorqueBox, providing for
server-based, in-memory, cluster-compatible sessions.  The template
also installed some rake tasks we'll use to deploy the app.

So what do we want the app to do?  We're not going to get too
Mr. Fancy-Pants here: just a simple controller to put stuff in and get
stuff out of the session.  Call it
`app/controllers/session_controller.rb`:

<script src='https://gist.github.com/767345.js'></script>

And don't forget to uncomment the "legacy wild controller route" at
the bottom of `config/routes.rb`:

    match ':controller(/:action(/:id(.:format)))'

# Deploy the app

Here's how we deploy our app to our two cluster nodes:

    $ JBOSS_CONF=node1 jruby -S rake torquebox:deploy[/test]
    $ JBOSS_CONF=node2 jruby -S rake torquebox:deploy[/test]

I encourage you to read the **Application Deployment** chapter of the
[TorqueBox documentation](/documentation) to understand what those
commands are doing, but essentially, each is dropping a YAML file
named `myapp-rails.yml` in `$JBOSS_HOME/server/$JBOSS_CONF/deploy/`.
This simple act, which you could easily do yourself without the rake
task, is what deploys your app to TorqueBox.

Remember: in a "real" clustered deployment, you probably wouldn't be
copying deployment descriptors (the YAML file).  Instead, you'd be
remote-copying zipped archives of your app using capistrano or some
such.  But we're just messing around with a cluster on our laptop.
It's handy to have both nodes referring to the same app on disk.  Any
changes we make to it are immediately propagated "throughout the
cluster".  ;-)

Speaking of the cluster, it's worth mentioning that JBoss clustering
provides another way to deploy apps.  You could copy your app to the
`$JBOSS_CONF/farm` directory instead of `$JBOSS_CONF/deploy`.  You
only have to copy it to one of your nodes.  JBoss itself will then
replicate those apps to the `$JBOSS_CONF/farm` directories on the
other nodes and deploy them.  Any changes you make to the contents of
`$JBOSS_CONF/farm` on any node will be pushed to the other nodes
automatically.  This feature can be quite handy.

Also note that the `mod_cluster` front-end is smart enough not to
route any requests to nodes that don't have a particular app fully
deployed.

# Test the app

So if you've had your cluster up while running these rake tasks, you
should see output in your shells indicating some deployment is going
on, and hopefully successful.  Check your `mod_cluster` status to see
your JBoss nodes and the /test app running on each:
<http://localhost:6666/mod_cluster_manager>

I like to use curl to easily test the apps in a shell, but you can
certainly use a browser if you prefer.  Let's set a value in our
session:
    $ curl -b cookies -c cookies http://localhost:8000/test/session/put?value=whatever
And test that it's still there in a subsequent request:
    $ curl -b cookies -c cookies http://localhost:8000/test/session/get

Curl requires us to specify a file to hold our cookies.  We use the
`cookies` file to store the identifiying key to our actual session
data on the server.  Open it, and you should see a `JSESSIONID` in
there.

Now, I'm picturing you with 3 shell windows visible on your monitor:
one for each JBoss instance, and one where you're running curl.  That
way, you can see which server you're "stuck" to because `mod_cluster`
provides "sticky sessions" by default, i.e. session affinity.

Let's test a failover scenario to see evidence of the replication.  In
your "curl" shell, run this:

    $ while sleep 1; do curl -b cookies -c cookies http://localhost:8000/test/session/get; done

That should print out your session value every second in both your
"curl" shell and one of your "node" shells.  Now, kill the node you're
stuck to (Ctrl-c from its shell).  Your "curl" shell shouldn't be
disrupted.  The other node should pick up right where the killed one
left off.

Cool, huh?  Try other scenarios yourself.  It's pretty darn robust.
In the next article, we'll
[see how well clustered background jobs work](/news/2011/01/07/clustered-tasks/).
