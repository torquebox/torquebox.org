---
title: FAQ 
layout: faq
toc: true
---

#{page.table_of_contents}

# Basics

## What is TorqueBox?

TorqueBox is a small adaptation layer on top of JBoss's Java application server, [JBoss AS](http://jboss.org/jbossas/).

TorqueBox goes beyond providing web-centric services (supporting Rails, Rack, Sinatra, etc),
to also expose other enterprise-grade services to Ruby applications.

## If it's a small layer, why is it a large download?

One goal of the TorqueBox distribution is a simplified end-user experience. 
To accomplish this, the distribution includes a pre-integrated combination
of the TorqueBox code, the base JBoss AS application server, and the full
JRuby distribution, plus some useful gems such as Rails, Rack and Sinatra.

The result is a #{site.releases.first.dist_size}mb distribution with everything you need (except for a JDK)
right in the tin.

**Note**: The next release of TorqueBox will be *much* smaller, as we will 
no longer distribute Rack, Rails, and other gems.  You can simply grab them
from RubyGems, of course.

## Will TorqueBox ever support Clojure, Python, Scala, Groovy, etc?

Great question! The team is hard at work developing
[Immutant](http://www.immutant.org), which brings the same
enterprise-grade services found in TorqueBox to the world of Clojure,
even to the point of deploying both Ruby and Clojure apps to the same
stack!

Beyond Clojure, Python is the most interesting, and could certainly
benefit from a similar initiative.

We would welcome ideas on how best to use Scala, Groovy, or maybe even
Javascript to harness the JBoss services in useful and interesting
ways. But we have no definite plans to do so at this time.

## 11?  What?

Please see [Up to eleven](http://en.wikipedia.org/wiki/Up_to_eleven).

# Contributing

## How can I contribute to TorqueBox?

Check out the multitude of resources available for our both our
[user](/community/) and [development](/development/) communities.

Your contributions to the code, this website, or the documentation
are always appreciated.


# Technical

## How much memory does each Ruby interpreter require?

For a very simple Rack app, each Ruby runtime took up 500KB of memory.

For Redmine (decent size Rails2 app), each Ruby runtime took up 2.5MB of memory.

These numbers are based on calculating the retained size of org.jruby.Ruby instances inside the JVM. If you're interested in finding the exact amount per runtime for your apps, I can help you figure this number out for app.

So, a decent-sized Rails application with 3 Ruby runtimes (messaging, web, and maybe a service) may need around 7.5MB of memory plus whatever memory the application consumes as it does its work.

## I'm getting deprecation warnings in my log about `*-rails.yml` and `*-rack.yml` file

These files should now be named with the `*-knob.yml` format.  It is no longer
necessary to encode your web framework in the filename.  So use `-knob.yml` instead.

Please see [this article for more information](/news/2011/02/05/grand-unification-and-knobs/).

## I'm getting deprecation warnings in my log about `jobs.yml` and other YAML files

These files are mostly deprecated at this point, replaced by sections within
a single `torquebox.yml` file.
      
Please see [this article for more information](/news/2011/02/05/grand-unification-and-knobs/).

## How to install TorqueBox to start on system boot?

Just run `cd $TORQUEBOX_HOME && rake torquebox:upstart:install`. This will install an upstart script and symlink `$TORQUEBOX_HOME` to `/opt/torquebox`.

Please see [this article for more information](/news/2011/05/11/simplify-your-deployment/).

