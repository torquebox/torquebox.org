---
title: 'TorqueBox v2.0.0.beta1 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.0.0.beta1'
tags: [ releases ]
---

# TorqueBox v2.0.0.beta1

The entire TorqueBox team is proud to announce immediate availability
of *TorqueBox v2.0.0.beta1*.

* [Download TorqueBox 2.0.0.beta1 (ZIP)][download]
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

This is the first beta for our 2.0.0 release, which is a *major* upgrade over
the 1.x you may already be familiar with.  Notable inclusions in this release include

* JRuby 1.6.5 (with better Ruby 1.9 support)
* JBoss AS7 (faster boot time, smaller memory footprint)
* Multi-resource distributed XA transactions
* WebSockets/STOMP

If you've been following our [incremental builds], this will mostly be just a 
label change for you.

# What's next?


[download]: /release/org/torquebox/torquebox-dist/2.0.0.beta1/torquebox-dist-2.0.0.beta1-bin.zip
[htmldocs]: /documentation/2.0.0.beta1/
[pdfdocs]:  /release/org/torquebox/torquebox-docs-en_US/2.0.0.beta1/torquebox-docs-en_US-2.0.0.beta1.pdf
[epubdocs]: /release/org/torquebox/torquebox-docs-en_US/2.0.0.beta1/torquebox-docs-en_US-2.0.0.beta1.epub
[features]: /features
[as7]: http://www.jboss.org/as7.html
[incremental builds]: /2x/builds/
