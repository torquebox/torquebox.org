---
title: TorqueBox 1.0.0.Beta19 is out!
author: Bob McWhirter
version: 1.0.0.Beta19
layout: release
---

Finally, TorqueBox 1.0.0.Beta19 is out.  

Go [download it](/download/) and [read the documentation](/documentation/#{page.version}/).

This release first and foremost includes an update to being based
upon [JBoss AS](http://jboss.org/jbossas/) 6.0.0 milestone 2.  To accomplish
the upgrade, we've reworked the Maven-based build system to be linked
at the elbow with the core JBoss AS build.

Additionally, on top of that, in fact, quite exceptionally,
TorqueBox now uses [JBoss HornetQ](http://hornetq.org/) to power
it's messaging.  Even regular JBoss AS doesn't do that yet.

This release also sees some major changes and improvements
to not just asynchronous tasks, but MQ integration in general. 
Be sure to check out the documentation, as new features have
been added and APIs have changed some.  That's why we call it
*beta*.

The next release will focus on some much-needed internal cleanup,
a documentation refresh, and perhaps an examination of Rails 3.
So far, this release ships with Rails 2.3.4.

This is what JIRA thinks we've accomplished:

## Bug
* [TORQUE-57](https://jira.jboss.org/jira/browse/TORQUE-57) - ActionController::send_data and send_file fail quietly
* [TORQUE-59](https://jira.jboss.org/jira/browse/TORQUE-59) - Queue payloads object to complex objects

## Task
* [TORQUE-66](https://jira.jboss.org/jira/browse/TORQUE-66) - Update Torquebox download link in documentation
* [TORQUE-67](https://jira.jboss.org/jira/browse/TORQUE-67) - Upgrade to JBoss AS 6 milestone 2
* [TORQUE-68](https://jira.jboss.org/jira/browse/TORQUE-68) - Integrate HornetQ for messaging





