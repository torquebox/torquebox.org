---
title: DataMapper, Infinispan, NoSQL, Oh My!
author: Lance Ball
layout: news
timestamp: Mon Jul 11 11:41:48 EDT 2011
tags: [infinispan, gems, nosql, orm, datamapper]
---

[CI]: https://torquebox.ci.cloudbees.com/
[1.x]: /1x/builds/
[2.x]: /2x/builds/

[ruby hotrod client]: http://torquebox.org/news/2011/06/08/infinispan-ruby-client/
[wiring it up]: http://torquebox.org/news/2011/03/09/torquebox-caching/
[noSQL datastore]: https://issues.jboss.org/browse/TORQUE-224
[ActiveRecord]: https://issues.jboss.org/browse/TORQUE-393
[community page]: http://torquebox.org/community/

# Introduction

We've mentioned Infinispan a lot on this blog. That's because we think it's
fantastic.  If you're new to Infinispan, you should definitely check it out.
It's a 100% Open Source, highly scalable data grid, with multiple language
bindings and a remote protocol that opens it's awesomeness up to anything that
can communicate over a network.

Jim Crossley was the first to take advantage of Infinispan by
[wiring it up] as an `ActiveSupport::Cache::Store`.  And not too long
after that, we released the first version of a [ruby hotrod client] which spoke the
native infinispan protocol.  But one of the most requested features we get for
Infinispan functionality is exposing it as a [noSQL datastore].

# Announcement

Today we're announcing early availability for a DataMapper Infinispan Adapter.
Now, with just a few lines of code, you get the scalability, replication, and
performance of Infinispan coupled with the simplicity of the Ruby DataMapper
API.  Let's look at an example.

# Example Usage

Here is a simple Sinatra application that uses the `dm-infinispan-adapter` that is
now available in the TorqueBox 2x-dev incremental builds.

<script src="https://gist.github.com/1076576.js?file=beers.rb"></script>

By default, the dm-infinispan-adapter will maintain an in-memory cache.  This is OK for testing
and perhaps some small applications.  You can control this behavior in the options to
`DataMapper.setup`.  In the example above, I've specified a specific location on disk for the
infinispan data files.

## How does this work?

When you declare your DataMapper models, `dm-infinispan-adapter` examines their properties
and, with some magic hand-waving, turns them into annotated Java classes that Infinispan and
the underlying search functionality (Hibernate Search + Lucene) can understand and index.

When your models are stored in the cache, Infinispan recognizes that they are indexable, and
passes them along to Lucene.  This allows us to search, what is essentially a key-value store
for values on specific properties of specific types.  Win!


# What's Next?

Documentation. Seriously, unless you want to read the code and poke through the JIRAs, this
post is as documented as it gets.  Obviously, that will need to change.

Also, the `dm-infinispan-adapter` code is relatively new and shipping with
incremental builds only.  But this work opens the door to many other exciting
possiblities, and brings "enterprise" scalability to an easy to use Ruby ORM.
This work allowed us to dip our toes into the popular noSQL world.  But
DataMapper isn't the only game in town, and we're actively interested in
pursuing integration with other ORM libraries such as [ActiveRecord].


# Staying Involved

We love our community and are always eager to hear about successes and failures when working with our stuff.
If you've got a hankering to see how this stacks up, please let us know how it goes.  We're regularly available
on the #torquebox channel on irc.freenode.net and we love helping folks out.

Check out our [community page] for other ways of keeping up to date.

# Availability

`dm-infinispan-adapter` is available now in the latest [incremental][CI] builds for the [2.x] branche. Give it a try.
We love feedback.

