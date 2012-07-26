---
title: 'TorqueBox 2.1.0 - New Release and New Leadership'
author: The Entire TorqueBox Team
layout: release
version: '2.1.0'
timestamp: 2012-07-27t09:30:00.0-05:00
tags: [ releases ]
---

We're extremely excited to announce the immediate availability of
TorqueBox 2.1.0! This release includes a lot of bug fixes (especially
around clustering) and several new features, described in a bit more
detail below. We've also had a change in the TorqueBox project
leadership and produced an updated roadmap to share so be sure to keep
reading.

* [Download TorqueBox 2.1.0 (ZIP)][download]
* [Browse HTML manual][htmldocs]
* [Browse JavaDocs][javadocs]
* [Browse Gem RDocs][rdocs]
* [Download PDF manual][pdfdocs]
* [Download ePub manual][epubdocs]

## Highlights of major changes

* The version of AS7 that TorqueBox is based on has been updated to an
  incremental build based on their 7.1 branch. This fixed several
  clustering-related bugs.

* The `inject` method has been renamed to `fetch` to reduce confusion
  with Enumerable's built-in `inject` method. All your old code will
  continue to work with `inject` but in some future release, probably
  2.2.0, `inject` will be removed.

* The default clustering mode of `TorqueBox::Infinispan::Cache` is now
  distributed instead of invalidated. See the [caching clustering mode
  documentation][cacheclusterdocs] for more details on the different
  modes.

* TorqueBox now respects the `$JRUBY_OPTS` environment variable which
  is useful for setting default 1.8 vs 1.9 Ruby modes or various other
  JRuby settings that aren't exposed in our torquebox.yml or
  torquebox.rb configuration. See the [documentation][jrubyoptsdocs]
  for more details.

* InvokeDynamic support in JRuby is now disabled by default in
  TorqueBox to work around a bug in current JDK 7 builds that
  manifests itself as a `NoClassDefFoundError`. This is just a
  temporary measure to keep things working until a fixed JDK 7 is
  released.

* Scheduled jobs now support configurable timeout and concurrency
  options for more control over how long a job is allowed to run and
  how many jobs can be run in parallel. See the scheduled job
  [timeout][jobtimeout] and [concurrency][jobconcurrency] documentation
  for more details.

## Leadership change

Almost four years ago, [Bob McWhirter][bob] took the crazy idea of
running Ruby applications on top of JBoss Application Server and made
it into reality with the first release of [JBoss
Rails][jbossrails]. About one year after that initial prototype, the
project was renamed and [TorqueBox was born][tbannouncement]. In these
past 3 years Bob has lead over 40 new TorqueBox releases, assembled an
amazing [team][] of developers, and convinced Red Hat to support
TorqueBox both financially (by hiring said team) and technologically
(by offering TorqueBox as a supported Red Hat product - more on this
below).

While Bob is still very active in TorqueBox, being the Director of
Polyglot for JBoss means he has plenty of other cool projects in
various stages of development that also require his attention. So,
effective last Friday, [Ben Browning][ben] is now the project lead of
TorqueBox. Ben has been an integral part of the TorqueBox team for the
past two years and has been unofficially driving things for the past
few months anyway - now it's just official.

## Upgrading from 2.0.3

As mentioned above, we've renamed the `inject` method from
TorqueBox::Injectors to `fetch`. However, we still alias this method
to `inject` so old code continues to work. All references to `inject`
in our documentation have been changed to `fetch` and we suggest you
start thinking about changing your code to do the same. In a future
version we will deprecate `inject` by logging a warning when it is
used and then in some future version past that we will actually remove
it.

Because we've rebased to a newer upstream AS7 build, this release also
includes some changes to the standalone.xml, standalone-ha.xml, and
domain.xml configuration files. If you never touch these files and
don't know what they are anyway then continue to ignore them. However,
if you store your configuration files in source control somewhere be
sure to take a look at the changes. The configuration file from 2.0.3
will not boot without some modification on 2.1.0.

## What happened to 2.0.4?

Some of our astute users have noticed that we used to have a 2.0.4
release scheduled but instead decided to release 2.1.0. The decision
was made to drop 2.0.4 and go forward with 2.1.0 once we realized that
to fix some clustering bugs in 2.0.3 we had to bring in an upstream
AS7 build that had the aforementioned config file changes. We didn't
want to break config files in a point release so 2.1.0 came a little
early.

