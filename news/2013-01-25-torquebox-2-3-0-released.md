---
title: 'TorqueBox 2.3.0 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.3.0'
timestamp: 2013-01-25t16:15:00.0-05:00
tags: [ releases ]
---

We're very excited to announce the release of TorqueBox 2.3.0! We hit
a couple of unexpected delays with this release but hopefully the list
of new features and bug fixes will make it worth the wait.

* [Download TorqueBox 2.3.0 (ZIP)][download]
* [Browse Getting Started Guide][gettingstarted]
* [Browse HTML manual][htmldocs]
* [Browse JavaDocs][javadocs]
* [Browse Gem RDocs][rdocs]
* [Download PDF manual][pdfdocs]
* [Download ePub manual][epubdocs]

## What is TorqueBox?

TorqueBox is a Ruby application server built on JBoss AS7 and JRuby.
In addition to being one of the [fastest Ruby servers
around][BENchmarks], it supports Rack-based web frameworks, and
provides [simple Ruby interfaces][features] to standard JavaEE
services, including *scheduled jobs*, *caching*, *messaging*, and
*services*.

## Highlights of major changes

* The bundled JRuby version has been updated from 1.7.1 to 1.7.2.

* [RubyMine 5][rubymine5] will ship with TorqueBox graphical debugging
  support. This has been tested with TorqueBox 2.2.0 and TorqueBox
  2.3.0 but should work with earlier TorqueBox 2 versions.

* Messaging Queues and Topics have a few more convenience methods. You
  can get a list of all Queues and Topics deployed in the server as
  well as pausing, resuming, counting, and clearing messages. See the
  [Queue][queue_rdoc] and [Topic][topic_rdoc] RDocs for more details.

* You can now easily change the HTTP port TorqueBox uses with a new
  `-p` option to `torquebox run`. For example, `torquebox run -p 3000`

* Distributed transactions (XA) are now disabled by default for
  databases and message processors. There are some edge cases that new
  TorqueBox users occasionally hit around our XA support and by
  disabling it by default we hope to keep the new user experience as
  smooth as possible.

* TorqueBox should now work out of the box with the latest
  activerecord-jdbc-adapter gems. They made a change in 1.2.5 that
  broke some assumptions made by TorqueBox and this is now fixed.

* TorqueBox should now work out of the box with the latest Rack
  gems. Rack 1.4.3 also made a change that caused basic Rack
  applications running in 1.9 mode (Sinatra and Rails applications
  appear unaffected) to not work. In this case the issue was TorqueBox
  not behaving exactly as specified in the Rack spec with regards to
  the response body.

* A bug was found that caused messages sent with a non-default
  priority level and consumed by a message processor to get resent on
  the next TorqueBox restart. This was a bug in our distributed
  transactions code and has been fixed. Additionally, as mentioned
  above, distributed transactions are disabled by default for message
  processors now.

* We've added a more complex example application to our Getting
  Started Guide. Check out [Chapter 3. Poorsmatic][poorsmatic] for
  more details.

## Upgrading from 2.2.0

* No change is required in the AS7 configuration files to upgrade from
  TorqueBox 2.2.0 to 2.3.0.

* If you relied on distributed transactions in previous TorqueBox
  versions, be sure to add an 'xa: true' entry to your appropriate
  database.yml and torquebox.yml entries. See our [transactions
  documentation][xadocs] for more details.

* The format of synchronous messages (ones sent via
  publish_and_receive and receive_and_publish methods) has changed
  slightly. Do not mix 2.3.0 with earlier TorqueBox versions in a
  cluster if you use synchronous messaging.

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 2.2.0

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-547'>TORQUE-547</a>] -         Support Debugging From RubyMine IDE
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-579'>TORQUE-579</a>] -         Provide Simple Way to Change HTTP Port TorqueBox Uses
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-636'>TORQUE-636</a>] -         TorqueBox should have quickstarts and tests for common deployment scenarios
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-740'>TORQUE-740</a>] -         Provide an API to list Queues and Topics from Ruby
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-790'>TORQUE-790</a>] -         Scheduled message delivery
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-801'>TORQUE-801</a>] -         Document FutureProxy.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-825'>TORQUE-825</a>] -         Add an option to disable distributed transactions for message processors
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-832'>TORQUE-832</a>] -         Expose pause/resume queue functionality in Ruby
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-888'>TORQUE-888</a>] -         Add clear queue method to TorqueBox::Messaging::Queue
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-905'>TORQUE-905</a>] -         Additional useful methods in torquebox-no-op
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-910'>TORQUE-910</a>] -         Create Example Application Showcasing TorqueBox Features
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-983'>TORQUE-983</a>] -         MessageProcessors broken for messages sent with non-default priorities
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-984'>TORQUE-984</a>] -         Parse erb in *-knob.yml with GlobalRuby
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-986'>TORQUE-986</a>] -         description option not allowed in job section of DSL config
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-987'>TORQUE-987</a>] -         Torquebox under Windows is case sensitive to the PATH environmental variable
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-989'>TORQUE-989</a>] -         Require users to explicitly enable distributed transactions for their database
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-990'>TORQUE-990</a>] -         Native sendfile for rack
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-992'>TORQUE-992</a>] -         Upgrade to JRuby 1.7.2
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-993'>TORQUE-993</a>] -         Rack 1.4.3 and TorqueBox broken in 1.9 apps
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-999'>TORQUE-999</a>] -         &quot;timeout&quot; option not allowed in job section of DSL configuration
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1000'>TORQUE-1000</a>] -         Absolute Prefix for spec tests on Windows is hardcoded
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1001'>TORQUE-1001</a>] -         publish_and_receive shouldn&#39;t wrap the message in a hash
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1002'>TORQUE-1002</a>] -         receive_and_publish should default to the encoding of the received message
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1003'>TORQUE-1003</a>] -         Disable distributed transactions for message processors by default
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1005'>TORQUE-1005</a>] -         Disable Quartz update check
</li>
</ul>


[download]:         /release/org/torquebox/torquebox-dist/2.3.0/torquebox-dist-2.3.0-bin.zip
[gettingstarted]:   /getting-started/2.3.0/
[htmldocs]:         /documentation/2.3.0/
[javadocs]:         /documentation/2.3.0/javadoc/
[rdocs]:            /documentation/2.3.0/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/2.3.0/torquebox-docs-en_US-2.3.0.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/2.3.0/torquebox-docs-en_US-2.3.0.epub
[BENchmarks]:       /news/2011/10/06/torquebox-2x-performance/
[features]:         /features
[rubymine5]:        http://www.jetbrains.com/ruby/nextversion/index.html
[xadocs]:           /documentation/2.3.0/transactions.html#transaction-messaging
[queue_rdoc]:       /documentation/2.3.0/yardoc/TorqueBox/Messaging/Queue.html
[topic_rdoc]:       /documentation/2.3.0/yardoc/TorqueBox/Messaging/Topic.html
[poorsmatic]:       /getting-started/2.3.0/poorsmatic.html
[roadmap]:          https://issues.jboss.org/browse/TORQUE?selectedTab=com.atlassian.jira.plugin.system.project%3Aroadmap-panel
[community]:        /community/
