---
title: 'TorqueBox 3.0.0 Released'
author: The Entire TorqueBox Team
layout: release
version: '3.0.0'
timestamp: 2013-08-29t13:15:00.0-04:00
tags: [ releases ]
---

We're pleased as punch to announce the release of TorqueBox 3.0.0!
Work first started on the 3.0 branch of TorqueBox seven months ago and
with the help of all our wonderful users and contributors we've
squeezed a lot of big changes into that time. This release
announcement includes things previously mentioned in the 3.0.0.beta1
and 3.0.0.beta2 announcements for those that have been waiting for
3.0.0 before updating. If you've been following along with the 3.0
beta releases, you can skip to the bottom to see issues resolved since
3.0.0.beta2.

* [Download TorqueBox 3.0.0 (ZIP)][download]
* [Download TorqueBox 3.0.0 (JBoss EAP overlay)][download_overlay]
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

## Highlights of changes in TorqueBox 3

### Smaller download and lighter footprint

The standard TorqueBox binary distribution has been slimmed down from
147mb to 61mb! The runtime footprint is also reduced - expect about a
20mb reduction in memory usage with the same applications deployed to
TorqueBox 3.0.0 compared to 2.3.2.

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
EAP 6, and unzip the TorqueBox overlay on top of EAP 6. We've added a
[new section to the Getting Started Guide][eap_instructions] to walk
you through this process.

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

### STOMP / WebSocket improvements

TorqueBox Stomplets, used for pushing data to a browser directly from
the server, now support falling back from WebSockets to Flash,
Server-Sent Events (SSE), and long-polling. We've also added secure
WebSocket (wss://) support, changed the JavaScript client API a bit,
and fixed passing of UTF8-encoded data from the JavaScript
client. Check out our blog posts "[STOMP Improvements][stomp_improve]"
and "[WebSockets: Secure!][wss]" for more details.


## Upgrading from 2.3.2

Upgrading from 2.3.2 to 3.0.0 should be fairly smooth - please let us know.

* If you deployed Java EE applications to TorqueBox you'll need the
new EAP overlay as described above.

* If you were still using `TorqueBox::Injectors.inject` that method
was removed - switch to `TorqueBox.fetch` instead.

* If you used the TorqueBox-provided JavaScript STOMP client, the way
  the .js file gets served, the way the client gets created, and the
  connect method have all changed. Read [this blog
  post][stomp_improve] for more details.

* If you managed the underlying AS7 configuration files yourself,
quite a few things have changed in TorqueBox 3. Take a moment to diff
the new configuration files against any existing ones. For the slim
distribution, standalone.xml, standalone-ha.xml, and domain.xml (in
domain mode) are what get used. For the EAP overlay,
torquebox-full.xml, torquebox-full-ha.xml, and torquebox-full.xml (in
domain mode) are what get used.

Read our [3.0.0.beta1][] and [3.0.0.beta2][] release announcements for
more specifics on the changes that went into each of those releases.

## Upgrading from 3.0.0.beta2

No changes (other than bumping gem versions) should be required to
your application or the AS7 configuration files to upgrade from
TorqueBox 3.0.0.beta2 to 3.0.0.

If you manage the AS7 configuration files yourself and run TorqueBox 3
in a non-multicast cluster or use the TorqueBox session store, you may
want to review the [changes we made][standalone_ha] to the jgroups,
infinispan, and messaging subsystems in the configuration files which
fixed issues TORQUE-869, TORQUE-1092, and TORQUE-1139 listed below.

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 3.0.0.beta2

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-869'>TORQUE-869</a>] -         Persist Rails sessions across deployments by default
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-991'>TORQUE-991</a>] -         XA and activerecord-jdbc-adapter 1.2.5 or higher don&#39;t play nicely together
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1086'>TORQUE-1086</a>] -         Stomp Web Socket is not encoding aware
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1092'>TORQUE-1092</a>] -         JGroups TCP discovery requests failing
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1133'>TORQUE-1133</a>] -         Stomplets dont put back database connections to the pool
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1134'>TORQUE-1134</a>] -         Stomplets dont handle non ascii chars?
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1135'>TORQUE-1135</a>] -         XA not working with jdbc-postgres 9.2.1002.1
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1136'>TORQUE-1136</a>] -         JRuby UnsafeGetter.getUnsafe throws an error
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1137'>TORQUE-1137</a>] -         Document possible need for CodeCache tuning
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1139'>TORQUE-1139</a>] -         Update default HornetQ cluster config to be more cloud-friendly
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1140'>TORQUE-1140</a>] -         Cannot have file named cache.rb in load path.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1143'>TORQUE-1143</a>] -         Remove middleware from STOMP docs in favor of fetching client from STOMP server directly
</li>
</ul>




[download]:         /release/org/torquebox/torquebox-dist/3.0.0/torquebox-dist-3.0.0-bin.zip
[download_overlay]: /release/org/torquebox/torquebox-dist/3.0.0/torquebox-dist-3.0.0-eap-overlay.zip
[gettingstarted]:   /getting-started/3.0.0/
[htmldocs]:         /documentation/3.0.0/
[javadocs]:         /documentation/3.0.0/javadoc/
[rdocs]:            /documentation/3.0.0/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/3.0.0/torquebox-docs-en_US-3.0.0.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/3.0.0/torquebox-docs-en_US-3.0.0.epub
[features]:         /features
[community]:        /community/

[download_eap]:     http://www.jboss.org/jbossas/downloads
[eap_instructions]: /getting-started/3.0.0/first-steps.html#first-steps-full-distro
[zero_downtime]:    /documentation/3.0.0/deployment.html#zero-downtime-redeployment
[job_api_docs]:     /documentation/3.0.0/yardoc/TorqueBox/ScheduledJob.html
[msgproc_api_docs]: /documentation/3.0.0/yardoc/TorqueBox/Messaging/MessageProcessor.html
[msgproxy_api_docs]:/documentation/3.0.0/yardoc/TorqueBox/Messaging/MessageProcessorProxy.html
[queue_api_docs]:   /documentation/3.0.0/yardoc/TorqueBox/Messaging/Queue.html
[ruby2rails4_bug]:  https://github.com/torquebox/torquebox/commit/5fc4da428f1d122a2c29ad3ea675b4cf1bc27565
[stomp_improve]:     /news/2013/03/20/stomp-improvements/
[wss]:               /news/2013/03/04/websockets-secure/
[standalone_ha]:     https://github.com/torquebox/torquebox/commits/3.0.0/build/assembly/src/main/resources/standalone/configuration/torquebox-slim-ha.xml
[3.0.0.beta1]:       /news/2013/07/15/torquebox-3-0-0-beta1-released/
[3.0.0.beta2]:       /news/2013/08/07/torquebox-3-0-0-beta2-released/
