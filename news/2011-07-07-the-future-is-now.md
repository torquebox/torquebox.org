---
title: 'The Future Is Now For Async Processing in TorqueBox'
author: Toby Crawley
layout: news
timestamp: 2011-07-07t13:45:00.0-04:00
tags: [async, backgroundable, futures, tasks]
---

[Wikipedia]: http://en.wikipedia.org/wiki/Futures_and_promises
[documentation]: http://torquebox.org/documentation/LATEST/messaging.html#messaging-futures
[rdocs]: http://torquebox.org/2x/builds/LATEST/yardocs/TorqueBox/Messaging/FutureResult.html
[Backgroundable methods]: http://torquebox.org/documentation/LATEST/messaging.html#backgroundable
[Async Tasks]: http://torquebox.org/documentation/LATEST/messaging.html#async-tasks
[CI]: https://torquebox.ci.cloudbees.com/
[1.x]: /1x/builds/
[2.x]: /2x/builds/


Have you ever wanted to see into the future? Well, now you can! Calls to [Backgroundable methods]
or [Async Tasks] in TorqueBox now return 'future' objects that let you monitor the progress of 
the asynchronous task.

# What the heck is a 'future' object?

I'm glad you asked! A 'future' object is a proxy that provides a channel for communicating the 
progress and results of an asynchronous operation back to the caller. If you aren't familiar
with the concept, there is a nice dry overview on [Wikipedia].

Within TorqueBox, a future allows you see when an asynchronous task has started, completed, or 
raised an error. You can also access the return value of the task, and get periodic status 
updates from the task (if you configure the task to send updates). Some implementations of futures
allow you to cancel the running task from the 'client' side, but the TorqueBox implementation
is currently just one-way: data only flows from the task to the future.

# Example Usage

For our examples, we'll model the family car of the future: The Aero Car!

<img src="/images/futures/jetsons.jpg"/>

<pre class="syntax ruby">class AeroCar
  include TorqueBox::Messaging::Backgroundable
  
  always_background :recharge_battery, :auto_fly
  
  def recharge_battery
    until battery.fully_charged?
      battery.charge_some
      TorqueBox::Messaging::FutureResponder.status = battery.charge_percentage
    end
  end
    
  def auto_fly(to_location)
    flight_time = auto_pilot.fly_to( to_location )
    flight_time
  end
  ...
end</pre>

## Waiting for the task to complete

The rest of the examples are snippets from the API we can use to control our AeroCar 
(this is the future, where everything has an API!).

<pre class="syntax ruby">post '/fly_home' do
  session[:fly_home_future] ||= @aerocar.auto_fly( :home )
end

get '/flying_home' do
  flying = session[:fly_home_future] && 
             session[:fly_home_future].started? && 
             !session[:fly_home_future].complete?
  { :flying_home => flying }.to_json
end

get '/fly_home_flight_time' do
  future = session[:fly_home_future]
  flight_time = nil
  flight_time = future.result if future && future.complete?
  { :flight_time => flight_time }.to_json
end</pre>

in our `/fly_home` action, we tell the AeroCar to do exactly that, and get a future object 
returned to us, since `auto_fly` is tagged to always execute in the background. We then store
the returned future in the session (poorly, I might add, but you get the idea). We can then 
see if that task is in progress via the `/flying_home` action. Since our `auto_fly` method 
returns the flight time, we expose that in the API as well via `/fly_home_flight_time`.

## Status

An asynchronous task can optionally report its status via its future, which can be useful
for tasks that take a considerable amount of time to complete. To do so, simply assign a
value to `TorqueBox::Messaging::FutureResponder.status`, as in the `recharge_battery` method
above in the `AeroCar` class. Let's use that status in our API:

<pre class="syntax ruby">post '/recharge_battery' do
  session[:recharge_battery_future] = @aerocar.recharge_battery
end

get '/recharge_status' do
  future = session[:fly_home_future]
  status = nil
  status = future.status if future
  { :status => status }.to_json
end</pre>

Now any call to the `/recharge_status` action will return the current charge percentage
of the battery. But what happens if an error occurs during the asynchronous task? Let's modify
`/recharge_status` to account for that:

<pre class="syntax ruby">get '/recharge_status' do
  future = session[:fly_home_future]
  if future.error?
    status 500 
    header "error" => future.error.to_json
  else
    status = nil
    status = future.status if future
    { :status => status }.to_json
  end
end</pre>

This is just a sample of the methods available on a future. You can read more about them in
the TorqueBox [documentation] and [rdocs].

We used [Backgroundable methods] in our examples, but futures work in the same manner with 
[Async Tasks] (as I mentioned earlier).

# Availability

Futures are available now in the latest [incremental][CI] builds for the [1.x] and [2.x] branches. Give it a try,
and feel free to [get in touch](/community) if you have any questions or issues. 

