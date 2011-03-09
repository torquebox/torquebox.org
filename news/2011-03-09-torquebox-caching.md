---
title: 'WINNING with TorqueBox Caching'
author: Jim Crossley
layout: news
tags: [ infinispan, caching, clustering, charlie-sheen ]
---

[Infinispan]: http://infinispan.org/
[ascache]: http://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html
[memstore]: http://api.rubyonrails.org/classes/ActiveSupport/Cache/MemoryStore.html
[modes]: http://community.jboss.org/wiki/Clusteringmodes
[TORQUE-33]: https://issues.jboss.org/browse/TORQUE-33
[sheen]: http://twitter.com/#!/charliesheen
[guide]: http://guides.rubyonrails.org/caching_with_rails.html
[cluster]: http://torquebox.org/news/2011/01/04/clustering-torquebox/
[dev]: http://torquebox.org/torquebox-dev.zip
[docs]: http://torquebox.org/documentation/DEV/rails.html#caching
[Galder]: http://twitter.com/#!/galderz
[Manik]: http://twitter.com/#!/maniksurtani
[Bob]: http://twitter.com/#!/bobmcwhirter

Well, we finally closed [TORQUE-33], originally opened in September of
*2009*!  We now have an extension of `ActiveSupport::Cache::Store`
supporting all the options of the
[existing Rails implementations][ascache], including `MemCacheStore`,
but backed by [Infinispan], the sexiest data grid we know.

Like [Charlie Sheen][sheen], Infinispan is sexy, has "tiger blood &
Adonis DNA", and "wins so radically in our underwear before our first
cup of coffee every day, it's scary."

Unlike Mr. Sheen, Infinispan is a state-of-the-art, high-speed,
low-latency, linearly-scalable distributed data grid that you *can*
process with a normal brain.

# Clustering modes

Before we show how simple it is to configure, we should go over the
[Infinispan clustering modes][modes] that determine exactly what
happens when something is written to the TorqueBox cache.

* ***Local*** -- This is what you get in non-clustered mode, roughly
   equivalent to the Rails [`MemoryStore`][memstore] if `MemoryStore`
   had write-through/write-behind persistence, JTA/XA support,
   MVCC-based concurency, and JMX manageability.  Enterprisey acronyms
   FTW! ;)
* ***Invalidation*** -- This is the default clustered mode for
   `TorqueBoxStore`, which works very well for Rails' fragment and
   action caching.  This mode does not actually share any data at all,
   so it's very "bandwidth friendly".  Whenever data is changed in a
   cache, other caches in the cluster are notified that their copies
   are now stale and should be evicted from memory.
* ***Replicated*** -- In this mode, entries added to any cache instance
   will be copied to all other cache instances in the cluster, and can
   then be retrieved locally from any instance.  Though simple, it's
   impractical for clusters of any significant size (>10).
* ***Distributed*** -- This mode is what enables Infinispan clusters to
   achieve "linear scalability". Cache entries are copied to a fixed
   number of cluster nodes (default is 2) regardless of the cluster
   size.  Distribution uses a consistent hashing algorithm to
   determine which nodes will store a given entry.

The coordination between nodes in a cluster can happen either
synchronously (slower writes) or asynchronously (faster writes).  The
default for `TorqueBoxStore` is asynchronous.

# Configuration

Our goal was to make the configuration extremely simple.  Contrary to
what you might infer from the Infinispan docs, you don't have to mess
with any XML.  You configure the TorqueBox cache store the
[same way you would any other Rails cache store][guide].  Simply put
this in your `config/application.rb` file:

    config.cache_store = :torque_box_store

Like the other `ActiveSupport` cache stores, that's really just
syntactic sugar for this:

    config.cache_store = ActiveSupport::Cache::TorqueBoxStore.new

Use whichever style you prefer.

By default, the `TorqueBoxStore` will be in asynchronous
*invalidation* mode when clustered (`JBOSS_CONF=all`), and *local*
mode when not.  So you don't have to worry about managing different
cache store configurations for each of your environments.  It will
adapt to whichever environment it finds itself.  That's why we
recommend setting it in `config/application.rb` rather than one or
more of the environment-specific files.

Use the `:mode` and `:sync` options to override the defaults, like so:

    config.cache_store = :torque_box_store, {:mode => :distributed, :sync => true}

And that's how you create a "perfect and bitchin' and just
winning-every-second" `Rails.cache`.

# "Bring me Dr. Clown Shoes!"

But perhaps you are "a warlock" or "an F-18, bro" or maybe you have
"fire-breathing fists" and "poetry in your fingertips, even during
naps."

Obviously, one cache may not be enough for you.

You may want to create multiple caches for your app, each in a
different mode that makes sense for the type of data being stored.  So
in addition to the invalidation cache used for fragment/action
caching, for example, you might include the following in an
initializer to maintain consistent, durable counters in your cluster:

    COUNTERS = ActiveSupport::Cache::TorqueBoxStore.new(:name => 'counters', 
                                                        :mode => :replicated, 
                                                        :sync => true)

When you create additional caches in your app, you're responsible for
uniquely identifying them (or not) using the `:name` attribute.  In
theory, it's possible for multiple apps to share the same cache by
using the same value for `:name`, but this is an advanced use case and
we're still working out some of the details involved.

It bears repeating that each `TorqueBoxStore` instance will fall back
to *local* mode regardless of its configuration if not deployed to a
clustered TorqueBox server.  This handy convenience means you don't
have to change your clustered config when testing locally, or even
when running outside of TorqueBox completely.

And when you *are* clustered, you never have to explicitly list the
hostnames or IP's of the other cache instances in your application's
config, as you would for `MemCacheStore`.  The nodes will be
discovered automatically and the cluster will form dynamically at
runtime.  See for yourself
[how easy it is to build a TorqueBox cluster][cluster].

# Off the Rails, like Charlie!

Although intended as an alternative implementation of
[`ActiveSupport::Cache::Store`][ascache] for Rails 3 apps (Rails 2 is
not supported), you can certainly use it from your non-Rails apps,
too, e.g. plain ol' Rack or Sinatra apps, and of course TorqueBox's
own Services, Tasks and Jobs!  Just add these to your Gemfile, bundle
install, and you'll be WINNING in no time, just like Charlie!

    gem "torquebox"
    gem "activesupport", ">= 3.0.3"
    gem "i18n"

Oh, and in case it's not obvious, you'll need to install the
[latest CI dev build][dev] to play with the new cache.  Links to it
and [accompanying docs][docs] are always available from the top-right
corner of any [torquebox.org](http://torquebox.org) page, probably
even this one!

With the Infinispan-backed `TorqueBoxStore`, your app will never again
have to "pretend it's not a total bitchin' rock star from Mars!"

# Acknowledgements

Big thanks to [Galder] and [Manik] for helping me grok Infinispan, and
[Bob] for courageously battling Maven and Bundler to re-org our gems,
but biggest thanks of all to [Charlie][sheen], without whom any of
this would have been possible.  Get well soon, Charlie!
