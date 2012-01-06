---
title: 'TorqueBox v2.0.0.beta2 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.0.0.beta2'
tags: [ releases ]
---

The entire TorqueBox team is proud to announce immediate availability
of *TorqueBox v2.0.0.beta2*.

* [Download TorqueBox 2.0.0.beta2 (ZIP)][download]
* [Browse HTML manual][htmldocs]
* [Browse JavaDocs][javadocs]
* [Browse Gem RDocs][rdocs]
* [Download PDF manual][pdfdocs]
* [Download ePub manual][epubdocs]

# What is TorqueBox?

TorqueBox builds upon the JBoss AS Java application server,
mixing in JRuby, to provide a scalable platform for Ruby applications,
including support for Rails, Sinatra and other Rack-based frameworks.

In addition to supporting popular web frameworks, TorqueBox [bridges
many common Java facilities][features] provided by JBoss, including *scheduled jobs*,
*caching*, *messaging*, and *services*.

# What's special about 2.0.0?

This is the second beta for our 2.0.0 release, which is a *major* upgrade over
the 1.x you may already be familiar with.  Notable inclusions in 2.0.0 include:

* JRuby 1.6.5.1 (with better Ruby 1.9 support)
* JBoss AS7 (faster boot time, smaller memory footprint)
* Multi-resource distributed XA transactions
* WebSockets/STOMP

If you've been following our [incremental builds], this will mostly be just a 
label change for you.

# You're in luck, VFS is gone!

We've fixed quite a few issues since beta1, but one large change is how
we handle file paths and how those file paths are exposed to ruby. Before 
this change, paths given to ruby (via `__FILE__`, `Dir.pwd`, `RAILS_ROOT`, etc.) 
were vfs: urls instead of regular paths. Now, any paths that pass into ruby 
from TorqueBox will be regular platform-specific file paths.

## What is VFS?

VFS stands for 'Virtual File System', and is used internally by AS7 to be
able to transparently mount jars/wars and treat them as filesystems. At one
time, TorqueBox needed to expose VFS to support archived ruby applications,
but this is no longer the case since we now explode archived apps to a 
temporary folder instead of using them archived.

## Why remove VFS?

Exposing VFS to ruby required us to do extensive monkeypatching to `File`, `IO`,
`Dir`, and various other classes to teach them to properly understand vfs:
urls, and has been a constant source of issues. Recent changes in the Rails
asset pipeline code exposed even more issues, causing us to reevaluate the
need for exposing VFS to ruby.

## How will removing VFS affect me?

Well, hopefully you'll see less bugs. Seriously though, you shouldn't see
any difference in your application, unless you have already had to work
around VFS issues. In that case, you'll want to remove the workarounds. We
still have to use VFS internally to communicate with AS7, so it is possible 
that there are places where vfs: urls are still bleeding through to ruby. 

As part of this change, the `torquebox-vfs` gem has been retired. If you have
it listed in a `Gemfile` or manually require it in your code, you'll need to 
remove those references. 

If you see any issues, please [let us know][JIRA].

# What's next?

We'd like everyone to give our beta2 release a whirl, report any issues you find
in [JIRA], and we hope to have another beta in a few weeks.  We absolutely
promise not to let Bob run this beta cycle, in order to keep it a reasonable length.

The final 2.0.0 really shouldn't be too far down the line, now.

# Issues resolved since beta1

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-407'>TORQUE-407</a>] -         &#39;rails console&#39; Throws Error When Gemfile Includes &#39;torquebox&#39;
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-510'>TORQUE-510</a>] -         CLONE - [BackStage] Display HornetQ cluster configuration
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-511'>TORQUE-511</a>] -         CLONE - [BackStage] Add Caches tab view to display infinispan statistics
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-600'>TORQUE-600</a>] -         System calls can fail silently when executed from the app server
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-627'>TORQUE-627</a>] -         Add profiler option to ruby section of deployment descriptor to allow profiling
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-628'>TORQUE-628</a>] -         stomp-endpoint appears to ignore host:
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-635'>TORQUE-635</a>] -         Using torque_box_cache Breaks Rake Tasks
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-639'>TORQUE-639</a>] -         Publish and link to javadocs/rdocs
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-640'>TORQUE-640</a>] -         Allow naming of knob file when deploying
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-642'>TORQUE-642</a>] -         Error on stylesheet_link_tag &amp; javascript_include_tag
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-644'>TORQUE-644</a>] -         Add rails template behavior to torquebox command
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-645'>TORQUE-645</a>] -         Update to AS 7.1.0.beta1b
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-647'>TORQUE-647</a>] -         Cannot start Torquebox and deployment failed on Ubuntu, Jruby 1.6.5, RVM, RAils 3.1.3
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-652'>TORQUE-652</a>] -         Can&#39;t use :torque_box_store in a non-torquebox environment
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-653'>TORQUE-653</a>] -         injection analyzer takes forever when confronted with lots of files
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-655'>TORQUE-655</a>] -         The TorqueBox config/initializers/session_store.rb created by the TorqueBox Rails template can cause problems when running an app outside of TorqueBox
</li>

<li>[<a href='https://issues.jboss.org/browse/TORQUE-657'>TORQUE-657</a>] -         TorqueBox builds generate 2 different gemspecs for the torquebox-* gems
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-659'>TORQUE-659</a>] -         Remove vfs from rubyland
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-661'>TORQUE-661</a>] -         torquebox run --clustered Broken
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-663'>TORQUE-663</a>] -         Add a torquebox archive ROOT subcommand to /bin/torquebox
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-666'>TORQUE-666</a>] -         Parse exceptions that occur during injection analysis should be logged and ignored
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-667'>TORQUE-667</a>] -         Quiet Injection Analyzer Warnings
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-668'>TORQUE-668</a>] -         Applications Containing database.yml Entries With Both jdbcmysql and mysql Adapters Don&#39;t Boot
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-669'>TORQUE-669</a>] -         rake torquebox:launchd:check aborted because TorqueBoxAgent.plist not installed
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-670'>TORQUE-670</a>] -         Need ability to set the client_id on a MessageProcessor for durable topics.
</li>
</ul>

[download]: /release/org/torquebox/torquebox-dist/2.0.0.beta2/torquebox-dist-2.0.0.beta2-bin.zip
[htmldocs]: /documentation/2.0.0.beta2/
[javadocs]: /documentation/2.0.0.beta2/javadoc/
[rdocs]: /documentation/2.0.0.beta2/yardoc/
[pdfdocs]:  /release/org/torquebox/torquebox-docs-en_US/2.0.0.beta2/torquebox-docs-en_US-2.0.0.beta2.pdf
[epubdocs]: /release/org/torquebox/torquebox-docs-en_US/2.0.0.beta2/torquebox-docs-en_US-2.0.0.beta2.epub
[features]: /features
[as7]: http://www.jboss.org/as7.html
[incremental builds]: /2x/builds/
[JIRA]: http://issues.jboss.org/
