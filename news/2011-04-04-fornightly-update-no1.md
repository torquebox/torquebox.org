---
title: 'Fortnightly Update Number 1'
author: Bob McWhirter
layout: news
tags: [ update ]
---

[ruby19]: /news/2011/03/30/ruby-19/
[devnexus]: /news/2011/03/29/devnexus-preso/
[resource injection]: /news/2011/03/28/java-resource-injection-for-torquebox/
[auth]: /news/2011/03/25/introducing-authentication/
[crash course]: /documentation/DEV/jboss.html
[logging integration]: /documentation/DEV/jboss.html#d0e414
[CloudBees]: http://cloudbees.com/
[builds]: /builds/

The day finds us with a high in the mid 80s (F) with snow predicted overnight.  Just as we
are on the cusp of seasons, the TorqueBox team is on the cusp of some cool stuff.  And
the phlox has started the bloom.

After a hearty discussion amongst the team, and a lack of motivation on my part to sit down
and write these every Sunday, it was decided that the updates should occur less frequently,
currently.  We're churning out a fair bit of real content, and the updates seem somewhat distracting
at times.

Let us know if you would like to see this more or less often.

# Gotta commit

**April 15**.  

TorqueBox 1.0.0.CR1 will be released on-or-before **April 15**.

# Code Improvements

Things you can look forward to include the awesome work the team has
been doing lately.

### Ruby 1.9

Toby added support for [selecting Ruby 1.8 or Ruby 1.9 interpreter
per application][ruby19].

### Resource Injection

One of things I (Bob) was most excited about presenting at DevNexus was
our new support for CDI and other [resource injection].

### Authentication

Lance wrote up an [awesome post][auth] about how he's exposed JAAS
authentication to Ruby applications.  If you've got an existing
credential store (LDAP, DB, etc), this is for you.

### Misc

Jim continues to squish bugs and write documentation in preparation
for the upcoming release. Additionally, he wrote a [crash course]
about JBoss for anyone new to JBoss AS.  This chapter also includes
notes on using the new [logging integration].

Ben took up the Windows baton this week,
and also adjusted our integration tests to run headless, no longer
requiring Firefox. 

Lance straightened out some issues involving our RubyGems not installing
cleanly.  Lance and Toby worked together to deliver durable message queues.

I added support for `TORQUEBOX_HOME/apps` as the default deployment
directory for user applications.  No longer must your drop your lovingly
hand-crafted apps amongst the cruft in `JBOSS_HOME/deploy`.  

Additionally, application roots starting with a tilde (~) will expand
it to the `$HOME` of the AS process.  Useful in development mode.

# Non-code Improvements

I presented at DevNexus, which took 50 minutes.  Ben filmed it
and then spent days editing and [uploading the video][devnexus].  I 
think I got the better end of that stick.

Through a very generous contribution from [CloudBees], we have migrated
from our TeamCity CI server to a Jenkins-based one.  Also, since we recommend
our incremental builds (previously called "dev builds" or "nightlies"), 
we've [created a page][builds] to make it easier to know what changes are in which
builds.

