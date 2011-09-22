---
title: 'DataMapper on Infinispan: Slides &amp; Code From StrangeLoop'
author: Lance Ball
layout: news
tags: [ presentations, strangeloop, datamapper, infinispan ]
---

The [Strange Loop 2011](https://thestrangeloop.com/) conference was held in St.
Louis this past Sunday-Tuesday. It was a really fun event, and I learned about
lots of not-necesssarily-ruby stuff. It was nice to mix things up a little.
[Alex Miller](https://twitter.com/#!/puredanger) did a great job with the
event. It was well organized, had plenty of video coverage, and excellent
speakers.  Gerald Sussman blew my mind with crazy math and then said he wasn't
really a mathematician, and Erik Meijer opened my eyes to coSQL.

From the Strange Loop [website](http://thestrangeloop.com),

> Strange Loop is a multi-disciplinary conference that aims to
> bring together the developers and thinkers building tomorrow's technology in
> fields such as emerging languages, alternative databases, concurrency,
> distributed systems, mobile development, and the web.  

So, instead of talking about the TorqueBox server as a whole, it seemed a
little more appropriate to talk specifically about our work with
[DataMapper](http://datamapper.org) on
[Infinispan](http://jboss.org/infinispan). In 2.x we're exposing the
Infninispan cache a bit more than we did in 1.x, and as part of that, we've
written an adapter for the DataMapper ORM that allows you to use Infinispan as
your scalable and replicated backend data store.

The slides discuss how we leap-frogged around the two languages, Java and JRuby
with a dash of metaprogramming along the way; and how we tied a Ruby-based ORM
to a distributed Java key-value store in-container.  Also included in the
download is the source code for the simple Beer Catalogue application I
demonstrated at the end of the presentation on Tuesday.  And lastly, during
Monday's catered lunch (thanks [Splunk](http://splunk.com) and
[Partek](http://partek.com)!) I gave a 5 minute lightning talk about TorqueBox.
Those slides are included too.

You can download the slides, code and other detritus from
[github](https://github.com/downloads/torquebox/presentations/2011-strangeloop-materials.tgz).

If you don't want to bother downloading all of that, just check out the slides
from the DataMapper on Infinispan presentation here.

<div style="width:425px" id="__ss_9378857"><iframe src="http://www.slideshare.net/slideshow/embed_code/9378857" width="425" height="355" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe></div>

