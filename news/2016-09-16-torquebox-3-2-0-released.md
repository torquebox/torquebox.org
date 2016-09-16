---
title: 'TorqueBox 3.2.0 Released'
author: The Entire TorqueBox Team
layout: release
version: '3.2.0'
timestamp: 2016-09-16t12:30:00.0-04:00
tags: [ releases ]
---

TorqueBox 3.2.0 is out and updates the bundled JRuby from the 1.7
series to 9.1.5.0 along with a few other minor fixes.

* [Download TorqueBox 3.2.0 (ZIP)][download]
* [Download TorqueBox 3.2.0 (JBoss EAP overlay)][download_overlay]
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

## Upgrading from 3.1.2

The biggest change is our bundled JRuby version is now 9.1.5.0 instead
of 1.7. This means applications will run under Ruby 2.3 compatibility
instead of 1.8, 1.9, or 2.0. Any Ruby version settings in your
TorqueBox configs will be ignored since they no longer apply.

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 3.1.2
<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1254'>TORQUE-1254</a>] -         run torquebox failed for first steps example
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1259'>TORQUE-1259</a>] -         Release a new Torquebox 3.X version with jruby 9
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1261'>TORQUE-1261</a>] -         Torquebox fails to load rails app depending on bundler config
</li>
<li>[<a href='https://github.com/torquebox/torquebox/pull/228'>#228</a>] -  Add support for sprocket manifest dotfiles for TorqueBox 3.x
</li>
<li>[<a href='https://github.com/torquebox/torquebox/issues/233'>#233</a>] - Torquebox 3.1.2 - Load error on VariableStack Java class
</li>
</ul>

[download]:         /release/org/torquebox/torquebox-dist/3.2.0/torquebox-dist-3.2.0-bin.zip
[download_overlay]: /release/org/torquebox/torquebox-dist/3.2.0/torquebox-dist-3.2.0-eap-overlay.zip
[gettingstarted]:   /getting-started/3.2.0/
[htmldocs]:         /documentation/3.2.0/
[javadocs]:         /documentation/3.2.0/javadoc/
[rdocs]:            /documentation/3.2.0/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/3.2.0/torquebox-docs-en_US-3.2.0.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/3.2.0/torquebox-docs-en_US-3.2.0.epub
[features]:         /features
[community]:        /community/
