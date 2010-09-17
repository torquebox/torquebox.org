---
title: New Format for Messaging Configuration
author: Jim Crossley
layout: news
sequence: 2
---

One of the benefits of a "perpetual beta" is being able to introduce
new configuration formats without fear of having to be
backwards-compatible!  :-)

With the next release of TorqueBox (beta 22, hopefully in a week or
so), we will have modified our configuration (yet again!) that maps
message destinations (topics and queues) to the handlers of those
messages (message *processors*, in TorqueBox terminology).

Previously, we expected the mappings to reside in `messaging.tq`,
expressed in our own Ruby DSL, e.g.

    subscribe FooHandler, '/queues/foo'
    subscribe BarHandler, '/topics/bar', :filter=>'cost > 30'
    subscribe BazHandler, '/topics/bar', :filter=>'cost > 0', :config=>{ :type=>"premium", :season=>"fall" }

This is relatively concise and easy to understand, but it had a few drawbacks:

* It's Ruby code, so it requires a Ruby interpreter, which is relatively expensive to start up at deployment time.
* Because the actual class instances are referenced, it complicated the autoload-changed-classes feature in Rails development mode.
* Mapping multiple processors, similarly configured, to the same destination could get pretty verbose.
* TorqueBox has a number of configuration files, and with the exception of this one, they're all YAML.

So we now expect our messaging configuration to be expressed in YAML,
specifically `messaging.yml`, and we're pretty flexible in that we
support a number of different YAML constructs to define your mappings.
Here is how the above example would be rewritten:

    /queues/foo: FooHandler

    /topics/bar:
      BarHandler:
        filter: "cost > 30"
      BazHandler:
        filter: "cost > 0"
        config:
          type: "premium"
          season: "fall"

More details on the `messaging.yml` structure can be found in the beta
22 docs.