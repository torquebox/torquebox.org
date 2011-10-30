---
title: 'TorqueBox v1.0.1 Released'
author: The Entire TorqueBox Team
layout: release
version: 1.0.1
tags: [ releases ]
---

[download]: http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-dist/1.0.1/torquebox-dist-1.0.1-bin.zip
[htmldocs]: /documentation/1.0.1/
[pdfdocs]:  http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-docs-en_US/1.0.1/torquebox-docs-en_US-1.0.1.pdf
[epubdocs]: http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-docs-en_US/1.0.1/torquebox-docs-en_US-1.0.1.epub
[features]: /features/
[externaljms]: /documentation/1.0.1/messaging.html#d0e2092
[pete]: http://screamingcoder.com/
[upstart]: http://upstart.ubuntu.com/
[upstarttasks]: /documentation/1.0.1/installation.html#running-torquebox

# TorqueBox v1.0.1 Released

The entire TorqueBox team is proud to announce immediate availability
of *TorqueBox v1.0.1*.

* [Download TorqueBox 1.0.1 (ZIP)][download]
* [Browse HTML documentation][htmldocs]
* [Download PDF documentation][pdfdocs]
* [Download ePub documentation][epubdocs]

# What is TorqueBox?

TorqueBox builds upon the JBoss AS Java application server,
mixing in JRuby, to provide a scalable platform for Ruby applications,
including support for Rails, Sinatra and other Rack-based frameworks.

In addition to supporting popular web frameworks, TorqueBox [bridges
many common Java facilities][features] provided by JBoss, including *scheduled jobs*,
*caching*, *messaging*, and *services*.

# What's in this release?

This is mostly a bug fix release, but does include few notable improvements:

* You can now interact with JMS queues that are external to your TorqueBox instance. Thanks
  to community member [Pete Royle][pete] for this contribution. See the [docs][externaljms] for
  more details.
  
* Creation of JRuby runtimes is now deferred at deploy time until they are requested. This allows
  applications to deploy much faster, and web requests will be queued until the web runtime
  is available, instead of returning 404's while that runtime spins up.
  
* We now ship a top level Rakefile that facilitates installing TorqueBox as an 
  [upstart][upstart] service. See the [docs][upstarttasks] for details. 

## What's changed since 1.0.0?

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-354'>TORQUE-354</a>] -         Processing messages from external JMS destinations
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-381'>TORQUE-381</a>] -         :selector option does not work for receive_and_publish
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-382'>TORQUE-382</a>] -         StompBox: Git deployment doesn&#39;t work with the recent changes to DeployUtils
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-383'>TORQUE-383</a>] -         Defer runtime pool filling until runtime is requested
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-384'>TORQUE-384</a>] -         BackStage: Add a control to allow users to clear the contents of a queue/topic
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-385'>TORQUE-385</a>] -         BackStage: Add pagination support to queue/topic message view
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-386'>TORQUE-386</a>] -         See if DataMapper works with sqlite vfs paths
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-387'>TORQUE-387</a>] -         Reorg web framework section, adding subsection for Sinatra
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-388'>TORQUE-388</a>] -         Fix TorqueBox SessionStore template, docs, and redundancy
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-389'>TORQUE-389</a>] -         Audit integration tests for gratuitous sleep and rails usage
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-390'>TORQUE-390</a>] -         Add a top level Rakefile to the distribution that has nothing but require &#39;torquebox/rake/tasks/server&#39;
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-392'>TORQUE-392</a>] -         Document top level Rakefile usage
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-396'>TORQUE-396</a>] -         Only symbols allowed as session keys
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-409'>TORQUE-409</a>] -         rails command raises &#39;NameError: uninitialized constant ActionDispatch::Session::TorqueboxStore&#39; in an app created with template.rb in rails 3
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-413'>TORQUE-413</a>] -         Runtimes Appear to Start Serially Instead of in Parallel
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-419'>TORQUE-419</a>] -         BACKPORT - TB 1.x Should Require Correct Rack Gem Version When Booting App
</li>

</ul>
            
# What's next?

After this release, we anticipate maybe one more 1.x patch release before
our next major release (2.0). The 2.0 release will be built on top of
JBoss AS7, and have a considerably faster boot deploy time along with
a much lower memory footprint. Expect an alpha release "soon"!
