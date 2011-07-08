---
title: 'The Future Is Now For Async Processing in TorqueBox'
author: Toby Crawley
layout: news
timestamp: 2011-07-08t10:00:00.0-04:00
tags: [async, backgroundable, futures, tasks]
---

[Wikipedia]: http://en.wikipedia.org/wiki/Futures_and_promises
[documentation]: http://torquebox.org/documentation/LATEST/messaging.html#messaging-futures
[FutureResponder]: http://torquebox.org/2x/builds/LATEST/yardocs/TorqueBox/Messaging/FutureResponder.html
[FutureResult]: http://torquebox.org/2x/builds/LATEST/yardocs/TorqueBox/Messaging/FutureResult.html
[Backgroundable methods]: http://torquebox.org/documentation/LATEST/messaging.html#backgroundable
[Async Tasks]: http://torquebox.org/documentation/LATEST/messaging.html#async-tasks
[CI]: https://torquebox.ci.cloudbees.com/
[1.x]: /1x/builds/
[2.x]: /2x/builds/


Have you ever wanted to see into the future? Well, now you can! Calls to [Backgroundable methods]
or [Async Tasks] in TorqueBox now return **Futures** that let you monitor the progress of 
the asynchronous task.

# What the heck is a Future object?

I'm glad you asked! A Future is a proxy that provides a channel for communicating the 
progress and results of an asynchronous operation back to the caller. If you aren't familiar
with the concept, there is a nice dry overview on [Wikipedia].

Within TorqueBox, a Future allows you to see when an asynchronous task has started, completed, or 
raised an error. You can also access the return value of the task, and get periodic status 
updates from the task if the task is so configured. Some implementations of Futures
allow you to cancel the running task from the Future itself, but the TorqueBox implementation
is currently just one-way: data only flows from the task to the Future.

# Example Usage

For our examples, we'll model the family car of the future: The Aero Car! We're using 
[Backgroundable methods] in our example, but Futures work in the exact same manner with 
[Async Tasks].

<img src="/images/futures/jetsons.jpg"/>

<pre class="syntax ruby">class AeroCar
  include TorqueBox::Messaging::Backgroundable
  
  always_background :recharge_battery, :auto_fly
   
  def recharge_battery
    until battery.fully_charged? 
      battery.charge_some 
    end
  end
    
  def auto_fly(to_location)
    flight_time = auto_pilot.fly_to( to_location )
    flight_time
  end
  ...
end</pre>

## Checking the state of the task

Let's take a look at how you can use a Future to see the state of the asynchronous task:

<pre class="syntax ruby">future = @aerocar.auto_fly( :home )

# check to see if the task has started
future.started?

# check to see if the task completed
future.complete?

# check to see if an error occurred 
future.error?</pre>

**Note:** In all of these examples, we access the Future immediately, but you could easily
stash it (in a session, for example) and access it later. In fact, it is probably much more
useful when used in that fashion.

## Accessing the result of the task

In addition to checking the state of the task, we can also access the result (return value) 
from the task:

<pre class="syntax ruby">future = @aerocar.auto_fly( :home )

# this will block until:
# * the task completes
# * the task generates an error
# * a timeout of 30s expires
puts "flying home took " + future.result

# you can also specify your own timeout (in ms)
puts "flying home took " + future.result( 60_000 )</pre>

A Future also implements a `method_missing` that delegates to the result, blocking 
with the same rules above using the default timeout.

## Handling an error from the task

If an error occurs in the remote task, it will be available on the Future:

<pre class="syntax ruby">future = @aerocar.auto_fly( :home )

if future.error?
  puts "something went wrong: " + future.error
end</pre>  

This error will also contain the full backtrace from the task, making debugging a bit easier.

## Status

An asynchronous task can optionally report its status via its Future, which can be useful
for tasks that take a considerable amount of time to complete. Our `recharge_battery` 
method is a good candidate for that, since it runs in a loop. First, we'll need to modify the
task method a bit to report its status:

<pre class="syntax ruby">def recharge_battery
  until battery.fully_charged?
    battery.charge_some 
    future.status = battery.current_charge
  end
end</pre>

The only real change we made was to add a call to **`future.status=`**. The `future.status=` 
call queues up the statuses that you give it, so you can call it as many times as you want.
To access those statuses from the Future, simply call its `status` method:

<pre class="syntax ruby">future = @aerocar.recharge_battery

# each call pops the next status off of the queue, and 
# returns the most recent status if no new status messages
# have been received
puts future.status
puts future.status
puts future.status</pre>

The status you pass back can be any marshalable ruby object.

# The behind the scenes tour

Under the hood, tasks use a HornetQ queue to communicate with the Future object. The messages
sent to the Future have a time-to-live of 1 hour set on them so they won't hang around forever if you
never have the Future retrieve them. The message types (:started, :status, :error, :result) have
different priorities, so the Future will see the most important message first. If an error 
occurred, you'll want to see that instead of any status messages that may have queued up.

# Availability

Futures are available now in the latest [incremental][CI] builds for the [1.x] and [2.x] branches. Give it a try,
and feel free to [get in touch](/community) if you have any questions or issues. 

# Resources

* The official TorqueBox [documentation] on Futures
* The RDocs for [FutureResult] and [FutureResponder]
