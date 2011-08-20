---
title: 'STOMP (and WebSockets) chat demo'
author: Bob McWhirter
layout: news
tags: [ websockets, stomp, messaging ]
---

# Chatty Cathy

It seems every browser *push* solution needs to demonstrate how
it works using a chat example.  TorqueBox is at least as good as
other solutions, so we also have a chat example.

The functionality presented in our demo includes

* Public messaging to all connected parties
* Private messaging with individuals
* System-generated announcements
* Notification to the chat from the web tier

The walk-through below includes simplified example code
with lots of the jQuery cruft removed.  The full source
for this demo may be found on GitHub, of course

* <http://github.com/torquebox/stomp-chat-demo>

# I see what you're saying...

<img src="/images/stomp-chat-demo/marvin.png" style="width: 550px;"/>

When a user connects, a roster of other users, along with entries
for **Everyone** and **System** are added.  The user can then send
and receive public messages, or communicate privately with any 
other user.

Additionally, if some other web user browses to the **profile page**
for any connected user, the user will be notified in real-time,
demonstrating how components such as web-tier controllers can
interact with the messaging system.

# Destination multiplexing

From the user's point-of-view, there is an unbounded set of destinations:
one for every other user connected for private chat.  Plus the destination for 
public chat.

Implementationlly, this is handled by two STOMP destinations, simply
`/private' and `/public`.

In the end, though, all chat traffic travels over a single `/topics/chat`
JMS topic.

<img src="/images/stomp-chat-demo/destination-mux.png" style="width: 550px;"/>

Using the Stomplet API, we are able to define a simple messaging-based API
for a Javascript client to work with, while moving complexity to the server.

# Connecting

## Web-based login and Sinatra server

The user first surfs to a normal web-page to login.  This example trusts
that users only log in as themselves, and after validating their username,
sets `session[:username]` in their web session, and redirects to the 
Javascript-based chat UI.

The server is written as a simple Sinatra application:

<pre class="syntax ruby"># chat_demo.rb

require 'sinatra/base'

class ChatDemo < Sinatra::Base
  get '/' do
    haml :login
  end
  
  post '/' do
    username = params[:username]
    redirect to( '/' ) and return if username.nil?
    username.strip!
    redirect to( '/' ) and return if ( ! ( username =~ /^[a-zA-Z0-9_]+$/ ) )
  
    session[:username] = username
    haml :chat 
  end
end
</pre>

The bulk of the client is written primarily as a Javascript application, using the
STOMP-over-WebSockets Javascript client.  It performs a few duties when
initially loaded, once a user signs in and is redirected.

1. Connect to the STOMP server
2. Subscribe to `/public` with a message handler
3. Subscribe to `/private` with a message handler

## STOMP connection

When the Javascript client has loaded, the chat-demo application
initializes a new client and connects it.  It binds to the
unload of the window in an attempt to cleanly shutdown when
a user wanders off, if possible.

The client also involves a little jQuery to display a "connecting..."
notice, and to change to the chat interface upon successful connection.

<pre class="syntax javascript">// chat.js

client = Stomp.client( stomp_url );

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
} );
</pre>

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

# Roster Roosters

During the above discussion of `PublicStomplet`, we glossed over the
`update_roster(...)` call.  The `PublicStomplet` maintains a list of
all usernames currently connected.  Every time a new user connects or
an existing user disconnects, the Stomplet sends the current roster
of currently-connected users to every client on the `/public` channel.

To differentiate roster messages from normal text messages, the 
roster updates are sent with header named `roster` with the value 
of `true`.  The client-side Javascript processes the body of
roster messages as JSON containing the list of user, and updates 
the UI accordingly.
    
<pre class="syntax ruby"># public_stomplet.rb

require 'json'

class PublicStomplet < JmsStomplet 

  def update_roster(changes={})
    @lock.synchronize do
      [ (changes[:remove] || []) ].flatten.each do |username|
        @roster.delete_at(@roster.index(username) || @roster.length)
      end
      [ (changes[:add] || []) ].flatten.each do |username|
        @roster << username
      end

      send_to( @destination, 
               @roster.uniq.to_json, 
               :sender=>:system, 
               :recipient=>:public, 
               :roster=>true )
    end
  end

end
</pre>

A lot of the punctuation above is simply to allow `update_roster()`
to take one-or-more usernames to `:add` or `:remove`. Since clients
may be connecting at arbitrary times, the `on_subscribe` and `on_unsubscribe`
methods need to be thread-safe.  We wrap our roster-management code
in a mutex block to ensure we're not having threads trampling each other.

## I've got you listed twice

Due to the nature of JMS topics, the chat application allows any user
to be connected multiple times, and receive the same messages through
all clients.  This even operates as expected for private messages 
between two parties.  Each half of the conversation will appear at all
clients connected with the same username.

The roster-management allows for multiple subscriptions, and requires
all of a user's subscriptions to be cancelled before completely removing
the user from the roster.

# King of the wild web tier

So far this example has demonstrated primarily round-trips from
one browser to another, through the magic of STOMP.

But sometimes the web tier (or other component) would like to initiate a 
message to a party connected over STOMP.

In our case, if a user named **'jim'** is connected to the chat application,
any time a web visitor hits the URL of `/profile/jim`, we want Jim to
be notified, privately, in real-time.  To accomplish this, we have 
the `system` user send him a private message from the Sinatra controller
for that URL.  And of course we display the profile to the web user
who has no idea he just alerted the authorities of his presence.

<pre class="syntax ruby"># chat_demo.rb

class ChatDemo < Sinatra::Base

  get '/profile/:username' do
    username = params[:username]
    message = "\#{username}, someone from \#{env['REMOTE_ADDR']} checked out your profile"
    inject( '/topics/chat' ).publish( message, 
                                      :properties=>{ 
                                        :recipient=>username, 
                                        :sender=>'system' 
                                       } )
    haml :profile
  end

end
</pre>

