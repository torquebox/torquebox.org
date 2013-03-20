---
title: 'STOMP Improvements'
author: Bob McWhirter
layout: news
timestamp: 2013-03-20T18:00:00.0Z
tags: [ websockets, stomp, sse, longpoll]
---

# Keeps getting better

After my last post about bringing TLS/SSL to TorqueBox's STOMP
subsystem, we decided to take it a step further.  A commenter 
asked about other technologies, mostly to support fallback for
when WebSockets either were not available in the browser, or
in the case of proxies between the client and server preventing
their effective use.

# Alternatives to WebSockets

There are a few different alternatives for browser-push:

* WebSockets
* Pseudo-WebSockets using Flash
* Server-Sent Events
* Long-Poll/Lingering-GET (Comet)

WebSockets, we've already covered.  There are libraries in 
the wild that implement the WebSocket API and network protocols
using a faceless Flash app, for browsers that might support Flash
but not WebSockets.  The one we've decided to use is 
[Gimite's web-socket-js](https://github.com/gimite/web-socket-js).
Applications designed to use WebSocket can function using either
natively-implemented WebSockets or Gimite's without modification.

Great!

But what if Flash isn't supported?  Or a proxy in the middle won't
successfully pass WebSocket packets?  

In this case, we fallback even further, to use one of two other
transports.  This is where Server-Sent-Events and Long-Poll (Comet) come
into play.  Both of these only support pushing data from the
server to the client, so we actually implement an asymetric transport,
where client-to-server uses normal AJAX POSTs, while server-to-client
uses SSE or Comet.

## Server-Sent-Events

Server-Sent-Events are a fairly nice middle-ground, but not necessarily
well-supported on every browser, especially if doing cross-origin 
requests.  Unfortunately, browsers view same-host-but-different-port
as a cross-origin request, and begin locking down security pretty hard.

For those browsers that we can convince to perform a CORS request,
notably Firefox, SSE is the first alternative after WebSockets.  The browser
initiates a connection to the server, including a header indicating it
wants server-sent-events, and the server can then stream events back to
the browser continuously, as data is made available.

Since it's purely server-to-client, the client still has to POST data
back to the server.

## Long-Poll/Lingering-GET/Comet

The oldest, and least efficient (but most-widely-viable) solution for server-push
is called Long-Poll or Lingering-GET.  For this, the client makes a GET request
to the server, and just waits for a response.  As soon as data is available,
the server sends a normal response to the seemingly normal GET request, and
ends the connection.  It's up to the client to then immediate re-establish another
GET request to the server. Each GET only receives one chunk of data from the server,
hence the reconnection and polling.

Typically the client will hang up the GET if no data has been received within a timeout
(15-30 seconds), and re-establish a new connection.

# But you don't have to care...

All of these transports are now transparent to users of the TorqueBox STOMP
stack. The Javascript client simply takes a host & a port, along with a secure
flag (indicating a desire to use SSL/TLS), and the client attempts the series
of transports until arriving at one that will work.  

# Updates to the client

Since I've been doing more work with [DynJS](http://dynjs.org/) on the side, 
I realized we were using some atypical Javascript patterns, and we've improved
the client to be more idiomatic.

Also, because the client may select various transports, it's no longer created
with a URL, but rather a hand-full of parameters to specify the host, port, and
secure flag.

<pre><code>client = new Stomp.Client('myhost.com', 8676, true);</code></pre>

Additionally, while `connect()` previously took an un-used combination of username
and password, these are now optional:

<pre><code>client.connect( null, null, function() { ... } )</code></pre>

The above can be replaced with:

<pre><code>client.connect( function() { ... } )</code></pre>

You can still provide a username and password, if for some reason you require it.
As long as the last parameter is an on-connect callback function, you're golden.

# Middleware begone

Since our STOMP server now handles a variety of protocols on the same port, 
including handling POST and GET requests for the asymetric transports, we've
moved the ability to serve the STOMP Javascript client straight to the server.

Simply ask for `/stomp.js` from the STOMP server.

<pre><code>&lt;script src="http://myserver.com:8676/stomp.js" type="text/javascript"&gt;&lt;/script&gt;</code></pre>

One benefit of using the `stomp.js` directly from the server, is that the 
client provided is pre-configured to reconnect back to the server that served
it, including matching the same TLS/SSL aspect.  

This leads to even easier client setup:

<pre><code>client = new Stomp.Client();
client.connect( function() {
  ..
} );</code></pre>

# Finding your STOMP endpoint

Within TorqueBox, we provide a way to inject (or `fetch()`) the insecure and
secure STOMP endpoints.  Previously these would return a `ws://` or `wss://` URL.
Since non-WebSocket transports might be used now, these endpoint injections return
an object which provides host and ports.

Assuming you've fetched the endpoint in an Rails helper like this:

<pre><code>def endpoint() 
  fetch( "stomp-endpoint" )
end</code></pre>

You can access its properties from your templates like this:

<pre><code>&lt;script src="http://&lt;%= endpoint.host %&gt;:&lt;%= endpoint.port %&gt;/stomp.js" type="text/javascript"&gt;</script></code></pre>

# Availability

This support is available in an incremental build of TorqueBox, and will
be included in the 3.0.0 release stream.

