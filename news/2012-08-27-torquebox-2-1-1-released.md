---
title: 'TorqueBox 2.1.1 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.1.1'
timestamp: 2012-08-27t16:30:00.0-05:00
tags: [ releases ]
---

We're extremely excited to announce the immediate availability of
TorqueBox 2.1.1! This is mostly a bug-fix release, with a few small
features slipped in. It is a recommended upgrade for anyone running
TorqueBox 2.x.

* [Download TorqueBox 2.1.1 (ZIP)][download]
* [Browse HTML manual][htmldocs]
* [Browse JavaDocs][javadocs]
* [Browse Gem RDocs][rdocs]
* [Download PDF manual][pdfdocs]
* [Download ePub manual][epubdocs]

## Highlights of major changes

* The JRuby runtime pools for the various subsystems (web, messaging,
  jobs, services, stomp) can now be toggled between **eager** or
  **lazy** startup. Eager pools will start when the application is
  deployed while lazy pools will wait until they are needed (first web
  request comes in, first job fires, first message received) before
  booting. The web runtime defaults to eager and the rest to
  lazy. This is the same defaults as 2.1.0, but now you have the
  option of changing those defaults. See the [pooling
  documentation][pooling_docs] for more details.

* There was a rather nasty bug where message processors and jobs were
  sharing a single instance of the message processor or job class when
  running in production mode with the default shared pooling. This has
  been fixed and every incoming message gets a new message processor
  instance and every job that fires gets a new job instance.

* TorqueBox will now serve files created by Rails page caching with
  our efficient static resource servlet vs cached page requests
  hitting the JRuby layer.

* Rolling deployments when load-balancing behind mod_cluster are now
  easier since we don't tell mod_cluster that a web application is
  ready until it's actually ready to serve requests. Previously we
  told mod_cluster the application was ready before the JRuby runtime
  had actually booted which led to long delays or timeouts on the
  first requests to hit the newly deployed application.

* Anyone using TorqueBox::Backgroundable with backgroundable methods
  that took longer than 5 minutes to complete has probably seen
  various errors in their logs related to the Arjuna library and
  transactions. To fix these errors, Backgroundable no longer runs
  inside an XA transaction by default. If you were relying on the
  transactionality of backgrounded methods, then you'll need to wrap
  the code inside your backgrounded method in a
  `TorqueBox.transaction` block as shown in the comments of
  [TORQUE-906][torque-906].

# Upgrading from 2.1.0

Our goal with 2.1.1 was to be backwards-compatible with 2.1.0, so
there shouldn't be any special steps needed for the upgrade. None of
the underlying AS7 xml configuration files or torquebox.yml /
torquebox.rb files need any changes. The only caveat is if you were
relying on Backgroundable's transactionality, as mentioned above.

# Roadmap update

We're still sticking to our monthly release schedule so expect
TorqueBox 2.1.2 (bug fixes only) to come out at the end of September
followed by TorqueBox 2.2.0 (new features galore) at the end of
October. As always the most up-to-date [roadmap][] is available in
JIRA.

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 2.1.0

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-420'>TORQUE-420</a>] -         Allow job classes to have a on_error method that we call when the job raises
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-433'>TORQUE-433</a>] -         Support Rails 3.1 Streaming Http Responses
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-542'>TORQUE-542</a>] -         Log the environment AS7 is booting in when calling `torquebox run`
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-629'>TORQUE-629</a>] -         stomp.yml causes Torquebox to fire a Warn: DEPLOYMENTS IN ERROR:   Deployment &quot;torquebox.StompServer&quot; is in error
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-820'>TORQUE-820</a>] -         Don&#39;t tell mod_cluster an app is deployed until web context is started
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-824'>TORQUE-824</a>] -         Torquebox should support rails page cache conventions out of the box
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-852'>TORQUE-852</a>] -         Processor and Service initialization receive a java Map
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-858'>TORQUE-858</a>] -         Infinispan throws errors when a symbol is used as a key
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-865'>TORQUE-865</a>] -         Enable eager/lazy initialization option per subsystem (jobs, messaging, etc)
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-881'>TORQUE-881</a>] -         Rails 3.2 Tagged Logging support
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-882'>TORQUE-882</a>] -         expose web context to rails applications
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-900'>TORQUE-900</a>] -         Rails template should not break an application when running in a non-torquebox context
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-902'>TORQUE-902</a>] -         Documentation/example for clustering mod_cluster without multicast is invalid and fails.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-903'>TORQUE-903</a>] -         Message Processors and Jobs are not threadsafe in production mode
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-906'>TORQUE-906</a>] -         Long-running backgroundable tasks cause the Arjuna reaper to retry
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-907'>TORQUE-907</a>] -         Support all the JEE transaction attributes, not just requires_new
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-909'>TORQUE-909</a>] -         TorqueBox dies on &quot;--client&quot; option in JRUBY_OPTS
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-911'>TORQUE-911</a>] -         Let receive optionally yield message to a block
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-912'>TORQUE-912</a>] -         Can&#39;t background task with NewRelic installed
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-916'>TORQUE-916</a>] -         torquebox.org/documentation/LATEST should point to 2.x docs, not 1.x
</li>
</ul>



[download]:         /release/org/torquebox/torquebox-dist/2.1.1/torquebox-dist-2.1.1-bin.zip
[htmldocs]:         /documentation/2.1.1
[javadocs]:         /documentation/2.1.1/javadoc/
[rdocs]:            /documentation/2.1.1/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/2.1.1/torquebox-docs-en_US-2.1.1.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/2.1.1/torquebox-docs-en_US-2.1.1.epub
[pooling_docs]:     /documentation/2.1.1/pooling.html#pooling-configuration
[torque-906]:       https://issues.jboss.org/browse/TORQUE-906
[roadmap]:          https://issues.jboss.org/browse/TORQUE?selectedTab=com.atlassian.jira.plugin.system.project%3Aroadmap-panel
[community]:        /community
