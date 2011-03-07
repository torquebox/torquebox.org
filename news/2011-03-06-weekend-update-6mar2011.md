---
title: 'TorqueBox Weekend Update: 6 March 2011'
author: Bob McWhirter
layout: news
tags: [ update ]
---


[uclug]: http://uclug.org/
[poznan]: http://www.jug.poznan.pl/

[galderz]: http://twitter.com/#!/galderz
[adamwarski]: http://twitter.com/#!/adamwarski
[tomek]: http://twitter.com/#!/szimano

[speedmetal]: https://github.com/torquebox/speedmetal
[StompBox]: https://github.com/torquebox/stompbox
[PicketBox]: http://www.jboss.org/picketbox
[Infinispan]: http://infinispan.org/
[BackStage]: https://github.com/torquebox/backstage

[sanegem]: news/2011/03/01/torquebox-gem-changes/

[jcra]: http://www.jboss.org/jbcra
[vote]: http://www.jboss.org/jbcra/voting.html
[nominees]: http://www.jboss.org/jbcra/nominees.html

# This Week's Special

In the coming week (Tuesday, 8 March; like, the **day after tomorrow**), whether
you're in Poland or South Carolina, you'll have the opportunity to hear about
TorqueBox.

Toby Crawley will present at the [Upstate Carolina Linux Users Group][uclug] in
Greenville, SC, while [Tomek Szymanski][tomek] and [Adam Warski][adamwarski] will present at the
[Poznan JUG][poznan] in Poznan.

# Now 100% Organic

The aforementioned Adam Warksi, who is supremely interested in CDI integration
between TorqueBox and the Java side of things (yes, he's a little nutty), solved
a few issues we had related to classloading.  It's obtuse stuff, but we expect
a blog post from Adam in the near future, describing his particular blend of 
lunacy.

One of the most frequent problems users run into with TorqueBox is the default
memory settings that ship with JBoss AS.  Toby has provided some changes to increase
the default to 1GB, up from 512MB.  

Lance updated our docs related to RVM usage, to account for our recent changes
to slim the distribution.

Super coolness this week is the integration between [Infinispan] and `ActiveSupport::Cache`
that Jim landed.  It's now super-simple to use the Infinispan-backed caching, in
either local or clustered mode, as an `ActiveSupport::Cache` implementation.  In the
process, being exposed to the depths of Infinispan (with the help of [Galder Zamarreno][galderz]),
Jim decided that Infinispan is Good Stuff(tm).

I (Bob) worked on [simplifying the RubyGems][sanegem] that are a part of the distribution.

As always, we recommend the CI-produced [dev builds (ZIP download)](/torquebox-dev.zip) to enjoy these improvements.

# Still baking

Lance, in his quest to shave the authentication yak, continues to deepen the 
integration with [PicketBox].  Thus far, he has elimnated the need for at least
one XML file, if not more.  A kitten just got its wings.

Ben continues to work on the [SpeedMetal] BENchmarks, working with Redmine now
to satisfy the various naysayers (to whom I say **neigh**).  

Toby continues work on [BackStage] to expose useful bits of an application's
components, including messaging destinations, services and scheduled jobs.  Supporting
his work, I have been adding JMX management paste to everything.

# Bring your kid to work

The voting for the [JBoss Community Recognition Awards][jcra] continues until
2 April 2011.  

The TorqueBox team nominated two community members.  One, of course, is Adam Warski, who is 
apparently one of our favorite people.  The other is Chris Schneider, who is starting to
grow on us.

Please, feel free to vote for them:

* [Adam for bug-fixes](http://community.jboss.org/polls/1067)
* [Chris for new features](http://community.jboss.org/polls/1066)

We continue to emphasize that [IRC](irc://irc.freenode.net/torquebox) is a great way to meet the 
team and get any assistance you might need while trying out TorqueBox.

If you won't listen to me, maybe you'll listen to the one and only Gavin Stark:

<a href="http://twitter.com/#!/GavinStark/status/43682829346947072"><img src="/images/gavinstark.png" style="margin: auto; display: block; border: 2px solid #666; width: 350px;"/></a>
