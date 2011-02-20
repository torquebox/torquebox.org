---
title: 'TorqueBox Weekend Update: 20 February 2011'
author: Bob McWhirter
layout: news
---

[PicketBox]: http://www.jboss.org/picketbox
[devbuild]: http://torquebox.org/torquebox-dev.zip
[lastfm]: http://www.last.fm/group/Project+Odd
[jbw]: http://www.redhat.com/summit/
[croci]: http://en.wikipedia.org/wiki/Crocus
[tomek]: http://twitter.com/szimano
[adam]: http://twitter.com/adamwarski
[Software Mill]: http://softwaremill.pl/
[Poznan JUG]: http://www.jug.poznan.pl/
[java4people]: http://java4people.com/
[benchmail]: http://torquebox.markmail.org/thread/sekbh2cqymgbd7zq
[speedmetal]: https://github.com/torquebox/speedmetal
[stompami]: https://issues.jboss.org/browse/TORQUE-272
[stompbox]: https://github.com/torquebox/stompbox
[Infinispan]: http://infinispan.org/

The week ending 20 February 2011 saw the [croci] push their
noggins up from earth, and some work occurred in the larger
TorqueBox ecosystem.

# About the box

This week we added two talks to the list of places you can
hear about TorqueBox from live humans.  We have our Polish
friends [Tomek Szymanski][tomek] and [Adam Warski][adam] to
thank for both newly-added talks.  They are founders of [Software Mill]
(and former employees of JBoss) and use TorqueBox with Java CDI in their products.

Adam and Tomek will be presenting on the 8th of March at the
[Poznan JUG].  Adam will then be presenting on the 16th of April
at [java4people].

Additionally, Toby Crawley submitted a proposal to RailsConf. We
think this would be a great opportunity to spread the word.

# Inside the box

Toby Crawley continued to work with the backgroundable tasks stuff,
trying to resolve a few lingering edge-case idiosyncrasies.

Lance started the integration work between TorqueBox and the
[PicketBox] security project.  Instead of pulling random authentication
gems into your application, you'll soon be able to leverage 
container-managed security. Build your application, not your infrastructure.

Jim started working with [Infinispan] integration into TorqueBox. This
should allow even better implicit caching, along with providing a
NoSQL data-store for general use. 

# Around the box

This week Ben Browning spent some time looking at the
[performance of TorqueBox][benchmail] in comparison to other alternatives
(both JRuby and MRI). We hope to have results published in the upcoming
week.  All of the performance-testing stuff is [kept in GitHub][speedmetal], because
we want to be stay honest, and give everyone a chance to reproduce
or augment our testing.  

Ben also reworked some of messaging documentation, including more details
about synchronous queue usage.

I (Bob) continued Lance's work related to both [StompBox][stompbox] and easy-to-use
[TorqueBox AMIs][stompami].  Work continues on these, but the idea is that it will be
one click to launch a StompBox-enabled AMI, and start deploying your 
applications.

Additionally, I (Bob) finished up the slimming of the distribution. It currently
stands a shade under 50% the size (180mb) of the previous 1.0.0.Beta23 release (361mb).

Overall, it was a good, productive, low-key week. 
