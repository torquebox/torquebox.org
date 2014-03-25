---
title: 'TorqueBox 3.1.0 Released'
author: The Entire TorqueBox Team
layout: release
version: '3.1.0'
timestamp: 2014-03-25t11:45:00.0-05:00
tags: [ releases ]
---

The next release in the TorqueBox 3 series, 3.1.0, is out! This
releases fixes Java 8 compatibility, updates JRuby to 1.7.11, and
updates the bundled Infinispan cache version to 6.0.0. The next
TorqueBox 3 release will be 3.1.1 and will concentrate on fixing bugs
we bumped from 3.1.0 in order to get Java 8 support out sooner.

We're also hard at work on the all new TorqueBox 4, which we've
referred to as 'torqbox' until now. Look for an upcoming blog post
that outlines all the big changes. We're really excited to talk about
the new embedded mode and the ability to deploy TorqueBox applications
to unmodified [WildFly 8][wildfly] servers!


* [Download TorqueBox 3.1.0 (ZIP)][download]
* [Download TorqueBox 3.1.0 (JBoss EAP overlay)][download_overlay]
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

## Highlights of changes in TorqueBox 3.1.0

### Java 8 support

TorqueBox 3.0.2 has a bug only exposed by Java 8 that prevents it from
booting under Java 8. This has been fixed in 3.1.0.

If you do upgrade to Java 8, note that by default JRuby will enable
InvokeDynamic support. This will change the performance profile of
your application, including memory usage, so be sure to test it out in
a staging environment first before just moving to Java 8 in
production.

### Bundled JRuby updated from 1.7.10 to 1.7.11

Like always, we've bumped the bundled JRuby version to the latest
available at the time of release. Read the JRuby [1.7.11][jruby1711]
release announcement to see what's changed.

JRuby 1.7.11 includes several nice performance fixes, including a
[faster SecureRandom][faster_secrand] implementation that should
improve performance for all Rails users.

### Infinispan 6

We've upgraded from Infinispan 5.3.0 to 6.0.0. This greatly improves
the performance of our default session store configuration and should
clean up some errors occasionally seen when restarting nodes of a
cluster. See [TORQUE-1199][] and [TORQUE-1151][] for more details.

### Config.ru now loaded on boot by default

Users were consistently surprised by our old behavior of not loading
the config.ru file until the first web request came in. We've changed
that to load the file immediately upon boot. To get back the old
behavior, you can [configure][pooling] the web runtime pool to be lazy
instead of eager and we won't load config.ru until the first web
request comes in.


## Upgrading from 3.0.2

While it's not something we've actually tested, we wouldn't suggest
trying to do a rolling upgrade of a cluster from 3.0.2 to 3.1.0
because of the new Infinispan version. In the past, Infinispan version
bumps have meant clustered rolling upgrades might not go so well.

If you maintain your own XML config files, there is a change related
to the Infinispan upgrade you'll need to apply. Commit [b51fb2b][] has
all the details, but essentially there is now a 'polyglot'
cache-container defined in the config file instead of it just being an
alias to the 'web' cache-container.


## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 3.0.2

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1138'>TORQUE-1138</a>] -         Load config.ru with web deployment
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1145'>TORQUE-1145</a>] -         Update Getting Started Guide for Rails 4
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1151'>TORQUE-1151</a>] -         Occasional Infinispan errors when restarting nodes in a multiple node cluster
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1168'>TORQUE-1168</a>] -         Upgrade Infinispan to 6.0.0
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1199'>TORQUE-1199</a>] -         Clustered session store an order of magnitude slower than non-clustered.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1207'>TORQUE-1207</a>] -         Upgrade to JRuby 1.7.11
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1210'>TORQUE-1210</a>] -         TorqueBox doesn&#39;t boot under Java 8 GA release
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1211'>TORQUE-1211</a>] -         Transactional cache usage causes memory leak across redeploys
</li>
</ul>
                    



[download]:         /release/org/torquebox/torquebox-dist/3.1.0/torquebox-dist-3.1.0-bin.zip
[download_overlay]: /release/org/torquebox/torquebox-dist/3.1.0/torquebox-dist-3.1.0-eap-overlay.zip
[gettingstarted]:   /getting-started/3.1.0/
[htmldocs]:         /documentation/3.1.0/
[javadocs]:         /documentation/3.1.0/javadoc/
[rdocs]:            /documentation/3.1.0/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/3.1.0/torquebox-docs-en_US-3.1.0.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/3.1.0/torquebox-docs-en_US-3.1.0.epub
[features]:         /features
[community]:        /community/

[wildfly]:          http://wildfly.org/
[jruby1711]:        http://jruby.org/2014/02/25/jruby-1-7-11.html
[faster_secrand]:   http://blog.mogotest.com/2014/03/11/faster-securerandom-in-jruby-1.7.11/
[pooling]:          /documentation/3.1.0/pooling.html
[TORQUE-1199]:      https://issues.jboss.org/browse/TORQUE-1199
[TORQUE-1151]:      https://issues.jboss.org/browse/TORQUE-1151
[b51fb2b]:          https://github.com/torquebox/torquebox/commit/b51fb2b
