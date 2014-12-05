---
title: 'TorqueBox 4 Alpha1 Released'
author: The Entire TorqueBox Team
layout: release
version: '4.0.0.alpha1'
timestamp: 2014-12-05t12:30:00.0-05:00
tags: [ releases, 4x ]
---

We're delighted to announce the first alpha release of TorqueBox 4!
TorqueBox 4 has changed substantially from any previous TorqueBox
release, so we'll be putting out at least one more alpha release
before transitioning to beta status. Read our [TorqueBox 4 blog
archives][tb4_posts] for more information on the motivation behind
TorqueBox 4 and the early stages of development leading up to this
alpha release.

* [Download TorqueBox 4.0.0.alpha1 from RubyGems][download]
* [Browse Documentation][docs]

## What is TorqueBox?

TorqueBox is a modular Ruby application server for JRuby that supports
Rack-based web frameworks and provides Ruby interfaces to standard
enterprisey services, including *scheduled jobs*, *caching*, and
*messaging*. TorqueBox can be used as a standalone server or
applications can be packaged into .war files and deployed onto the
[WildFly][] Java application server.

## Highlights of changes in TorqueBox 4.0.0.alpha1

### Just RubyGems

All of our release artifacts are now RubyGems, downloadable from
[rubygems.org][download] and installed via Bundler or whatever
mechanism you already use for other gems.

### Application server optional

TorqueBox 4 can now be used just like any standard Ruby web server,
without the need to run inside a Java application server. But, if you
need it, TorqueBox applications can also be bundled into a .war file
and deployed to the [WildFly][] application server. This TorqueBox
release has been tested with WildFly 8.2.0.Final.

### Substantial improvements to web performance

TorqueBox 4's web server, powered by [Undertow][undertow], has made
substantial improvements in throughput and resource efficiency over
TorqueBox 3. A prerelease version of TorqueBox 4's web server powers
all the 'rack-jruby' tests on the [TechEmpower Framework
Benchmarks][techempower], placing rack-jruby near the top of the JSON
and plaintext tests it participates in.

We'll delve a bit deeper into performance below for anyone interested.

## Getting started with TorqueBox 4

The best resource for getting started with TorqueBox 4, including
attempting to migrate applications from TorqueBox 3, is our
documentation. This is an alpha and some of the documentation is still
incomplete, but the various guides as well as API docs should help you
get started.

**[TorqueBox 4 Documentation][docs]**

<a name="performance"/>

## Web performance compared to other Ruby servers

In our testing, TorqueBox 4 is the highest performing JRuby web server
available. This means we may also be the overall highest performing
Ruby web server (MRI or JRuby) for many applications, but each
application is different. We'll provide a complete updated set of
benchmarks for TorqueBox 4 against other servers as time permits and
encourage members of the community to do their own testing. Accurate
benchmarking takes a large amount of time and effort, but we hope to
find time to do more of it.

With that said, there's been a lot of buzz generated lately about the
performance of a [new version of Phusion Passenger][raptor], codenamed
Raptor. It claims to be "up to 4x faster than other Ruby app servers",
but the devil is in the details. After some investigation, we've
determined that Raptor is caching responses on the "hello world"
benchmark application, bypassing the Ruby layer entirely for most
requests. All the other servers under test are going through the
entire Rack stack.

The merits of "hello world" benchmarks are debatable, but they
do provide some valuable insight into the maximum throughput any
server can possibly achieve with the simplest of Rack
applications. With turbocaching enabled, Raptor serves cached
responses to the benchmark client, bypassing the Rack layer entirely,
even though the Rack application never indicates that the response
should be cached. This invalidates any usefulness of the benchmark
except to prove that caching can improve performance, which is already
well-known.

Using Phusion's own benchmarking kit, modified to test against
TorqueBox 4.0.0.alpha1 instead of TorqueBox 3 and with Raptor's
turbocaching disabled, I get the following results when running their
hello world Rack benchmark:

<img src="/images/benchmarks/phusion_kit_hello_world.png"/>

The relative performance of each is all that matters here - the actual
requests per second numbers will be different on every machine. As you
can see, TorqueBox 4 leads the pack and Passenger 5 brings up the
rear.

We love friendly competition among other web servers and encourage
everyone to continue to push the boundaries of Ruby web server
performance. But, we also believe it's just as important to be open
and forthcoming with what is actually being benchmarked and not make
claims based on misleading configurations.

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

[download]:    http://rubygems.org/gems/torquebox/versions/4.0.0.alpha1-java
[docs]:        /documentation/4.0.0.alpha1/yardoc/
[community]:   /community/

[tb4_posts]:   /news/tags/4x/
[wildfly]:     http://wildfly.org/
[undertow]:    http://undertow.io/
[techempower]: http://www.techempower.com/benchmarks/#section=data-r9&hw=i7&test=json
[raptor]:      http://blog.phusion.nl/2014/11/25/introducing-phusion-passenger-5-beta-1-codename-raptor/
