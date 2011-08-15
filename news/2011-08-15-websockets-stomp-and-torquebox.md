---
title: 'WebSockets, STOMP and TorqueBox'
author: Bob McWhirter
layout: news
tags: [ websockets, stomp, messaging ]
---

[Stilts project]: http://stilts.projectodd.org/
[Netty]: http://www.jboss.org/netty
[jmesnil-stomp]: https://github.com/jmesnil/stomp-websocket
[websockets-spec]: http://www.whatwg.org/specs/web-socket-protocol/
[stomp-spec]: http://stomp.github.com/stomp-specification-1.1.html

# Push and Shove

<img src="/images/push.jpg" style="float: right; width: 150px; margin-left: 1em; margin-bottom: 1em;"/>

After a few misdirections, we've finally started to bring home
the latest incarnation of our WebSocket support in TorqueBox.
WebSockets are exciting because they enable dynamic user interfaces via a browser *push* model.
It allows the application server to have the ability to send chunks
of data to a browser-based Javascript client.

TorqueBox implements [the WebSocket protocol][websockets-spec] with [STOMP][stomp-spec] to make the 
programming model even richer.

## WebSockets

WebSockets, supported by many newer browsers (and other browsers
using a Flash plugin), allow the browser to have a synchronous
and bidirectional channel to communicate back with the server.

WebSockets are very useful for *push* types of applications, where
data may be actively and continously loaded into a dynamic Javascript-based
user interface.  The WebSockets protocol operates on top of TCP/IP, and involve
passing discrete "frames" of arbitrary data between the two endpoints.  

While supporting basic WebSockets could be useful, we decided to
layer on some more useful technology, in the form of STOMP.

## STOMP

STOMP is a wire-level protocol (unrelated to the WebSockets protocol) defining 
messaging semantics.  STOMP does layer nicely on top of WebSockets, though, and 
keeps applications from having to deal with the lower-level data-framing.  STOMP also
adds the benefit of multiplexing multiple named streams of
data (in the form of messaging destinations) across a single
WebSocket connection, which results is lower resource usage
and easier application authoring.

# Stomplets

Part of the tangent between TorqueBox and WebSockets involved
the [Stilts project], which decided to treat messaging as 
a designable API endpoint, but separately from your core
JMS implementation.

We think it's a fundamentally bad idea to directly expose
your JMS broker to WebSocket-based clients on the public internet.
Just as MVC frameworks provide for the concept of a *controller*
to arbitrate the interaction between the user and underlying
resources such as a database, the Stilts project introduces
a controller role for messaging APIs.

We introduce an `app/stomplets/` directory to contain
your messaging controllers.

The Stomplet API allows your code to handle subscriptions
and messages for some destination(s), with routing similar
to how Rails web-request routing works.

## API

Stomplets may implement a few methods:

### `on_subscribe(subscriber)` and `on_unsubscribe(subscriber)`

First, when a client subscribes to a destination, the Stomplet
matching the route will have its `on_subscribe(...)` method called
with a subscriber object used to return messages to the client.

Likewise, upon unsubscription (or if the client closes the connection),
the Stomplet's `on_unsubscribe(...)` will be called.

### `on_message(message)`

For any message sent to a destination bound to the Stomplet, it's
`on_message(...)` will be called with the message from the client.

### Example

The Stomplet below handles multiple cheese-related destinations.
For each destination seen, it maintains a list of subscribers to
that destination.  For instance, everyone who subscribes to
`/stomplets/cheeses/gouda` is kept in one array, while subscribers
to `/stomplets/cheese/swiss` is kept in another.

Messages sent to any destination is distributed to all current
subscribers of the given fromage.  If there are no subscribers,
the message is quietly dropped.

<pre class="syntax ruby">class CheeseStomplet

  def initialize()
    @cheeses = {}
  end

  def on_subscribe(subscriber)
    @cheeses[ subscriber.destination ] ||= []
    @cheeses[ subscriber.destination ] << subscriber
  end

  def on_unsubscribe(subscriber)
    ( @cheeses[ subscriber.destination ] || [] ).delete( subscriber )
  end

  def on_message(message)
    ( @cheeses[ message.destination ] || [] ).each do |subscriber|
      subscriber.send( message )
    end
  end

end
</pre>

## Configuration and Routing

To configure the WebSockets/STOMP stack, a `stomp:` section is added to
your application's `torquebox.yml`.  

