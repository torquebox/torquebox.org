---
title: 'STOMP Chat Demo - Part 1'
author: Bob McWhirter
layout: news
tags: [ websockets, stomp, messaging ]
---

[stomp-over-ws-intro]: /news/2011/08/15/websockets-stomp-and-torquebox/
[incremental-builds]: /2x/builds

# Chatty Cathy

It seems every browser *push* solution needs to demonstrate how
it works using a chat example.  With our recent introduction
of STOMP-over-WebSockets, TorqueBox is at least as good as
other solutions, so we also have a chat example.  If you missed
what all this STOMP-over-WebSockets stuff is about, please
check out the blog-post [_WebSockets, STOMP & TorqueBox_][stomp-over-ws-intro].

The functionality presented in this demo includes

* Public messaging to all connected parties
* Private messaging with individuals
* System-generated announcements
* Notification to the chat from the web tier

The walk-through below includes simplified example code
with lots of the jQuery cruft removed.  The full source
for this demo may be found on GitHub, of course

* <http://github.com/torquebox/stomp-chat-demo>

# Tag along!

## Deploy and Launch

If you would like to play along at home, you may clone
the above repository, install a recent [incremental build][incremental-builds]
(#336 or higher), and get started.

We assume you've installed TorqueBox, set $TORQUEBOX_HOME
and you've got a good JRuby in your path.  From the demo's
directory, you should run the following commands:

    demo$ jruby -S gem install bundler
    demo$ jruby -S bundle install
    demo$ jruby -S rake torquebox:deploy

And then start the application-server from the JBoss
directory:

    jboss$ ./bin/standalone.sh

## Appropriate Clients

To connect to the chat server, the following browsers are
known to work out-of-the-box:

* Safari on OSX an iOS
* Google Chrome 13.0.782.112

With some adjustment, Firefox 5 works well, also.

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

# Cascading destinations

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

Before diving into how STOMP destinations connect to JMS destinations, 
let's see how STOMP messaging integrates with the web portion of your
application.

# Connecting Client to Server

## Web-based Login

The user first surfs to a normal web-page to login.  This example trusts
that users only log in as themselves, and after validating their username,
sets `session[:username]` in their web session, and redirects to a simple
page which loads the Javascript-based chat UI.

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

By setting the `session[:username]` after our admittedly-poor authentication,
we make the user available to the message-handling components described shortly.
The entire stack provides a unified view of a user's **session** across both
STOMP and web component.

## Javascript Client in the Browser

The bulk of the client is written primarily as a Javascript application, using the
STOMP-over-WebSockets Javascript client.  It performs a few duties when
initially loaded, once a user signs in and is redirected.

1. Connect to the STOMP server
2. Subscribe to `/public` with a message handler
3. Subscribe to `/private` with a message handler

Connection to the STOMP server in this case requires **no authentication**,
since the user already authenticated from the web portion of the application.

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

In the next part of this series, we'll see how a Javascript-based
application actually sends and receives messages.
