---
title: 'STOMP Chat Demo - Part 2'
author: Bob McWhirter
layout: news
tags: [ websockets, stomp, messaging ]
---

This is part 2 of a multi-part series, walking you through the
new STOMP-over-WebSockets functionality in TorqueBox.  This
is a set of technologies that enabled advanced *push* applications
over the web.

In this part, we will describe how our previous-connected client
actually sends and receives messages, and how they move around
the system.

In the first part, we showed how the Javascript client connects
and sets up some subscriptions:


<pre class="syntax javascript">// chat.js
client.connect( null, null, function() {

  $(window).unload(function() {
    client.disconnect();
  });

  $( '#connecting' ).hide();
  $( '#chat-panel' ).show();

  client.subscribe( '/private', function(message) {
    // handle private messages
  } );

  client.subscribe( '/public', function(message) {
    // handle public messages
  } );
</pre>

Now let's see what actually happens to move messages around.

# Public messages

## Client sending

To send a message publicly to everyone, when a user submits a message,
using jQuery we grab it and publish a message onto the `/public` STOMP
destination.

<pre class="syntax javascript">// chat.js

client.send( '/public', {}, $('#input').val() );
</pre>

At no point is the browser client responsible for setting the `sender`
or "from" address of the message. The client simply delivers the bare
text to the `/public` destination.

## Server-side

On the server-side, we've wired the `/public` STOMP destination
to our `PublicStomplet`.  This Stomplet handles all messages sent
by ever client, and is responsible for moving them along.  This
Stomplet enforces the `sender` of each value, to prevent anyone
else from spoofing messages from others.

The user's web-based session is available to every Stomplet, 
and it can be used to enforce identity.  It also ensures that
the `recipient` header is set to the value of `public`.

It then uses the `send_to(...)` method of `JmsStomplet` to
convert and deliver a STOMP message to a JMS destination, 
which was obtained through injection.

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

In diagram form, you can see that the `PublicStomplet`
receives STOMP messages, sets some headers, and then
uses the `JmsStomplet` superclass to get the message
placed onto the JMS queue as a JMS message.

<img src="/images/stomp-chat-demo/public-stomplet.png"/>

## Client receiving

The client, as shown above, has subscribed to the `/public` STOMP 
destination.  It has a simple handler that receives messages
and displays them in the UI appropriately.

The subscription management is also handled by our
`PublicStomplet`.  It uses the `subscribe_to(...)` 
helper method from `JmsStomplet`, subscribing the
client to the `/topics/chat` JMS destination with the
addition of a JMS selector of `recipient='public'`.
This ensures that the client only receives messages
truly destined for the public, since all messages, both
public and private, travel on the same underlying JMS
topic. The Javascript client
is never given direct control of the JMS subscription,
so our Stopmlet is allowed to mutate the inputs before
taking action.  

Additionally, we use subscriptions to `/public` to drive
our available-user roster.  And every time a user connects,
we drop a message from the `system` user to the public channel
announcing the newly-connected user.

<pre class="syntax ruby"># public_stomplet.rb

class PublicStomplet < TorqueBox::Stomp::JmsStomplet

  on_subscribe(subscriber)
    username = subscriber.session[:username]

    subscribe_to( subscriber, @destination, "recipient='public'" )
    update_roster :add=>username
    send_to( @destination, 
            "\#{username} joined", 
            :sender=>:system, 
            :recipient=>:public )
  end
end
</pre>

# Private messages

Private messages involve more JMS selector magic.  We implement
the entire `/private` STOMP destination through the `PrivateStomplet`
which once again uses the `JmsStomplet` superclass to connect to the
same `/topics/chat` JMS topic.

## Client sending

When the client wishes to send a private message to another user,
he uses the UI to select a recipient (`public` or another username).

If the recipient is not `public`, then we channel the message to the
`/private` STOMP destination, setting the `recipient` header to indicate
who should receive the message.  As with public messages, the client
is not responsible for setting the `sender` header, and is given no
opportunity to spoof arbitrary other users.

<pre class="syntax javascript">// chat.js

recipient = $( '.recipient.current' ).attr( 'recipient' );
client.send( '/private', { recipient: recipient }, $('#input').val() );
</pre>


## Server-side 

The `PrivateStomplet` is about as simple as the `PublicStomplet`.  It
is responsible for setting the bonafide `sender` header based on the
authenticated username kept in the session, and forwards the message
to the JMS topic.

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

## Client receiving

The `PrivateStomplet` is responsible for handling all subscriptions to
the `/private` STOMP destination.  As with the `/public` subscriptions,
JMS selectors are used to enforce receiving only a specific sub-set of
all messages on the underlying JMS topic.

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

In this case, we wish to receive private messages sent by others,
where `recipient='\#{username}'` would be true.  Additionally, though,
so that we can see our half of any private conversation, we wish to receive
messages sent by ourselves, which are not public.  If they are public,
our `/public` subscription will catch them.

Once again, remember the client simply subscribes to the basic STOMP
destination of `/private`, while the server-side Stomplet handles
the entirety of this complexity.

On the client-side, receiving private messages operates about the same
as receiving public messages.  The only complexity is the messages 
representing the client's half of the conversation should be matched
with the remote party's portion of the conversation in the UI.

