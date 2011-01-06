---
title: Clustering TorqueBox with mod_cluster
author: Jim Crossley
layout: news
---

Clustering TorqueBox instances is pretty darn simple, and it requires
virtually no special configuration whatsoever as long as you have IP
multicast routing enabled in your network.  There are, of course,
alternatives to multicast for those environments that prevent it (I'm
looking at you EC2!), but they are less magical and not as fun.  This
article describes the steps I took to form a TorqueBox cluster in my
development environment using a
[standard TorqueBox installation](/documentation/1.0.0.Beta23/installation.html).

# IP Aliases

My development environment is a single MacBook Pro (with its sharp
edges filed smooth).  Rather than building a cluster of virtual
machines on it, I chose to use IP aliases.  This allows me to run
multiple TorqueBox instances on a single host -- binding each to its
own interface -- without port conflicts.  Here's the command I used to
create an alias of `192.168.6.201`:

    sudo ifconfig en1 inet 192.168.6.201/32 alias

Actually, I used a shell "for loop" to create multiple aliases quickly:

    for i in {1,2}; do sudo ifconfig en1 inet 192.168.6.20${i}/32 alias; done

This gave me, for example, `192.168.6.201` and `192.168.6.202`.

# Server Configurations, i.e. $JBOSS_CONF

JBoss keeps its server configurations beneath `$JBOSS_HOME/server/`.
Each directory in there represents a different configuration.  You
specify which one to use with the `-c` option to JBoss' startup
script, `$JBOSS_HOME/bin/run.sh`. If not specified, `default` is used,
but that's not a clustered configuration, so it won't suit our needs.

We need to use the `all` configuration, which **is** clustered, but
because both of our JBoss processes will share the same file system,
and because certain services maintain their state beneath temporary
directories in the server configuration, we need to create copies for
each of our "nodes" to use.

    $ cd $JBOSS_HOME/server
    $ cp -R all node1
    $ cp -R all node2

The directory names are completely arbitrary -- we just need a way to
reference them with the `-c` option -- but it's a good idea to adopt
some sort of convention.

Keep in mind that this wouldn't be necessary when clustering *real*
machines (or even real *virtual* machines) because they wouldn't
typically be sharing a file system, but making copies of server
configurations to tweak in various ways is a handy JBoss technique,
regardless.  So I'm kinda doing you a favor.  You're welcome! ;)

# Start your JBoss back-end "nodes"

Fire up a shell window and start "node1":
    $JBOSS_HOME/bin/run.sh -b 192.168.6.201 \
                           -c node1 \
                           -Djboss.mod_cluster.advertise.enabled=true

Then fire up "node2" in another shell window:
    $JBOSS_HOME/bin/run.sh -b 192.168.6.202 \
                           -c node2 \
                           -Djboss.mod_cluster.advertise.enabled=true

* `-b` references our IP aliases
* `-c` references our copies of the `all` config
* the `jboss.mod_cluster.advertise.enabled` system property enables
  automatic discovery of the httpd mod_cluster front-end[s]. Its
  default value [false] is in
  `$JBOSS_HOME/server/$JBOSS_CONF/deploy/mod_cluster.sar/META-INF/mod_cluster-jboss-beans.xml`.
  You could, of course, set it there and omit it from the command
  line.

You should see some indication of each node finding the other in the
log output.  Hopefully, you won't see any stack traces!

# Start your httpd/mod_cluster front-end

The
[JBoss mod_cluster Apache module](http://www.jboss.org/mod_cluster) is
a truly amazing piece of software.  I encourage you to
[read all about it](http://docs.jboss.org/mod_cluster/1.1.0/html/),
but in a nutshell: grab the appropriate tarball from
[here](http://www.jboss.org/mod_cluster/downloads/1-1-0.html), unpack
it, configure it to run non-privileged, and start it:

    $ tar xvzf mod_cluster-1.1.0.Final-macosx-x86-ssl.tar.gz
    $ ./opt/jboss/httpd/sbin/installhome.sh
    $ ./opt/jboss/httpd/sbin/apachectl start

This results in `httpd` listening on <http://localhost:8000> (not 80).
It will accept MCMP messages on `localhost:6666` and offer
`/mod_cluster_manager` on the same host and port.  This means you
should see your JBoss instances listed at
<http://localhost:6666/mod_cluster_manager> within a few seconds.
  
# Congratulations, you're a cluster!

You now have a TorqueBox cluster fronted by httpd/mod_cluster,
complete with session replication, affinity, failover and
load-balanced web requests and message delivery.  You can grow it by
simply firing up another JBoss back-end.  You can shrink it by killing
one.

It's arguably easier to set up virtual machines than use the IP
aliases because you can omit the steps of creating the aliases and
copying the server configurations, but you then must use capistrano,
rsync, or something else to deploy your app to each backend.  This is
obviously how you'd want to manage your app in production, but for
development, I prefer to have the nodes share the filesystem so that
changes to the app are reflected immediately in all nodes.

In a future article, I'll create a simple Rails app that demonstrates
session replication and failover.  Then we'll show how clustered
messaging "just works" out of the box, too.
