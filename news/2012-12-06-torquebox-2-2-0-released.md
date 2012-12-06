---
title: 'TorqueBox 2.2.0 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.2.0'
timestamp: 2012-12-06t16:30:00.0-05:00
tags: [ releases ]
---


We're very excited to announce the immediate availability of TorqueBox
2.2.0! This release has a substantial amount of new features and
bug-fixes over 2.1.2 and is a recommended upgrade for anyone running
TorqueBox 2.1.x

* [Download TorqueBox 2.2.0 (ZIP)][download]
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

## Highlights of major changes

* We now ship with JRuby 1.7.1, which is several versions newer with
  lots of changes compared to the JRuby 1.6.7.2 shipped in TorqueBox
  2.1.2.

* There's a new [torquebox-console][tbconsole] gem that you may have
  already seen. It's not shipped with TorqueBox itself - instead, it's
  an application you deploy to TorqueBox that gives you a web-based
  and a commandline-based console for interacting with your
  applications running inside TorqueBox. Note that it's still very
  young and missing some basic features like authentication so please
  don't run it on a production server unless you're absolutely sure
  you've locked it down.

* Scheduled Jobs and Services and now be inspected and controlled at
  runtime via our new [TorqueBox::ScheduledJob][job_rdoc] and
  [TorqueBox::Service][service_rdoc] APIs.

* If you've had any issues with redeployment of applications,
  especially ones running in a cluster, those should now be
  fixed. We've upgraded to a newer version of JBoss AS7 and combined
  with the newer version of JRuby lots of errors and memory leaks
  during redeploys are now fixed. If you still experience any memory
  leaks on application redeployment, please [get in touch][community]
  so we can track down what's causing it.

* There was a bug where HTTP responses from Rails streaming could get
  chunked twice - once by Rails and another time by JBoss AS7. If you
  experienced any issues with Rails streaming before and garbled
  responses, please try 2.2.0.

* A thread leak from scheduled jobs with a timeout set was fixed. If
  you use scheduled jobs with a job timeout on a previous TorqueBox
  version, you're likely leaking one thread every time the job gets
  fired and will eventually run out of memory.

## Upgrading from 2.1.2

* We now ship with JRuby 1.7.1, which has major changes over the JRuby
  1.6.7.2 we previously shipped. Most applications should work on the
  newer version without issue. Keep in mind that JRuby 1.7.x defaults
  to Ruby 1.9 mode instead of Ruby 1.8 mode.

