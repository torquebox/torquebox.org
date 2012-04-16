---
title: 'TorqueBox v2.0.1 Released'
author: The Entire TorqueBox Team
layout: release
version: '2.0.1'
timestamp: 2012-04-16t16:40:00.0-05:00
tags: [ releases ]
---

Hot on the heels of our [2.0.0] release, we're happy as a Sunday in Paris, full of song, 
dance, and laughter to announce the immediate availability of *TorqueBox v2.0.1*. 
This fixes a couple of regressions that slipped in between cr1 and the 
2.0.0 final release,
as well as a few bugs that didn't surface in the beta/candidate cycle.

* [Download TorqueBox 2.0.1 (ZIP)][download]
* [Browse HTML manual][htmldocs]
* [Browse JavaDocs][javadocs]
* [Browse Gem RDocs][rdocs]
* [Download PDF manual][pdfdocs]
* [Download ePub manual][epubdocs]

## What is TorqueBox?

TorqueBox is a Ruby application server built on JBoss AS7 and JRuby.  In
addition to being one of the [fastest Ruby servers around][BENchmarks], it supports
Rack-based web frameworks, and provides [simple Ruby interfaces][features] to
standard JavaEE services, including *scheduled jobs*, *caching*, *messaging*,
and *services*.

## What's changed since 2.0.0?

There aren't that many fixes in 2.0.1, but a couple of them are important, and 
warranted a release sooner rather than later:

* Clustering behind mod_cluster was [broken in 2.0.0][755], but now works like gangbusters!
* Our capistrano tasks had an issue where it would appear to redeploy an application,
  but actually [failed to do so][757].
  
Other notable changes in this release include:

* We've [changed the way HornetQ buffers messages for processors][748] to improve
  their utilization when your processor concurrency is > 1 and the processors are
  performing time consuming operations. If you are using the default concurrency of
  1, you should see no performance change.
* You can now [properly connect to a remote topic or queue][769] running in another
  TorqueBox container.
* TorqueBox now [properly starts up if used under domain mode][773].

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].
## Issues resolved since 2.0.0

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-748'>TORQUE-748</a>] -         the default consumer-window-size may be a poor default 
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-755'>TORQUE-755</a>] -         mod_cluster should be easier to setup
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-756'>TORQUE-756</a>] -         Capistrano-based deploys break in MRI 1.9.3p125
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-757'>TORQUE-757</a>] -         Capistrano no longer fully deploys
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-758'>TORQUE-758</a>] -         Capistrano support should use deploy:create_symlink hook
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-759'>TORQUE-759</a>] -         Debugger Doesn&#39;t Work When TorqueBox Started via &#39;torquebox run&#39;
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-760'>TORQUE-760</a>] -         Cannot get more than two backgroundables to run concurrently 
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-761'>TORQUE-761</a>] -         Rails template add_source line leftover from incremental builds
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-765'>TORQUE-765</a>] -          TorqueBox should ship without the modcluster ROOT context excluded
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-766'>TORQUE-766</a>] -         None of the scripts in jboss/bin/ are executable in the gem install
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-767'>TORQUE-767</a>] -         Update the production setup guide to refer to 2.0.1 instead of cr1
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-769'>TORQUE-769</a>] -         Cannot subscribe to remote HornetQ Topics from within a TorquBox application
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-771'>TORQUE-771</a>] -         Don&#39;t Display &quot;Can&#39;t get or create an Infinispan cache&quot; Log Message When Running Rake / Rails Commands
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-773'>TORQUE-773</a>] -         Domain mode missing dependency
</li>
</ul>

                                    
[2.0.0]: /news/2012/04/02/torquebox-2-0-0-released/
[download]: /release/org/torquebox/torquebox-dist/2.0.1/torquebox-dist-2.0.1-bin.zip
[htmldocs]: /documentation/2.0.1/
[javadocs]: /documentation/2.0.1/javadoc/
[rdocs]:    /documentation/2.0.1/yardoc/
[pdfdocs]:  /release/org/torquebox/torquebox-docs-en_US/2.0.1/torquebox-docs-en_US-2.0.1.pdf
[epubdocs]: /release/org/torquebox/torquebox-docs-en_US/2.0.1/torquebox-docs-en_US-2.0.1.epub
[features]: /features
[BENchmarks]: /news/2011/10/06/torquebox-2x-performance/
[community]: /community
[755]: https://issues.jboss.org/browse/TORQUE-755
[757]: https://issues.jboss.org/browse/TORQUE-757
[748]: https://issues.jboss.org/browse/TORQUE-748
[769]: https://issues.jboss.org/browse/TORQUE-769
[773]: https://issues.jboss.org/browse/TORQUE-773
