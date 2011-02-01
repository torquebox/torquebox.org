---
title: Turn Any Method Into A Task Inside TorqueBox
author: Toby Crawley
layout: news
---

TorqueBox already has background tasks that allow you to [define methods on a
task class that can be called asynchronously][tasks], but with the latest 
[HEAD][repo], you can now have any method on any object handled asynchronously!

To demonstrate these new task features, we're going to model an employee. An
employee has two methods that can be time consuming: `file_tps_report` (which
almost always takes a considerable amount of time) and `meet_with_the_bobs` 
(which can be quick and painless, or long and tedious, depending on the context):

<script src="https://gist.github.com/806013.js"></script>

<noscript>
    class InitechEmployee < ActiveRecord::Base
      def file_tps_report(report)
        # this always takes time...
      end

      def meet_with_the_bobs
        # some say this sometimes takes some time...
      end
      
      def is_this_good_for_the_company?
        false
      end
    end
</noscript>

Since we're using this model in a web based app, requests using these methods
block until they return, and you're hearing about how slow the app is from
five different managers. We know that `file_tps_report` should always be 
processed as a background task, so let's add that:

<script src="https://gist.github.com/806012.js"></script>

<noscript>
    class InitechEmployee < ActiveRecord::Base
      include TorqueBox::Messaging::Backgroundable
      
      def file_tps_report(report)
        # this always takes time...
      end
      always_background :file_tps_report
      
      def meet_with_the_bobs
        # some say this sometimes takes some time...
      end
      
      def is_this_good_for_the_company?
        false
      end
    end
</noscript>

There are two important lines in the code above. The first is the `include` 
call to add the `TorqueBox::Messaging::Backgroundable` methods to the class. The second
is the `always_background` call - this marks the `file_tps_report` method to *always* 
be executed in the background. Now, any time `file_tps_report` is called on an 
`InitechEmployee` object, it will happen asynchronously, returning immediately to the
caller.

But what about `meet_with_the_bobs`? Sometimes we know it will take a long time, but 
other times we know it will be a quick meeting, or need to wait for it to finish before
asking security to escort the employee from the building. the `Backgroundable` module
gives us another method to help in this situation - `background`. Let's look at some 
interactions with an employee to see it in action:

<script src="https://gist.github.com/806009.js"></script>

<noscript>
    peter = InitechEmployee.find(id)
    
    # returns immediately and executes in the background
    peter.file_tps_report(report)
    
    # executes in the foreground (this thread)
    peter.meet_with_the_bobs
    
    # returns immediately and executes in the background
    peter.background.meet_with_the_bobs
</noscript>

The `background` method allows you to push any instance method to the background, and have 
it processed asynchronously. Here we see `meet_with_the_bobs` called both synchronously and
asynchronously. This allows us to have our monthly company birthday celebration cake, 
and eat it too! 

## What's going on behind the scenes?

Here's how this works under the hood:

* When your app starts up, TorqueBox creates a HornetQ queue for all `Backgroundable` task messages, and 
  registers a ruby message processor to handle messages from that queue.
* When you background a method call (either using `always_background` or calling
  `background`), TorqueBox serializes the receiver and the method arguments (if any), and puts them
  on to the queue along with the method name.
* The message processor then pops the message from the queue, deserializes the receiver and arguments,
  and calls the method on the receiver.

## Setting up your app to use this goodness

* You'll need to load the `org.torquebox.torquebox-messaging-client` gem in your app's environment. 
  If you use the latest [rails template][template] from TorqueBox, you'll get that for free.
* The [rails template][template] also creates an initializer to include `Backgroundable` in all
  of your `ActiveRecord` classes:
  
<script src="https://gist.github.com/806005.js"></script>

<noscript>
    if defined?(TorqueBox::Messaging) && defined?(ActiveRecord::Base)
      require 'torquebox/messaging/backgroundable'
      ActiveRecord::Base.send(:include, TorqueBox::Messaging::Backgroundable)
    end
</noscript>

`Backgroundable` isn't just for `ActiveRecord` classes - you can use it in almost any ruby class.
To use it in any other class, you'll need to include `TorqueBox::Messaging::Backgroundable`
manually, as we did in the `InitechEmployee` example.

## Caveats

* This is brand new, so it's probably still rough around the edges.
* The queue will be created for every app you deploy to TorqueBox, even if that app does not use 
  any embedded tasks. 
* There is only one message processor, so the queue can back up with higher loads.
* We serialize the receiver and arguments using [Marshal][marshal], which works well for
  `ActiveRecord` objects and basic ruby objects. It may not work as well for objects that expect
  a lot of plumbing in place (`ActionController`s, for example - but if you have a method on a 
  controller that you want to execute asynchronously, you have bigger problems). 
  
We plan to add a section to the task [docs][tasks] covering these features in the near future,
and add configuration options to control the concurrency of the message processor, or to turn
off the embedded task queue if you don't need it.

## How does this compare to the existing (app/tasks/) task system?

* With `Backgroundable`, you keep all of the domain logic for the task in the model instead of
  splitting it with the task class.
* If you `always_background` a method, you don't have to think about whether it is async or not on 
  every call.
* With `Backgroundable`, you currently only have one queue and one processor handling all of the 
  requests, which may become a bottleneck. In comparison, each dedicated task class has it's own queue and
  processor.
  
If you have any questions, comments, or concerns, don't hesitate to [join our community][contact].

[tasks]: http://torquebox.org/documentation/current/messaging.html#async-tasks
[repo]: https://github.com/torquebox/torquebox
[template]: https://github.com/torquebox/torquebox/blob/master/system/rake-support/share/rails-template.rb
[marshal]: http://www.ruby-doc.org/core/classes/Marshal.html
[contact]: http://torquebox.org/community/
