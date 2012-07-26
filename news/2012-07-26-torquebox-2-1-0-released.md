---
title: 'TorqueBox 2.1.0 - New Release and New Leadership'
author: The Entire TorqueBox Team
layout: release
version: '2.1.0'
timestamp: 2012-07-26t14:00:00.0-05:00
tags: [ releases ]
---

We're extremely excited to announce the immediate availability of
TorqueBox 2.1.0! This release includes a lot of bug fixes and new
features, but we'd like to point out a few of these specifically:

* The version of AS7 that TorqueBox is based on has been updated to an
  incremental build based on their 7.1 branch. This fixed several
  clustering-related bugs.

* The `inject` method has been renamed to `fetch` to reduce confusion
  with Enumerable's built-in `inject` method.

* The default clustering mode of TorqueBox::Infinispan::Cache is now
  distributed instead of invalidated - see the [caching clustering
  mode documentation][cacheclusterdocs] for more details on the different
  modes.

* TorqueBox now respects the `$JRUBY_OPTS` environment variable which
  is useful for setting default 1.8 vs 1.9 Ruby modes or various other
  JRuby settings that aren't exposed in our torquebox.yml or
  torquebox.rb configuration - see the [documentation][jrubyoptsdocs]
  for more details.

* InvokeDynamic support in JRuby is now disabled by default in
  TorqueBox to work around a bug in current JDK 7 builds that
  manifests itself as a `NoClassDefFoundError`. This is just a
  temporary measure to keep things working until a fixed JDK 7 is
  released.

* Scheduled Jobs  - timeouts and concurrency, blah blah

## Upgrading from 2.0.3
changes to config file format

## Leadership change
bob -> ben

## What happened to 2.0.4?

## Roadmap update

## Expanded CI testing
jruby 1.7, windows

## Red Hat now offers TorqueBox support


* [Download TorqueBox 2.1.0 (ZIP)][download]
* [Browse HTML manual][htmldocs]
* [Browse JavaDocs][javadocs]
* [Browse Gem RDocs][rdocs]
* [Download PDF manual][pdfdocs]
* [Download ePub manual][epubdocs]


[download]:  /release/org/torquebox/torquebox-dist/2.1.0/torquebox-dist-2.1.0-bin.zip
[htmldocs]:  /documentation/2.1.0
[javadocs]:  /documentation/2.1.0/javadoc/
[rdocs]:     /documentation/2.1.0/yardoc/
[pdfdocs]:   /release/org/torquebox/torquebox-docs-en_US/2.1.0/torquebox-docs-en_US-2.1.0.pdf
[epubdocs]:  /release/org/torquebox/torquebox-docs-en_US/2.1.0/torquebox-docs-en_US-2.1.0.epub
[cacheclusterdocs]: /documentation/2.1.0/cache.html#caching-clustering-modes
[jrubyoptsdocs]: /documentation/2.1.0/installation.html#setting-jruby-properties
