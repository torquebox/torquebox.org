---
title: 'TorqueBox 4 Beta2 Released'
author: The Entire TorqueBox Team
layout: release
version: '4.0.0.beta2'
timestamp: 2015-09-03t14:30:00.0-04:00
tags: [ releases, 4x ]
---

The second beta release of TorqueBox 4 is out with some important bug
fixes! As you've been doing with beta1, please give 4.0.0.beta2 a try
and file any bugs you find. Make sure to [create an issue][issues] for
anything you consider a blocker for TorqueBox 4.0.0 so we can get
things wrapped up and get that release out.

* [Download TorqueBox 4.0.0.beta2 from RubyGems][download]
* [Browse Documentation][docs]

## What is TorqueBox?

TorqueBox is a modular Ruby application server for JRuby that supports
Rack-based web frameworks and provides Ruby interfaces to standard
enterprisey services, including *scheduled jobs*, *caching*, and
*messaging*. TorqueBox can be used as a standalone server or
applications can be packaged into .war files and deployed onto the
[WildFly][] Java application server.

## Changelog for TorqueBox 4.0.0.beta2

* The `TorqueBox::Logger` class now provides methods to instantiate
  new loggers and configure the underlying logging system.

* Starting TorqueBox via rackup and specifying a port will no longer
  throw an error about converting a RubyString to int.

* Executable wars and jars will default to the correct RACK_ENV /
  RAILS_ENV when created with the "-e" or "--envvar" options instead
  of always defaulting to development.

## Getting started with TorqueBox 4

The best resource for getting started with TorqueBox 4, including
attempting to migrate applications from TorqueBox 3, is our
documentation.

**[TorqueBox 4 Documentation][docs]**

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

[download]:    http://rubygems.org/gems/torquebox/versions/4.0.0.beta2-java
[docs]:        /documentation/4.0.0.beta2/yardoc/
[community]:   /community/
[wildfly]:     http://wildfly.org/

[issues]:      https://github.com/torquebox/torquebox/issues
