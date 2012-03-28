---
title: 'TorqueBox Now Available On Red Hat OpenShift PaaS'
author: Ben Browning
layout: news
timestamp: 2011-09-07t09:40:00.0-04:00
tags: [ openshift, announcements ]
---

[express]: https://openshift.redhat.com/app/
[torquebox-openshift-express]: https://github.com/torquebox/torquebox-openshift-express
[register]: https://openshift.redhat.com/app/user/new/express
[user-guide]: https://docs.redhat.com/docs/en-US/OpenShift_Express/1.0/html/User_Guide/index.html
[rails-quickstart]: https://www.redhat.com/openshift/kb/kb-e1005-ruby-on-rails-express-quickstart-guide
[2x-builds]: http://torquebox.org/2x/builds/
[flex]: https://openshift.redhat.com/app/flex
[new-post]: /news/2012/03/28/torquebox-openshift

<img src="/images/openshift_logo.png"/>

**Please refer to the [updated instructions][new-post] for running
  TorqueBox on OpenShift. The process below might still work but is
  being deprecated in favor of the [new method][new-post].**

# TorqueBox on OpenShift Express

We are pleased to announce that you can now run Ruby applications on
top of TorqueBox with the free Red Hat [OpenShift Express][express]
Platform-as-a-Service. OpenShift Express has supported Ruby
applications for some time on Passenger but now you have the option of
using TorqueBox for greater power and flexibility.

# Try It Out

The most up-to-date instructions live in our
[torquebox-openshift-express][] repository but I've included the steps
below to get up and running on OpenShift Express in a few minutes.

1. [Register][] for OpenShift Express
1. Install OpenShift client gems - `gem install rhc`
1. Create a domain name - `rhc-create-domain -n mydomain -l username`
1. Create an AS7 application - `rhc-create-app -a myapp -t jbossas-7.0`
1. Convert the newly created Java application to Ruby for use with TorqueBox
    * `cd myapp`
    * wget `https://raw.github.com/torquebox/torquebox-openshift-express/master/java_to_ruby.rb`
    * `ruby java_to_ruby.rb` to convert your application
1. Confirm changes and commit result - be sure to `git add` the new files
    * `git add .openshift/config/modules`
    * `git add config.ru`
    * `git commit -am "Converted to TorqueBox"`
1. `git push` your new Ruby application
    * During this first push Express will download the necessary TorqueBox and
      JRuby installations then start your application
1. Visit your new application at http://myapp-mydomain.rhcloud.com -
   if everything worked you should see an OpenShift splash page
1. Edit your application and `git push` to deploy new changes

Once you get your sample application running check out the [OpenShift
Express User Guide][user-guide] and the [Ruby on Rails Express
Quickstart Guide][rails-quickstart] to learn more about the OpenShift
client tools (rhc-* commands) and how to deploy a Rails application.

# The Details

For the curious, we piggyback on top of the JBoss AS7 support in
OpenShift Express by adding the TorqueBox modules and a JRuby
installation in a post-receive hook on the server. This hook is stored
inside your application's git repository at
`.openshift/action_hooks/build` if you'd like to take a peek.

We're running on JRuby 1.6.4 and a 2.x incremental build of
TorqueBox. If you'd like to run a newer TorqueBox incremental build
than the default one, just edit this post-receive hook and specify a
higher build number found on our [2.x builds][2x-builds] page.

We don't yet have messaging or STOMP support in OpenShift Express but
will continue to work on adding support for the full TorqueBox
stack. Memory is also quite constrained so you'll need to be careful
when deploying applications that use multiple Ruby runtimes (jobs,
services) that you don't run out of memory.

Even with these limitations TorqueBox still provides a lot of features
and better performance compared to a vanilla Ruby application running
on Passenger.

If you need the full power of TorqueBox, it will soon be available on
[OpenShift Flex][flex] without memory or feature constraints. We'll
post more details once that happens.

Please try it out and give us your feedback!
