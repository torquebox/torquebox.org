---
title: 'STOMP Chat Demo - Part 2'
author: Bob McWhirter
layout: news
tags: [ websockets, stomp, messaging ]
---

[Part 1]: /news/2011/08/23/stomp-chat-demo-part1/
[Part 2]: /news/2011/08/23/stomp-chat-demo-part2/
[Part 3]: /news/2011/08/23/stomp-chat-demo-part3/
[HornetQ]: http://hornetq.org/

# Let's review, shall we?

This is part 2 of a multi-part series, walking you through the new 
STOMP-over-WebSockets functionality in TorqueBox. This is a set of technologies 
that enabled advanced push applications over the web.

1. [Part 1]: Getting started, Sinatra app & Javascript client
2. [Part 2]: Sending and receiving messages
3. [Part 3]: Originating messages from other components

In this part, we will describe how our previously-connected client actually 
sends and receives messages, and how they move around the system.

In the first part, we showed how the Javascript client connects and sets up some 
subscriptions. Additionally, we defined a jQuery event `TorqueBox.Chat.NewMessage` 
which delegates to an `onNewMessage` function, which takes the message, along with 
the recipient, and shuffles it back to the STOMP server.

<pre class="syntax javascript">// chat.js
client.connect(null, null, function() {
  $(TorqueBox.Events).bind('TorqueBox.Chat.NewMessage',
                            onNewMessage);

  client.subscribe( '/public', function(message) {
    $(TorqueBox.Events).trigger('TorqueBox.Chat.NewPublicMessage',
                                [message]);
  });
  
  client.subscribe( '/private', function(message) {
    $(TorqueBox.Events).trigger('TorqueBox.Chat.NewPrivateMessage',
                                [message]);
  } );
};


var onNewMessage = function(event, message, recipient) {
  if ( recipient == 'public' ) {
    client.send( '/public',
                 {},
                 message );
  } else {
    client.send( '/private',
                 { recipient: recipient },
                 message );
  }
};
</pre>

Now let's see what actually happens to move messages around.

# Browser-to-server

## Browser-side

When a user submits a message, our handler figures out which 
recipient is being targeted based on the current-displayed 
recipient panel.

It then fires the TorqueBox.Chat.NewMessage event with the 
message and recipient as arguments.

<pre class="syntax javascript">// chat_view.js
var onMessageSubmit = function(event) {
  recipient = $( '.recipient.current' ).attr( 'recipient' );
  $(TorqueBox.Events).trigger('TorqueBox.Chat.NewMessage', [$('#input').val(), recipient]);
  $( '#input' ).val( '' );
  return false;
};
</pre>

At no point is the browser client responsible for setting the 
sender or "from" address of the message. The client simply 
delivers the bare text to either the `/public` or `/private` destinations.

For messages intended for the public, our event-handler simply 
posts the raw text as a message to the `/public` STOMP destination. 
No headers, either sender nor recipient are set.

For private messages being sent to a specific individual, our 
event-handler sets the `recipient` (but not sender) header, and 
deposits the message on the `/private` STOMP destination.

## Server-side

### JMS as the spine

On the server, our chat application ultimately is based around [HornetQ], 
an awesome JMS broker. We've designed the application to only use one 
JMS topic for everything, differentiating messages using JMS message 
properties and selectors.

### Messages sent to `/public`

On the server-side, we've wired the `/public` STOMP destination to our `PublicStomplet`. 
This Stomplet handles all messages sent by ever client to the `/public` destination, and 
is responsible for moving them along. This Stomplet enforces the sender of each value, 
to prevent anyone else from spoofing messages from others.

The user's web-based session is available to every Stomplet, and it can be used to enforce 
identity. It also ensures that the `recipient` header is set to the value of `public`, 
taking the burden off the browser client.

The then uses the `send_to(...)` method of `JmsStomplet` to convert and deliver a STOMP 
message to a JMS destination, which was obtained through injection.

<pre class="syntax ruby"># public_stomplet.rb
require 'torquebox-stomp'

class PublicStomplet < TorqueBox::Stomp::JmsStomplet
  def initialize()
    super
    @destination = inject( '/topics/chat' )
  end

  def on_message(stomp_message, session)
    username = session[:username]
    stomp_message.headers['sender'] = username
    stomp_message.headers['recipient'] = 'public'
    send_to( @destination, stomp_message )
  end
end
</pre>

In diagram form, you can see that the PublicStomplet receives STOMP messages, 
sets some headers, and then uses the JmsStomplet superclass to get the message 
placed onto the JMS queue as a JMS message.

<img src="/images/stomp-chat-demo/public-stomplet.png"/>

### Messages sent to `/private`

Private messages involve more JMS selector magic. We implement the entire `/private` STOMP 
destination through the `PrivateStomplet` which once again uses the `JmsStomplet` superclass 
to connect to the same `/topics/chat` JMS topic.

The `PrivateStomplet` is about as simple as the `PublicStomplet`. It is responsible for 
setting the bonafide sender header based on the authenticated username kept in the session, 
and forwards the message to the JMS topic.

<pre class="syntax ruby"># private_stomplet.rb
require 'torquebox-stomp'

class PrivateStomplet < TorqueBox::Stomp::JmsStomplet

  def initialize()
    super
    @destination = inject( '/topics/chat' )
  end

  def on_message(stomp_message, session)
    username = session[:username]
    stomp_message.headers['sender'] = username
    send_to( @destination, stomp_message )
  end

end
</pre>

# Server-to-browser

When our browser-based client connected, we set up subscriptions and handlers 
for messages on the `/public` and `/private` STOMP destinations. Now we will 
examine how messages flow to these subscriptions from the server to the browser.

## Subscriptions on the server

Just as our Stomplet's `on_message` is called when a message is destined for it, 
its `on_subscribe` method is called when a client registers an interest in a 
matching STOMP destination by creating a subscription.

Our `PublicStomplet` and `PrivateStomplet` both implement this method in order 
to connect each client with an appropriate JMS subscription.

### PublicStomplet#on_subscribe(subscriber)

<pre class="syntax ruby"># public_stomplet.rb
class PublicStomplet < TorqueBox::Stomp::JmsStomplet

  def on_subscribe(subscriber)
    username = subscriber.session[:username]
    subscribe_to( subscriber, 
                  @destination, 
                  "recipient='public'" )
    update_roster :add=>username
  end

end
</pre>

Any time a client subscribes to `/public` this method will be invoked with a unique 
subscriber matching the client. This object provides access to the session, and can 
be used to positively identify the user.

The `JmsStomplet` provides a useful method, `subscribe_to` which helps connect a 
`subscriber` to a JMS destination, with an optional JMS selector. In this case, 
the Stomplet adds a selector to ensure only messages destined for `public` are accepted.

Internally, JMS messages matching this subscription will be converted to STOMP messages 
and delivered to the subscriber.

Notice, we receive all messages sent to the `public` recipient, even those we send ourselves. 
The UI only displays messages it receives, resulting in seeing our own messages only once 
they've been received by the server and redistributed.

### PrivateStopmlet#on_subscribe(subscriber)

The PrivateStomplet is responsible for handling all subscriptions to the `/private` STOMP 
destination. As with the `/public` subscriptions, JMS selectors are used to enforce receiving 
only a specific sub-set of all messages on the underlying JMS topic.

<pre class="syntax ruby"># private_stomplet.rb
class PrivateStomplet < TorqueBox::Stomp::JmsStomplet

  def on_subscribe(subscriber)
    username = subscriber.session[:username]
    subscribe_to( subscriber, 
                  @destination, 
                  "recipient='\#{username}' OR ( sender='\#{username}' AND NOT recipient='public')" )
  end

end
</pre>

In this case, since the client only ever displays messages it receives, in order to see our 
own half of the conversation, we need a slightly more complex JMS selector.

While we definitely want to receive messages which are targetted to our confirmed username, 
we also need to receive a copy of any non-public message we send, so that it may be interleaved 
into private responses we receive from people.

# A picture

<img src="/images/stomp-chat-demo/full-topo.png"/>

# Moving along...

In the next part, we'll demonstrate how advanced data, in the form of JSON, can be used to manage 
our connect-used roster. Additionally, you'll see how other components within your application 
can originate messages destined for browser-based clients.

* [Part 3]: Originating messages from other components
