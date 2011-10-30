---
title: 'TorqueBox Ruby App-Server: v1.0.0 Available Now'
author: The Entire TorqueBox Team
layout: release
version: 1.0.0
tags: [ releases ]
---

[download]: http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-dist/1.0.0/torquebox-dist-1.0.0-bin.zip
[htmldocs]: /documentation/1.0.0/
[pdfdocs]:  http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-docs-en_US/1.0.0/torquebox-docs-en_US-1.0.0.pdf
[epubdocs]: http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-docs-en_US/1.0.0/torquebox-docs-en_US-1.0.0.epub
[features]: /features/
[firstcommit]: https://github.com/bobmcwhirter/jboss-rails/commit/42ef271f42f8bfb3219862c26e9955c4e8806abb
[CloudBees]: http://cloudbees.com/
[JUDCon]: http://www.jboss.org/events/JUDCon
[JBoss AS]: http://jboss.org/jbossas/
[Infinispan]: http://infinispan.org/
[HornetQ]: http://hornetq.org/
[JRuby]: http://jruby.org/

# TorqueBox v1.0.0 Released

The entire TorqueBox team is proud to announce immediate availability
of *TorqueBox v1.0.0*.

* [Download TorqueBox 1.0.0 (ZIP)][download]
* [Browse HTML documentation][htmldocs]
* [Download PDF documentation][pdfdocs]
* [Download ePub documentation][epubdocs]

# What is TorqueBox?

TorqueBox builds upon the JBoss AS Java application server,
mixing in JRuby, to provide a scalable platform for Ruby applications,
including support for Rails, Sinatra and other Rack-based frameworks.

In addition to supporting popular web frameworks, TorqueBox [bridges
many common Java facilities][features] provided by JBoss, including *scheduled jobs*,
*caching*, *messaging*, and *services*.

# What's in this release?

**Everything!**  

## What's changed since 1.0.0.CR2?

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-360'>TORQUE-360</a>] -         Sample Gem Install Command in Docs Should Include --pre Flag Until 1.0 Final
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-370'>TORQUE-370</a>] -         double-splats match dot dirs.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-371'>TORQUE-371</a>] -         TorqueBox spins forever in PoolManager#waitForMinimumFill() if rails app raises during init
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-372'>TORQUE-372</a>] -         Unintialized Constant ActiveSupport::Cache::TorqueBoxStore Error Following Caching Docs
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-373'>TORQUE-373</a>] -         Make main torquebox gem require torquebox-base and torquebox-rack-support
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-374'>TORQUE-374</a>] -         rake torquebox:run leaves BUNDLE_GEMFILE set in ENV, which breaks any other deployed apps that depend on bundler
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-375'>TORQUE-375</a>] -         TorqueBoxStore Ignores Rails3 :race_condition_ttl Option
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-378'>TORQUE-378</a>] -         Dir.glob returns filenames, not directory names when glob ends with a &#39;/&#39;
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-365'>TORQUE-365</a>] -         Backstage log viewing feature
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-369'>TORQUE-369</a>] -         Figure out why CR2 is 2mb larger than CR1
</li>
</ul>

# A Special Message From Me (Bob)

Reaching *v1.0.0* has been a long journey.  The [first commit][firstcommit] towards this
goal was on 5 September 2008.  That's over 2.5 years ago.  If you were to draw a graph of the
progress we've made, though, it'd be a definite hockey-stick, taking on a steep slope
with the addition of the great guys who do most of the work around here:

* Jim Crossley
* Ben Browning
* Toby Crawley
* Lance Ball

<div style="margin-bottom: 2em;">
  <img src="http://projectodd.org/images/jc3.png"/>
  <img src="http://projectodd.org/images/bbrowning.png"/>
  <img src="http://projectodd.org/images/tcrawley.png"/>
  <img src="http://projectodd.org/images/lanceball.png"/>
</div>

These guys brought a lot of talent, perspective, maturity and dedication to the
project, and it definitely shows.

I'd like to personally thank Sacha Labourey who allowed us to start this
project back when he was leading JBoss.  I'd also like to thank him now in
his currently capacity working for [CloudBees], which powers our incremental
builds.

Mark Little, my current boss, also deserves credit for continuing to provide
his support, guidance, and even a little bit of code.

Rayme Jernigan has done a fantastic job of helping to spread the word and 
deserves a beer or two next week during [JUDCon].

James Cobb holds a very special place in our heart for designing our logo:

<img src="/images/knob.png" style="display: block; margin: auto; width: 200px;"/>

It goes without saying (but I'm going to say it anyhow), that our active community
deserves kudos for finding and fixing bugs, making suggestions, and generally providing
great feedback.

Everything we've accomplished has been because we've been standing on the shoulders
of giants behind projects such as [JBoss AS], [HornetQ], [Infinispan], and of 
course [JRuby].

# What's next?

After this release, we do already anticipate some smaller 1.x releases to wrap
up a few more things we'd like to do on this codebase.

We will also concurrently kick off the next major release version, to be based
upon JBoss AS 7.

Stay tuned!
