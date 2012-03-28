---
title: 'Get Up and Running with TorqueBox on OpenShift'
author: Ben Browning
layout: news
timestamp: 2012-03-28t16:30:00.0-05:00
tags: [ openshift ]
---

[torquebox-openshift-first]: /news/2011/09/07/torquebox-openshift/express
[polyglot-openshift-example]: https://github.com/projectodd/polyglot-openshift-example
[immutant]: http://immutant.org

<img src="/images/openshift_200.png"/>

We [previously][torquebox-openshift-first] posted how to run TorqueBox
on Red Hat OpenShift Express but thought it was time to freshen things
up a bit since OpenShift and TorqueBox have had several releases since
then.

# Services, Scheduled Jobs, Caching, and Messaging Support

The biggest change is you can now use TorqueBox services, scheduled
jobs, caching and messaging on OpenShift with no extra setup
required. This is a lot of functionality you get for free - free as in
you didn't have to set it up, and free as in OpenShift costs you $0 to
use these features.

# Get Started

To help you get started, we've provided a [polyglot-openshift-example]
repository that walks you through creating an AS7 application on
OpenShift and then merging in the necessary changes to support
TorqueBox applications. Take a moment to head over there and try it
out for yourself. At the end you'll get to play a simple game of ping
pong with messaging between Ruby and Clojure.

<img src="/images/pingpong.png"/>

Assuming you followed the directions from the README.md in that
repository, you've now deployed a Java application, a Ruby
application, and a Clojure application (via [Immutant]) to a single
AS7 instance running in OpenShift. That's **three applications** in
**three different languages** all running in the **same JVM** on
**OpenShift**. Mind blown yet?

The fun doesn't stop here. Want to deploy a second Ruby application to
this same TorqueBox instance? Just create a new directory next to the
`ruby/` and `clojure/` ones already present and place your code inside
of it, ensuring you have a `torquebox.yml` or `config/torquebox.yml`
inside the new directory with a unique web context specified. Add the
new files to git, `git push`, and watch your new application be picked
up and deployed to TorqueBox. We detect the type of application from
the contents of the directory, not from the directory name. The sample
applications are just named ruby and clojure for simplicity.

Don't want the example Clojure app anymore? Just `rm -r
clojure/`. Don't want the example Java app? Just `rm -r src` and `rm
pom.xml`.

How many applications can you deploy to this single OpenShift
instance? I don't know - it all depends on the size of your
applications and how much memory they ultimately consume. Give it a
shot and let us know! And, don't forget that you get multiple
OpenShift instances for free - so far we've been deploying all these
applications to a single one. See the potential?
