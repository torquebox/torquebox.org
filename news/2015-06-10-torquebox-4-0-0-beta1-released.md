---
title: 'TorqueBox 4 Beta1 Released'
author: The Entire TorqueBox Team
layout: release
version: '4.0.0.beta1'
timestamp: 2015-06-10t11:00:00.0-04:00
tags: [ releases, 4x ]
---

We're pleased to announce the first beta release of TorqueBox 4! This
beta release fixes many issues identified in our TorqueBox 4 alpha
release. Unless a large volume of bug reports get filed for the beta,
expect our next release to be TorqueBox 4.0. Read our [TorqueBox 4
blog archives][tb4_posts] for more information on the motivation
behind TorqueBox 4 and how it differs from TorqueBox 3.

* [Download TorqueBox 4.0.0.beta1 from RubyGems][download]
* [Browse Documentation][docs]

## What is TorqueBox?

TorqueBox is a modular Ruby application server for JRuby that supports
Rack-based web frameworks and provides Ruby interfaces to standard
enterprisey services, including *scheduled jobs*, *caching*, and
*messaging*. TorqueBox can be used as a standalone server or
applications can be packaged into .war files and deployed onto the
[WildFly][] Java application server.

## Changelog for TorqueBox 4.0.0.beta1

* The 'torquebox' gem was missing gem dependencies on
  'torquebox-caching' and 'torquebox-messaging'. This has been fixed.

* Streaming of responses when not using chunked transfer-encoding is
  fixed. Previously, the response wouldn't be streamed and only get
  sent when the response was finished. This impacts Rail's
  response.stream, SSE, etc. Anything using chunked transfer-encoding
  worked fine and will continue to work fine.

* Bundler wasn't being packaged inside executable jars created with
  'torquebox jar' if Bundler was installed in a non-standard
  $GEM_HOME. The logic now looks at Gem.path instead of
  Gem.default_path, and thus should respect $GEM_HOME.

* Recent versions of Nokogiri will once again work when an app is
  packaged as a .war and deployed to WildFly.

* Passing "--env foo" to the "torquebox war" command no longer results
  in "NoMethodError: undefined method `[]=' for
  nil:Nilclass". Previously, this error would happen anytime you used
  the "--env" flag unless you also used the "--envvar FOO=BAR" flag to
  set some environment variable earlier in the command.

* Development moved to the 'master' branch instead of 'torqbox'

* The Rack Hijack API has been partially implemented. The only tested
  use of this is with the `tubesock` gem for WebSocket support.

* Print out the host and port that web is listening on when
  programmatically started with :auto_start set to true.

* Wars generated with 'torquebox war' can now be run directly with
  `java -jar foo.war`, just like jars.

* Scripts can now be run from inside packaged jar and war files using
  "-S".  Ex: `java -jar my_rails_app.jar -S rake db:migrate`

## Getting started with TorqueBox 4

The best resource for getting started with TorqueBox 4, including
attempting to migrate applications from TorqueBox 3, is our
documentation.

**[TorqueBox 4 Documentation][docs]**

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

[download]:    http://rubygems.org/gems/torquebox/versions/4.0.0.beta1-java
[docs]:        /documentation/4.0.0.beta1/yardoc/
[community]:   /community/

[tb4_posts]:   /news/tags/4x/
[jar_guide]:   /documentation/4.0.0.beta11/yardoc/file.jar.html
[wildfly]:     http://wildfly.org/
