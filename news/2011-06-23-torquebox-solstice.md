---
title: 'TorqueBox Solstice Update'
author: Bob McWhirter
layout: news
tags: [ update ]
---

I look out my window and see nothing, because it's 1am, and dark.  I did notice the
hibiscus blooming earlier in the day, though.

The team has been extremely busy over the past month, since the last update, but I'll try
to hit the high points.

# For your consideration: TorqueSpec

Leading this update is the work [Jim has done on TorqueSpec](/news/2011/06/17/introducing-torquespec/).  With code as 
large as TorqueBox, we obviously have to test well. While TorqueSpec has existed in a few forms, the coolest addition
is the **in-container testing**, which allows us to load up our tests inside the container.

Once in the container, they can `inject(...)` and otherwise interact with components to ensure
they are working well.  

Of course, TorqueSpec still supports client-based external testing using Capybara to create
very literate tests.

# Java and Ruby, livin' together

Marek presented his combination of Ruby and Java, using TorqueBox and CDI, at the Confitura
conference.  Due to time constraints, he was unable to walk through his demo.  But lucky for us,
he [wrote it up in very fine detail](/news/2011/06/13/torquebox-a-javaists-tutorial-on-messaging-services-and-cdi-in-ruby/).  

It's a must-read if you're doing CDI from your Ruby applications.

# TorqueBox as a RubyGem

Ben Browning worked so that [`gem install torquebox-server`](/news/2011/06/10/torquebox-gem/) gets you a TorqueBox installed
into your existing (perhaps RVM-managed) JRuby.  That's pretty slick.  You can't ask for
anything easier than that.

# Infinispan! Infinispan! Infinispan!

Lance Ball has been kicking it in the backseat with Infinispan, churning out both a
[pure-Ruby Infinispan client](/news/2011/06/08/infinispan-ruby-client/) which speaks the 
HotRod binary protocol, and making great strides on a DataMapper-Infinispan adapter.  Look for more 
info on DM-Infinispan before too long.

# Presents!

Ben posted the video from his [Scaling Rails Apps with TorqueBox](/news/2011/06/14/scaling-rails-with-torquebox-video/)
talk at JUDCon in Boston.

Toby posted the slides from his [Charlotte.rb](/news/2011/05/25/charlotterb-preso/) presentation at the end
of May.

# Yay community!

Community contributor Bruno Oliveira has started diving into our documentation to ensure it makes 
sense and adjusting it to the changes that AS7 and TorqueBox 2.x have brought.  Everyone hates writing
docs, so we love having Bruno pitch in.

We would like to thank Mike Dobozy, from our sister company Amentra, for contributing WebSockets support.  We'll blog more 
about this once we've straightened out our strategy.  This is cool stuff.  Related to this work,
I (Bob) dropped the [Stomplet API](http://stilts.projectodd.org/stomplet/) and will be integrating
it shortly.


# TorqueBox 2.x

Progress continues on TorqueBox 2.x, and we *promise* the beta cycle will be much shorter than the
1.x series.  No, really. We mean it this time.

