---
title: 'Infinispan Ruby Client Released'
author: Lance Ball
layout: news
tags: [ infinispan ]
---

[github]: http://github.com/torquebox/infinispan-ruby-client
[infinispan]: http://www.jboss.org/infinispan
[torquebox-cache]: http://torquebox.org/documentation/LATEST/web.html#caching
[download]: http://www.jboss.org/infinispan/downloads

# Infinispan on Ruby

[Infinispan][infinispan] is a highly-scalable, distributed data grid that ships
with JBoss AS.  Since it's built into the AS, TorqueBox already puts it to good
use for session storage and [ActiveSupport caching][torquebox-cache].  The
`infinispan-ruby-client` gem takes things a step further, providing ruby access
to a remote Infinispan data grid utilizing the Hot Rod binary protocol.

As a bonus, it's straight-up Ruby. Unlike a lot of what we produce, the
`infinispan-ruby-client` does not require JRuby, TorqueBox, or any other
Java-related technology.  Just install the gem and go.

# Installation
To install the client, use rubygems.

    $ gem install infinispan-ruby-client

# Usage

The client connects to an Infinispan server running the hotrod protocol. To get
started, [download] Infinispan and run the server.

1) Start Infinispan specifying hotrod for the protocol 

    $INFINISPAN_DIR/bin/startServer.sh -r hotrod

2) Then write some code

    require 'infinispan-ruby-client'
    cache = Infinispan::RemoteCache.new 

    # Store and retrieve a string
    cache.put("Name", "Lance") 
    cache.get("Name") # returns "Lance" 

    # Store and retrieve a ruby object
    cache.put("Time", Time.now) 
    time = cache.get("Time") 
    time.class # returns Time


# What's next?

This is a first release.  There is still plenty to do.  Here are some items on the list.

* Support cache names so the client can connect to something other than the default cache.
* Provide an operation to expose various server statistcs as reported by hotrod.
* Support for intelligent clients and topologies, and listeners.
* Support for transactions

If you end up trying out the gem or using it in any way, really, we'd love to hear from you.
You can almost always find us hanging out in #torquebox on irc.freenode.net.

