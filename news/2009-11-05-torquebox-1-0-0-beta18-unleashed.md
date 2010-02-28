---
title: TorqueBox 1.0.0.Beta18 Unleashed!
author: Bob McWhirter
version: 1.0.0.Beta18
layout: release
---
TorqueBox 1.0.0.Beta18 is out right now.
  
[Download it](/download) and [read the documentation](/documentation/#{page.version}/).
  
Mostly this fixes some bugs with the VFS support, queues with complex names, 
and session identification through URL manipulation (useful for Flash-based 
uploaders that don't play friendly with cookies).

*Update: Yes, this release is based upon JRuby 1.4.*

Here's what JIRA thinks we've done:

## Bug

* [TORQUE-22](https://jira.jboss.org/jira/browse/TORQUE-22) - Report errors better in the case of incomplete tasks specified in jobs.yml
* [TORQUE-46](https://jira.jboss.org/jira/browse/TORQUE-46) - gems cannot be compiled, mvn install - compilation error
* [TORQUE-49](https://jira.jboss.org/jira/browse/TORQUE-49) - VFS IO.open(...) does not catch existing files or open them correctly.
* [TORQUE-50](https://jira.jboss.org/jira/browse/TORQUE-50) - Remove crypto jar from torquebox-core-deployer.jar
* [TORQUE-51](https://jira.jboss.org/jira/browse/TORQUE-51) - StringUtils.camelize(...) will occasionally enter infinite loop
* [TORQUE-52](https://jira.jboss.org/jira/browse/TORQUE-52) - rake torquebox:server:run assumes unix and run.sh
* [TORQUE-53](https://jira.jboss.org/jira/browse/TORQUE-53) - ENV\\[\\*\\*\\] not being set appropriately
* [TORQUE-55](https://jira.jboss.org/jira/browse/TORQUE-55) - URL-based session-tracking leaves ;jsessionid=X in the REQUEST_URI

## Task

* [TORQUE-42](https://jira.jboss.org/jira/browse/TORQUE-42) - Adjust to Yecht for YML parsing (JRuby 1.4)