* If you have customized versions of the AS7 config files
  (standalone.xml and friends), then there's a minor change you'll
  need to make to use the config file from TorqueBox 2.1.2 with
  TorqueBox 2.2.0 - see the diff at
  [https://gist.github.com/4173070](https://gist.github.com/4173070).

* Since TorqueBox now respects the "-J" style JRUBY_OPTS entries, make
  sure any JVM arguments set in JRUBY_OPTS are ones you want TorqueBox
  to use.

* The Rack PATH_INFO value was unintentionally being set to a decoded
  version of the path and that has now been fixed. As an example, a
  path of "thumb/633x579%2350%2C50" used to get decoded to
  "thumb/633x579#50,50" but now stays as
  "thumb/633x579%2350%2C50". This new behavior follows the Rack
  specification but has the potential to break applications running on
  TorqueBox that were expecting the previously incorrect behavior.

* The previous :clojure message encoding has been replaced by :edn. If
  you were using messaging to communicate between TorqueBox and
  Immutant you'll need to replace any references to the :clojure
  encoding with :edn.

## Roadmap update

The next scheduled release is TorqueBox 2.3.0 in early January. That's
not very far away, so check out our [roadmap][] and vote for any
issues you really want to see in 2.3.0.


## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 2.1.2

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-361'>TORQUE-361</a>] -         Expose durable option for Backgroundable
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-544'>TORQUE-544</a>] -         Allow services to be started/stopped on demand
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-549'>TORQUE-549</a>] -         Provide TorqueBox Console That Mimics Rails Console But Evaluates Ruby Inside TorqueBox Runtime
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-751'>TORQUE-751</a>] -         Tables in docs are hard to read.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-754'>TORQUE-754</a>] -         TypeError: assigning non-exception to $! raised in service call can&#39;t be rescured
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-811'>TORQUE-811</a>] -         unable to rescue NativeException: javax.jms.JMSException: Failed to create session factory
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-862'>TORQUE-862</a>] -         Allow runtime inspection and manipulation of jobs
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-879'>TORQUE-879</a>] -         app runs much slower after hot deployment than after fully restarting jboss server
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-891'>TORQUE-891</a>] -         always_background doesn&#39;t work properly with class methods
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-894'>TORQUE-894</a>] -         Document Backgroundable Usage with Class Methods
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-908'>TORQUE-908</a>] -         Hot deployment into cluster breaks clustering/infinispan
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-914'>TORQUE-914</a>] -         Torquebox hangs after &quot;Error invoking Rack filter: Attempt to unlock a mutex which is locked by another thread&quot;
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-926'>TORQUE-926</a>] -         session-timeout variable is not torquebox.rb DSL-friendly
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-936'>TORQUE-936</a>] -         Support -J style JRUBY_OPTS
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-938'>TORQUE-938</a>] -         torquebox-stomp causes load error when running rake
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-943'>TORQUE-943</a>] -         logging.properties file anywhere in app source tree gets loaded
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-945'>TORQUE-945</a>] -         ERB/encoding error in database.yml reported at startup
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-946'>TORQUE-946</a>] -         Windows .bat files don&#39;t work in binary distribution, only when built from source
</li>
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-947'>TORQUE-947</a>] -         Update to AS 7.1.x.incremental.129
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-950'>TORQUE-950</a>] -         Deploying via Capistrano Returns Error about jruby_opts
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-951'>TORQUE-951</a>] -         &quot;Could not locate Gemfile&quot; during boot
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-953'>TORQUE-953</a>] -         Upgrade Quartz to 2.1.5
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-954'>TORQUE-954</a>] -         (NameError) undefined method &#39;new&#39; for class &#39;#&lt;Class:0xe8e8bf&gt; during application deploy
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-955'>TORQUE-955</a>] -         Encoded backslashes in URL are not decoded correctly
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-956'>TORQUE-956</a>] -         Docs for long-lived-destinations do not mention the need to create -knob.yml.dodeploy
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-958'>TORQUE-958</a>] -         Enable code execution in arbitrary ruby runtimes through torquebox-console
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-963'>TORQUE-963</a>] -         Support bundling gems and precompiling assets in &#39;torquebox archive&#39;
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-964'>TORQUE-964</a>] -         Upgrade to JRuby 1.7.1
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-965'>TORQUE-965</a>] -         The polyglot-stomp socket-binding reverts to &quot;undefined&quot; on restart
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-966'>TORQUE-966</a>] -         Update production setup guide to use current TB version
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-967'>TORQUE-967</a>] -         Make TorqueBox::Logger compatible with Rack::CommonLogger
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-971'>TORQUE-971</a>] -         Allow alternate rackup config files for Rails apps
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-974'>TORQUE-974</a>] -         Replace clojure message encoding with edn
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-975'>TORQUE-975</a>] -         New Rake 10.0.2 causes issues with torquebox-rake-support dependency
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-976'>TORQUE-976</a>] -         Scheduled Tasks with Timeouts Never Clean Up Their Thread Pools
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-977'>TORQUE-977</a>] -         TorqueBox inadvertently decodes path part of URLs
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-978'>TORQUE-978</a>] -         Rails streamed responses come out double-chunk encoded
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-982'>TORQUE-982</a>] -         Workaround race condition in jnr-constant shipped with JRuby 1.7.1
</li>
</ul>



[download]:         /release/org/torquebox/torquebox-dist/2.2.0/torquebox-dist-2.2.0-bin.zip
[htmldocs]:         /documentation/2.2.0/
[javadocs]:         /documentation/2.2.0/javadoc/
[rdocs]:            /documentation/2.2.0/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/2.2.0/torquebox-docs-en_US-2.2.0.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/2.2.0/torquebox-docs-en_US-2.2.0.epub
[gettingstarted]:   /getting-started/2.2.0/
[BENchmarks]:       /news/2011/10/06/torquebox-2x-performance/
[features]:         /features
[tbconsole]:         https://github.com/torquebox/torquebox-console
[job_rdoc]:         /documentation/2.2.0/yardoc/TorqueBox/ScheduledJob.html
[service_rdoc]:     /documentation/2.2.0/yardoc/TorqueBox/Service.html
[roadmap]:          https://issues.jboss.org/browse/TORQUE?selectedTab=com.atlassian.jira.plugin.system.project%3Aroadmap-panel
[community]:        /community/
