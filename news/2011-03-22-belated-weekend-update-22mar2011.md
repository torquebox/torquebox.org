---
title: 'TorqueBox Belated Weekend Update: 22 March 2011'
author: Bob McWhirter
layout: news
tags: [ update ]
---

[adamcdi]: http://www.warski.org/blog/?p=383
[DevNexus]: http://devnexus.com
[BackStage]: /news/2011/03/16/introducing-backstage/
[newrelic]: http://newrelic.com/
[summit]: http://www.redhat.com/summit/
[benchmarks]: /news/2011/03/14/benchmarking-torquebox-round2/
[Fabrizio]: https://issues.jboss.org/browse/TORQUE-309
[jruby]: http://jruby.org/2011/03/15/jruby-1-6-0.html
[devbuild]: http://torquebox.org/torquebox-dev.zip
[gogreen]: /images/gogreen.png

First off, apologies for the belated weekend update.  I am apparently
suffering jet-lag from my flight down the eastern seaboard and lost
track of the day.

# Wake up!

Later Today (Tuesday), I (Bob) will be presenting about TorqueBox
at the [DevNexus] conference in Atlanta, Georgia.  Unlike previous
presentations, this is one specifically targetting Java developers
who are looking for a familiar route to get into Ruby.

Ben Browning and Jim Crossley are manning the JBoss booth, and
will be filming the talk, which we hope to get online fairly quickly.

# Hooray!

This week, Lance put the authentication integration to bed.  Due to
complexities around JAAS and the PicketLink implementation against
JBoss AS6, we decided to reduce the scope slightly.  Look for a blog
post from Lance about it this week.  Right, Lance?

Toby wrapped up [BackStage], the dashboard you can use to monitor
and control components across your Ruby applications deployed 
on TorqueBox.  See his [article][BackStage] describing the awesomeness.

Mr. Crawley also wins the ABCD Award (Above-and-Beyond the Call of Duty),
for relieving me from Windows duty.  Nobody likes having to make sure
TorqueBox builds on Window, so I will be eternally grateful to Toby;
at least until next week.

Ben published round two of our BENchmarks, this time 
testing a real-world application (Redmine), against a variety
of servers and runtimes (MRI, REE, JRuby).  We think the results
[speak for themselves][benchmarks] pretty well.

Additionally, Ben has begun running the official RubySpec compliance
tests against our VFS-modified interpreter, ensuring we're not breaking
stuff.  Apparently we were breaking stuff.  Ben's fixing it.  Quality
improves.

Jim and I collaborated on what we hope will become one of the
killer features of TorqueBox, inspired by our awesome
community member, [Adam Warski][adamcdi]: **CDI integration**, 
and other dependency-injection support.  This goes one step
further towards blurring the lines between your Ruby and Java
applications.  Look forward to a blog post detailing this
feature in the near future.

Jim has also been smashing bugs and applying patches submitted
by community members such as [Fabrizio].  We love our community!
And we love Jim for helping make our issue graph cross over from
red to green.

<img src="/images/gogreen.png" style="width: 346px; margin: auto; display: block;">


# Super duper awesome!

One of the biggest accomplishments last week was actually the feat
of a team other than ours: the JRuby guys [released 1.6.0][jruby].
Charlie Nutter, Tom Enebo, and the rest of the guys and gals worked
fantastically with us, to ensure that the 1.6.0 release would support
everything TorqueBox needs.

Following their release, within 24 hours, we had updated TorqueBox 
to use it.  You can try it now by using our [developer build (~180mb, ZIP)][devbuild].

# Don't forget

We're charging ahead, committed to getting **1.0.0.Final** shipped by 
the JBoss World/Red Hat Summit conferences, near the beginning of May.

After that, we will shift gears, and try to jump up the ladder to JBoss AS 7 and
start our 2.x cycle.

Exciting times ahead.
