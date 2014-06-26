---
title: 'TorqueBox 3.1.1 Released'
author: The Entire TorqueBox Team
layout: release
version: '3.1.1'
timestamp: 2014-06-26t10:45:00.0-05:00
tags: [ releases ]
---

The next bug-fix release in the TorqueBox 3 series is out, TorqueBox
3.1.1! This release includes JRuby 1.7.13, fixes multipart form
submissions, and drastically reduces memory consumption when uploading
large files. We'll continue to squash bugs in TorqueBox 3 on an
as-needed basis while still concentrating most of our efforts on the
upcoming TorqueBox 4.

* [Download TorqueBox 3.1.1 (ZIP)][download]
* [Download TorqueBox 3.1.1 (JBoss EAP overlay)][download_overlay]
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

## Highlights of changes in TorqueBox 3.1.1

### Bundled JRuby updated from 1.7.11 to 1.7.13

Like always, we've bumped the bundled JRuby version to the latest
available at the time of release. Read the JRuby [1.7.12][jruby1712]
and [1.7.13][jruby1713] release announcements to see what's changed
since the last TorqueBox release.

### Multipart form submissions fixed

A change in TorqueBox 3.0.2 broke many multipart form submissions and
this has been fixed in 3.1.1. See [TORQUE-1212][] for more details.

### Large file upload memory consumption fixed

The same change in TorqueBox 3.0.2 that broke multipart form
submissions also caused the entire file to be read into memory if more
than 4096 bytes of that file were read at one time. This is fixed in
TorqueBox 3.1.1. See [TORQUE-1228][] for more details.

### Memory leak on zero-downtime redeploy fixed

If you used TorqueBox Services and zero-downtime redeployments, we've
fixed an issue that was keeping a reference to the old service around
in TorqueBox::Registry and thus causing a memory leak on every
redeployment. See [TORQUE-1217][] for more details.


## Upgrading from 3.1.0

No changes should be required to applications or config files to
upgrade from TorqueBox 3.1.0 to 3.1.1.


## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 3.1.0

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1196'>TORQUE-1196</a>] -         Torquebox store throws errors when it receives NullSessionHash
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1212'>TORQUE-1212</a>] -         Multipart form submission appears broken in 3.0.2, works in 3.0.1
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1215'>TORQUE-1215</a>] -         JBOSS inserts content into response empty body
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1217'>TORQUE-1217</a>] -         TorqueBox::Registry was not updated after zero-downtime deployment
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1222'>TORQUE-1222</a>] -         Remove NonLeakingLoadService and friends
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1223'>TORQUE-1223</a>] -         Bundled bundler does not ship with a .bat file for windows users
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1224'>TORQUE-1224</a>] -         Upgrade JRuby to 1.7.13
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1226'>TORQUE-1226</a>] -         Rails cache store auto-loading broken
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1228'>TORQUE-1228</a>] -         RackChannel#read causes OutOfMemoryError when uploading large files
</li>
</ul>




[download]:         /release/org/torquebox/torquebox-dist/3.1.1/torquebox-dist-3.1.1-bin.zip
[download_overlay]: /release/org/torquebox/torquebox-dist/3.1.1/torquebox-dist-3.1.1-eap-overlay.zip
[gettingstarted]:   /getting-started/3.1.1/
[htmldocs]:         /documentation/3.1.1/
[javadocs]:         /documentation/3.1.1/javadoc/
[rdocs]:            /documentation/3.1.1/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/3.1.1/torquebox-docs-en_US-3.1.1.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/3.1.1/torquebox-docs-en_US-3.1.1.epub
[features]:         /features
[community]:        /community/

[jruby1712]:        http://jruby.org/2014/04/15/jruby-1-7-12.html
[jruby1713]:        http://jruby.org/2014/06/24/jruby-1-7-13.html
[torque-1212]:      https://issues.jboss.org/browse/TORQUE-1212
[torque-1217]:      https://issues.jboss.org/browse/TORQUE-1217
[torque-1228]:      https://issues.jboss.org/browse/TORQUE-1228
