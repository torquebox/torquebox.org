---
title: 'TorqueBox 2.3.1 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.3.1'
timestamp: 2013-05-07t12:45:00.0-04:00
tags: [ releases ]
---

We're thrilled to announce the release of TorqueBox 2.3.1! This is a
small update to TorqueBox 2.3.0 to fix a few outstanding bugs while we
continue the main development work for the upcoming TorqueBox 3.0
series.

This release was delayed a couple of weeks from the original schedule
because of a new addition to the TorqueBox team. Connor Benjamin
Browning joins us after spending 9 months in a startup before things
went belly-up. He'll be fulfilling the role of release manager and be
the primary driver of schedules while my wife and I handle the change
control duties.

<img src="/images/connor.jpg" class="alignright bordered" style="width: 300px;"/>

* [Download TorqueBox 2.3.1 (ZIP)][download]
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

## Highlights of changes

* The bundled JRuby version has been updated from 1.7.2 to 1.7.3.

* A rather large memory leak in development mode when using Rails 3.2
  and message processors or scheduled jobs has been fixed.

* Several race conditions around booting applications with multiple
  services, multiple jobs, or booting TorqueBox with multiple
  applications deployed have been fixed. If you experienced
  intermittent failure of applications to deploy this should fix those
  issues.

* Stomplets can once again access HTTP session data.

Scroll down for the complete list of issues fixed in this release.

## Where's the torquebox-server gem?

Unfortunately, we found out at the last-minute after pushing all other
TorqueBox 2.3.1 gems that the torquebox-server gem is too large to
upload to rubygems.org. It was not too large in the past and has not
grown in size but rubygems.org has undergone a lot of changes in the
last few months and one of those is apparently a decreased maximum gem
size. We'll try to figure something out for future TorqueBox releases.

**Update**

We've created a custom gem repository you can add as a source to get
torquebox-server 2.3.1 - here's an example Gemfile.

    source 'https://rubygems.org'
    source 'http://torquebox.org/rubygems'

    gem 'torquebox-server', '2.3.1'

## Upgrading from 2.3.0

Upgrading from 2.3.0 to 2.3.1 should be very straightforward, unless
you use the torquebox-server gem - we worked hard to ensure only bug
fixes made it into this release so no configuration or code should
need changing.

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 2.3.0

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1012'>TORQUE-1012</a>] -         Eager loading for messaging is not working with ruby DSL and a shared pool
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1020'>TORQUE-1020</a>] -         rake torquebox:archive fails on Windows
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1028'>TORQUE-1028</a>] -         Session data is not available in Stomplets 
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1029'>TORQUE-1029</a>] -         Memory leak in MessageProcessor with Rails development mode
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1031'>TORQUE-1031</a>] -         Web contexts should be normalized
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1036'>TORQUE-1036</a>] -         An app requiring an incremental configured with torquebox.rb crashes at deployment
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1037'>TORQUE-1037</a>] -         Update to JRuby 1.7.3
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1049'>TORQUE-1049</a>] -         Constant Foo not defined for Object errors when starting multiple services in Rails applications
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1055'>TORQUE-1055</a>] -         Improper use of StartContext.asynchronous() and .execute() can starve MSC threads
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1057'>TORQUE-1057</a>] -         Race condition in ScheduledJob can cause NPE on start
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1058'>TORQUE-1058</a>] -         Applications with multiple Services sometimes fail to boot
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1078'>TORQUE-1078</a>] -         ArrayIndexOutOfBoundsException during startup
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1081'>TORQUE-1081</a>] -         TorqueBox Stomp rack handler breaks on Ruby 1.9 because it does not follow the Rack spec
</li>
</ul>


[download]:         /release/org/torquebox/torquebox-dist/2.3.1/torquebox-dist-2.3.1-bin.zip
[gettingstarted]:   /getting-started/2.3.1/
[htmldocs]:         /documentation/2.3.1/
[javadocs]:         /documentation/2.3.1/javadoc/
[rdocs]:            /documentation/2.3.1/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/2.3.1/torquebox-docs-en_US-2.3.1.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/2.3.1/torquebox-docs-en_US-2.3.1.epub
[BENchmarks]:       /news/2011/10/06/torquebox-2x-performance/
[features]:         /features
[community]:        /community/
