---
title: 'TorqueBox Weekend Update: 13 March 2011'
author: Bob McWhirter
layout: news
tags: [ update ]
---

[tobyslide]: /news/2011/03/10/uclug-preso/
[adamcdi]: http://www.warski.org/blog/?p=383
[devnexus]: http://devnexus.com
[caching]: /news/2011/03/09/torquebox-caching/
[backstage]: https://github.com/torquebox/backstage
[authbranch]: https://github.com/torquebox/torquebox/tree/authentication
[dobozy]: http://twitter.com/#!/dobozysaurus
[newrelic]: http://newrelic.com/
[rpmbranch]: https://github.com/torquebox/rpm
[summit]: http://www.redhat.com/summit/

If we got less accomplished this week, it's because someone bent space-time
and stole an hour from us last night.

# Have you heard?

Last week Adam and Toby presented about TorqueBox on two different continents.
[Toby's slides][tobyslide] are available for your review.  Adam wrote up
a [blog entry][adamcdi] covering integration of CDI with TorqueBox.

And I'll remind you again next week, but I (Bob) will be presenting at
DevNexus in Atlanta during the last slot, on the last day (22-Mar).

# Winning

This week, Jim [delivered and explained][caching] the Infinispan/ActiveSupport::Cache
work he wrapped up.  This is cool stuff and is exactly what we mean by bringing
Java enterprise goodness to Ruby.  **Enterprisey** doesn't have to be a bad word.

Part of this work included continuing to figure out the best way to package some
of our Ruby bits (such as our Cache and Session implementations).  This continues
to improve.

Toby continued work on [BackStage][backstage], including improving message inspection
in queues, plus adding tests and an API. 

Lance continued work on the PicketLink integration; we hope to see it merged into
the mainline soon.  Until then, you can check it out on [his branch][authbranch].

I spent another few days inside a Windows 7 virtual machine, and TorqueBox seems
to once again function better on second-class operating systems.  We would still
love an active community member to caretake the Windows build.  We'll give you a
sticker.

With some prodding and assistance from [Mike Dobozy][dobozy], we got [NewRelic
RPM][newrelic] working with TorqueBox.  Currently it requires a 1-line patch
to the official NewRelic gem, which we've submitted from [our fork][rpmbranch].

# Losing (for now)

With the release of JRuby 1.6.0.RC3, we gave it another whirl. And once again,
we failed.  Thankfully, the JRuby guys are **awesome** and are actively working
with us to get everything lined up.  

# Measuring

Ben continued performing BENchmarking this week.  He's been working hard, leveraging
the crap out of EC2 to run performance tests against "real world" application loads
in order to quiet the naysayers.  Look forward to the next round of results this week.

# Coming Weeks

Our goal is to release **1.0.0.Final** in time for the [Red Hat Summit/JBoss World][summit]
conference in early May.  This means we're really going to stop implementing features, 
and concentrate on closing out the remaining open issues to start the **CR** release cycle.

And with that, I leave you to enjoy your sunny Sunday, where at least in my part of the
world, the sound of banjos are echoing around the hollow.
