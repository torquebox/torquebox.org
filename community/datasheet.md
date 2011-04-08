---
title: TorqueBox Community Datasheet
layout: default
---

TorqueBox takes the power of JBoss AS and mixes it with the beauty of
the Ruby language, using JRuby.  Not only does it provide a simple but
powerful substrate for running your web applications, it gives Ruby
developers easy access to advanced enterprise functionality such as
messaging, scheduled jobs, service daemons, and resource injection,
not to mention cross-cutting capabilities like clustering and
high-availability.

TorqueBox aims to be a comfortable environment for the pure Rubyist,
at the same time allowing Java-speaking polyglots to encapsulate
existing legacy code.  While JavaEE is wonderful for creating
stateless services that define your domain's transactional boundaries,
JSF componentry in the web tier can be complex and confusing.  By
allowing CDI components to be "injected" into Ruby objects, TorqueBox
gives enterprise architects the option to leverage powerful Ruby web
frameworks in the presentation tier without sacrificing the
sophistication of EJB/JPA in the model.

TorqueBox supports all popular Ruby web frameworks:

* Ruby on Rails (versions 2 and 3)
* Sinatra
* Any and all Rack-based frameworks

TorqueBox integrates many popular JBoss and third-party projects,
exposing them through simple Ruby libraries.

* JBoss AS 
* JBoss HornetQ message broker
* JBoss Infinispan data grid
* JBoss mod_cluster
* Quartz scheduler

This is what we mean by mixing JBoss power and Ruby beauty: achieving
the same result with one line of Ruby versus a dozen (or more!) lines
of Java.  Any developer familiar with JMS will appreciate this.

Additionally, TorqueBox provides an ecosystem of supporting
applications:

* BackStage: Provides access to the components TorqueBox exposes via
  JMX, including a message queue browser, along with tools for
  debugging application components, including evaluation of arbitrary
  ruby code against the server runtimes
* StompBox: Provides easy application deployment using `git`,
  i.e. deployment is triggered automatically after pushing changes to
  a remote git repository.

Find out more at http://torquebox.org/, or join #torquebox on irc.freenode.net
