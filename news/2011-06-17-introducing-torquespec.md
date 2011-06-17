---
title: 'Introducing TorqueSpec'
author: Jim Crossley
layout: news
tags: [ testing, rspec, torquespec, rvm, gems, tutorial ]
---

[TorqueSpec]: http://github.com/torquebox/torquespec
[Arquillian]: http://arquillian.org
[gem]:        /news/2011/06/10/torquebox-gem/
[tutorial]:   /news/2011/06/13/torquebox-a-javaists-tutorial-on-messaging-services-and-cdi-in-ruby/
[ci]:         http://en.wikipedia.org/wiki/Continuous_integration
[rvm]:        https://rvm.beginrescueend.com/
[README]:     https://github.com/torquebox/torquespec/blob/master/README.org
[RSpec]:      http://relishapp.com/rspec
[bees]:       http://www.cloudbees.com/
[Capybara]:   https://github.com/jnicklas/capybara
[Akephalos]:  https://github.com/bernerdschaefer/akephalos
[quote]:      http://twitter.com/#!/bobmcwhirter/status/79417826041004032


I think the time has come to talk of [TorqueSpec].  As its name
implies, it is the metaphorical mutant love-spawn of TorqueBox and
[RSpec].

Inspired by the most excellent Java testing tool, [Arquillian],
TorqueSpec is a handy way to perform automated
[Continuous Integration][ci] testing of your TorqueBox apps.  And
since we eat our own dogfood, of course, we use it to test TorqueBox
itself.

Rather than regurgitate here what's there, take a few minutes to read
its aptly-named [README] file on github.  Go ahead.  I'll wait.

Basically, TorqueSpec handles all the JBoss lifecycle management and
deployment.  All you have to do is tell TorqueSpec which apps to
deploy prior to running your RSpec examples and whether you want the
tests to run inside or outside of TorqueBox.  Running outside,
i.e. poking at it with HTTP, is typical for end-to-end CI tests, but
in-container testing can be very convenient at times.

As your apps evolve to take advantage of the built-in
[features provided by TorqueBox](/features), e.g. messaging,
backgrounding, jobs, daemons, etc, it becomes more important for your
automated tests to involve an actual TorqueBox instance, ideally on a
[dedicated CI server][bees], triggering end-to-end tests whenever
changes are committed.

TorqueSpec aims to make this easy and intuitive, especially if you're
already familiar with [RSpec] and [Capybara].  For example:

    it "should retrieve tweets using a Capybara DSL" do
      visit "/tweets"
      page.should have_content( "Last 20 tweets" )
      page.find("h1").text.should == "Tweets"
      page.find("table")[:class].should be_nil
    end

# Oysters for the Walrus and Carpenter

We're going to mash-up [Marek's excellent tutorial][tutorial] with
[Ben's excellent `torquebox-server` gem][gem] to demonstrate how easy
TorqueSpec is to setup and use in your own applications.

I forked Marek's demo and added a couple of spec files to it.  We'll
treat it as representative of an application you might build.  I'm
going to walk you through setting up a virgin TorqueBox workspace
using [rvm] and the pre-release gem, and then we'll clone my fork,
install its dependencies and run its tests.  We'll then look at the
tests in more detail to show what TorqueSpec can do for you.

If you've ever installed TorqueBox before, you may have these
environment variables lying around.  

- `TORQUEBOX_HOME`
- `JRUBY_HOME`
- `JBOSS_HOME`

They're no longer necessary.  Unset them before we get started,
please.

# Alright you Sinners... Swing!

I'll be using [rvm] for this, so let's first initialize a new gemset:

    $ rvm install jruby
    $ rvm gemset create torquespec
    $ rvm jruby@torquespec
    $ gem install bundler

Now I'm gonna check out my fork of Marek's demo:

    $ git clone git@github.com:jcrossley/confitura-2011-torquebox-demo.git

At this point, I should be able to `bundle install` and `rake spec`,
but due to the fact that my Gemfile depends on the 2.x
`torquebox-server` gem which hasn't been officially released yet, I
can't do that.  I must first do this:

*IMPORTANT: You can omit this step after we release 2.x*

    $ gem install torquebox-server --pre --source http://torquebox.org/2x/builds/LATEST/gem-repo/

Marek chose to divide his demo into two separate applications.  He
didn't have to -- he's just weird that way.  ;)

