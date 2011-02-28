---
title: 'TorqueBox Weekend Update: 27 February 2011'
author: Jim Crossley
layout: news
tags: [ update, awards, backstage, benchmarks ]
---

[PicketBox]: http://www.jboss.org/picketbox
[Amentra]: http://www.amentra.com
[speedmetal]: https://github.com/torquebox/speedmetal
[stompbox]: https://github.com/torquebox/stompbox
[Infinispan]: http://infinispan.org/
[wobegon]: http://en.wikipedia.org/wiki/Lake_Wobegon
[benchmark]: http://bit.ly/tbbenchmark
[Redmine]: http://www.redmine.org
[262]: https://issues.jboss.org/browse/TORQUE-262
[281]: https://issues.jboss.org/browse/TORQUE-281
[backgroundable]: http://torquebox.org/documentation/DEV/messaging.html#backgroundable
[Backstage]: https://github.com/torquebox/backstage
[jcra]: http://www.jboss.org/jbcra
[vote]: http://www.jboss.org/jbcra/voting.html
[nominees]: http://www.jboss.org/jbcra/nominees.html

Well, it's been a quiet week in [Lake Wobegon][wobegon].

But it's probably been one of the loudest weeks in the history of
TorqueBox Land, mostly due to Ben publishing his first round of
[benchmarking results][benchmark].  Geeks sure do love to hate on
benchmarks!

# What have you done with Bob?

You may have noticed by now, alert readers, that Bob, normally
responsible for these weekly updates, isn't writing this one.  He
spent most of last week prepping for a presentation at [Amentra], Red
Hat's professional services group in D.C., upon whom he slathered much
TorqueBox and Ruby love.

So I volunteered to pay attention!

# Community 

Congratulations to two of our TorqueBox regulars, Chris Schneider and
Adam Warski, for being nominated for
[JBoss Community Recognition Awards][jcra]!  In return for all the
love and emotional support they smother us with, we're trying to score
them some er... um...

... t-shirts.  Yay, t-shirts!  

We'll send them some stickers, too!  Heck, we'll send anyone some
stickers!  Just send Toby an SASE!

But first, go [vote] for [Adam and Chris][nominees]!

# Development

As I mentioned, Ben's report of his first round of
[BENchmarks][benchmark] dominated the scene last week.  We were quite
happy with the results and the feedback, as TorqueBox compared
favorably with the other popular Ruby deployment platforms.  We caught
a little heat for our admittedly-contrived sample apps, though, so
Ben's already working on a second round of tests that will feature
[Redmine].  You can follow [all his work][speedmetal] on github, of
course.

Toby had one of his normally prolific weeks, putting the finishing
touches on his awesome Backgroundable stuff, adding
[some docs][backgroundable] and finally squashing
[one of our most annoying bugs][262].  He also started work on one of
our most requested features, a [queue browser][281] he's calling
[Backstage].

Lance continued his fine work on our [PicketBox] integration, getting
intimately familiar with the JBoss MicroContainer internals in order
to get file-based JAAS security working.  He also posted a great
article on
[using RVM with TorqueBox](2011/02/25/using-rvm-with-torquebox/),
since apparently some of y'all do!

Me, I finally took my first whack at an [Infinispan] implementation of
an ActiveSupport::Cache::Store.  And it mostly seems to work!

One other cool thing Bob did last week: although we've had a PDF
version of the bleeding edge TorqueBox documentation (matching our CI
dev builds) for a while, he's now added a more convenient HTML
version, a link to which can be found in the top right corner of the
[torquebox.org](/) pages.

I think that pretty much covers it!
