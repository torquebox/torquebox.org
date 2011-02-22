---
title: RubyGems.org Maven Proxy
author: Bob McWhirter
layout: news
tags: [ rubygems, maven ]
---

Work is well underway towards 1.0.0.Beta21, including adjustments
in how we use Maven to interact with Rubygem dependencies.

In previous versions, we'd used [mkristian's extensions](http://github.com/mkristian/jruby-maven-plugins) to Maven
to allow it to treat rubygems.org as a normal Maven repository
with a custom layout.

That failed to some extent, in handling missing dependencies
and for synthesizing POMs from the gemspecs.

Now, though, we're using mkristian's gem-proxy, running at
*http://rubygems-proxy.torquebox.org/*.  It's not pretty at the moment,
but for any gem hosted at rubygems.org, you can fetch back
a Maven POM.

Like a [POM for Rails 2.3.8](http://rubygems-proxy.torquebox.org/releases/rubygems/rails/2.3.8/rails-2.3.8.pom).

Additionally, we've improved the RSpec plugin to make it easier
to run single rspecs from the command-line against your JRuby projects.
