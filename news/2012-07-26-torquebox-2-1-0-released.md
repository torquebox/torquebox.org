---
title: 'TorqueBox 2.1.0 - New Release and New Leadership'
author: The Entire TorqueBox Team
layout: release
version: '2.1.0'
timestamp: 2012-07-26t14:00:00.0-05:00
tags: [ releases ]
---

We're extremely excited to announce the immediate availability of
TorqueBox 2.1.0! This release includes a lot of bug fixes (especially
around clustering) and several new features, described in a bit more
detail below. We've also had a change in the TorqueBox project
leadership and produced an updated roadmap to share so be sure to keep
reading.

* [Download TorqueBox 2.1.0 (ZIP)][download]
* [Browse HTML manual][htmldocs]
* [Browse JavaDocs][javadocs]
* [Browse Gem RDocs][rdocs]
* [Download PDF manual][pdfdocs]
* [Download ePub manual][epubdocs]

## Highlights of major changes

* The version of AS7 that TorqueBox is based on has been updated to an
  incremental build based on their 7.1 branch. This fixed several
  clustering-related bugs.

* The `inject` method has been renamed to `fetch` to reduce confusion
  with Enumerable's built-in `inject` method. All your old code will
  continue to work with `inject` but in some future release, probably
  2.2.0, `inject` will be removed.

* The default clustering mode of TorqueBox::Infinispan::Cache is now
  distributed instead of invalidated. See the [caching clustering mode
  documentation][cacheclusterdocs] for more details on the different
  modes.

* TorqueBox now respects the `$JRUBY_OPTS` environment variable which
  is useful for setting default 1.8 vs 1.9 Ruby modes or various other
  JRuby settings that aren't exposed in our torquebox.yml or
  torquebox.rb configuration. See the [documentation][jrubyoptsdocs]
  for more details.

* InvokeDynamic support in JRuby is now disabled by default in
  TorqueBox to work around a bug in current JDK 7 builds that
  manifests itself as a `NoClassDefFoundError`. This is just a
  temporary measure to keep things working until a fixed JDK 7 is
  released.

* Scheduled jobs now support configurable timeout and concurrency
  options for more control over how long a job is allowed to run and
  how many jobs can be run in parallel. See the scheduled job
  [timeout][jobtimeout] and [concurrency][jobconcurrency] documentation
  for more details.

## Leadership change

Almost four years ago, [Bob McWhirter][bob] took the crazy idea of
running Ruby applications on top of JBoss Application Server and made
it into reality with the first release of [JBoss
Rails][jbossrails]. About one year after that initial prototype the
project was renamed and [TorqueBox was born][tbannouncement]. In these
past 3 years Bob has lead over 40 new TorqueBox releases, assembled an
amazing [team][] of developers, and convinced Red Hat to support
TorqueBox both financially (by hiring said team) and technologically
(by offering TorqueBox as a supported Red Hat product - more on this
below).

While Bob is still very active in TorqueBox, being the Director of
Polyglot for JBoss means he has plenty of other cool projects in
various stages of development that also require his attention. So,
effective last Friday, [Ben Browning][ben] is now the project lead of
TorqueBox. Ben has been an integral part of the TorqueBox team for the
past two years and has been unofficially driving things for the past
few months anyway - now it's just official.

## Upgrading from 2.0.3

changes to config file format

## What happened to 2.0.4?

## Roadmap update

## Expanded CI testing
jruby 1.7, windows

## Red Hat now offers TorqueBox support


[download]:         /release/org/torquebox/torquebox-dist/2.1.0/torquebox-dist-2.1.0-bin.zip
[htmldocs]:         /documentation/2.1.0
[javadocs]:         /documentation/2.1.0/javadoc/
[rdocs]:            /documentation/2.1.0/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/2.1.0/torquebox-docs-en_US-2.1.0.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/2.1.0/torquebox-docs-en_US-2.1.0.epub
[cacheclusterdocs]: /documentation/2.1.0/cache.html#caching-clustering-modes
[jrubyoptsdocs]:    /documentation/2.1.0/installation.html#setting-jruby-properties
[jobtimeout]:       /documentation/2.1.0/scheduled-jobs.html#jobs-timeout
[jobconcurrency]:   /documentation/2.1.0/scheduled-jobs.html#jobs-concurrency
[bob]:              https://twitter.com/bobmcwhirter
[jbossrails]:       http://oddthesis.org/posts/2008-09-jboss-on-rails/
[tbannouncement]:   /news/2009/05/18/announcing-the-torquebox-project/
[team]:             http://projectodd.org
[ben]:              https://twitter.com/bbrowning
