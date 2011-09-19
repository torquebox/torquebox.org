---
title: 'Distributed Transactions with TorqueBox'
author: Jim Crossley
layout: news
tags: [ xa, transactions ]
---

[MarkL]: http://twitter.com/nmcl
[Bob]: http://twitter.com/bobmcwhirter
[simple]: http://diveintomark.org/archives/2010/02/23/simplicity-is-hard-lets-go-shopping
[fun]: http://people.apache.org/~acmurthy/WhyIsProgrammingFun.html
[MessageProcessors]: http://torquebox.org/documentation/LATEST/messaging.html#messaging-consumers
[Backgroundable]: http://torquebox.org/documentation/LATEST/messaging.html#backgroundable
[art]: http://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html
[activerecord-jdbc-adapter]: https://github.com/jruby/activerecord-jdbc-adapter
[rails]: http://torquebox.org/documentation/LATEST/web.html#rails
[jbossds]: https://docs.jboss.org/author/display/AS7/DataSource+configuration
[IronJacamar]: http://www.jboss.org/ironjacamar
[HornetQ]: http://hornetq.org
[JBossTS]: http://www.jboss.org/jbosstm
[JRuby]: http://jruby.org
[bugs]: https://jira.jboss.org/jira/secure/CreateIssue.jspa?issuetype=1&pid=12310812

# TorqueBox is [Atomic, Dog](http://www.youtube.com/watch?v=LuyS9M8T03A)

