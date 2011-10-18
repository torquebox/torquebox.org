---
title: 'Pluggable Message Encoding in TorqueBox 2.x'
author: Toby Crawley
layout: news
timestamp: 2011-10-18t09:00:00.0-04:00
tags: [messaging, interop]
---

The latest [incremental builds] of TorqueBox (build 535 and newer) support 
pluggable message encoding. This paves the way for interoperability via messaging with applications 
written in languages other than Ruby. In the process, we also replaced the default message encoding
scheme with one that is considerably faster, and made it easy for you to create your own encodings.

# What do we mean by 'message encoding'?

<img src="/images/enigma.jpg" alt="[Enigma Machine]" class="alignright bordered"/>

To send data via JMS messages, we need to convert Ruby object trees into serial streams of data.
If the object tree in question is simply a Ruby string, that's easy - we can just send the string
itself. But with anything more complicated than that, we need to serialize. That's where the 
encodings come in to play - each one is a different way to serialize/deserialize (encode/decode)
an object tree.

# Available Encodings

TorqueBox includes four built-in message encodings:

* *:marshal* - The message is encoded/decoded via Marshal, and is transmitted as a binary message 
  (via a [javax.jms.BytesMessage]). This is the default encoding.
* *:marshal_base64* - The message in encoded/decoded via Marshal,
  and is transmitted as a base64 encoded text message (via a [javax.jms.TextMessage]). This was the 
  encoding scheme used in TorqueBox 1.x, and is considerably slower than *:marshal*. You would
  only want to use this encoding if you need interoperability with TorqueBox 1.x consumers.
* *:json* - The message in encoded/decoded via JSON, and is transmitted as a text message 
  (via a [javax.jms.TextMessage]). This encoding is intended to provide interoperability
  with other languages, and won't support the simple and painless serialization you get
  with *:marshal*. Any binary data will need to be base64 encoded to a string before
  publishing, and generally only primitive types should be used. This will work
  well with *:json*:
  <pre class="syntax ruby">{ 'name' => 'Alan Turing', 'birthdate' => '1912-06-23' }</pre>
  This, however, may not:
  <pre class="syntax ruby">{ 'cipher_machine' => Enigma.new, 'timestamp' => Time.now }</pre>
  
  Any application that uses the *:json* encoding will need
  to provide the json gem via its Gemfile, or, if you are not using Bundler, 
  the json gem must at least be installed. We can't ship our own json gem
  without it potentially colliding with yours.
* *:text* - No encoding/decoding occurs, and the message is passed straight through as text
  (via a [javax.jms.TextMessage]). The content of the message must be a string. This
  is useful for passing messages you can guarantee will always be strings, or you
  are doing your own application level encoding/decoding.

# Using an encoding
        
You can specify the encoding on a per-publish basis, or set the default encoding 
globally for the app in the deployment descriptor.

When specified on the publish call, you use the *:encoding* option:
<pre class="syntax ruby">some_queue.publish(my_message, :encoding => :json)</pre>

If no encoding is specified with the publish options, the default is used.

You can override the default encoding (*:marshal*) in your deployment descriptor. This
default will be used for any of your publish calls if no encoding is specified at call time.
This change will not affect any messages used by TorqueBox internally (to implement 
[Backgroundable] for example).

To override using the YAML syntax:
<pre class="syntax yaml">application:
  ...
messaging:
  default_message_encoding: json</pre>
  
  
Or via the DSL:
<pre class="syntax ruby">TorqueBox.configure do
  ...
  options_for :messaging, :default_message_encoding => :json
end</pre>

# Creating your own encoding

Creating your own encoding is simple and straightforward. To do so, 
just create a subclass _TorqueBox::Messaging::Message_ that provides
*encode* and *decode* methods, along with *ENCODING* and 
*JMS_TYPE* constants. 

Here is a simple annotated example of a custom YAML encoding:

<pre class="syntax ruby">require 'yaml'

module MyModule
  class YAMLMessage < TorqueBox::Messaging::Message
    # a unique name for the encoding, stored with a published 
    # message so it can be properly decoded
    ENCODING = :yaml 

    # can also be :bytes for a binary message
    JMS_TYPE = :text 

    def encode(message)
      # @jms_message is the actual javax.jms.TextMessage
      @jms_message.text = YAML::dump(message) unless message.nil?
    end

    def decode
      YAML::load(@jms_message.text) unless @jms_message.text.nil?
    end
  end

  # this will register the class under the key given by its ENCODING
  TorqueBox::Messaging::Message.register_encoding(YAMLMessage)
end</pre>

Using your new encoding:

<pre class="syntax ruby">#you'll need to require your encoding class anywhere you publish/receive 
require 'yaml_message'

data = [1, 2, 3]
some_queue.publish(data, :encoding => :yaml)
puts some_queue.receive # [1, 2, 3]</pre>

For additional encoding class examples, see the message classes defined in the 
TorqueBox source: [JSONMessage], [TextMessage], [MarshalMessage], and [MarshalBase64Message].

# Resources

The [messaging docs] cover this in about the same detail as this post. If you have any 
questions/issues [get in touch]!

*Image credit: [ENIGMA machine, by Erik Pitti][image]*


[incremental builds]: http://torquebox.org/2x/builds/
[javax.jms.BytesMessage]: http://download.oracle.com/javaee/6/api/javax/jms/BytesMessage.html
[javax.jms.TextMessage]: http://download.oracle.com/javaee/6/api/javax/jms/TextMessage.html
[Backgroundable]: http://torquebox.org/2x/builds/LATEST/html-docs/messaging.html#backgroundable
[JSONMessage]: https://github.com/torquebox/torquebox/blob/2x-dev/gems/messaging/lib/torquebox/messaging/json_message.rb
[TextMessage]: https://github.com/torquebox/torquebox/blob/2x-dev/gems/messaging/lib/torquebox/messaging/text_message.rb
[MarshalMessage]: https://github.com/torquebox/torquebox/blob/2x-dev/gems/messaging/lib/torquebox/messaging/marshal_message.rb
[MarshalBase64Message]: https://github.com/torquebox/torquebox/blob/2x-dev/gems/messaging/lib/torquebox/messaging/marshal_base64_message.rb
[messaging docs]: http://torquebox.org/2x/builds/LATEST/html-docs/messaging.html
[image]: http://www.flickr.com/photos/epitti/2585357353/in/photostream/
[get in touch]: /community
