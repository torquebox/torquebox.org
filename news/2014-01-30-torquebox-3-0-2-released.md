---
title: 'TorqueBox 3.0.2 Released'
author: The Entire TorqueBox Team
layout: release
version: '3.0.2'
timestamp: 2014-01-30t15:40:00.0-05:00
tags: [ releases ]
---

The next bug fix release in the TorqueBox 3 series, 3.0.2, is out! We
expect this to be the last release in the 3.0.x line and work towards
a 3.1.0 release next. It's likely 3.1.0 will also be mainly bug fixes,
but we'll be bumping some important component versions to new major
releases so a minor version bump on our part conveys the proper risk
associated with the upcoming changes.

We'll continue to maintain the TorqueBox 3 line of releases while we
continue parallel development on the all new [next-generation
TorqueBox][torqbox] that's been [pushing the boundary][tfbr8] on Ruby
web application performance. Keep an eye on the 'rack-jruby' results
on those benchmarks to see how we're progressing.


* [Download TorqueBox 3.0.2 (ZIP)][download]
* [Download TorqueBox 3.0.2 (JBoss EAP overlay)][download_overlay]
* [Browse Getting Started Guide][gettingstarted]
* [Browse HTML manual][htmldocs]
* [Browse JavaDocs][javadocs]
* [Browse Gem RDocs][rdocs]
* [Download PDF manual][pdfdocs]
* [Download ePub manual][epubdocs]

## What is TorqueBox?

TorqueBox is a Ruby application server built on JBoss AS7 and JRuby.
It supports Rack-based web frameworks and provides [simple Ruby
interfaces][features] to standard enterprisey services, including
*scheduled jobs*, *caching*, *messaging*, and *services*.

## Highlights of changes in TorqueBox 3.0.2

### Bundled JRuby updated from 1.7.8 to 1.7.10

Like always, we've bumped the bundled JRuby version to the latest
available at the time of release. Read the JRuby [1.7.9][jruby179] and
[1.7.10][jruby1710] release announcements to see what's changed.

### Web performance improvements

Thanks to the performance work of [Kevin Menard][nirvdrum], we've
fixed several bottlenecks for Rack applications. Specifically, we've
removed some unnecessary synchronization in the request path which
improves top-end throughput substantially for high-performance
applications. He also noticed that our session store was creating a
session for every user, even if that session was never used. We've
fixed this to lazily create sessions as-needed. See [TORQUE-1200][]
and [TORQUE-1198][] for more details.

### Clustered session bug fixes

We've fixed several reported issues around clustered sessions where
NullPointerExceptions were received on restart of a node in a cluster
when the TorqueBox session store was in use. See [TORQUE-1155][] and
[TORQUE-1194][] for more details.


## Upgrading from 3.0.1

If you maintain your own XML config files, the only change we've made
from 3.0.1 to 3.0.2 is to remove the default expiration for the web
session cache -
<https://github.com/torquebox/torquebox/commit/514004758961a0bc981331ed74e71305b5bc5522>. This
fixes [TORQUE-1155][], [TORQUE-1194][], and
[TORQUE-1201][]. Otherwise, no changes are needed in applications or
config files to upgrade.


## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 3.0.1

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1155'>TORQUE-1155</a>] -         Null Pointer Exception on Restart
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1188'>TORQUE-1188</a>] -         Reproducable lockups with bounded pool
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1189'>TORQUE-1189</a>] -         TorqueBox.fetch behaves inconsistently for built in DLQ / Expiry Queue
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1193'>TORQUE-1193</a>] -         Upgrade to JRuby 1.7.10
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1194'>TORQUE-1194</a>] -         NullPointerException in org.jboss.as.web.session.ClusteredSession.update() on failover
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1195'>TORQUE-1195</a>] -         TorqueBox should have a security policy
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1196'>TORQUE-1196</a>] -         Torquebox store throws errors when it receives NullSessionHash
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1198'>TORQUE-1198</a>] -         Session store creates session if one doesn&#39;t exist on every request
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1200'>TORQUE-1200</a>] -         Reduce locking in RackFilter#doFilter for shared pools
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1201'>TORQUE-1201</a>] -         Increase default cache and clustered session eviction time
</li>
</ul>



[download]:         /release/org/torquebox/torquebox-dist/3.0.2/torquebox-dist-3.0.2-bin.zip
[download_overlay]: /release/org/torquebox/torquebox-dist/3.0.2/torquebox-dist-3.0.2-eap-overlay.zip
[gettingstarted]:   /getting-started/3.0.2/
[htmldocs]:         /documentation/3.0.2/
[javadocs]:         /documentation/3.0.2/javadoc/
[rdocs]:            /documentation/3.0.2/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/3.0.2/torquebox-docs-en_US-3.0.2.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/3.0.2/torquebox-docs-en_US-3.0.2.epub
[features]:         /features
[community]:        /community/

[torqbox]:          http://torquebox.org/news/2013/12/04/torquebox-next-generation/
[tfbr8]:            http://www.techempower.com/benchmarks/#section=data-r8&hw=i7&test=json
[jruby179]:         http://jruby.org/2013/12/06/jruby-1-7-9.html
[jruby1710]:        http://jruby.org/2014/01/09/jruby-1-7-10.html
[nirvdrum]:         https://twitter.com/nirvdrum
[TORQUE-1155]:      https://issues.jboss.org/browse/TORQUE-1155
[TORQUE-1194]:      https://issues.jboss.org/browse/TORQUE-1194
[TORQUE-1198]:      https://issues.jboss.org/browse/TORQUE-1198
[TORQUE-1200]:      https://issues.jboss.org/browse/TORQUE-1200
[TORQUE-1201]:      https://issues.jboss.org/browse/TORQUE-1201
