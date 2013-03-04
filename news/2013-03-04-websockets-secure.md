---
title: 'WebSockets: Secure!'
author: Bob McWhirter
layout: news
timestamp: 2012-09-07T18:00:00.0Z
tags: [ websockets, stomp, ssl, tls ]
---

TorqueBox has supported STOMP-over-WebSockets for quite a while, now, but
due to popular request, we've taken it one step further and added support
for SSL/TLS.  Now you can connect using your WebSocket client
using the `wss://` scheme to enable encryption.

# Configuring for SSL traffic

Since WebSockets are closely aligned with normal HTTP traffic, the secure
WebSocket channel piggy-backs on the web container's SSL configuration.
The [JBoss-AS documentation](http://docs.jboss.org/jbossweb/7.0.x/ssl-howto.html) 
goes into greater detail, but the bottom-line
is that you need to edit `standalone.xml` (or whichever configuration you're
using) to setup an additional connector

<pre class="xml"><code>&lt;subsystem xmlns='urn:jboss:domain:web:1.4' default-virtual-server='default-host' native='false'&gt;
  &lt;connector name="https" protocol="HTTP/1.1" scheme="https" socket-binding="https" secure="true"&gt;
    &lt;ssl password="password" certificate-key-file="${jboss.home.dir}/keystore.jks"/&gt;
  &lt;/connector&gt;
  ...
&lt;/subsystem&gt;
</code></pre>

The main component is adding a `<connector>` with the `scheme` of
`https`, the `secure` set to `true`, and the `socket-binding` set to
`https`.  The `https` socket-binding uses port 8443 by default for web
SSL traffic.

Additionally, a nested `<ssl>` element is required to provide enough information
for it to be able to find and unlock your SSL certificate, particularly the
`certificate-key-file` and `password` attributes.

## Additional WebSocket connector

While un-encrypted WebSocket traffic travels on port 8675 by default, if SSL
is enabled on the web-server, an additional WebSocket port is opened on port 8676.
Since SSL is encrypted from the first packet, we cannot pass both secure and non-secure
traffic on the same port.  Hence the additional port.

## Finding the end-point

TorqueBox has allowed you to inject the WebSocket/STOMP endpoint using the `fetch()`
injection method. 

<pre><code>fetch( 'stomp-endpoint' )</code></pre>

To access the URL for the secure endpoint, simply inject:

<pre><code>fetch( 'stomp-endpoint-secure' )</code></pre>

# Using self-signed keys

In the event you do not yet have a CA-issued SSL certifcate, the Java `keytool`
provides an easy way to create a new keystore containing a newly-generated
self-signed certificate
<pre><code>keytool -genkey -keyalg RSA \
  -alias selfsigned -keystore keystore.jks \
  -storepass password \
  -validity 3600 \
  -keysize 2048</code></pre>

## A note on using self-signed certifcates

By default, browsers only trust certificates that are ultimately issued by
a trusted CA. A human is given a chance to review and accept any certifcate 
that is not trusted by default when you land on an SSL-encrypted page.  Most
browsers display a scary warning, and allow you to examine the certificate details
before making a trust decision.

With a WebSocket connection, the browser does *not* present an opportunity to 
review and accept an untrusted certificate.  But the WebSocket will trust any certificate
that has already been accepted as trustworthy.

This is a long-winded way of saying that to use a self-signed certificate, 
it's best to initiate your `wss://` connection from a page served over SSL
in the first place.  This allows you to present the user with the opportunity
to accept the certificate, and then the subsequent WebSocket connection will
succeed.

# Not just WebSockets

As with the non-secure STOMP endpoint, the secure port can accept connections
from both STOMP-over-WebSockets clients and pure STOMP clients.  To use a
pure STOMP client (such as the Stilts clients) with the secure port, simply pass
in a correctly-configured `SSLContext` which is backed by your trust-manager.  In 
most cases, the trust-manager should be configured to trust the same keystore 
(and certificate) that the server is using.

The Java code to setup and use a `SSLContext` looks roughly like this:

<pre><code>KeyStore keyStore = KeyStore.getInstance( "JKS" );
InputStream stream = fetchTheStreamToTheKeystoreFile();
keyStore.load( stream, "password".toCharArray() );

TrustManagerFactory tmf = TrustManagerFactory.getInstance("SunX509" );

tmf.init( keyStore );

SSLContext sslContext = SSLContext.getInstance("TLS");
sslContext.init(null, tmf.getTrustManagers(), null);

StompClient client = new StompClient( "stomp+ssl://localhost:8676/", sslContext );</code></pre>

Notice that pure STOMP-over-SSL uses the `stomp+ssl://` scheme in the URL. 

