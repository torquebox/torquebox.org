---
title: High Availability Singleton Services in TorqueBox
author: Ben Browning
layout: news
tags: [ hasingleton, services, cluster ]
---

This is the second article in a series exploring TorqueBox
Services. The [first article] introduced services with an IRC bot
example and we'll build on that to show how to make IrcBotService more
robust when used in a cluster. These examples use features not
available in the current Beta23 release so make sure you're running a
recent [developer build][] or any newer release that's available at
the time you read this.

[first article]: /news/2011/01/28/services
[developer build]: /download

Before you can explore clustered services, you'll need a clustered
TorqueBox. If you're unsure how to do this, read Jim's great articles
on [clustering TorqueBox][].

[clustering torquebox]: /news/2011/01/04/clustering-torquebox

# Clustered Services Overview

The default behavior for services in a cluster is for the service to
run on every node in the cluster. This is useful in many cases but not
for our IrcBotService.

# High Availability Singletons

In the case of IrcBotService, we only want one node in the cluster to
connect to IRC. Otherwise, we'd end up with multiple bots in the same
channel and nickname conflicts. At the same time if the cluster node
that's connected to IRC goes down we'd like the service to
automatically start on another node.

This type of service is called a high availability singleton, or
HASingleton, and is applicable to a wide range of services outside our
contrived IRC example. By using HASingleton services, we're guaranteed
that our service will only run on one node (the master node) and if
that node goes down another node will be elected master and the
service started on the new node. Other than a brief interval when one
master has stopped and the new one has yet to take over, the service
is always running on one and only one node.

# Using HASingletons in TorqueBox

Using HASingleton services in TorqueBox is easy! All it requires is
adding a `singleton: true` entry in the services.yml file. Here's our
IrcBotService entry from the last article marked as a HASingleton:

<script src="https://gist.github.com/819017.js"></script>

<noscript>
    IrcBotService:
      singleton: true
      nick: torquebox_bot
      server: irc.freenode.net
      port: 6667
      channel: '#torquebox'
</noscript>

When using HASingleton services you'll notice a warning message logged
to all TorqueBox instances started after the first one that looks
like:

    Dependency "jboss.ha:service=HASingletonDeployer,type=Barrier"
    (should be in state "Start", but is actually in state "Create")

This looks like an error but is expected behavior. There's an
outstanding JIRA to get rid of the scary log message in upstream JBoss
AS - [JBAS-7096][].

[jbas-7096]: https://issues.jboss.org/browse/JBAS-7096
