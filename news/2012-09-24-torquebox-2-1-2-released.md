---
title: 'TorqueBox 2.1.2 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.1.2'
timestamp: 2012-09-24t21:30:00.0-04:00
tags: [ releases ]
---

We're as happy as a moth in a sweater factory to announce the
immediate availability of TorqueBox 2.1.2! This is a bug-fix only
release and is a recommended upgrade for anyone running TorqueBox
2.1.0 or 2.1.1.

<img src="/images/moth.jpg" class="alignright bordered" style="width: 300px;"/>

* [Download TorqueBox 2.1.2 (ZIP)][download]
* [Browse Getting Started Guide][gettingstarted]
* [Browse HTML manual][htmldocs]
* [Browse JavaDocs][javadocs]
* [Browse Gem RDocs][rdocs]
* [Download PDF manual][pdfdocs]
* [Download ePub manual][epubdocs]

## Highlights of major changes

* We have a new [Getting Started Guide][gettingstarted] that walks
  Windows, RVM, and Mac / Linux users through downloading and
  installing TorqueBox, deploying simple Rails and Rack applications,
  and adding basic TorqueBox features to an existing application.

* We fixed a bug in our handling of cookie headers caused by a
  misinterpretation of the Rack spec. If you had a Rails application
  that was setting cookies explicitly in addition to using session
  cookies and had unexplained issues with cookies going away, this is
  the reason and it's now fixed.

* Some users with Rails applications were seeing a large number of
  `already initialized constant` warnings during TorqueBox boot -
  these should no longer appear.

* We're a bit smarter about finding Bundler when `torquebox run` is
  used within an application that uses `bundle install
  --deployment`. If you've been fighting with errors like `no such
  file to -- bundler/setup` this should fix them.

* We're much looser in our Thor dependency requirement for the
  torquebox gem so any error caused by TorqueBox requiring a Thor
  version that was incompatible with other gems should be fixed.

* The parsing of database.yml to setup XA datasources has been
  improved to handle basic ERB usage, like reading environment
  variables. If you previously had to add `xa: false` to your
  database.yml and it contains ERB, try removing `xa: false` and see
  if things work.

## Upgrading from 2.1.1

Our goal with 2.1.2 was to be backwards-compatible with 2.1.1, so
there shouldn't be any special steps needed for the upgrade. None of
the underlying AS7 xml configuration files or torquebox.yml /
torquebox.rb files need any changes.

## Roadmap update

This is the last anticipated release in our 2.1.x line. The next
release is 2.2.0, currently scheduled for October 29th. The feature
list of 2.2.0 is probably a bit too aggressive so don't be surprised
if some things get bumped to 2.3.0. Head on over to the [roadmap][]
page and make sure you vote for any features you'd really like in
2.2.0 so we can prioritize accordingly.

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 2.1.1

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-802'>TORQUE-802</a>] -         Explain concurrency setting better.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-805'>TORQUE-805</a>] -         Favicon for BackStage
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-841'>TORQUE-841</a>] -         torquebox-capistrano-support always sets ruby version to 1.8 in the external descriptor which will prevent settings in the internal descriptor
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-859'>TORQUE-859</a>] -         Lots of constant already initialized warnings when booting Rails apps
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-913'>TORQUE-913</a>] -         `torquebox rails` does not properly detect if a directory already contains a Rails app
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-917'>TORQUE-917</a>] -         Backstage logs Invalid or misspelled option: credentials
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-920'>TORQUE-920</a>] -         When deployed with HTTP auth, Backstage ignores &quot;production&quot; env flag, defaulting to &quot;development&quot;
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-922'>TORQUE-922</a>] -         Web pool defaults to lazy if web pooling config given but lazy not specified
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-925'>TORQUE-925</a>] -         Create Getting Started Guide
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-927'>TORQUE-927</a>] -         Torquebox upstart should default to max 4096 open files
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-930'>TORQUE-930</a>] -         database.yml with ERB causes invalid XA error when creating jdbc datasource
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-931'>TORQUE-931</a>] -         Torquebox declares strict dependency on thor (0.14.6) which prevents installation with padrino (which requires ~&gt; 0.15.2)
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-932'>TORQUE-932</a>] -         Messages w/ marshal encoding cannot be decoded more than once
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-937'>TORQUE-937</a>] -         Rack cookie headers are not processed as expected through Torquebox
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-940'>TORQUE-940</a>] -         Binary distribution doesn&#39;t include .bat stubs for bundle and torquebox commands
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-944'>TORQUE-944</a>] -         TorqueBox can&#39;t find bundler/setup when app uses bundle install --deployment
</li>
</ul>


*Image &copy; Copyright [Mark A. Wilson] and licensed for reuse under this [Creative Commons License]. The original can be be found [here][image].*


[download]:         /release/org/torquebox/torquebox-dist/2.1.2/torquebox-dist-2.1.2-bin.zip
[htmldocs]:         /documentation/2.1.2/
[javadocs]:         /documentation/2.1.2/javadoc/
[rdocs]:            /documentation/2.1.2/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/2.1.2/torquebox-docs-en_US-2.1.2.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/2.1.2/torquebox-docs-en_US-2.1.2.epub
[gettingstarted]:   /getting-started/2.1.2/
[roadmap]:          https://issues.jboss.org/browse/TORQUE?selectedTab=com.atlassian.jira.plugin.system.project%3Aroadmap-panel
[community]:        /community
[Mark A. Wilson]:   http://commons.wikimedia.org/wiki/User:Wilson44691
[Creative Commons License]: http://creativecommons.org/licenses/by-sa/3.0/
[image]:            http://upload.wikimedia.org/wikipedia/commons/e/eb/Zygaena_filipendulae_Hiiumaa.jpg
