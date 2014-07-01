---
title: 'TorqueBox 4 Update'
author: Ben Browning
layout: news
timestamp: 2014-07-01t10:30:00.0-05:00
tags: [ roadmap, torqbox, update ]
---

Lots of community users have been asking about TorqueBox 4 recently,
so it's probably past time to talk about TorqueBox 4 a bit and give a
roadmap update.

For starters, the gem we've published as 'torqbox' and any references
to that codename are being wrapped into TorqueBox 4.

We have a couple of high-level goals with TorqueBox 4:

* The various RubyGems we provide should be fully-functional
  libraries, usable just like any other RubyGem. No application server
  is required.

* Applications using our gems can optionally be deployed to a stock
  [WildFly][] or [JBoss EAP][] server.

## Just RubyGems

TorqueBox 4 will no longer have a large .zip download or the large
torquebox-server gem. Instead, we'll have a handful of smaller gems
(torquebox-web, torquebox-messaging, torquebox-scheduling, etc) that
can be added to any JRuby application.

Want to switch your JRuby application from another web server to
TorqueBox 4? Just add 'torquebox-web' to your Gemfile, `bundle
install`, and `rackup -s torquebox`.

Want to use our messaging and scheduling but something else for your
web requests? Just add 'torquebox-messaging' and
'torquebox-scheduling' to your Gemfile, `bundle install`, and start
using our APIs.

We provide an all-in-one set of components tested with each other that
gets pulled in with the 'torquebox' gem. But, you're also free to
pick-and-choose individual components if you don't want the full
stack.

## Application servers

If you need or want to use an application server, we'll still make it
easy to run JRuby applications on top of [WildFly][] and [JBoss
EAP][]. Applications written against our APIs will be able to go from
running directly on the command-line to running inside the application
server without changing the application or the application
server. We'll take advantage of the application server to enable more
advanced functionality when run inside of it, such as:

* web session replication
* load-balanced message distribution
* highly-available singleton scheduled jobs
* flexible cache replication
* multiple polyglot application deployments

## Following along

If you'd like to follow along or contribute to the TorqueBox 4
development, it currently takes place on the [torqbox][tb4git]
branch. We'll be merging that to master before too long and will give
a heads-up on the [developer mailing list][devlist] when that happens.

If you'd like to give TorqueBox 4 a try, for now you'll need to build
from source on that branch. The [README.md][readme] has instructions
on doing so.

Once we get some incremental builds of TorqueBox 4 and its
documentation published somewhere, we'll do another blog post that
shows how to use those incremental builds.


## Roadmap

### TorqueBox 4.0 by mid-to-late 2014

We'll be putting out some 4.0 alpha / beta releases soon and hope to
get 4.0 out by the middle of September. A lot of things will not be
backwards compatible with TorqueBox 3.

At a minimum this will contain web, scheduling, messaging, and caching
APIs. Each API may not exactly duplicate the features we have today in
TorqueBox 3, but we'll add features where appropriate with each new
minor release.

### TorqueBox 4.1 by early 2015

The main focus of 4.1 will be easing the transition from TorqueBox
3. This means writing an in-depth migration guide as well as deciding
what, if any, APIs we want to provide a backwards-compatibility layer
for. Early adopters will be encouraged to migrate to TorqueBox 4.0 and
provide feedback so we can make the migration as smooth as possible
for everyone else in TorqueBox 4.1.

We'll also save time to add in some features missing from 4.0 that
existed in 3.1, based on community feedback.

### TorqueBox 3 in maintenance mode

We'll continue to fix bugs in TorqueBox 3 and put out releases
as-needed, but don't expect any new features there. The tentative plan
is to stop fixing bugs in TorqueBox 3 approximately one year after we
release TorqueBox 4. 

## More to come

This was just a high-level overview of where TorqueBox 4 stands and
what it will be. We'll be going into a lot more depth on various
pieces in future posts.

## Feedback welcome!

We welcome and encourage feedback from our potential users, current
users, and especially our production users. Please [get in
touch][community] if you have questions, concerns, or comments about
TorqueBox 4.


[wildfly]: http://wildfly.org
[jboss eap]: https://www.jboss.org/products/eap
[tb4git]: https://github.com/torquebox/torquebox/tree/torqbox
[devlist]: /community/mailing_lists/
[readme]: https://github.com/torquebox/torquebox/blob/torqbox/README.md
[community]: /community/
