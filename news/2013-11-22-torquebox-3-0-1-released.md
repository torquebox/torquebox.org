---
title: 'TorqueBox 3.0.1 Released'
author: The Entire TorqueBox Team
layout: release
version: '3.0.1'
timestamp: 2013-11-22t10:50:00.0-05:00
tags: [ releases ]
---

After taking a brief hiatus from TorqueBox 3 development, the team got
back to work a couple of weeks ago. We originally planned for the next
TorqueBox release to be 3.1.0, but soon realized that there were
several bugs that need addressing in 3.0.0 before we start adding in
new features. So, we give you TorqueBox 3.0.1!

What were we doing during that hiatus, you ask? We've been hard at
work brainstorming, discussing, and prototyping how TorqueBox needs to
continue to evolve to meet our users' needs. And, we've been
collecting [your feedback][email_thread] as well. We're hoping this
work will eventually land in a TorqueBox 5.

We invite everyone to participate in the email thread linked above or
chat with us on IRC about your TorqueBox experiences. We'll go into
more detail and invite users to play around with our TorqueBox 5
prototyping with a post next week.

Enough about the future - let's get back to the present!


* [Download TorqueBox 3.0.1 (ZIP)][download]
* [Download TorqueBox 3.0.1 (JBoss EAP overlay)][download_overlay]
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

## Highlights of changes in TorqueBox 3.0.1


### Bundled JRuby updated from 1.7.4 to 1.7.8

We held off on updating JRuby for a couple of releases because JRuby
1.7.4 to 1.7.5 had some big changes (new RubyGems version, encoding
changes), and we wanted time for any impact of those changes to be
found and fixed.

### Caching, messaging, and clustering reliability improvements

The bundled Infinispan version (used by TorqueBox caching) has been
downgraded from 5.3.0.Final to 5.2.7.Final. We've seen too many
reports of unreliability with 5.3.0 so we're downgrading to the latest
version used by [JBoss Enterprise Application Platform][eap], which
should be the most stable.

Similarly, we've bumped the bundled JGroups version (used for cluster
discovery as well as most cluster traffic) to 3.2.12 and HornetQ (used
for messaging) to 2.3.1.Final.

If you've been having issues with clustered caching and messaging,
give 3.0.1 a shot and let us know if it improves things. There are
lots of bugs fixed in the underlying components since TorqueBox 3.0.0,
so things should behave better.

### Rails 4

A couple of Rails 4 incompatibilities were fixed in our logger and
session store - <a
href='https://issues.jboss.org/browse/TORQUE-1163'>TORQUE-1163</a>, <a
href='https://issues.jboss.org/browse/TORQUE-1173'>TORQUE-1173</a>,
and <a
href='https://issues.jboss.org/browse/TORQUE-1183'>TORQUE-1183</a>.

### Easier testing outside of TorqueBox

A few changes were made to make testing applications outside of
TorqueBox easier - <a
href='https://issues.jboss.org/browse/TORQUE-1016'>TORQUE-1016</a>, <a
href='https://issues.jboss.org/browse/TORQUE-1150'>TORQUE-1150</a>, <a
href='https://issues.jboss.org/browse/TORQUE-1177'>TORQUE-1177</a>,
and <a
href='https://issues.jboss.org/browse/TORQUE-1178'>TORQUE-1178</a>.
  


## Upgrading from 3.0.1

No changes (other than bumping gem versions) should be required to
your application or the AS7 configuration files to upgrade from
TorqueBox 3.0.0 to 3.0.1.

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 3.0.0

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1016'>TORQUE-1016</a>] -         torquebox-no-op should stub out session store
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1094'>TORQUE-1094</a>] -         torquebox archive CLI tool does not respect the --exclude option
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1150'>TORQUE-1150</a>] -         TorqueBox::Infinispan::Cache gem errors when used outside of TorqueBox
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1160'>TORQUE-1160</a>] -         Problem with cache - torquebox 3.0.0
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1161'>TORQUE-1161</a>] -         HornetQ - Record is too large to store 102723
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1163'>TORQUE-1163</a>] -         undefined method &#39;formatter&#39; in Torquebox::Logger on Rails 4
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1172'>TORQUE-1172</a>] -         torquebox archive broken in windows 7 x64
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1173'>TORQUE-1173</a>] -         Session store is not fully compatible with the ruby Hash API
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1177'>TORQUE-1177</a>] -         application rspec tests fail because TorqueBox::FallbackLogger does not have flush
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1178'>TORQUE-1178</a>] -         TorqueBox::FallbackLogger should take the file to log to from an environment variable
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1180'>TORQUE-1180</a>] -         Upgrade to JRuby 1.7.8
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1182'>TORQUE-1182</a>] -         RDoc generation seems broken again
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1183'>TORQUE-1183</a>] -         reset_session doesn&#39;t work in rails 4
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1184'>TORQUE-1184</a>] -         Infinispan 5.3.0.Final is buggy, downgrade to 5.2.7.Final
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-1185'>TORQUE-1185</a>] -         Upgrade to HornetQ 2.3.1.Final
</li>
</ul>




[download]:         /release/org/torquebox/torquebox-dist/3.0.1/torquebox-dist-3.0.1-bin.zip
[download_overlay]: /release/org/torquebox/torquebox-dist/3.0.1/torquebox-dist-3.0.1-eap-overlay.zip
[gettingstarted]:   /getting-started/3.0.1/
[htmldocs]:         /documentation/3.0.1/
[javadocs]:         /documentation/3.0.1/javadoc/
[rdocs]:            /documentation/3.0.1/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/3.0.1/torquebox-docs-en_US-3.0.1.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/3.0.1/torquebox-docs-en_US-3.0.1.epub
[features]:         /features
[community]:        /community/

[eap]:              https://www.jboss.org/products/eap.html
[email_thread]:     http://markmail.org/thread/4ffelg3qklycwhfo
