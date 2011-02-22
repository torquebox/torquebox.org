---
title: Hooking RSpec up with Arquillian via JRuby
author: Jim Crossley
layout: news
tags: [ rspec, arquillian ]
---

In the spirit of the holiday season,
[Bob](http://twitter.com/bobmcwhirter) and
[I](http://twitter.com/jcrossley3) have been opening presents and
playing with some cool toys.  And by that I mean we can now write
integration tests using Ruby ([RSpec](http://rspec.info/) and
[Capybara](https://github.com/jnicklas/capybara)) instead of Java
([JUnit](http://www.junit.org/) and
[Selenium](http://seleniumhq.org/)).  We're using some neat features
of JRuby to annotate our Ruby classes with Java annotations expected
by [Arquillian](http://www.jboss.org/arquillian).  Read on for all the
details!

The TorqueBox integration test suite continues to grow, mostly because
Arquillian makes it so easy to fire up a JBoss instance, deploy test
apps to it, and run JUnit tests against it,
[just as Bob described](/news/2010/08/30/end-to-end-testing/). But the
JUnit test cases are a tad awkward and verbose.  We'd prefer to write
our tests using Ruby!

**Instead of this...**

<script src='https://gist.github.com/748633.js'></script>

**...we want this!**

<script src='https://gist.github.com/748630.js'></script>

Getting our Maven build to run RSpec tests is
[easy enough](https://github.com/mkristian/jruby-maven-plugins), since
we're already doing that for our unit tests.  But integrating the
RSpec test lifecycle with Arquillian required a bit of helpful
guidance from [Aslak](http://twitter.com/aslakknutsen), who suggested
using the
[Arquillian JUnit extension](https://github.com/arquillian/arquillian/blob/1.0.0.Alpha4/junit/src/main/java/org/jboss/arquillian/junit/Arquillian.java)
as a model.

Essentially, we need to create a `TestRunnerAdaptor` by calling
`DeployableTestBuilder.build(configuration)` and then pass our test
classes to it via the appropriate lifecycle callbacks.  RSpec's test
lifecycle is exposed through global
[before and after blocks](http://rspec.info/documentation/before_and_after.html).
So just like in the JUnit extension, we store our TestRunnerAdaptor in
a thread-local variable before the suite is run, accessing it in each
subsequent callback.

<script src='https://gist.github.com/748607.js'></script>

So `before(:suite)` causes Arquillian to fire up a JBoss instance.
And `before(:all)` will trigger Arquillian to deploy the artifact
returned by the `:create_deployment` method of the RSpec example
class being run.

Actually, Arquillian couldn't care less that our RSpec example has a
method called `:create_deployment`.  What it really wants is a static
method returning an instance of `JavaArchive` marked with the
`@Deployment` annotation.  Plus, it wants the class itself to be
marked with the `@Run` annotation.  And it probably goes without
saying that it wants the class to be a real, honest-to-goodness Java
class!

For that, we `require 'jruby/core_ext'`.  In particular, these handy,
largely undocumented methods:

* `add_class_annotation` which takes a hash of annotation classes,
  each mapped to a hash of its attributes
* `add_method_annotation` which takes a method name in addition to the
  above hash
* `add_method_signature` which takes a method name and an array of
  parameter types, with the first one being the type returned. Without
  this, the return type will be too vague for Arquillian.
* `become_java!` which is a method JRuby puts on every Ruby class,
  allowing you to turn it into a real, honest-to-goodness Java class!

BTW, I probably should've mentioned this before, but I'm speaking of
JRuby 1.5.6 specifically.  When we first started looking at doing this
(with JRuby 1.5.3), we noticed that `become_java!` was broken with
respect to static methods.  So
[Bob fixed that](http://jira.codehaus.org/browse/JRUBY-5127).

Anyhoo, here's the implementation of our `deploy` method invoked in
each of our RSpec examples:

<script src='https://gist.github.com/748720.js'></script>

For completeness, here are the implementations of
`create_archive_for_resource` and `run_mode` but they're really just
convenience methods, and the latter only serves to trick you into
thinking we support `IN_CONTAINER` testing.  (We don't yet, but when
we do, it'll be as simple as passing `:run_mode => :container` to
`deploy`)

<script src='https://gist.github.com/748740.js'></script>

So once we hooked up RSpec, we wanted to play with
[Capybara](https://github.com/jnicklas/capybara), but since it only
supports RSpec v2, and our Maven plugin only supports RSpec v1 (which
Bob's fixing as I type this), we ended up with this in our
`spec_helper.rb`:

<script src='https://gist.github.com/748749.js'></script>

And that's pretty much where we stand at the moment.  But there are
many presents yet to be opened:

* Break out the Arquillian-RSpec integration into its own gem.
* Support RSpec v2
* Write a simple DSL for creating deployment archives
* Support Arquillian in-container testing (test injected @EJB's with
  Ruby, yay!)

Happy Holidays, everyone!
