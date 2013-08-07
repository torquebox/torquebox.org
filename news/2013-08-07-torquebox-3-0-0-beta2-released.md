---
title: 'TorqueBox 3.0.0.beta2 Released'
author: The Entire TorqueBox Team
layout: release
version: '3.0.0.beta2'
timestamp: 2013-08-07t14:15:00.0-04:00
tags: [ releases ]
---

We received some great community feedback on the first TorqueBox 3
beta release and decided to spin a second beta to make sure all the
kinks are worked out. If everything goes well we hope to jump from
3.0.0.beta2 straight to 3.0.0 before the end of August. If you haven't
yet tried upgrading your application from TorqueBox 2.3.2 to TorqueBox
3 please do and let us know of any issues.

* [Download TorqueBox 3.0.0.beta2 (ZIP)][download]
* [Download TorqueBox 3.0.0.beta2 (JBoss EAP overlay)][download_overlay]
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

## Highlights of changes in 3.0.0.beta2

### Zero downtime deployment improvements

Zero downtime deployments now wait until the new JRuby runtimes are
completely initialized before sending requests to them, preventing any
web timeout issues you may have seen in 3.0.0.beta1.

If the new runtimes fail to initialize we also log and error and
continue to use the old runtimes so that an application isn't left in
an unusable state.

Our shipped Capistrano recipes were updated to point TorqueBox at the
"current" symlink instead of an actual release, allowing you to use
Capistrano to push a new release and then have Capistrano touch
tmp/restart.txt to execute a zero downtime deployment. If you've
modified our default recipe read the comments in
[TORQUE-1121][torque-1121] to see the commit details.

### OpenShift quickstart updated for TorqueBox 3

We've spent a lot of time testing and tweaking the [TorqueBox
quickstart for OpenShift][openshift-quickstart]. In addition to
getting it working with TorqueBox 3, we're also putting the finishing
touches on clustering support and will write up how to do that in the
next week. If you'd like to run TorqueBox on a PaaS this is the best
option.

### Heroku instructions updated for TorqueBox 3

We also updated the instructions for running [TorqueBox on
Heroku][heroku-torquebox]. Things are a bit better than with TorqueBox
2, but Heroku's 60 second deploy timeout still poses a challenge for
most TorqueBox applications.

### torquebox-console updated to work with TorqueBox 3

We released torquebox-console 0.3.0 a week ago that fixes
compatibility with TorqueBox 3 while also retaining compatibility with
TorqueBox 2. If you previously tried to use torquebox-console with
TorqueBox 3.0.0.beta1 or later updating to torquebox-console 0.3.0
should fix things.

## Upgrading from 3.0.0.beta1

No changes (other than bumping gem versions) should be required to
your application or the AS7 configuration files to upgrade from
TorqueBox 3.0.0.beta1 to 3.0.0.beta2.


## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 3.0.0.beta1

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1038'>TORQUE-1038</a>] -         torquebox-console switch_application doesn&#39;t work without parentheses.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1063'>TORQUE-1063</a>] -         torquebox run --help doesn&#39;t work
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1071'>TORQUE-1071</a>] -         torquebox-console doesn&#39;t work with 3.x incrementals
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1112'>TORQUE-1112</a>] -         Remove mod_cluster recommendation from docs
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1119'>TORQUE-1119</a>] -         Remove extra AS7 configs from slim dist
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1120'>TORQUE-1120</a>] -         Ensure all documentation config snippets are up-to-date
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1121'>TORQUE-1121</a>] -         Figure out how to integrate Capistrano and zero-downtime deploys
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1122'>TORQUE-1122</a>] -         torquebox-console broken with 3.0.0.beta1
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1123'>TORQUE-1123</a>] -         Disable management auth in the slim dist
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1124'>TORQUE-1124</a>] -         Wait until new runtimes are created before handing off zero downtime requests
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1127'>TORQUE-1127</a>] -         Update OpenShift quickstart for TB 3
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1128'>TORQUE-1128</a>] -         JBoss AS 7.2: Rewrite doesn&#39;t support conditions
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1129'>TORQUE-1129</a>] -         Abort/Rollback a zero downtime deploy if torquebox cannot start the new runtimes
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1130'>TORQUE-1130</a>] -         Race condition with eval&#39;ing of torquebox.rb on slow machines
</li>
</ul>


[download]:         /release/org/torquebox/torquebox-dist/3.0.0.beta2/torquebox-dist-3.0.0.beta2-bin.zip
[download_overlay]: /release/org/torquebox/torquebox-dist/3.0.0.beta2/torquebox-dist-3.0.0.beta2-eap-overlay.zip
[gettingstarted]:   /getting-started/3.0.0.beta2/
[htmldocs]:         /documentation/3.0.0.beta2/
[javadocs]:         /documentation/3.0.0.beta2/javadoc/
[rdocs]:            /documentation/3.0.0.beta2/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/3.0.0.beta2/torquebox-docs-en_US-3.0.0.beta2.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/3.0.0.beta2/torquebox-docs-en_US-3.0.0.beta2.epub
[features]:         /features
[community]:        /community/

[openshift-quickstart]: https://github.com/openshift-quickstart/torquebox-quickstart
[heroku-torquebox]:     https://gist.github.com/bbrowning/4296297
[torque-1121]:          https://issues.jboss.org/browse/TORQUE-1121
