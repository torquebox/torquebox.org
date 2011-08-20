---
title: 'STOMP Chat Demo - Part 3'
author: Bob McWhirter
layout: news
tags: [ websockets, stomp, messaging ]
---

This is part 3 of a multi-part series describing how to use
the new STOMP-over-WebSockets features of TorqueBox.

* Part 1
* Part 2

In the previous parts, we examined how a browser can send messages
which ultimately are received by other browsers.  But there are times
when you may wish non-browsers to be the originator or consumers
of messages.

# Roster Roosters

During the previous discussion of `PublicStomplet` in [part 2], we glossed over the
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
        send_to( @destination, 
                 "#{username} parted", 
                 :sender=>:system
                 :recipient=>:public )
      end
      [ (changes[:add] || []) ].flatten.each do |username|
        @roster << username
        send_to( @destination, 
                 "#{username} joined", 
                 :sender=>:system
                 :recipient=>:public )
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

Beyond that, though, for every user added to the roster, the
system originates a message announcing the user who joined.  Likewise,
the system originates a message annoucing each departure.

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

If your STOMP endpoints ultimately connect to JMS, other non-STOMP
components can simply interact with messaging like normal.
