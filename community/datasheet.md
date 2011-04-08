---
title: TorqueBox Community Datasheet
layout: default
---

TorqueBox takes the power of JBoss AS and mixes it with the beauty of
the Ruby language, using JRuby.  Not only does it provide a simple but
powerful substrate for running your web applications, it gives Ruby
developers easy access to advanced enterprise functionality such as
messaging, scheduled jobs, service daemons, and resource injection,
not to mention cross-cutting capabilities such as clustering and
high-availability.

TorqueBox aims to be a comfortable environment for the pure Rubyist, while
allowing Java-speaking polyglots to encapsulate existing legacy code.

TorqueBox supports all popular Ruby web frameworks:

* Ruby on Rails (versions 2 and 3)
* Sinatra
* Any and all Rack-based frameworks

TorqueBox integrates many popular JBoss and third-party projects, exposing them
through simple Ruby libraries:

* JBoss AS 
* JBoss HornetQ message broker
* JBoss Infinispan data grid
* JBoss mod_cluster
* Quartz scheduler

TorqueBox additionally provides integration with Java CDI components
and is manageable through JMX.

TorqueBox provides an ecosystem of supporting applications:

* BackStage: Provides a queue browser, along with tools for debugging application 
  components, including evaluation of arbitrary ruby code against the server
  runtimes
* StompBox: Provides easy application deployment using `git`

Find out more at http://torquebox.org/, or join #torquebox on irc.freenode.net
