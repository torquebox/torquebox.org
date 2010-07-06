---
title: Project Update and Roadmap
author: Bob McWhirter
layout: news
---

Well, it's been over 4 months since 1.0.0.Beta19 was released, and three
since the last blog post. I figured it's time to communicate with the
community.

*Jim Crossley* has joined the TorqueBox team in the last few weeks, and
has hit the ground running.  Due to his efforts, later this week we'll
see 1.0.0.Beta20 released, with a few minor bugfixes and update of JRuby.

Shortly after that (for some value of "shortly"), 1.0.0.Beta21 will be
released, which brings about major changes, including being based
off JBoss AS6 instead of AS5.  

Additionally, we've been working furiously improving the HornetQ
integration and providing ways to use smaller portions of TorqueBox
as gems from arbitrary Ruby scripts.

We're nearing what we'd call "feature complete" for a good v1.0
release.  We still aim to spend some time on...

* More unit testing
* Performance testing
* Packaging and distribution
* Ecosystem integration (capistrano, rake)

Longer-term (v2.0+), we'll be focusing on bringing in more advanced functionality
such as transaction management to truly make Ruby "enterprisey".

Additionally, expect some cross-over from Marek's [CirrAS](http://jboss.org/stormgrind/projects/cirras.html) project,
to make TorqueBox in the cloud (EC2, etc) super simple and effective.
