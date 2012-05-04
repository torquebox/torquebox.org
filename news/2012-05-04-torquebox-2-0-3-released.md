---
title: 'TorqueBox v2.0.3 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.0.3'
timestamp: 2012-05-04t13:00:00.0-05:00
tags: [ releases ]
---

Well, this is a little embarrassing.  

Only a few hours after we released
2.0.2, the JRuby guys released JRuby-1.6.7.2 fixing a security issue.
Along with having found a few of our own bugs in the past 
4 days, we are embarrassingly proud to announce the availability of TorqueBox
2.0.3.

Happy Cuatro de Mayo!

* [Download TorqueBox 2.0.3 (ZIP)][download]
* [Browse HTML manual][htmldocs]
* [Browse JavaDocs][javadocs]
* [Browse Gem RDocs][rdocs]
* [Download PDF manual][pdfdocs]
* [Download ePub manual][epubdocs]

## What is TorqueBox?

TorqueBox is a Ruby application server built on JBoss AS7 and JRuby.  In
addition to being one of the [fastest Ruby servers around][BENchmarks], it supports
Rack-based web frameworks, and provides [simple Ruby interfaces][features] to
standard JavaEE services, including *scheduled jobs*, *caching*, *messaging*,
and *services*.

## JRuby 1.6.7.2

The only change incorporated into the upgrade of JRuby is the updating of
the bundled RubyGems to 1.8.24.  This version starts checking the server certificate
of rubygems.org.  That's a good thing.

## `public/` directory not consistently serving assets

You might've noticed that files from your `public/` directory were only
being served every other request or so.  This has been tracked (via [TORQUE-810])
and fixed in 2.0.3


## Keep up with the flurry of releases

As always, one of the best ways to keep up with the flurry of
releases and announcements about TorqueBox is to [follow us on Twitter (@torquebox)][twitter].

## Issues resolved since 2.0.2

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-791'>TORQUE-791</a>] -         Web context in torquebox.rb is ignored during deployment
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-810'>TORQUE-810</a>] -         Files &amp; Assets in Rails /public folder are only served successfully 50% of the time and are sometimes incorrectly passed to rails
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-813'>TORQUE-813</a>] -         undefined method `__enable_backgroundable_newrelic_tracing&#39;
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-814'>TORQUE-814</a>] -         Upgrade to JRuby 1.6.7.2
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-816'>TORQUE-816</a>] -         Capistrano app_environment produces an invalid deployment descriptor
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-818'>TORQUE-818</a>] -         Services docs incorrectly state that app/services/ has to be added to the load path
</li>
</ul>

[download]: /release/org/torquebox/torquebox-dist/2.0.3/torquebox-dist-2.0.3-bin.zip
[htmldocs]: /documentation/2.0.3/
[logdocs]:  /documentation/2.0.3/jboss.html#jboss-logging
[javadocs]: /documentation/2.0.3/javadoc/
[rdocs]:    /documentation/2.0.3/yardoc/
[pdfdocs]:  /release/org/torquebox/torquebox-docs-en_US/2.0.3/torquebox-docs-en_US-2.0.3.pdf
[epubdocs]: /release/org/torquebox/torquebox-docs-en_US/2.0.3/torquebox-docs-en_US-2.0.3.epub
[BENchmarks]: /news/2011/10/06/torquebox-2x-performance/
[features]: /features
[twitter]: http://twitter.com/torquebox
[TORQUE-810]: https://issues.jboss.org/browse/TORQUE-810
