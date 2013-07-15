---
title: 'TorqueBox 3.0.0.beta1 Released'
author: The Entire TorqueBox Team
layout: release
version: '3.0.0.beta1'
timestamp: 2013-07-15t11:30:00.0-04:00
tags: [ releases ]
---

After months of hard work and 325 commits from 18 contributors we're
proud to announce the first beta release of TorqueBox 3.0.0! This
release introduces a much smaller TorqueBox download along with many
other substantial changes, which we've highlighted below.

* [Download TorqueBox 3.0.0.beta1 (ZIP)][download]
* [Download TorqueBox 3.0.0.beta1 (JBoss EAP overlay, see below)][download_overlay]
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

## Highlights of changes in 3.0.0.beta1

## Upgrading from 2.3.2

Upgrading from 2.3.2 to 3.0.0.beta1 may require some application
changes (TorqueBox::Injectors.inject deprecation) and lots of config
changes that we should probably enumerate.

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 2.3.2

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-257'>TORQUE-257</a>] -         Provide support for &#39;at&#39; jobs
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-470'>TORQUE-470</a>] -         Synchronous Message Processors
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-591'>TORQUE-591</a>] -         Don&#39;t create a new connection only to re-use the currently active session
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-674'>TORQUE-674</a>] -         Allow runtime scheduling of jobs
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-764'>TORQUE-764</a>] -         Ability to accomplish anything that can be done in torquebox.yml via API that can be used dynamically at runtime
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-795'>TORQUE-795</a>] -         Allow changing processors&#39; concurrency setting without restarting torquebox or redeployment of an app
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-804'>TORQUE-804</a>] -         Expand clustering documentation with example output
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-819'>TORQUE-819</a>] -         Allow zero downtime deploy of specific Ruby runtimes
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-860'>TORQUE-860</a>] -         Allow to deploy Message Processors and Jobs stopped
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-877'>TORQUE-877</a>] -         fix support for remote message processors
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-887'>TORQUE-887</a>] -         rake torquebox:freeze doesn&#39;t generate the vendor/bundle/jruby/ tree under rails 3.2
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-929'>TORQUE-929</a>] -         Automatically close ActiveRecord connections when finished with work in non-web threads
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-941'>TORQUE-941</a>] -         cached ruby hash is invalid after tb deploy
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-959'>TORQUE-959</a>] -         expose the message_ttl for backgroundable futures
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-996'>TORQUE-996</a>] -         Mention non-activerecord use of JDBC in documentation
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1004'>TORQUE-1004</a>] -         Document how to enable sendfile support in TorqueBox
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1006'>TORQUE-1006</a>] -         Unable to use symbols to fetch session data
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1013'>TORQUE-1013</a>] -         Expose session configuration options
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1014'>TORQUE-1014</a>] -         Inconsistency in Rails session store and cache store names.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1017'>TORQUE-1017</a>] -         torquebox relies on AS71, but hornetq bridge relies on AS7.2
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1019'>TORQUE-1019</a>] -         Upgrade to AS 7.2 / EAP 6.1 compatible builds
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1022'>TORQUE-1022</a>] -         Capistrano support should use sudo to start/stop torquebox service in initd control style
</li>
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1023'>TORQUE-1023</a>] -         Capistrano support could let users deploy the application with a name other than the :application option
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1024'>TORQUE-1024</a>] -         TorqueBox session store should index by String too
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1025'>TORQUE-1025</a>] -         expose expireMessage, sendToDeadLetterQueue, and moveMessage methods
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1027'>TORQUE-1027</a>] -         Poorsmatic shouldn&#39;t &quot;rescue Exception&quot;
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1030'>TORQUE-1030</a>] -         Create a core codecs lib used by both messaging and caching
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1033'>TORQUE-1033</a>] -         Create messaging objects with a default :encoding 
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1034'>TORQUE-1034</a>] -         Re-enable container-managed JAAS authorization
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1039'>TORQUE-1039</a>] -         Update Remote JMX connection documentation
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1042'>TORQUE-1042</a>] -         Have destination deployment create a global MSC service
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1047'>TORQUE-1047</a>] -         Move all injection work to happen at runtime instead of a pre-deployment scanner
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1051'>TORQUE-1051</a>] -         &#39;torquebox rails&#39; command doesn&#39;t work with Rails 4
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1053'>TORQUE-1053</a>] -         Use QueueInstaller to create queues using TorqueBox::Messaging::Queue.start method
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1054'>TORQUE-1054</a>] -         Remove TorqueBox::Injectors deprecated inject method
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1056'>TORQUE-1056</a>] -         Add TorqueBox.fetch(...) method as alternative to including TorqueBox::Injectors
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1059'>TORQUE-1059</a>] -         Increase default messaging and jobs pool size in development mode
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1061'>TORQUE-1061</a>] -         Db connection leak between deploy
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1067'>TORQUE-1067</a>] -         Missing depednencies errror while replacing scheduled job
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1069'>TORQUE-1069</a>] -         Make it possible to create queues and topic at runtime in the way they are created currently at boot time
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1070'>TORQUE-1070</a>] -         Infinispan::Cache created with a persist option causes encoding errors
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1073'>TORQUE-1073</a>] -         Marshaling error with cache store
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1075'>TORQUE-1075</a>] -         Use service name in :inspect implementation
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1079'>TORQUE-1079</a>] -         Always reconfigure caches when created, regardless of replication mode
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1080'>TORQUE-1080</a>] -         Expose :max_entries and :eviction options for caches
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1087'>TORQUE-1087</a>] -         Servlets defined in WEB-INF/web.xml are ignored
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1088'>TORQUE-1088</a>] -         Documentation missing for clustering without multicast for jgroups-diagnostics
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1089'>TORQUE-1089</a>] -         Substantially decrease size of torquebox-server gem
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1090'>TORQUE-1090</a>] -         Improper assigning of the name instance variable in TorqueBox::Messaging::Queue and Topic when using the javax.jms.Destination as the destination
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1095'>TORQUE-1095</a>] -         Create Slim TorqueBox Based on Custom AS 7.2 Builds
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1101'>TORQUE-1101</a>] -         Make hornetq use jgroups for clustering
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1108'>TORQUE-1108</a>] -         UTF-8 strings become MacRoman on OS X when JVM runs under Apple JDK
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1111'>TORQUE-1111</a>] -         NoSuchHostException thrown when connecting over STOMP w/o WebSockets.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1113'>TORQUE-1113</a>] -         Add Ruby 2.0 Support
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1115'>TORQUE-1115</a>] -         Support Rails 4 applications
</li>
</ul>


[download]:         /release/org/torquebox/torquebox-dist/3.0.0.beta1/torquebox-dist-3.0.0.beta1-bin.zip
[download_overlay]: /release/org/torquebox/torquebox-dist/3.0.0.beta1/torquebox-dist-3.0.0.beta1-eap-overlay.zip
[gettingstarted]:   /getting-started/3.0.0.beta1/
[htmldocs]:         /documentation/3.0.0.beta1/
[javadocs]:         /documentation/3.0.0.beta1/javadoc/
[rdocs]:            /documentation/3.0.0.beta1/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/3.0.0.beta1/torquebox-docs-en_US-3.0.0.beta1.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/3.0.0.beta1/torquebox-docs-en_US-3.0.0.beta1.epub
[BENchmarks]:       /news/2011/10/06/torquebox-2x-performance/
[features]:         /features
[community]:        /community/