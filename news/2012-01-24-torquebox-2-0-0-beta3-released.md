---
title: 'TorqueBox v2.0.0.beta3 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.0.0.beta3'
timestamp: 2012-01-24t14:45:00.0-05:00
tags: [ releases ]
---

The entire TorqueBox team is proud to announce the immediate
availability of *TorqueBox v2.0.0.beta3*.

* [Download TorqueBox 2.0.0.beta3 (ZIP)][download]
* [Browse HTML manual][htmldocs]
* [Browse JavaDocs][javadocs]
* [Browse Gem RDocs][rdocs]
* [Download PDF manual][pdfdocs]
* [Download ePub manual][epubdocs]

# What is TorqueBox?

TorqueBox is a Ruby application server built on JBoss AS7 and JRuby.  In
addition to supporting Rack-based web frameworks, TorqueBox provides [simple
Ruby interfaces][features] to standard JavaEE services, including *scheduled
jobs*, *caching*, *messaging*, and *services*.

# What's special about 2.0.0?

This is the third beta for our 2.0.0 release, which is a *major*
upgrade over the 1.x you may already be familiar with.  Notable
inclusions in 2.0.0 include:

* JRuby 1.6.5.1 (with better Ruby 1.9 support)
* JBoss AS7 (faster boot time, smaller memory footprint)
* Multi-resource distributed XA transactions
* WebSockets/STOMP

# What's In Beta 3?

## No-op gem

I'll admit it. Sometimes unit testing is difficult. While TorqueSpec is great
for integration tests, you don't always want or need the entire TorqueBox
stack. Introducing `torquebox-no-op`. [Joe Kutner], a long-time TorqueBox
user has written this gem to help you out in those situations.  It's now
maintained in the TorqueBox source. Look for a post from Joe on these pages
soon.

## HornetQ updated to 2.2.10

This release brings with it an updated HornetQ, fixing a small memory
leak for each published message and issues with large messages in a
cluster.

## Configuration validation

One of the things that we wanted to add to TorqueBox is automatic validation for
your app's configuration. So, we now validate configuration at deploy time according to 
our schema. If it doesn't pass, we'll fail fast and stop the deployment with an 
appropriate error, which should greatly reduce confusing errors related to erroneous 
configuration.

## Issues resolved since beta2

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-474'>TORQUE-474</a>] -         HornetQ 2.1.2 Final throws NPE when largemessage is published to cluster  
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-592'>TORQUE-592</a>] -         Small Memory Leaked For Each Message Published
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-634'>TORQUE-634</a>] -         Large &quot;Indexing was not enabled on this cache&quot; Stack When Using torque_box_cache
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-656'>TORQUE-656</a>] -         org.jruby.exceptions.RaiseException: (NoMethodError) undefined method `to_app&#39; for #&lt;Rack::Builder:0x21aa4aaf&gt;
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-664'>TORQUE-664</a>] -         Disable output buffering
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-665'>TORQUE-665</a>] -         TorqueBox needs to document how to create messaging endpoints on the fly
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-679'>TORQUE-679</a>] -         Integration test coverage for torquebox thor command&#39;s archive tests is incomplete
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-680'>TORQUE-680</a>] -         Following documentation for publishing to a remote queue inside a jruby script results in failure.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-682'>TORQUE-682</a>] -         Knob files with a torquebox.rb fail deployment
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-687'>TORQUE-687</a>] -         AnnotationIndexProcessor runs unnecessarily on app root
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-692'>TORQUE-692</a>] -         Messaging section of schema does not allow for singleton option
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-693'>TORQUE-693</a>] -         Shipped domain.xml Throws ParseError
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-697'>TORQUE-697</a>] -         Get Rid of Huge MySQL Connection Ping CNFE Stack
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-624'>TORQUE-624</a>] -         Provide validation for torquebox configuration
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-681'>TORQUE-681</a>] -         Advanced Configuration for torquebox:archive Rake task.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-671'>TORQUE-671</a>] -         TorqueBox should allow users to disable the injection scanner if they are not using it
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-678'>TORQUE-678</a>] -         Introduce &quot;null-object, no-op, reasonable behavior&quot; when TB gems are used outside the JBoss container or even in MRI
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-684'>TORQUE-684</a>] -         Add support for startup command-options on upstart:install
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-676'>TORQUE-676</a>] -         Improve documentation about web.xml in WEB-INF instead of config/
</li>
</ul>

# What's next?

We'd like everyone to give our beta3 release a whirl and report any
issues you find in [JIRA]. If all goes as planned, we should have our
first 2.0.0 candidate release out in a few weeks!


[download]: /release/org/torquebox/torquebox-dist/2.0.0.beta3/torquebox-dist-2.0.0.beta3-bin.zip
[htmldocs]: /documentation/2.0.0.beta3/
[javadocs]: /documentation/2.0.0.beta3/javadoc/
[rdocs]:    /documentation/2.0.0.beta3/yardoc/
[pdfdocs]:  /release/org/torquebox/torquebox-docs-en_US/2.0.0.beta3/torquebox-docs-en_US-2.0.0.beta3.pdf
[epubdocs]: /release/org/torquebox/torquebox-docs-en_US/2.0.0.beta3/torquebox-docs-en_US-2.0.0.beta3.epub
[features]: /features
[JIRA]: http://issues.jboss.org/browse/TORQUE
[Joe Kutner]: https://github.com/jkutner