Regardless, we'll perform our normal routine (install deps and run
tests) in both apps.  First, the web application:

    $ cd confitura-2011-torquebox-demo/twitter
    $ bundle install
    $ rake spec

You should see JBoss start up within a few seconds, and then you'll
see a message indicating a `*-knob.yml` file being deployed.  This
might take a minute or so (Marek's app has a lot of components to
deploy) but after a bit you should see some HTML dump to stdout and 3
tests complete successfully.  We'll come back to these shortly.

And now let's test the "tweet collection service", which requires
valid Twitter credentials in order to run successfully:

    $ cd ../twitter_service
    $ bundle install
    $ USERNAME=username PASSWORD=password rspec spec

Note that the web app has a Rakefile but the service does not, and I'm
just lazy enough to not add one.

Ok, that's it.  We're done!  You installed TorqueBox.  You installed
an app.  You ran tests that deployed your *REAL APP* and then
interacted with it just like a *REAL USER* might.

Pretty sweet, right?

# Wait... What?

Here's what we did in order to make the above work... assuming it did
work for you, of course.  

To the web app in the `twitter/` directory of the demo, I did three
things:

- I added a few gems to the Gemfile
- I added a `:spec` task to the Rakefile
- I added a `spec/` directory containing a `basic_spec.rb` spec and a
  `spec_helper.rb`

Here are the gems I added:

    group :development, :test do
      gem 'torquespec', ">= 0.3.5"
      gem 'torquebox-server', "~> 2.x.incremental.00"
      gem 'capybara'
      gem 'akephalos'
    end

And here are the specs...

## twitter/spec/basic\_spec.rb

<script src='https://gist.github.com/1030828.js'></script>

A few things to note about it:

- Everything in it is vanilla RSpec except for the TorqueSpec
  value-add methods, `deploy` and `remote_describe`.
- The parameter to `deploy` is a Ruby "here document" representing a
  standard TorqueBox deployment descriptor.
- Both of the local tests do essentially the same thing, but one does
  it with the way-cool [Capybara] DSL.
- The `remote_describe` block will be run remotely, inside the
  TorqueBox runtime, therefore I can inject container-specific objects
  into my test.  This means **you can test your Java CDI components
  with RSpec!**
- The `remote_describe` block is nested within the local `describe`
  block containing the `deploy` call.  This enables us to run both
  local and remote tests on a single deployment of our app.

## twitter\_service/spec/basic\_spec.rb

<script src='https://gist.github.com/1030856.js'></script>

Some notes on it:

- The top-level group is denoted by `remote_describe` so it runs
  entirely remotely.
- Injection is fully-supported in your examples, e.g. `inject_queue`,
  as long as you `include TorqueBox::Injectors`.
- String substitution is used in the deployment descriptor to pass the
  credentials via environment variables.
- Any output, i.e. `puts "foo"`, won't display in your shell. Because
  it's running within TorqueBox, stdout/stderr is directed to the
  JBoss log file, by default.

Incidentally, to view the TorqueBox 2.x log:

    $ tail -F $(torquebox env jboss_home)/standalone/log/server.log

## Headless Rodents

In the web app, you'll also find a `spec_helper.rb` file that
integrates three very cool testing frameworks: [Capybara],
[Akephalos], and [RSpec].

<script src='https://gist.github.com/1030880.js'></script>

Though we love Capybara's DSL, we can't use its default driver
(`:rack_test`) because it doesn't support running against a remote
server.  And its `:selenium` driver is not headless, so choosing it
results in Firefox windows popping up on your desktop unannounced,
which won't work well on a CI server.

So Akephalos (get it? it's *headless*!) comes to our rescue.

Note that all of the Capybara configuration happens within a
`TorqueSpec.local` block, which means it only executes for the specs
run outside of TorqueBox.  This is because in-container tests will
load this file, too, but the capybara and akephalos gems won't
necessarily be available in the server's runtime.

# Testing From Within

We've put a lot of effort into TorqueSpec recently because everyone on
the TorqueBox team takes software testing to heart.

[Like Bob said][quote], "Projects without CI are just deceiving
themselves into thinking their code works. With CI, we *know* it's
broken."

We're hopeful that with TorqueSpec, you'll know your code is broken,
too.  ;-)

Happy Hacking!
