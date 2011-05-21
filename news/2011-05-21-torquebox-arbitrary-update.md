---
title: 'TorqueBox: An Arbitrary Update'
author: Bob McWhirter
layout: news
tags: [ update, as7, jbossworld ]
---

[tb10]: /news/2011/04/29/torquebox-ruby-appserver-1-0-0-available-now/
[benslides]: /news/2011/05/03/judcon-preso/
[bobslides]: http://www.redhat.com/summit/2011/presentations/jbossworld/in_the_weeds/thursday/mcwhirter_th_1130_beauty_ruby_jboss.pdf
[jbwslides]: http://www.redhat.com/summit/2011/presentations/jbossworld/
[as7]: https://github.com/jbossas/jboss-as
[msc]: https://github.com/jbossas/jboss-msc
[as7branch]: https://github.com/torquebox/torquebox/tree/as7

As the cold snap ends, the peony buds begin to open, and I start finding
wasps in my house.

When my non-geek friends tweet asking for an update on the project, 
I figure it's really time to provide an update.  Almost a month
ago we released the [first non-beta version of TorqueBox ever][tb10].
We hope to release 1.0.1 this coming week to rectify a few small
issues.

Since the 1.0.0 release, the entire team gathered in Boston for
the JUDCon and the JBossWorld/Red Hat Summit conference.  Ben
[posted his slides][benslides] from his talk, _Scaling Rails with TorqueBox_.
The [slides][bobslides] from my (Bob) talk are available along
with the slides from many of the great [JBoss World presentations][jbwslides].

The majority of development since the conference has been on
TorqueBox 2.0.  The TorqueBox 2.x code-line represents a major
shift from JBoss AS6 to [JBoss AS7][as7].  While AS6 was a logical
extension to AS5, the leap to AS7 is major.  It's based on a new kernel,
called the [JBoss Modular Services Container][msc], along with a new
management model. 

That all sounds like a lot of mumbo-jumbo, so what does it mean?

It means that AS (and thence TorqueBox) can boot, on average, in under 5
seconds.  No longer is the AS the slow part of booting your Rails 
application.  It also means that we have more opportunities for concurrency,
so you don't have to wait for several Ruby runtime pools to boot up
sequentially.

It means you can run you application (for some values of "run" and "application") in
under 100MB of RAM.  It means the distribution is now under 100MB.

The team has worked awesomely over the past two weeks, and as of today, all of
our integration tests from TorqueBox 1.0 pass on the new [AS7-based TorqueBox 2.0 branch][as7branch]
in Ruby 1.8 and 1.9 modes.  We've still got some more to do, but we definitely
hope to start producing incremental builds and releases in short order,
for you fearless early-adopter types.  Yeah, **you**.

The plan is to release 2.0.0 when we reach parity with 1.x, but based on
JBoss AS7.

Exciting times ahead.  And these are the guys who are bringing it to you:

<a href="http://www.flickr.com/photos/goldmann/5727002430/" title="Untitled by Marek Goldmann, on Flickr"><img src="http://farm2.static.flickr.com/1430/5727002430_8928e06bbf.jpg" width="500" height="333" alt=""></a>

<div style="font-size:80%">
<b>Left-to-right: Lance Ball, Marek Goldmann, Toby Crawley, Jim Crossley, Ben Browning, Marc Savy, Bob</b>
</div>