## Roadmap update

We've updated our [roadmap in JIRA][roadmap] and will continue to keep
it updated so users have a better idea when new releases are coming
out and what general features or bug fixes should be in each
release. If you prefer not to dig through JIRA issues, here's a
high-level overview of what you can expect.

We're trying to move towards a monthly release cycle, with each point
release (2.1.1, 2.1.2) keeping backwards compatibility with
applications and configuration files. Right now 2.1.1 is scheduled for
the end of August and 2.1.2 for the end of September.

Our next minor release, 2.2.0, is scheduled for the end of October and
may break backwards compatibility a bit if it needs to upgrade to a
newer AS7 version or for some of the new features. The focus of 2.2.0
is on dynamic creation and runtime control of jobs, services, message
processors, etc. Basically we want to take everything you currently
configure in torquebox.yml or torquebox.rb and make it so that these
things can be created, destroyed, and controlled at runtime.

Beyond 2.2.0 things get a bit sketchy. We already have some ideas for
our next major release, 3.0.0, but it's far enough away that who knows
what will change in the interim.

## Red Hat now offers TorqueBox support

Last, but certainly not least, we've had users ask us at conferences
and other venues if Red Hat provides support for TorqueBox. As of last
month Red Hat now supports TorqueBox in Tech Preview status as part of
[JBoss Web Framework Kit 2.0][wfk2]. The supported TorqueBox is a
[separate download][wfkdownload] that runs on top of [JBoss EAP
6][eap] and supports most of the features found in the TorqueBox
community release 2.0.3.

## Don't be a stranger!

As always, if you have any questions about or issues with TorqueBox, please [get in touch][community].

## Issues resolved since 2.0.3

