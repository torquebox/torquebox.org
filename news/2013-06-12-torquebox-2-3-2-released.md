---
title: 'TorqueBox 2.3.2 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.3.2'
timestamp: 2013-06-12t14:45:00.0-04:00
tags: [ releases ]
---

While we've been working hard to get the first TorqueBox 3 release out
the door, a couple of important bugs were discovered in our Rails page
cache implementation that warranted a new TorqueBox 2.3 release. So,
we give you TorqueBox 2.3.2!

* [Download TorqueBox 2.3.2 (ZIP)][download]
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

* The bundled JRuby version has been updated from 1.7.3 to 1.7.4.

* A thread-safety issue in our Rails page cache implementation that
  could cause some web requests to fail under high load has been
  fixed. This bug only impacts Rails users, and likely only Rails
  users actually using page caching.

* A bug where TorqueBox would serve pages out of the page cache for
  POST requests has been fixed. This only impacts Rails users using
  page cache where they have both a GET action they want cached and a
  POST action they don't want cached mapped to the same URL.

* The performance of message processors in production mode has been
  increased substantially. We were erroneously reloading the message
  processor's source from disk on every incoming message in production
  mode instead of only doing that in development mode.

## Reminder about torquebox-server gem

The torquebox-server gem is still too large for the new rubygems.org
infrastructure, so torquebox-server users will need to continue using
our own gem source at <http://torquebox.org/rubygems>. We've greatly
reduced the size of this gem for TorqueBox 3 in the hopes of getting
it small enough to host on rubygems.org again.

Here's an example Gemfile for Bundler users:

    source 'https://rubygems.org'
    source 'http://torquebox.org/rubygems'

    gem 'torquebox-server', '2.3.2'

## Upgrading from 2.3.1

Upgrading from 2.3.1 to 2.3.2 shouldn't require any changes.

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 2.3.1

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1096'>TORQUE-1096</a>] -         Update to JRuby 1.7.4
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1098'>TORQUE-1098</a>] -         future.status not available from backgrounded class methods
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1099'>TORQUE-1099</a>] -         Sporadic web request failure under high load for Rails applications
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1104'>TORQUE-1104</a>] -         Typo in capistrano init.d restart task
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1105'>TORQUE-1105</a>] -         Unexpected page caching with POST request
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1107'>TORQUE-1107</a>] -         Message processors always reloading class, even in production mode
</li>
</ul>


[download]:         /release/org/torquebox/torquebox-dist/2.3.2/torquebox-dist-2.3.2-bin.zip
[gettingstarted]:   /getting-started/2.3.2/
[htmldocs]:         /documentation/2.3.2/
[javadocs]:         /documentation/2.3.2/javadoc/
[rdocs]:            /documentation/2.3.2/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/2.3.2/torquebox-docs-en_US-2.3.2.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/2.3.2/torquebox-docs-en_US-2.3.2.epub
[BENchmarks]:       /news/2011/10/06/torquebox-2x-performance/
[features]:         /features
[community]:        /community/
