---
title: 'TorqueBox v2.0.2 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.0.2'
timestamp: 2012-05-01t16:40:00.0-05:00
tags: [ releases ]
---

We're as happy as kids around a maypole on May Day to announce the
immediate availability of *TorqueBox v2.0.2*. This release brings
JRuby 1.7 compatibility, fixes for distributed transactions on Oracle,
several other minor bug fixes, and some changes and additions to our
documentation - including oft-requested explanations about
[how logging works][logdocs], thanks to
[jcrossley3](http://twitter.com/jcrossley3).

* [Download TorqueBox 2.0.2 (ZIP)][download]
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

## Updates on the Release Process and Versions

The 2.0.x TorqueBox releases will be bugfixes only from this point
forward, while we'll continue adding new features to what will become
2.1.0. The goal is to ensure maximum stability of all future 2.0.x
releases while not hindering new feature requests and development.

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].
## Issues resolved since 2.0.1

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-567'>TORQUE-567</a>] -         Get XA transactions working on Oracle
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-570'>TORQUE-570</a>] -         Occasional deployment failures when redeploying app
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-753'>TORQUE-753</a>] -         Integrate rack-webconsole or something like it with BackStage
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-762'>TORQUE-762</a>] -         oracle_enhanced errors with No suitable driver found for jdbc:oracle:thin
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-775'>TORQUE-775</a>] -         Make TorqueBox Compatible with JRuby 1.7
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-777'>TORQUE-777</a>] -         Document How to Connect VisualVM to a Remote TorqueBox
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-778'>TORQUE-778</a>] -         Document New Relic integration
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-780'>TORQUE-780</a>] -         Newrelic Doesn&#39;t work on 2.0.0 or 2.0.1
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-781'>TORQUE-781</a>] -         Don&#39;t Assume Every ActiveRecord User is Using ActiveRecord-JDBC
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-782'>TORQUE-782</a>] -         session store logs warnings when multiple apps are deployed and one of them is at /
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-783'>TORQUE-783</a>] -         Clustering Without Multicast Docs Should Show ModCluster Example
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-784'>TORQUE-784</a>] -         HornetQ fails to cluster on some platforms
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-787'>TORQUE-787</a>] -         Some bug in STOMP makes it use all CPU resource
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-792'>TORQUE-792</a>] -         Torquebox not passing HTTP OPTIONS requests through to our app
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-793'>TORQUE-793</a>] -         Task concurrency &gt; backgroundable tasks test fails on OpenJDK
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-794'>TORQUE-794</a>] -         Allow to check if curent Ruby runtime is a web context, a message processor or a service.
</li>
</ul>

                                    
[download]: /release/org/torquebox/torquebox-dist/2.0.2/torquebox-dist-2.0.2-bin.zip
[htmldocs]: /documentation/2.0.2/
[logdocs]:  /documentation/2.0.2/jboss.html#jboss-logging
[javadocs]: /documentation/2.0.2/javadoc/
[rdocs]:    /documentation/2.0.2/yardoc/
[pdfdocs]:  /release/org/torquebox/torquebox-docs-en_US/2.0.2/torquebox-docs-en_US-2.0.2.pdf
[epubdocs]: /release/org/torquebox/torquebox-docs-en_US/2.0.2/torquebox-docs-en_US-2.0.2.epub
[features]: /features
[BENchmarks]: /news/2011/10/06/torquebox-2x-performance/
[community]: /community