<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-337'>TORQUE-337</a>] -         Expose pools and runtimes in BackStage
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-400'>TORQUE-400</a>] -         REGRESSION - Allow creation of queues using code as well as with queues.yml file
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-514'>TORQUE-514</a>] -         Allow setting a timeout on scheduled jobs
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-527'>TORQUE-527</a>] -         Make TorqueBox::Logger work with the Rails console
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-580'>TORQUE-580</a>] -         Add bin/torquebox Command to Zip Distribution
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-598'>TORQUE-598</a>] -         Torqubox and Jars relying on Native libraries
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-633'>TORQUE-633</a>] -         TorqueBox Should Respect $JRUBY_OPTS
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-677'>TORQUE-677</a>] -         Print a useful error message when JRUBY_HOME is improperly set
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-688'>TORQUE-688</a>] -         Provide gem for remote messaging
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-724'>TORQUE-724</a>] -         Backgroundable should wire up NewRelic instrumentation so its stats can be reported in the &#39;Background tasks&#39; tab of the NewRelic control panel
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-774'>TORQUE-774</a>] -         HornetQ not starting (Torquebox 2.0.1 on ubuntu 11.10)
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-782'>TORQUE-782</a>] -         session store logs warnings when multiple apps are deployed and one of them is at /
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-786'>TORQUE-786</a>] -         Backstage web context missing after redeploying another app. 
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-788'>TORQUE-788</a>] -         HTTP Status 503 - The requested service () is not currently available for app A &amp; B after deploying C. C works fine.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-793'>TORQUE-793</a>] -         Task concurrency &gt; backgroundable tasks test fails on OpenJDK
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-806'>TORQUE-806</a>] -         Scheduled job using infinispan cache not accessible in controller
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-808'>TORQUE-808</a>] -         TorqueBox Sometimes Fails to Boot When Multiple Clustered Applications are Deployed
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-815'>TORQUE-815</a>] -         Revert mod_cluster Backport Fixes Once Upgraded to AS 7.1.2
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-821'>TORQUE-821</a>] -         Infinispan errors when clustered
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-823'>TORQUE-823</a>] -         TorqueBox::Logger#info throws an error when passed nil
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-826'>TORQUE-826</a>] -         The command `torquebox rails myapp` fails in 2.0.3 binary installations
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-829'>TORQUE-829</a>] -         torquebox.rb is evaluated in the context of the global runtime and working directory is the JBoss directory
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-830'>TORQUE-830</a>] -         Unintialized Constant ActiveSupport::Cache::TorqueBoxStore Error Following Caching Docs
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-831'>TORQUE-831</a>] -         The :tx option is not included in the publish options in Table 8.2 of the documentation
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-833'>TORQUE-833</a>] -         Infinispan cluster not communicating
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-834'>TORQUE-834</a>] -         Errno::ENOENT: No such file or directory - config/torquebox.yml
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-838'>TORQUE-838</a>] -         TorqueBox::Messaging::TextMessage should implement respond_to?
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-839'>TORQUE-839</a>] -         Better error catching when the $JRUBY_HOME is not correct, there&#39;s no lib folder in it
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-840'>TORQUE-840</a>] -         Rename inject method to fetch
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-842'>TORQUE-842</a>] -         Integration Tests Using jmx4r Fail on RHEL 6
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-843'>TORQUE-843</a>] -         Torquebox::Messaging::Destination should not accept a nil destination name
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-850'>TORQUE-850</a>] -         Creating a TorqueBox Archive Fails on Windows
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-855'>TORQUE-855</a>] -         Cache transactional values are not properly rolled back for failed XA transactions in a clustered cache
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-864'>TORQUE-864</a>] -         Change the config sample in the job docs to not use &#39;throttle&#39; as the example
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-870'>TORQUE-870</a>] -         jdk1.7-64bit error which works in jdk1.7-32bit on windows
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-873'>TORQUE-873</a>] -         torquebox rails command creates a &quot;tasks&quot; folder 
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-874'>TORQUE-874</a>] -         Exception Acquiring Ownership of Clustered Session
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-875'>TORQUE-875</a>] -         The default cache clustering mode should be transactional distributed synchronous with optimistic locking
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-880'>TORQUE-880</a>] -         Unable to change the Quartz threadpool size to accomodate different &#39;job&#39; pool sizes
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-883'>TORQUE-883</a>] -         FakeConstant does not resolve more than 2 levels
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-885'>TORQUE-885</a>] -         &#39;rake torquebox:run&#39; shouldn&#39;t allow RUBYOPT settings from passing through
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-886'>TORQUE-886</a>] -         torquebox:archive mistakenly packages the &#39;vendor/bundle/jruby/RUBY_VERSION/cache/&#39; directory
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-890'>TORQUE-890</a>] -         Warn in documentation about setting JAVA_OPTS environment variable
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-896'>TORQUE-896</a>] -         HASingleton jobs and services don&#39;t start if a cluster only has a single node
</li>
</ul>



[download]:         /release/org/torquebox/torquebox-dist/2.1.0/torquebox-dist-2.1.0-bin.zip
[htmldocs]:         /documentation/2.1.0
[javadocs]:         /documentation/2.1.0/javadoc/
[rdocs]:            /documentation/2.1.0/yardoc/
[pdfdocs]:          /release/org/torquebox/torquebox-docs-en_US/2.1.0/torquebox-docs-en_US-2.1.0.pdf
[epubdocs]:         /release/org/torquebox/torquebox-docs-en_US/2.1.0/torquebox-docs-en_US-2.1.0.epub
[cacheclusterdocs]: /documentation/2.1.0/cache.html#caching-clustering-modes
[jrubyoptsdocs]:    /documentation/2.1.0/installation.html#setting-jruby-properties
[jobtimeout]:       /documentation/2.1.0/scheduled-jobs.html#jobs-timeout
[jobconcurrency]:   /documentation/2.1.0/scheduled-jobs.html#jobs-concurrency
[bob]:              https://twitter.com/bobmcwhirter
[jbossrails]:       http://oddthesis.org/posts/2008-09-jboss-on-rails/
[tbannouncement]:   /news/2009/05/18/announcing-the-torquebox-project/
[team]:             http://projectodd.org
[ben]:              https://twitter.com/bbrowning
[roadmap]:          https://issues.jboss.org/browse/TORQUE?selectedTab=com.atlassian.jira.plugin.system.project%3Aroadmap-panel
[wfk2]:             http://www.redhat.com/products/jbossenterprisemiddleware/web-framework-kit/
[wfkdownload]:      https://access.redhat.com/downloads/
[eap]:              http://www.redhat.com/products/jbossenterprisemiddleware/application-platform/
[community]:        /community