The primary subsection is then the `stomplets:` block, to wire a Stomplet
to one-or-more destinations, similar to Rails routing.

<pre class="syntax yaml">stomp:
  stomplets:
    cheese.stomplet:
      class: CheeseStomplet
      route: '/stomplets/cheeses/:cheese'
</pre>

# Yeah, but JMS is nice...

One problem with offering bare WebSockets support is that it is indeed
a point-to-point connection.  When working with clusters of application servers,
a given client maintains a WebSocket connection with exactly one node of
the cluster.  In the event that every node accepted connections and ran its
own `CheeseStomplet`, each cluster node would represent an isolated island
of clients.

A cluster-wide messaging implementation such as HornetQ can overcome
this limitation.  Each cluster node can manage a subset of STOMP
clients, but access the same queues and topics shared across JMS.

To make integration with JMS easier, while providing the ability to still
arbitrate subscriptions and sent messages, we include a `JmsStomplet`
which you may subclass.  It provides simple methods to connect
STOMP subscribers to JMS consumers, and to forward messages between
the two.  It additionally supports full transaction semantics.

A simple Stomplet to bridge a STOMP destination to a JMS destination 
would look like this:

<pre class="syntax ruby">require 'torquebox-stomp'

class BridgeStomplet < TorqueBox::Stomp::JmsStomplet

  def initialize()
    super
  end

  def configure(stomplet_config)
    super
   
    @destination_type = stomplet_config['type']
    @destination_name = stomplet_config['destination']
  end

  def on_message(stomp_message)
    send_to( stomp_message, @destination_name, @destination_type )
  end

  def on_subscribe(subscriber)
    subscribe_to( subscriber, @destination_name, @destination_type )
  end

end
</pre>

It could be configured in `torquebox.yml` like this, where the Stomplet's
`config:` section is passed through the `configure(...)` method.

<pre class="syntax yaml">stomp:
  stomplets:
    foo.bridge.stomplet:
      class: BridgeStomplet
      route: '/bridge/foo'
      config:
        destination: /queues/foo
        type: queue
</pre>

# Oh, I'm just browsing.

The whole point of this exercise is to push things to the browser.  
That requires a little Javascript.  The Stilts project provides a
STOMP-over-WebSockets Javascript client based upon [the work of Jeff Mesnil][jmesnil-stomp].

<pre class="syntax javascript">client = Stomp.client( "ws://localhost:8675/" );
client.connect( 'username', 'password', function() {
  client.subscribe( '/stomplets/cheeses/gouda', function(message) {
    // received a message!
  } );

  client.send( '/stomplets/cheeses/swiss', 
               { aged: 'true' }, 
               'Swiss is great!' );
} );
</pre>

The username and password parameters are currently ignored while
we determine what they should actually connect to.

Currently, the STOMP server runs on port 8675, until the IANA assigns
a port specifically for the protocol.

The Javascript client is provided in `$TORQUEBOX_HOME/share/javascript` directory.

## Rack middleware

To make it even easier to include the Javascript client in your application and
make it available to browsers, we provide a hunk of Rack middleware to serve the
Javascript client when your application sees a request for `/stilts-stomp.js`.

To use it, simply include the `torquebox-stomp` gem, and use it as you would
any Rack middleware.

<pre class="syntax ruby">require 'torquebox-stomp'

# ... whatever ... 

use TorqueBox::Stomp::StompJavascriptClientProvider
run app
</pre>

# Implementationally Efficient

In large-scale deployments, there's the opportunity to have thousands of
clients connected with WebSockets at any point in time.  We're using
[Netty] by Trustin Lee, which is a highly-scalable NIO framework capable
of dealing with a ton of clients without spawning a bajillion threads.

# Moving Target

We are actively working on the WebSockets/STOMP support, and there are 
some known weaknesses.  We absolutely welcome community input and use-cases
of how you actually intend to use this functionality.  Find us in `#torquebox`
on IRC or leave a comment right here.

There are absolutely opportunities to simplify some usage scenarios.

The current documentation can be [found here](/2x/builds/html-docs/websockets.html).

This functionality is available for preview in the 2.x codeline through
our [incremental builds](/2x/builds).

# Thanks

Once again, I'd like to thank Mike Dobozy for kicking off the whole
WebSockets effort and helping out continuously on its development.
Additionally, I'd like to thank Jeff Mesnil for writing a nice
Javascript client.
