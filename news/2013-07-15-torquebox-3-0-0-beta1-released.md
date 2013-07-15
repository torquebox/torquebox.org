---
title: 'TorqueBox 3.0.0.beta1 Released'
author: The Entire TorqueBox Team
layout: release
version: '3.0.0.beta1'
timestamp: 2013-07-15t12:30:00.0-04:00
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
It supports Rack-based web frameworks and provides [simple Ruby
interfaces][features] to standard enterprisey services, including
*scheduled jobs*, *caching*, *messaging*, and *services*.

## Highlights of changes in 3.0.0.beta1

### Smaller download and lighter footprint

The standard TorqueBox binary distribution has been slimmed down from
147mb to 61mb! The runtime footprint is also reduced - expect about a
20mb reduction in memory usage with the same applications deployed to
TorqueBox 3.0.0.beta1 compared to 2.3.2.

The downside to all this slimming is that you can no longer run Java
EE applications (but can run regular Java .war files) in the standard
slim download. You'll need to overlay TorqueBox on top of JBoss EAP 6
(see below) if you deploy Java EE applications that utilize CDI, EJBs,
MDBs, or pretty much any other enterprise-sounding three letter
acronym. If you just use Ruby and the occasional .war file that will
run on servers like Apache Tomcat then the slim download is all you
need.

### Overlay for JBoss Enterprise Application Server 6

If you use Java EE then you'll need to download [JBoss EAP
6][download_eap], our new [TorqueBox overlay][download_overlay] for
EAP 6, and unzip the TorqueBox overlay on top of the unzipped EAP
6. We've added a [new section to the Getting Started
Guide][eap_instructions] to walk you through this process.

The TorqueBox EAP overlay is purely additive and does not modify any
existing files when unzipped on top of a JBoss EAP 6
installation. Because of this, if you boot EAP 6 via `standalone.sh`
instead of `torquebox run`, you'll need to tell EAP where to find the
TorqueBox config files:

    standalone.sh --server-config=torquebox-full.xml    # standalone
    standalone.sh --server-config=torquebox-full-ha.xml # standalone clustered
    domain.sh --server-config=torquebox-full.xml        # domain mode

### Zero downtime deployments

The ability to redeploy an application to TorqueBox without losing any
web requests was our most requested feature ever. And, with TorqueBox
3, we've added that and more! You can now redeploy an entire
application or just pieces of an application (web, messaging, jobs,
etc) without downtime. See the new [Zero Downtime
Redeployment][zero_downtime] section of our user manual for all the
details.

### More runtime control of jobs and messaging

We've exposed several new Ruby API methods to let you schedule jobs
(including new 'at'-style jobs), change a message processor's
concurrency setting, and expire or move messages between queues all at
runtime. If you haven't looked in a while, now would be a good time to
review our Ruby API docs. Specifically those for
[TorqueBox::ScheduledJob][job_api_docs],
[TorqueBox::Messaging::MessageProcessor][msgproc_api_docs],
[TorqueBox::Messaging::MessageProcessorProxy][msgproxy_api_docs], and
[TorqueBox::Messaging::Queue][queue_api_docs].

### Ruby 2.0 and Rails 4 support

We now support Ruby 2.0 and Rails 4 to the extent that JRuby
does. You'll need to use activerecord-jdbc-adapter 1.3.0.beta2 or
newer with Rails 4 - `rails new` won't automatically pick this version
for new applications.

If you want to try the combination of Rails 2.0 and Rails 4, you'll
need to add a workaround for a Struct#to_h bug present in JRuby 1.7.4
- see [commit
5fc4da428f1d122a2c29ad3ea675b4cf1bc27565][ruby2rails4_bug] for an
example.

### Resource injection completely overhauled

Previously, to use resource injection, we used to ask users to
`include TorqueBox::Injectors` followed by `fetch(...)`. We've now
deprecated that usage in favor of `TorqueBox.fetch`, without the need
to include anything into your classes. The old `inject(...)` method
from TorqueBox::Injectors was completely removed, since it was
deprecated in previous TorqueBox 2 releases.

We've also moved all injection work to happen at runtime, getting rid
of the previous behavior of scanning Ruby source files before
application deployment. Any configuration related to injection being
enabled or not or configuring the injection paths we scan is now
obsolete, and applications with large numbers of source files may
notice a substantial improvement in deployment speed.

### Messaging (HornetQ) clustering changes

We've upgraded to a newer version of HornetQ that now clusters via
JGroups for simplified clustering configuration. Whether in a
multicast or non-multicast environment the JGroups section of the AS7
configuration file now gets used for all clustering. This is
especially helpful when configuring clustering in non-multicast
environments like Amazon EC2.

### Other important changes

See the individual issues linked below for more details on each of
these items.

* [<a href='https://issues.jboss.org/browse/TORQUE-877'>TORQUE-877</a>] - remote message processors

* [<a href='https://issues.jboss.org/browse/TORQUE-470'>TORQUE-470</a>] - synchronous message processors

* [<a href='https://issues.jboss.org/browse/TORQUE-1030'>TORQUE-1030</a>] and the [new :encoding option][cache_docs] - configurable cache codecs

* [<a
  href='https://issues.jboss.org/browse/TORQUE-929'>TORQUE-929</a>]
  and [<a
  href='https://issues.jboss.org/browse/TORQUE-1061'>TORQUE-1061</a>] -
  ActiveRecord connections are now closed by TorqueBox after a
  scheduled job or message processor runs and when undeploying
  applications


## Upgrading from 2.3.2

Upgrading from 2.3.2 to 3.0.0.beta1 should be fairly smooth - please let us know.

* If you deployed Java EE applications to TorqueBox you'll need the
new EAP overlay as described above.

* If you were still using `TorqueBox::Injectors.inject` that method
was removed - switch to `TorqueBox.fetch` instead.

* If you managed the underlying AS7 configuration files yourself,
quite a few things have changed in TorqueBox 3. Take a moment to diff
the new configuration files against any existing ones. For the slim
distribution, standalone.xml, standalone-ha.xml, and domain.xml (in
domain mode) are what get used. For the EAP overlay,
torquebox-full.xml, torquebox-full-ha.xml, and torquebox-full.xml (in
domain mode) are what get used.

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
[features]:         /features
[community]:        /community/

[download_eap]:     http://www.jboss.org/jbossas/downloads
[eap_instructions]: /getting-started/3.0.0.beta1/first-steps.html#first-steps-full-distro
[zero_downtime]:    /documentation/3.0.0.beta1/deployment.html#zero-downtime-redeployment
[job_api_docs]:     /documentation/3.0.0.beta1/yardoc/TorqueBox/ScheduledJob.html
[msgproc_api_docs]: /documentation/3.0.0.beta1/yardoc/TorqueBox/Messaging/MessageProcessor.html
[msgproxy_api_docs]:/documentation/3.0.0.beta1/yardoc/TorqueBox/Messaging/MessageProcessorProxy.html
[queue_api_docs]:   /documentation/3.0.0.beta1/yardoc/TorqueBox/Messaging/Queue.html
[ruby2rails4_bug]:  https://github.com/torquebox/torquebox/commit/5fc4da428f1d122a2c29ad3ea675b4cf1bc27565
[cache_docs]:       /documentation/3.0.0.beta1/cache.html#caching-options-and-usage