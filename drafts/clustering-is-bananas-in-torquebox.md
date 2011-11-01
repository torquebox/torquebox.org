---
title: 'Clustering is bananas in TorqueBox'
author: Bob McWhirter
layout: narrow 
tags: [ clustering, enterprisey, bananas ]
---

[JGroups]: http://jboss.org/jgroups

# Clustering

Up until recently, while the TorqueBox team worked on the 2.x codeline, moving
from JBoss AS6 to JBoss AS7, we ignored the fact that clustering has changed.
Now we've taken a look, and are happy to say that clustering in 2.x is bananas!

With TorqueBox 2.x, though, the idea of a "cluster" is more ethereal than you
might imagine (or not, depending on your imagination and recreational drug use).
JBoss AS7 has attempted to approach "manage a bunch of servers" orthogonally to
"have those servers collude to form a 'cluster'".

Let's ignore the management aspect, and think about collusion.  With TorqueBox 2.x,
collusion occurs at the service level, irrespective of what sort of containers 
they live in, or how they are managed.  You may have 20 instances of TorqueBox
running, but if only 3 have HornetQ enabled (and set to cluster), then your messaging
cluster contains 3 nodes.  Likewise, if only 10 of those servers have Infinispan
on them, then your Infinispan cluster (and therefore your clustered webservers, also)
are only 10 nodes wide.

<a href="http://www.flickr.com/photos/ahvega/4428377886/">
  <img src="http://farm3.static.flickr.com/2697/4428377886_26a8365b46.jpg" style="width: 200px; float: right; margin-left: 1em">
</a>

The way this works, in practice, is you stand up a lot of nodes, and the
services they contain go and find their friends using [JGroups], and 
create these service-level clusters.  It's like a bunch of bananas, living 
their independent bananay lives, but joined together at one critical point.

Things that are currently cluster-capable in TorqueBox includes

* Infinispan caches
* Web sessions (using Infinispan)
* HornetQ 

While not directly cluster-aware, the STOMP/WebSocket support can be used
in cluster modes using HornetQ to perform the inter-node communication.

# Make some pudding

How do you take advantage of this clustery goodness?  If you're on an
multicast-capable network (ie, *not* Amazon EC2), you can boot up a
cluster-aware node using the stock JBoss scripts under `$JBOSS_HOME/bin`:

    $JBOSS_HOME/bin/standalone.sh -c standalone-ha.xml

This launches a node of TorqueBox in using the HA, or high-availability
profile.  After booting, some of its services will use multicast to 
find any other HA nodes and wire them together.

# Make some instant pudding

An even easier way to launch an actual cluster, a not just a single cluster-aware
node is to use *domain mode*.  Remember above when we discussed how management
is orthogonal to clustering?  Domain mode applies management to these independent
bananay nodes.  By launching in domain mode, it actually will fire up a 
*domain controller* to manage all of your AS instances.  Additionally it fires
up a *host controller*, which manages the actual AS instances on a given host,
and since you've gone through all of this trouble, the host controller will fire
up (by default) two HA-aware AS nodes.

The nice thing about domain mode is that you can add and remove AS instances
at runtime, without having to install more copies or edit XML files.  It makes
it easy to say "launch me another but shift all the ports by 100", and the
host controller ensures each instance on that host gets its own filesystem
space and the same configuration, along with unique port assignments.

To launch a simple 2-cluster on localhost:

    $JBOSS_HOME/bin/domain.sh

Wait until everything boots and discovers its neighbors, and you've got a
cluster.

# But where's my spoon?

How do you get your apps onto all of these nodes?  That depends on if you're
using *standalone* or *domain* based management, and if you're deploying
`-knob.yml` files or complete `*.knob` archives.

# Failover and HA

<a href="http://www.flickr.com/photos/rberteig/283365238/">
  <img src="http://farm1.static.flickr.com/103/283365238_9e062e3951.jpg" style="width:200px; float: left; margin: 1em;">
</a>

Sometimes something bad can befall one of the nodes in your cluster.  Many times
we use clusters to support scalability and load, but other times we count on clusters
to reduce downtime, absorbing failures gracefully.

# Clustered Demo

The stomp-chat-demo application demonstrates a few levels of clustering.

First, the web layer uses clustered sessions, so if a user ends up on different
nodes for each web request, his session data follows him around. In HA mode,
sessions are replicated using Infinispan under the covers.

Secondly, since we have multiple nodes participating in a single chat session,
it takes advantage of *clustered topics* in HornetQ to ensure that messages
received by any node are distributed to all other clients connected to other
nodes.

Thirdly, an *HA-singleton* roster-maintenance message processor runs on one
node of the cluster, sending out the current roster of chatters connected 
to the entire system (on any node).  The HA-singleton aspect allows for failover.
If the roster-maintenance processor is on a node that gets tackled by a monkey,
the same roster-maintenance processor will crank up on another node.

Finally, since the roster-maintenance processor might shift from one node
to another, the state of the roster itself needs to be able to be accessed
from whichever node is currently serving that role.  To achieve this, the
processor directly uses a replicated Infinispan cache to store the actual
data.  This avoids using the filesystem for persistance, and also keeps us
from having to use and manage a separate network-accessible database.