Ever since I came to work at Red Hat, my [boss'][Bob] [boss][MarkL],
the JBoss CTO and a reputed transactions expert, has been politely
nagging us to bring transactions to TorqueBox. Well, I'm proud to
announce we finally got around to it: TorqueBox 2.x features
distributed XA transaction support in what we believe is a darn
elegant Ruby API... because it's mostly transparent. ;)

Few things get an enterprise architect's blood pumping (boiling?) more
than distributed transactions, though many anti-enterprisyists dismiss
them as heavyweight, preferring comparatively complex alternatives,
e.g. idempotent receiver, that are arguably just as resource-intensive
(though potentially more distributable) and often more error-prone.

To those naysayers, we proudly say **"Pfft!"**

The goal of the TorqueBox project is to make robust enterprise
services [simple] and [fun] to use, combining the power of JBoss with
the expressiveness of Ruby. Distributed XA transactions are our latest
attempt at achieving that goal.

# Some Terminology

It's important to understand the difference between a conventional
database transaction and a *distributed* transaction: *multiple
resources* may participate in a distributed transaction. The most
common transactional resource is a database, of course. But a message
broker may also be a transactional resource. Distributed transactions
allow your application to say, tie the success of a database update to
the delivery of a message, i.e. the message is only sent if the
database update succeeds, and vice versa. If either fails, both
rollback.

*X/Open XA* is a standard specification for implementing distributed
transactions. It uses a *two-phase commit (2PC)* protocol. Often these
terms are used interchangeably to refer to the same thing.

# Messaging

Here's how we've made messaging transactional in 2.x:

- By default, all [MessageProcessors] are transactional, so each
  `on_message(msg)` invocation demarcates a transaction.
- Any messages published to any JMS destinations inside
  `on_message(msg)` become a part of its transaction by default, so if
  an exception is raised, none of the messages will be delivered, and
  the failed message will be scheduled for redelivery.
- All [Backgroundable] tasks are transactional and, when invoked
  within `on_message(msg)`, will only start if `on_message` doesn't
  raise an exception, i.e. it commits.
- Any manipulations of your Rails ActiveRecord models (persisted to
  your XA-compliant database) within `on_message(msg)` will become
  part of its transaction.

This bears repeating: all the above you get for free when your app is
deployed on TorqueBox 2.x. No extra config is required. 

# TorqueBox.transaction() {...}

In addition, we've introduced a new method, `TorqueBox.transaction`,
that can be used to enlist multiple XA-compliant resources into a
single distributed transaction from anywhere in your application. This
includes Rails ActiveRecord models, which are enhanced when run in
TorqueBox, so contrary to the [ActiveRecord Transactions docs][art]:

- Transactions **can** be distributed across database connections when
  you have multiple class-specific databases.
- The behavior of nested transaction rollbacks won't surprise you: if
  the child rolls back, the parent will, too, excepting the
  `:requires_new=>true` option passed to the child.
- Nested transactions should work correctly on more than just MySQL
  and PostgreSQL; in theory, they should work on any database
  providing an XA driver known to work with JBoss, including H2,
  Derby, Oracle, SQL-Server, and DB2. (Sqlite3 doesn't support XA)
- Callbacks for `after_commit` and `after_rollback` work as you would
  expect for models involved in a `TorqueBox.transaction`

# Configuration

All ActiveRecord-dependent apps running on TorqueBox must use the most
excellent JRuby [activerecord-jdbc-adapter] as described in the
[docs][rails].

It's certainly possible to configure the JDBC adapter in your
`database.yml` with the JNDI name of an XA datasource [you configured
by either clicking through some admin web page or tab-completing
through a convenient console script or even adding some raw XML to a
config file yourself, not to mention bundling and/or uploading the
hand-modified jar file containing your database driver!][jbossds]

*But **ZOMFG** what a **FPITA** that would be!*

Worse still, that JNDI name wouldn't work for your database
migrations, since you'd be running those outside of TorqueBox, hence
no JNDI. Frankly, we'd rather you not even know how to spell JNDI.

So TorqueBox creates those XA datasources for you automatically when
your app deploys, using the normal AR-JDBC config in your
`database.yml`, and that works perfectly well for your migrations,
too.

Bottome line: no extra configuration required.

# Let's see some code, kk? kk!

Here's a typical TorqueBox message handler:

<pre class="syntax ruby">class Processor &lt; TorqueBox::Messaging::MessageProcessor
  always_background :send_thanks_email
  def on_message(msg)
    thing = Thing.create(:name => msg).id
    inject('/queues/post-process').publish(thing.id)
    send_thanks_email(thing)
    # raise "rollback everything"
  end
  def send_thanks_email(thing)
    ...
  end
end</pre>

Of course, the commented raise statement is contrived, but it
illustrates the point that if any exception occurs during the
execution of `:on_message`, no `Thing` instance is created, no
`post-process` queue receives a message, and no gratitude is emailed.

The above code is certainly valid in TorqueBox 1.x, but uncommenting
the raise statement would only cause the message to be redelivered, by
default another 9 times, effectively resulting in the creation of 10
like-named Thing objects, 10 messages sent to the post-process queue,
and 10 emails of gratitude sent out. Without transactions, you're
gonna need some more code, e.g. "idempotent receiver", to ensure the
integrity of your data.

Occasionally, you may not want all published messages to assume the
transaction of `on_message`. In that case, pass `:requires_new =>
true`:

<pre class="syntax ruby">class Processor &lt; TorqueBox::Messaging::MessageProcessor
  def on_message(msg)
    inject('/queues/post-process').publish("foo", :requires_new => true)
    raise "you're gonna post-process ten 'foo' messages"
  end
end</pre>

The `on_message` method is invoked after an implicit transaction is
started, but you can do this explicitly yourself using
`TorqueBox.transaction`. It accepts the following arguments:

- An arbitrary number of resources to enlist in the current
  transaction (you probably won't use this)
- An optional hash of options; currently only `:requires_new` is
  supported, defaulting to `false` (often handy)
- A block defining your transaction (kind of the whole point)

Here's the "surprising" example from the [Rails docs][art] which
results in the creation of both 'Kotori' and 'Nemu':

<pre class="syntax ruby">User.transaction do
  User.create(:username => 'Kotori')
  User.transaction do
    User.create(:username => 'Nemu')
    raise ActiveRecord::Rollback
  end
end</pre>

And here's the TorqueBox version which creates neither 'Kotori' nor
'Nemu', as you would expect:

<pre class="syntax ruby">TorqueBox.transaction do
  User.create(:username => 'Kotori')
  TorqueBox.transaction do
    User.create(:username => 'Nemu')
    raise ActiveRecord::Rollback
  end
end</pre>

To prevent Nemu's failures from discouraging Kotori, use
`:requires_new` just like with ActiveRecord, and only Kotori will be
created:

<pre class="syntax ruby">TorqueBox.transaction do
  User.create(:username => 'Kotori')
  TorqueBox.transaction(:requires_new => true) do
    User.create(:username => 'Nemu')
    raise ActiveRecord::Rollback
  end
end</pre>

Here's an example of enlisting a message destination into a
transaction saving a Post instance, but I'll admit the syntax for
obtaining the JMS session is a tad obtuse. In practice, I'd recommend
doing this in a MessageProcessor instead, but it does show an example
of adding an XAResource to a transaction.

<pre class="syntax ruby">queue = inject('/queues/foo')
queue.with_session do |session|
  TorqueBox.transaction(session) do 
    queue.publish("a message")
    post.save!
  end
end</pre>

# The Fine Print

It's still early days for this, so be gentle when reporting [bugs]!
It's only been tested with Rails 3 so far, on H2 and PostgreSQL
backends, but not with a "real application", if you know what I mean.

The API is still subject to further coagulation up until we officially
release 2.0, of course. So get your cards and letters in now!

# Acknowledgments

Transactions are hard. Much thanks and credit goes to the JBoss teams
and communities behind [IronJacamar], [HornetQ], [JBossTS], and
everyone else I forgot. You guys rock!

Of course, none of this would be possible without the excellent work
of, and continued support from, the [JRuby] team. You guys are
awesome!

And last but not least, my [team](http://projectodd.org), and
especially [Bob], who single-handedly wrote all the "automatic XA
datasouce creation from database.yml" stuff. Thanks! :)
