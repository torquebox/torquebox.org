---
title: 'TorqueBox v2.0.0 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.0.0'
timestamp: 2012-04-02t16:30:00.0-05:00
tags: [ releases ]
---

The entire TorqueBox team is proud to announce the immediate
availability of *TorqueBox v2.0.0*.

* [Download TorqueBox 2.0.0 (ZIP)][download]
* [Browse HTML manual][htmldocs]
* [Browse JavaDocs][javadocs]
* [Browse Gem RDocs][rdocs]
* [Download PDF manual][pdfdocs]
* [Download ePub manual][epubdocs]

## What is TorqueBox?

TorqueBox is a Ruby application server built on JBoss AS7 and JRuby.  In
addition to being one of the [fastest Ruby servers around][BENchmarks], it supports
Rack-based web frameworks, and provides [simple Ruby interfaces][features] to
standard JavaEE services, including *scheduled jobs*, *caching*, *messaging*,
and *services*.

## What's special about 2.0.0?

This is the 2.0.0 *final* release, which is a *major*
upgrade over TorqueBox 1.x.  Notable inclusions in 2.0.0 include:

* JRuby 1.6.7 (with better Ruby 1.9 support)
* JBoss AS 7.1.1 (faster boot time, smaller memory footprint)
* [Multi-resource distributed XA transactions][XA]
* [WebSockets/STOMP][STOMP]
* Considerable [speed & memory improvements][BENchmarks] over 1.x

## What's changed since cr1?

We fixed a handful of issues reported against cr1, and gave our documentation an 
overhaul. Highlights in this release include:

* A brand-spankin-new [production setup guide]
* A chapter in the documentation covering [application deployment]
* Jobs & Services are now singleton by default - if you are running in a cluster 
  and were relying on Jobs and Services running on every node by default, you'll need 
  to turn off singleton support by setting `singleton: false` for each Job or Service.

## How do I migrate from 1.x to 2.0.0?

The biggest changes you'll see will be around any xml configuration changes you
have made to the underlying JBoss AS server. TorqueBox 1.x was based on AS6, and
2.x is based on AS7, which is considerably different than AS6. Any changes you'll
need to make to your application code and configuration should be minimal, if any.
We plan on writing migration guide sometime in the next couple of weeks. In the 
meantime, read through the [documentation][htmldocs], give it a try, and 
[bug us][community] if you have any questions or problems.

## Thanks to an outstanding community

Thanks to everyone that helped us with patches, bug reports, and generally good natured
support as we went through this major rewrite over the last 11 months. You guys are
great! Without you, there would just be us :)

We'd especially like to thank the following folks for their code contributions to 2.0.0:

* Benjamin Anderson 
* Bruno Oliveira 
* Carl Hörberg 
* Curtis Carter 
* David Glassborow 
* Gavin Stark 
* Joe Kutner 
* John Lynch 
* Joshua Borton 
* Kris Leech 
* Marek Goldmann 
* Mike Dobozy 
* Robert Rasmussen 
* Saulius Grigaitis 
* Tony Collen 
* penumbra 
* tinylox 

## Issues resolved since cr1

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-190'>TORQUE-190</a>] -         Create Documentation for Production setup of Torquebox
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-683'>TORQUE-683</a>] -         Stomplets fails sometimes during setup
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-713'>TORQUE-713</a>] -         TorqueBox documentation should highlight necessary postgres XA configuration changes
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-715'>TORQUE-715</a>] -         torquebox upstart task does not properly kill standalone server when stopping the torquebox service
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-723'>TORQUE-723</a>] -         jobs cannot load classes in a namespace
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-725'>TORQUE-725</a>] -         Document new torquebox run options
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-726'>TORQUE-726</a>] -         by default the Gemfile does not specify the version of torquebox, which cause bundle to bring in 1.1.1 =&gt; causes errors at runtime
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-728'>TORQUE-728</a>] -         Log a Warning and Disable XA When We Can&#39;t Parse database.yml
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-729'>TORQUE-729</a>] -         injection analyzer fails at startup
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-730'>TORQUE-730</a>] -         Default Xss is too small for medium-to-large Rails apps
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-731'>TORQUE-731</a>] -         torquebox.rb DSL no longer forwards options to services
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-732'>TORQUE-732</a>] -         Don&#39;t Automatically Attempt XA Connections to Non-Standard Database Keys in database.yml
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-733'>TORQUE-733</a>] -         Limit Maximum Stack Depth During Injection Analysis
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-736'>TORQUE-736</a>] -         Upgrade to AS 7.1.1.Final
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-737'>TORQUE-737</a>] -         Rails template (for Rails 2.x, at least) should enable torquebox_store for non-session caching (Rails.cache)
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-738'>TORQUE-738</a>] -         Torquebox/JBoss tries to deploy netty jar as application
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-739'>TORQUE-739</a>] -         Component configuration involving arrays don&#39;t survive full transfer to components when using torquebox.rb DSL
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-743'>TORQUE-743</a>] -         Write a basic config/torquebox.yml with some instructional comments as part of $TORQUEBOX_HOME/share/rails/template.rb
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-744'>TORQUE-744</a>] -         Support torquebox_init.rb in both ROOT and ROOT/config
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-745'>TORQUE-745</a>] -         TorqueBox Session (Section 4.4) Docs Should Show Session Usage for Rack Apps and Cross-Reference Rails / Sinatra Examples
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-746'>TORQUE-746</a>] -         TorqueBox::Infinispan::Cache not using cluster, always local
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-747'>TORQUE-747</a>] -         Change deploy:restart deploy:stop deploy:start behaviour
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-749'>TORQUE-749</a>] -         Clustered Jobs/Services should be singleton by default
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-750'>TORQUE-750</a>] -         Resource Injection is befuddled
</li>
</ul>

[download]: /release/org/torquebox/torquebox-dist/2.0.0/torquebox-dist-2.0.0-bin.zip
[htmldocs]: /documentation/2.0.0/
[javadocs]: /documentation/2.0.0/javadoc/
[rdocs]:    /documentation/2.0.0/yardoc/
[pdfdocs]:  /release/org/torquebox/torquebox-docs-en_US/2.0.0/torquebox-docs-en_US-2.0.0.pdf
[epubdocs]: /release/org/torquebox/torquebox-docs-en_US/2.0.0/torquebox-docs-en_US-2.0.0.epub
[features]: /features
[JIRA]: http://issues.jboss.org/browse/TORQUE
[BENchmarks]: /news/2011/10/06/torquebox-2x-performance/
[production setup guide]: /documentation/2.0.0/production-setup.html
[application deployment]: /documentation/2.0.0/deployment.html
[STOMP]: /documentation/2.0.0/stomp.html
[XA]: /documentation/2.0.0/transactions.html
[community]: /community
