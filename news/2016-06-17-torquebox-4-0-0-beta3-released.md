---
title: 'TorqueBox 4 Beta3 Released'
author: The Entire TorqueBox Team
layout: release
version: '4.0.0.beta3'
timestamp: 2016-06-17t14:15:00.0-04:00
tags: [ releases, 4x ]
---

The next beta release of TorqueBox 4 is out with some important bug
fixes, including compatibility with the latest JRuby 9
releases. Please give 4.0.0.beta3 a try and [create issues][issues]
for any bugs you find. The betas have been out long enough that
barring any major issues our next release will be 4.0.0

* [Download TorqueBox 4.0.0.beta3 from RubyGems][download]
* [Browse Documentation][docs]

## What is TorqueBox?

TorqueBox is a modular Ruby application server for JRuby that supports
Rack-based web frameworks and provides Ruby interfaces to standard
enterprisey services, including *scheduled jobs*, *caching*, and
*messaging*. TorqueBox can be used as a standalone server or
applications can be packaged into .war files and deployed onto the
[WildFly][] Java application server.

## Changelog for TorqueBox 4.0.0.beta3

* The `rack` gem dependency of `torquebox-web` was loosened in
  preparation for Rack 2.0.

* The `--exclude` option to `torquebox jar` was fixed to match based
  on a more natural `--exclude foo` instead of requiring a leading
  slash as in `--exclude /foo`. The leading slash variant will
  continue to work as well.

* Long-running monitored daemon support was added. When running in a
  WildFly cluster, the daemons can optionally be singletons (one
  instance running per cluster). See the API docs for
  `TorqueBox::Daemon` for more details.

* Calling `env.each_pair` on the Rack environment hash would sometimes
  only iterate over some of the hash. This is fixed so that it will
  iterate over the entire hash as expected.

* Our performance-optimized RackEnvironmentHash implemention had a
  method override that was incompatible with JRuby 9.1.0.0. This has
  been removed and JRuby versions >= 9.1.0.0 should work again.

* When running `java -jar my_torquebox_app.jar -S ...` default gems
  (json, rake, etc) may not have been found or even bundled inside the
  jar file correctly. Now they are.

* The WunderBoss version was bumped to 0.12.1, bringing in newer
  versions of Infinispan, Undertow, and several other of the
  underlying libraries. This also allows us to support running inside
  WildFly 10.0.0.Final.

* Integration tests are now run against WildFly 9.0.1.Final and
  WildFly 10.0.0.Final.

* Empty 304 responses sent from a Ruby application were ending up with
  a `Transfer-Encoding: chunked` header added and could result in the
  request hanging for some clients. This was fixed with the WunderBoss
  upgrade that brought in a newer Undertow version.

* Repeated executions of `torquebox jar` or `torquebox war` will no
  longer cause the generated archive to continually grow in size. We
  were accidentally including the existing archive inside the new
  archive every time the command was run.

## Getting started with TorqueBox 4

The best resource for getting started with TorqueBox 4, including
attempting to migrate applications from TorqueBox 3, is our
documentation.

**[TorqueBox 4 Documentation][docs]**

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

[download]:    http://rubygems.org/gems/torquebox/versions/4.0.0.beta3-java
[docs]:        /documentation/4.0.0.beta3/yardoc/
[community]:   /community/
[wildfly]:     http://wildfly.org/

[issues]:      https://github.com/torquebox/torquebox/issues
