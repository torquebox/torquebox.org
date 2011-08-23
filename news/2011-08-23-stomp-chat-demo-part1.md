---
title: 'STOMP Chat Demo - Part 1'
author: Bob McWhirter
layout: news
tags: [ websockets, stomp, messaging ]
---

[Part 1]: /news/2011/08/23/stomp-chat-demo-part1/
[Part 2]: /news/2011/08/23/stomp-chat-demo-part2/
[Part 3]: /news/2011/08/23/stomp-chat-demo-part3/
[STOMP]: http://stomp.github.com/stomp-specification-1.1.html
[WebSockets]: http://en.wikipedia.org/wiki/WebSocket

# Chatty Cathy

It seems every browser push solution needs to demonstrate how 
it works using a chat example. With our recent introduction of 
[STOMP]-over-[WebSockets], TorqueBox is at least as good as other solutions, 
so we also have a chat example. If you missed what all this 
STOMP-over-WebSockets stuff is about, please check out [the blog-post _WebSockets, 
STOMP & TorqueBox_][/news/2011/08/15/websockets-stomp-and-torquebox/].

The functionality presented in this demo includes:

* Public messaging to all connected parties
* Private messaging with individuals
* System-generated announcements
* Notification to the chat from the web tier

The walk-through below includes simplified example code with lots of the jQuery cruft 
removed. The full source for this demo may be found on GitHub, of course

* <http://github.com/torquebox/stomp-chat-demo>

This demonstration has been broken into 3 parts:

1. [Part 1]: Getting started, Sinatra app & Javascript client
2. [Part 2]: Sending and receiving messages
3. [Part 3]: Originating messages from other components

# Tag along!

## Deploy and Launch

If you would like to play along at home, you may clone the above repository, 
install a recent incremental build (#340 or higher), and get started.

We assume you've installed TorqueBox, set $TORQUEBOX_HOME and you've got a good 
JRuby in your path. From the demo's directory, you should run the following commands:

    demo$ jruby -S gem install bundler
    demo$ jruby -S bundle install
    demo$ jruby -S rake torquebox:deploy

And then start the application-server from the JBoss directory:

    jboss$ ./bin/standalone.sh

# Appropriate Clients

To connect to the chat server, the following browsers are known to work out-of-the-box:

* Safari on OSX an iOS
* Google Chrome 13.0.782.112
* Firefox 6

With some adjustment to enable WebSockets, which is disabled by default, Firefox 5 works well, also.

# I see what you're saying...

When a user connects, a roster of other users, along with 
entries for Everyone and System are added. The user can then 
send and receive public messages, or communicate privately with any 
other user.

Additionally, if some other web user browses to the profile page for 
any connected user, the user will be notified in real-time, demonstrating 
how components such as web-tier controllers can interact with the messaging 
system.

<img src="/images/stomp-chat-demo/chat-window.png" style="width: 550px;"/>

# Cascading destinations

From the user's point-of-view, there is an unbounded set 
of destinations: one for every other user connected for private chat. 
Plus the destination for public chat.

Implementationally, this is handled by two STOMP destinations, 
simply `/private` and `/public`.

In the end, though, all chat traffic travels over a single 
`/topics/chat` JMS topic.

<img src="/images/stomp-chat-demo/destination-mux.png" style="width: 450px;"/>

Using the Stomplet API, we are able to define a simple messaging-based 
API for a Javascript client to work with, while moving complexity to 
the server.

Before diving into how STOMP destinations connect to JMS destinations, 
let's see how STOMP messaging integrates with the web portion of your application.

# Connecting Client to Server

## Web-based Login

The user first surfs to a normal web-page to login. This example 
trusts that users only log in as themselves, and after validating their 
username, sets session[:username] in their web session, and redirects 
to a simple page which loads the Javascript-based chat UI.

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
The entire stack provides a unified view of a user's session across both STOMP 
and web component.

## Javascript Client in the Browser

The bulk of the client is written primarily as a Javascript application, using the 
STOMP-over-WebSockets Javascript client. It performs a few duties when initially 
loaded, once a user signs in and is redirected.

1. Connect to the STOMP server
2. Subscribe to `/public` with a message handler
3. Subscribe to `/private` with a message handler
4. Connection to the STOMP server in this case requires no authentication, 
   since the user already authenticated from the web portion of the application.

### Core Client

The Javascript client uses jQuery eventing in order to separate the the 
STOMP interaction from UI goodness. The core of the client handling STOMP 
interactions is reproduced below.

<pre class="syntax ruby">// chat.js
var chatView = new TorqueBox.ChatView();
chatView.initialize();

var client = Stomp.client(stomp_url);
client.connect( null, null, function() {

  $(TorqueBox.Events).bind('TorqueBox.Chat.Close', 
                            function() { client.disconnect });

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

  $(TorqueBox.Events).trigger('TorqueBox.Chat.Connect');
});

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

When loaded, the primary script connects to the STOMP server, and defines the on 
connection handler which will be called onced the STOMP client is fully connected. 
This handler sets up a few house-keeping events to handling closing the client 
down and sending new messages.

Additionally, the STOMP client is configured to subscribe to two STOMP destinations, 
`/private` and `/public` and then notify the UI view once all of this is accomplished.

1. Connection is triggered.
2. The on connection handler is fired once connected.
3. disconnect and message sending events are configured.
4. Client subscribes to `/private` STOMP destination, delegating received messages to another event-handler.
4. Client subscribes to `/public` STOMP destination, delegating received messages to another event-handler.
5. Notify the UI layer that the STOMP layer has successfully connected, subscribed, and is ready to go.

### Client UI

The primary bits of the view are defined in `chat_view.js` and involves the logistics necessary to 
maintain a panel for each chat participant. Additionally, the view keeps up with the 
currently-displayed recipient, and uses that information, along with messages typed by the user, 
to invoke our onNewMessage event-handler defined above in chat.js.

# Next...

In the next part of this series, we'll see how a Javascript-based application actually sends and receives messages.

* [Part 2]: Sending and receiving messages
