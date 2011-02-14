---
title: 'TorqueBox Weekend Update: 13 February 2011'
author: Bob McWhirter
layout: news
---

[magicruby]: http://magic-ruby.com/
[magicruby.video]: http://torquebox.org/news/2011/02/08/magic-ruby-preso/
[ben.ha]: /news/2011/02/09/hasingleton-services/
[toby.messaging]: /news/2011/02/08/async-message-options/
[backgroundable]: /news/2011/02/01/turn-any-method-into-a-task/
[picketbox]: http://www.jboss.org/picketbox
[stompbox]: http://github.com/torquebox/stompbox
[sso]: https://issues.jboss.org/browse/TORQUE-193
[alacarte]: https://issues.jboss.org/browse/TORQUE-250
[saner]: https://issues.jboss.org/browse/TORQUE-227
[devbuild]: http://torquebox.org/torquebox-dev.zip
[lastfm]: http://www.last.fm/group/Project+Odd
[jbw]: http://www.redhat.com/summit/

The week ending 13 February 2011 was a good week.  The snows came to an end,
the weather turned at least teasingly warmer, and much work was performed
on TorqueBox.

# MagicRuby, yet again

Since the last update, Ben Browning did a fine job of post-production
on the film he and Toby Crawley shot at [MagicRuby][magicruby].  Jim 
[posted it, along with some personal notes][magicruby.video].  If
you were unable to attend MagicRuby, you can watch Jim's complete
presentation online, now, for free.

# News & Articles

As promised, Ben [blogged about highly-available services with 
failover][ben.ha], showing just how very simple it is to deploy
an HA service on a TorqueBox cluster.

Toby also wrote about advanced options now available with
messaging, such as [message priority and TTL][toby.messaging].

# Development

This week saw the three great minds of Jim, Ben and Toby working
on various aspects of messaging.  Jim extended Toby's
work on [backgroundable] methods to support non-Rails deployments,
while Toby worked on supporting various edge-cases related
to development-mode reloading of classes.

Ben has been working on making our synchronous queues more performant and conscious of resource
usage.  Additionally, he eliminated some peformance issues in
our web session-hanlding implementation.  

Lance continued work on the [Stompbox deployment tool][stompbox], and started
nudging into things like authentication, JAAS, [SSO][sso] and [PicketBox][picketbox].

I (Bob) enabled deployment of Ruby apps lacking a web component.  I'll
be blogging about [a-la-carte knobs][alacarte] this week.  At the
logical insistence of Jim, I also began work on improving our admittedly
[crappy rubygem names][saner].  Plus, virtual host support has been fixed in the
latest [development build][devbuild].

# Teamness

The team all uses last.fm a fair bit, and if you'd like to listen
to the music that's ingrained in this code, check out our [team
station on last.fm][lastfm].  The whole team is hoping to get
together at the [Red Hat Summit/JBossWorld][jbw] conference
this May. Come find us if you're in the area.  
