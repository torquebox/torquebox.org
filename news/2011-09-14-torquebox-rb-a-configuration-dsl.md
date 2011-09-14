---
title: 'torquebox.rb - A Configuration DSL'
author: Toby Crawley
layout: news
timestamp: 2011-09-14t16:40:00.0-04:00
tags: [ configuration ]
---

[descriptors]: /2x/builds/LATEST/html-docs/deployment-descriptors.html
[2x-builds]: /2x/builds/
[documentation]: /2x/builds/LATEST/html-docs/
[community]: /community

TorqueBox has traditionally used a YAML configuration syntax, both for its
internal (`torquebox.yml`) and external (`*-knob.yml`) [descriptors]. 
In addition to that YAML syntax, you can now use a Ruby DSL in your internal
descriptor. To use the DSL, simply replace your `torquebox.yml` file with a 
`torquebox.rb` file.

# But what goes in that file?

The best way to see that is through an example. We'll take the following 
`torquebox.yml` and convert it into a `torquebox.rb`:

<pre class="syntax yaml">environment:
  SOME_API_USERNAME: joe
  SOME_API_PASSWORD: vagabond
  
queue:
  /queue/work:
  
messaging:
  /queue/work:
    SmallHandler:
      filter: 'size < 50'
    LargeHandler:
      filter: 'size >= 50'
      concurrency: 5
  
  /queue/managed_by_another_app: SomeHandler

jobs:
  work.notifier:
    job: WorkNotifier
    cron: '0 */5 * * * ?'
    config:
      notifier_url: http://my.notification.service.com/</pre>
      
Here is the same configuration expressed using the Ruby DSL in
torquebox.rb:

<pre class="syntax ruby">TorqueBox.configure do
  environment do 
    SOME_API_USERNAME 'joe'
    SOME_API_PASSWORD 'vagabond'
  end
  
  queue '/queue/work' do 
    processor SmallHandler, :filter => 'size < 50'
    
    processor LargeHandler do 
      filter 'size >= 50'
      concurrency 5
    end
  end
  
  queue '/queue/managed_by_another_app', :create => false do
    processor SomeHandler
  end
    
  job WorkNotifier do 
    cron '0 */5 * * * ?'
    config do 
      notifier_url 'http://my.notification.service.com/'
    end
  end
end</pre>
    
Things to note about the above example:

* Everything needs to be wrapped in the `TorqueBox.configure` block.
* In most places, the DSL is a close analog to the YAML syntax. One notable
  exception to that is with destinations and message processors: in the YAML
  syntax, the destination itself is defined in a `queues:` or `topics:` block,
  with processors wired to the destinations in a `messaging:` block.
  In the DSL, those are combined under the `queue` or `topic' definition.
* Most of the DSL directives can take their options as a hash, as method calls 
  within the block, or a combination of the two (see the queue and processor 
  definitions above).
* This obviously isn't an exhaustive example of the configuration options;
  see the [documentation] for more examples.

# Sharing configuration

Since the DSL is just Ruby, sharing configuration options between several directives
is easy, with one 'gotcha'. If you have common settings you want to share between entries 
in the configuration, you could try this, but it won't work:

<pre class="syntax ruby">TorqueBox.configure do 
  queue '/queue/my_queue' do 
    common_options = { :x => 'ex', :y => 'wye', :z => 'zee' }

    processor SomeProcessor do 
      # this won't work!
      config common_options
    end
    
    processor SomeOtherProcessor do 
      # neither will this!
      config common_options.merge!(:z => 'zed')
    end
  end
end</pre>

The DSL uses `instance_eval` to parse the configuration, which prevents variables
defined outside of a block from being seen within that block. To work around this,
the DSL supports single argument blocks. If you provide an argument for the block,
`instance_eval` is disabled, and you are passed a configuration object to use instead.
Since there is no `instance_eval`, you will need treat any DSL directives within
that block as method calls on the given configuration object.
Here is the above example again, but with a couple of changes that allow it to
work as we intend it:

<pre class="syntax ruby">TorqueBox.configure do 
  queue '/queue/my_queue' do 
    common_options = { :x => 'ex', :y => 'wye', :z => 'zee' }

    processor SomeProcessor do |proc|
      # this will work!
      proc.config common_options
    end
    
    processor SomeOtherProcessor do |proc|
      # and so will this!
      proc.config common_options.merge!(:z => 'zed')
    end
  end
end</pre>

# Current status

The DSL is available in [recent 2.x incremental builds][2x-builds] (build #425 and newer). Since
it's brand new, it may get tweaked a bit before the actual 2.0 release. The 
[documentation] has been updated throughout with DSL examples for all of the
available configuration options.

If you have any questions, comments, or feature requests in regards to the DSL, please 
[get in touch][community] - we'd love to hear from you!
