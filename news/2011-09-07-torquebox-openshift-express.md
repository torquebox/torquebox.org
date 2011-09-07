---
title: 'TorqueBox Now Available On Red Hat OpenShift PaaS'
author: Ben Browning
layout: news
timestamp: 2011-09-07t09:20:00.0-04:00
tags: [ openshift, announcements ]
---

[express]: https://openshift.redhat.com/app/
[torquebox-openshift-express]: https://github.com/torquebox/torquebox-openshift-express
[user-guide]: https://docs.redhat.com/docs/en-US/OpenShift_Express/1.0/html/User_Guide/index.html
[rails-quickstart]: https://www.redhat.com/openshift/kb/kb-e1005-ruby-on-rails-express-quickstart-guide
[2x-builds]: http://torquebox.org/2x/builds/

<img src="/images/openshift_logo.png"/>

# TorqueBox on OpenShift Express

We are pleased to announce that you can now run Ruby applications on
top of TorqueBox with the free Red Hat [OpenShift Express][express]
Platform-as-a-Service. OpenShift Express has supported Ruby
applications for some time on Passenger but now you have the option of
using TorqueBox for greater power and flexibility in the types of Ruby
applications you can deploy.

# Try It Out

Follow the instructions in our [torquebox-openshift-express][]
repository to get up and running on OpenShift Express in a few
minutes.

Once you get your sample application running check out the [OpenShift
Express User Guide][user-guide] and the [Ruby on Rails Express
Quickstart Guide][rails-quickstart] to learn more about the OpenShift
client tools (rhc-* commands) and how to deploy a Rails application.

# The Details

For the curious, we piggy-back on top of the JBoss AS7 support in
OpenShift Express by adding the TorqueBox modules and a JRuby
installation in a post-receive hook on the server. This hook is stored
inside your application's git repository at
`.openshift/action_hooks/build` if you'd like to take a peek.

We're running on JRuby 1.6.4 and a 2.x incremental build of
TorqueBox. If you'd like to run a newer TorqueBox incremental build
than the default one, just edit this post-receive hook and specify a
higher build number found on our [2.x builds][2x-builds] page.

We don't yet have messaging or stomp support in OpenShift Express but
will continue to work on adding support for the full TorqueBox
stack. Memory is also quite constrained so you'll need to be careful
when deploying applications that use multiple Ruby runtimes (jobs,
services) that you don't run out of memory.

Even with these limitations TorqueBox still provides a lot of features
and performance compared to a vanilla Ruby application running on
Passenger.

Please try it out and give us your feedback!
