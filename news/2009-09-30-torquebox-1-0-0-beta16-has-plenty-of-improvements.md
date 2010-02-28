---
title: TorqueBox 1.0.0.Beta16 has plenty of improvements
version: 1.0.0.Beta16
author: Bob McWhirter
layout: release
---
I'm happy to announce the release of TorqueBox 1.0.0.Beta16.

Go [download it](/download/) and [read the docs](/documentation/#{page.version}/) now.

I'd like to especially thank *GertThiel* and *dmilith* (both on [#torquebox IRC on freenode](/community/irc/)) 
for their input and bug-finding contributions for this release.  Gert's been working on enterprisey cache 
support using JBoss Cache.  Expect to see that integrated in a future upcoming release.  He also helped 
narrow down some bugs involving sessions and Rack integration (TORQUE-38 and TORQUE-39).

Included in this release, though:

## Bug

* [TORQUE-20](https://jira.jboss.org/jira/browse/TORQUE-20) - Ensure task queues fully undeploy
* [TORQUE-23](https://jira.jboss.org/jira/browse/TORQUE-23) - Fix jobs.yml documentation
* [TORQUE-28](https://jira.jboss.org/jira/browse/TORQUE-28) - Removing \\*-rails.yml from $JBOSS_HOME/server/\\*/deploy does not undeploy the application.
* [TORQUE-35](https://jira.jboss.org/jira/browse/TORQUE-35) - Specifying context in web.yml causes NPE
* [TORQUE-36](https://jira.jboss.org/jira/browse/TORQUE-36) - When using a context, relative paths are wrong if a trailing slash is not included
* [TORQUE-37](https://jira.jboss.org/jira/browse/TORQUE-37) - Rails' production.log shouldn't be mixed into JBoss AS' server.log
* [TORQUE-38](https://jira.jboss.org/jira/browse/TORQUE-38) - Set Rack's env\\['REMOTE_ADDR'\\]
* [TORQUE-39](https://jira.jboss.org/jira/browse/TORQUE-39) - Servlet-based session-store initialization fails for RAILS_ENV=production

## Task

* [TORQUE-29](https://jira.jboss.org/jira/browse/TORQUE-29) - Create a rails application template
* [TORQUE-31](https://jira.jboss.org/jira/browse/TORQUE-31) - Support generic Rack frameworks (sinatra, etc) and config.ru


