---
title: 'TorqueBox v2.0.0.cr1 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.0.0.cr1'
timestamp: 2012-03-05t09:15:00.0-05:00
tags: [ releases ]
---

The entire TorqueBox team is proud to announce the immediate
availability of *TorqueBox v2.0.0.cr1*.

* [Download TorqueBox 2.0.0.cr1 (ZIP)][download]
* [Browse HTML manual][htmldocs]
* [Browse JavaDocs][javadocs]
* [Browse Gem RDocs][rdocs]
* [Download PDF manual][pdfdocs]
* [Download ePub manual][epubdocs]

# What is TorqueBox?

TorqueBox is a Ruby application server built on JBoss AS7 and JRuby.  In
addition to being one of the [fastest Ruby servers around][BENchmarks], it supports
Rack-based web frameworks, and provides [simple Ruby interfaces][features] to
standard JavaEE services, including *scheduled jobs*, *caching*, *messaging*,
and *services*.

# What's special about 2.0.0?

This is the first candidate-release (see below) for our 2.0.0 version, which is a *major*
upgrade over the 1.x you may already be familiar with.  Notable
inclusions in 2.0.0 include:

* JRuby 1.6.7 (with better Ruby 1.9 support)
* JBoss AS7 (faster boot time, smaller memory footprint)
* [Multi-resource distributed XA transactions][XA]
* [WebSockets/STOMP][STOMP]

We'd love it if you give our *CR1* release a whirl and report any
issues you find in [JIRA].

# What's CR1?

*CR1* means this is our first *Candidate Release* for the *2.0.0* version.  It is
of a quality that we're comfortable thinking it just might be our 2.0.0 release.  But
this is your opportunity to find any last-minute show-stopper bugs before we apply
the final stamp of approval.  Things will roll quickly from here out, we hope.

## What's in the tin?

Mostly we focused on bugfixes, but a few features did slip in before we closed
the CR pipeline.

* A new `clojure` encoding for messaging to allow even better interop with [Immutant] message
publishers and processors.
* Easier to pass options to JBoss/JVM from the `torquebox` command.
* Better DataMapper support with messaging-related features.
* `torquebox_init.rb` for arbitrary initialization code.

## Issues resolved since beta3

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-585'>TORQUE-585</a>] -         ERROR: Can&#39;t get clustered cache; falling back to local: undefined method `transaction&#39; for #&lt;Java::OrgInfinispanConfig::Configuration:0x5bdd2dcd&gt;
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-648'>TORQUE-648</a>] -         Poor error message when active_record_store is used instead of torque_box_store
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-672'>TORQUE-672</a>] -         torquebox deploy doesn&#39;t set default environment
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-683'>TORQUE-683</a>] -         Stomplets fails sometimes during setup
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-685'>TORQUE-685</a>] -         Occasionally unable to deploy app due to LifecycleException - null classloader
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-686'>TORQUE-686</a>] -         Rename the &quot;filter&quot; option to &quot;selector&quot; to be more consistent, both internally and with JMS
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-687'>TORQUE-687</a>] -         AnnotationIndexProcessor runs unnecessarily on app root
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-691'>TORQUE-691</a>] -         Documentation for Message Destination Constructor Options Incorrect
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-699'>TORQUE-699</a>] -         Deploying two applications in clustered mode fails.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-700'>TORQUE-700</a>] -         Messaging needs to handle DataMapper specially for Marshal.dump and Marshal.load
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-703'>TORQUE-703</a>] -         bin/torquebox fails with a stack trace if rails is not installed
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-704'>TORQUE-704</a>] -         `bin/torquebox rails` does not work with rails &lt; 3.0
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-707'>TORQUE-707</a>] -         The runtime initialization inheritance chain won&#39;t properly initialize bare apps
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-710'>TORQUE-710</a>] -         TorqueBox does not deploy web runtimes for Rails 2.x applications shimmed with bundler unless a config.ru file exists
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-711'>TORQUE-711</a>] -         The web: section in torquebox.yml requires a context: but shouldn&#39;t
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-717'>TORQUE-717</a>] -         XAResource generating many warning messages for non-clustered apps
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-721'>TORQUE-721</a>] -         Injection doesn&#39;t work properly in a padrino app
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-705'>TORQUE-705</a>] -         Docs for Ruby Web Frameworks (Section 4.6) should be updated to include `torquebox rails`
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-708'>TORQUE-708</a>] -         Allow for a torquebox-init.rb and/or a block in torquebox.rb for users to provide runtime initialization code
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-718'>TORQUE-718</a>] -         bin/torquebox deploy should remove .failed deployment markers for the app being deployed
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-719'>TORQUE-719</a>] -         Add bin/torquebox list to show apps currently deployed and their status (deployed, failed, waiting to be deployed).
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-698'>TORQUE-698</a>] -         Do a better job with rack app runtime load paths
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-702'>TORQUE-702</a>] -         session-timeout is not honored
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-709'>TORQUE-709</a>] -         Support Publishing Messages to Remote HornetQ Servers Requiring Authentication
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-712'>TORQUE-712</a>] -         Support passing through options to JBoss when using torque box run command
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-714'>TORQUE-714</a>] -         Make It Easy to Pass JVM Parameters to TorqueBox via torquebox run
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-722'>TORQUE-722</a>] -         Provide a :clojure message codec
</li>
</ul>
                                            


[download]: /release/org/torquebox/torquebox-dist/2.0.0.cr1/torquebox-dist-2.0.0.cr1-bin.zip
[htmldocs]: /documentation/2.0.0.cr1/
[javadocs]: /documentation/2.0.0.cr1/javadoc/
[rdocs]:    /documentation/2.0.0.cr1/yardoc/
[pdfdocs]:  /release/org/torquebox/torquebox-docs-en_US/2.0.0.cr1/torquebox-docs-en_US-2.0.0.cr1.pdf
[epubdocs]: /release/org/torquebox/torquebox-docs-en_US/2.0.0.cr1/torquebox-docs-en_US-2.0.0.cr1.epub
[features]: /features
[JIRA]: http://issues.jboss.org/browse/TORQUE
[BENchmarks]: /news/2011/10/06/torquebox-2x-performance/
[Immutant]: http://immutant.org/
[STOMP]: /documentation/2.0.0.cr1/stomp.html
[XA]: /documentation/2.0.0.cr1/transactions.html
