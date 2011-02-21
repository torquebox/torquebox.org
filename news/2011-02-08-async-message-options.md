---
title: Setting Async Message Priority & TTL in TorqueBox
author: Toby Crawley
layout: news
---


Last week we added [backgroundable methods][backgroundable], and decided to bust out
some more asynchronous goodness while we were at it by exposing asynchronous message
options.

If you are running TorqueBox [edge][repo], you can now set priority, time-to-live,
and persistence options on a per message basis:

* `:priority` - higher priority messages will be delivered before lower priority 
  messages within the context of a queue. You can specify the priority as an integer
  in the range 0..9, or as one of the following convenience symbols (with the 
  corresponding integer priorities in parentheses):
  * `:low` (1)
  * `:normal` (4) - the default 
  * `:high` (7)
  * `:critical` (9)
* `:ttl` - messages that aren't delivered within the specified timeframe are discarded.
  Specified in milliseconds. By default, messages don't have a ttl.
* `:persistent` - by default, queued messages will survive across AS restarts. If
  you don't want a message to be persistent, set the persistence to `false`.

## Usage

The options are passed as a hash to the various task helper methods (`async`, 
`always_background`, and `background`).

If you are using dedicated task classes via the `async` method or calling a 
backgroundable method via `background`, you pass the options with each invocation:

<pre lang="ruby"><code>SomeTask.async(:a_method, payload, :priority => :high)
some_object.background(:persistent => false).another_method</code></pre>

When marking a method as `always_background`able, you'll need to pass the options
to `always_background`, which will then be applied to every invocation of the
backgrounded method:

<pre lang="ruby"><code>SomeModel.always_background(:a_method, :ttl => 5000, :priority => :low)</code></pre>

Enjoy! And as always, if you have any questions, comments, or concerns, don't hesitate 
to [join our community][contact].

[backgroundable]: http://torquebox.org/news/2011/02/01/turn-any-method-into-a-task/
[repo]: https://github.com/torquebox/torquebox
[contact]: http://torquebox.org/community/
