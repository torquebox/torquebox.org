---
title: 'TorqueBox 3.1.2 Released'
author: The Entire TorqueBox Team
layout: release
version: '3.1.2'
timestamp: 2015-04-09t10:45:00.0-04:00
tags: [ releases ]
---

A long overdue bug-fix release of TorqueBox 3 is out - TorqueBox
3.1.2. This release was done mainly to update the bundled JRuby from
1.7.13 to 1.7.19, but also includes a couple of other minor fixes.

* [Download TorqueBox 3.1.2 (ZIP)][download]
* [Download TorqueBox 3.1.2 (JBoss EAP overlay)][download_overlay]
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

## Highlights of changes in TorqueBox 3.1.2

### Bundled JRuby updated from 1.7.13 to 1.7.19

Like always, we've bumped the bundled JRuby version to the latest
available at the time of release - 1.7.19.

If you're wondering about JRuby 9 support, our current plan is to stay
with bundling JRuby 1.7.x with TorqueBox 3 and support JRuby 9 via
TorqueBox 4.

### Specific Rake version no longer required

TorqueBox 3.1.1 created a bug where our `torquebox-rake-support` gem
depended on a specific version of Rake instead of a wide range of
allowed versions. Oops. This is now fixed.

### X-Sendfile and Rails work together again

TorqueBox 3.1.1 also created a bug where using sendfile via X-Sendfile
from inside a Rails application caused an IllegalStateException to get
thrown. This is now fixed.


## Upgrading from 3.1.1

No changes should be required to applications or config files to
upgrade from TorqueBox 3.1.1 to 3.1.2.


## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 3.1.1

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1236'>TORQUE-1236</a>] -         torquebox-rake-support gem should not require specific Rake version
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1240'>TORQUE-1240</a>] -         X-Sendfile and Rails not working together 
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1242'>TORQUE-1242</a>] -         Upgrade to JRuby 1.7.19
</li>
</ul>


[download]:         /release/org/torquebox/torquebox-dist/3.1.2/torquebox-dist-3.1.2-bin.zip
[download_overlay]: /release/org/torquebox/torquebox-dist/3.1.2/torquebox-dist-3.1.2-eap-overlay.zip
[gettingstarted]:   /getting-started/3.1.2/
[htmldocs]:         /documentation/3.1.2/
[javadocs]:         /documentation/3.1.2/javadoc/
[rdocs]:            /documentation/3.1.2/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/3.1.2/torquebox-docs-en_US-3.1.2.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/3.1.2/torquebox-docs-en_US-3.1.2.epub
[features]:         /features
[community]:        /community/
