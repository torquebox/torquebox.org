---
title: 'Video & Slides from MagicRuby'
author: Jim Crossley
layout: news
tags: [ presentations, magic-ruby, orlando ]
---

[MagicRuby]: http://magic-ruby.com/
[Bob]: http://bob.mcwhirter.org/
[Jeremy]: http://www.jeremymcanally.com/
[Toby]: http://blog.tobiascrawley.net/
[Ben]: http://thinkingconcurrently.com/
[projectodd]: http://projectodd.org/
[JSF]: http://en.wikipedia.org/wiki/JavaServer_Faces

Here is the video from my TorqueBox talk at [MagicRuby] 2011:

<iframe src="http://player.vimeo.com/video/19705548" width="500" height="325" frameborder="0"></iframe>

<p>&nbsp;</p>

A few comments clarifying some of my answers during question time.

* We don't hate *javaists*.  We love all programmers who want to
  produce great software quickly, regardless of their language
  preference.  We recognize there are two potential audiences for
  TorqueBox: *javaists* and *rubyists*.  We simply believe that the
  *javaists* will have a higher "enterprisey bullshit tolerance" than
  the *rubyists*, so we measure our success by the adoption of
  TorqueBox by *rubyists*.  Because we strive to encapsulate the
  enterprisey bullshit, and emphasize the enterprisey goodness.
* We don't hate [JSF]. There are some brilliant programmers who can do
  amazing things with it.  But I'm not one of 'em.  Because I'm a
  language guy, not a tools guy.  I prefer an awesome editor to an
  awesome IDE.  I prefer a request/response metaphor to a component
  metaphor.  There are plenty of people who share my opinion and at
  least as many who don't.  The beauty of TorqueBox is that it can
  adapt to the way each of us wants to work.  It allows multiple
  development teams within a single enterprise to choose the tools and
  techniques that work best for them but still target the same shared
  deployment platform.
* I completely flubbed the scaling question.  Even after stewing on
  it, I think the right answer is "it depends on your app", but
  scaling out (rather than up) probably makes the most sense for most
  apps.  Your price/performance will be better on mainstream hardware,
  and you get to take advantage of the built-in clustering features of
  JBoss and mod_cluster.
* I say "basically" a lot and touch my face too much.  Sorry.  My new
  favorite phrase is "default by true".

Big thanks to two of my [incredible teammates][projectodd], [Toby] and
[Ben], for filming the talk.  Ben also did an awesome job of editing
the video.  Because we're a bona fide "pants-optional" distributed
team, we don't get a lot of face time with each other, and it was
great hanging out with them and their families for a couple of days.

Thanks also to [Jeremy] for organizing a really fun, informative
conference with breakfast, and thanks to [Bob] for encouraging us to
go down there.  It was a blast.

Here are the slides. You can download the pdf from slideshare, if you
prefer.

<div style="width:425px" id="__ss_6834885"><object id="__sse6834885" width="425" height="355"><param name="movie" value="http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=magic-ruby-2011-110206221226-phpapp01&stripped_title=crank-up-your-apps-with-torquebox&userName=jcrossley3" /><param name="allowFullScreen" value="true"/><param name="allowScriptAccess" value="always"/><embed name="__sse6834885" src="http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=magic-ruby-2011-110206221226-phpapp01&stripped_title=crank-up-your-apps-with-torquebox&userName=jcrossley3" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="355"></embed></object></div>

