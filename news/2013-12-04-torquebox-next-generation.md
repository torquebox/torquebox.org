---
title: 'TorqueBox Next Generation - The Future is Now'
author: Ben Browning
layout: news
timestamp: 2013-12-04t13:30:00.0-05:00
tags: [ announcements, torqbox ]
---


TorqueBox 3 started us down the path of a smaller, lighter server. The
next generation of TorqueBox will take that idea to the next level,
with the entire core rewritten to offer a much smaller, simpler
out-of-the-box experience and the ability to bring in additional
functionality as-needed. Because of the scope of this undertaking,
we're developing this next generation TorqueBox in parallel with the
current TorqueBox 3 releases.


## Codename TorqBox

We're assigning the codename of TorqBox to the next generation
TorqueBox because we'll be putting out releases while development is
still active on the current generation TorqueBox 3. In fact, we've
already made a couple of stealth releases of the [`torqbox`][torqbox]
gem. To try it out, add `torqbox` to your Gemfile then:

    rackup -s torqbox

or

    rails s torqbox

More details about `torqbox` usage can be found in our [torqbox
branch][branch] on GitHub. At some point, when TorqBox is ready for a
1.0 release, we'll probably drop the codename and just call it a new
major version of TorqueBox. When that happens we'll make sure to ease
the transition by keeping the `torqbox` gems around for a couple of
releases.


## Application server optional

TorqBox deviates from previous TorqueBox releases in that it is not
built directly on top of an existing Java application server. Instead,
we bring in specific components of the application server as-needed,
wiring them together ourselves. For users that want to run on top of a
Java EE application server, we'll also provide a way to run TorqBox on
top of [WildFly][] or [JBoss EAP][eap]. This lets us provide a more
natural experience to pure Ruby developers while still giving Java EE
developers and organizations the ability to use Ruby with their Java
where appropriate.


## Web first, more to come

TorqBox development is going to concentrate on one component at a
time, giving the community time to test each component and make sure
it's rock solid before moving on to the next component. The first
component we're tackling is web. Our goal with the web component is to
provide a high-performance, lightweight JRuby web server that requires
minimal to no configuration.

We've made a lot of progress on performance, and based on our testing
TorqBox should outperform every other Ruby web server. We can't
magically reduce the large performance overhead involved when using a
framework like Rails, but by using less CPU in our actual web serving
bits more CPU is available to your application. If you find any cases
where we don't beat the competition, [let us know][community]. We
don't have any of our own benchmarks ready for publishing yet, but
keep an eye out for Round 8 of the TechEmpower Framework Benchmarks
which should have results published in about a week on [their
blog][techemp]. All their JRuby tests now run on TorqBox and the
results should speak for themselves.

Try our `torqbox` gem and [let us know][community] what it lacks to
make it your default JRuby web server. Also let us know what feature
from TorqueBox 3 (or elsewhere) you'd like to see us tackle
next. Real-time push of data from the server to browser clients?
Background jobs? Asynchronous messaging? Running multiple applications
in one server? Whatever we add next, `torqbox` will remain the
lightweight, high-performance web serving core and additional features
will be brought in by adding additional gems to your Gemfile.




[wildfly]: http://wildfly.org/
[eap]:     https://www.jboss.org/products/eap.html
[torqbox]: http://rubygems.org/gems/torqbox
[branch]:  https://github.com/torquebox/torquebox/tree/torqbox
[techemp]: http://www.techempower.com/blog/

[community]: http://torquebox.org/community/
