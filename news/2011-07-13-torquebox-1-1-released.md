---
title: 'TorqueBox v1.1 Released'
author: The Entire TorqueBox Team
layout: release
version: '1.1'
tags: [ releases ]
---

# TorqueBox v1.1 Released

The entire TorqueBox team is proud to announce immediate availability
of *TorqueBox v1.1*.

* [Download TorqueBox 1.1 (ZIP)][download]
* [Browse HTML documentation][htmldocs]
* [Download PDF documentation][pdfdocs]
* [Download ePub documentation][epubdocs]

# What is TorqueBox?

TorqueBox builds upon the JBoss AS Java application server,
mixing in JRuby, to provide a scalable platform for Ruby applications,
including support for Rails, Sinatra and other Rack-based frameworks.

In addition to supporting popular web frameworks, TorqueBox [bridges
many common Java facilities][features] provided by JBoss, including *scheduled jobs*,
*caching*, *messaging*, and *services*.

# What's in this release?

This is mostly a bug-fix release, but does include few notable improvements:

* This version includes JRuby 1.6.3. If you aren't using the bundled JRuby, 
  we recommend that you upgrade to 1.6.3, especially if you are using JRuby's 1.9 
  compatibility mode. See [JRUBY-5839] for more details.

* Asynchronous task calls (either via an [Async Task] or a [Backgroundable method]) now 
  return Future objects, allowing you to monitor the results of the task from the 
  caller. See our recent [blog post][futures_post] and the [docs][futures_docs] for details.
  
* Topics now support durable subscriptions via the `receive` method. See the [docs][durable_topics]
  for more details.

* The [New Relic] gem (version 3.1.0 and newer) now properly recognizes a TorqueBox application. 

## What's changed since 1.0.1?

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-71'>TORQUE-71</a>] -         Support NewRelic RPM
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-423'>TORQUE-423</a>] -         Include rack.gem in the distribution for a cleaner out-of-the-box experience.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-424'>TORQUE-424</a>] -         Include bundler.gem in the distribution for a more convenient out-of-the-box user experience
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-430'>TORQUE-430</a>] -         Monkey patch rack to fix broken Enumerable#map under jruby --1.9
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-435'>TORQUE-435</a>] -         Enumerable#inject and TorqueBox::Injectors#inject stomp the snot out of each other
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-437'>TORQUE-437</a>] -         support durable topic subscriptions via Topic#receive
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-442'>TORQUE-442</a>] -         Documentation shows Service parameter hashes being passed with symbol keys, when they are in fact strings
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-445'>TORQUE-445</a>] -         File.exists? erroneously returns true for a non-existent file if a file[2..-1] exists in the same dir
</li>

<li>[<a href='https://issues.jboss.org/browse/TORQUE-450'>TORQUE-450</a>] -         Tasks and Backgroundable should return a future object
</li>

<li>[<a href='https://issues.jboss.org/browse/TORQUE-452'>TORQUE-452</a>] -         Bare rack applications don&#39;t have access to rack.session
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-461'>TORQUE-461</a>] -         Dir.glob returns non-existing filenames
</li>

<li>[<a href='https://issues.jboss.org/browse/TORQUE-468'>TORQUE-468</a>] -         Support Session#unsubscribe for durable topics
</li>

<li>[<a href='https://issues.jboss.org/browse/TORQUE-469'>TORQUE-469</a>] -         Injection analyzer fails with rails 3.1
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-473'>TORQUE-473</a>] -         Sending binary files directly via hornetq results in corruption
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-475'>TORQUE-475</a>] -         The singleton option for jobs does not work in a cluster
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-477'>TORQUE-477</a>] -         Starting Rails 3.1 app fails due to &quot;Application has been already initialized&quot;
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-479'>TORQUE-479</a>] -         Update to JRuby 1.6.3
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-485'>TORQUE-485</a>] -         Update rails template to work with rails 3.1
</li>

</ul>
                            
# What's next?

After this release, we don't anticipate any more releases to the 1.x 
line before our next major release (2.0), though we do reserve the right 
to change our minds. The 2.0 release will be built on top of the recently 
released [JBossAS 7][as7], and have a considerably faster deploy time along
with a much lower memory footprint. We hope to have a 2.0 beta soon,
but in the meantime, feel free to give our [incremental builds][2x] a try.


[download]: http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-dist/1.1/torquebox-dist-1.1-bin.zip
[htmldocs]: /documentation/1.1/
[pdfdocs]:  http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-docs-en_US/1.1/torquebox-docs-en_US-1.1.pdf
[epubdocs]: http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-docs-en_US/1.1/torquebox-docs-en_US-1.1.epub
[features]: /features/
[JRUBY-5839]: http://jira.codehaus.org/browse/JRUBY-5839
[Backgroundable method]: /documentation/1.1/messaging.html#backgroundable
[Async Task]: /documentation/1.1/messaging.html#async-tasks
[durable_topics]: /documentation/1.1/messaging.html#receiving-messages
[futures_post]: /news/2011/07/08/the-future-is-now/
[futures_docs]: /documentation/1.1/messaging.html#messaging-futures
[as7]: http://www.jboss.org/as7.html
[2x]: /2x/builds/
[New Relic]: http://newrelic.com/
