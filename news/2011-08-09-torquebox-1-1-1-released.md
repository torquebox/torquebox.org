---
title: 'TorqueBox v1.1.1 Released'
author: The Entire TorqueBox Team
layout: release
version: '1.1.1'
tags: [ releases ]
---

# TorqueBox v1.1.1 Released

The entire TorqueBox team is proud to announce immediate availability
of *TorqueBox v1.1.1*.

* [Download TorqueBox 1.1.1 (ZIP)][download]
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

This is a bug-fix release, and includes a few notable changes:

* JRuby 1.6.3 has an issue that may cause TorqueBox to crash when an app is deployed (see [JRUBY-5933] for the specifics).
  This release includes a workaround to prevent that from happening. This issue currently affects TorqueBox 1.1.

* We made a small change to the way we initialize JRuby runtimes for Rails applications, resulting in a ~30% 
  improvement in the runtime startup time.

* Improved support for Rails 3.1. Rails 3.1 is in the release candidate stage (currently rc5), and often
  has significant changes between candidates. As such, we may need to make another TorqueBox release when
  Rails 3.1 final is released to track additional changes there. 

# Tested Frameworks

With each release of TorqueBox, we test with a specific set of frameworks and libraries, and recommend their
use with that release. For the 1.1.1 release, we have tested against:

* JRuby 1.6.3
* rack 1.1.0
* rails 2.3.11
* rails 3.0.5
* rails 3.1.0.rc5
* activerecord-jdbc-adapter 1.1.3
* sinatra 1.2.3

# Community Contributions

This release includes several fixes and documentation contributions from the following community members:

* [Ben Anderson](https://github.com/banderso)
* [Joshua Borton](https://github.com/digitaltoad)
* [Bruno Oliveira](https://github.com/abstractj)
* [Gavin Stark](https://github.com/gstark)

Thanks so much for your contributions!

## What's changed since 1.1?

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-492'>TORQUE-492</a>] -         Globbing doesn&#39;t translate multiple single splats correctly
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-493'>TORQUE-493</a>] -         Assets contained in the app/assets fail to serve in Rails 3.1
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-497'>TORQUE-497</a>] -         TorqueBox seg faults with &#39;invalid memory access&#39; or &#39;malloc double free&#39; when initializing runtimes
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-499'>TORQUE-499</a>] -         Rails Initialization Wastes Several Seconds Inspecting Caller Stacks
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-503'>TORQUE-503</a>] -         Unable to load bundled gems due to wrong vfs paths
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-506'>TORQUE-506</a>] -         Bootstrap.java should only try to mount jars in JRUBY_HOME
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-516'>TORQUE-516</a>] -         Update docs to mention the -b requirement for clustering 
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-519'>TORQUE-519</a>] -         activerecord-jdbc-adapter 1.1.3 fails when used with vfs sqlite path
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-522'>TORQUE-522</a>] -         Update rails template to not include gems that will be automatically included in the Gemfile by rails 3.1
</li>
</ul>
                            
# What's next?

After the last release, we stated that we didn't anticipate any more 1.x 
releases before 2.x, but that is clearly not the case. Expect no more sweeping
proclamations of that nature. 

The 2.0 release will be built on top of the recently 
released [JBossAS 7][as7], and have a considerably faster deploy time along
with a much lower memory footprint. We hope to have a 2.0 beta soon,
but in the meantime, feel free to give our [incremental builds][2x] a try.


[download]: http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-dist/1.1.1/torquebox-dist-1.1.1-bin.zip
[htmldocs]: /documentation/1.1.1/
[pdfdocs]:  http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-docs-en_US/1.1.1/torquebox-docs-en_US-1.1.1.pdf
[epubdocs]: http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-docs-en_US/1.1.1/torquebox-docs-en_US-1.1.1.epub
[features]: /features/
[JRUBY-5933]: http://jira.codehaus.org/browse/JRUBY-5933
[as7]: http://www.jboss.org/as7.html
[2x]: /2x/builds/
