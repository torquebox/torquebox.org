---
title: TorqueBox 1.0.0.Beta22 Released
author: Jim Crossley
version: 1.0.0.Beta22
layout: release
---

We're just pleased as punch to announce our second September release,
TorqueBox 1.0.0.Beta22.  Go [download it](/download/) and [checkout
the improved documentation](/documentation/1.0.0.Beta22/) now.

This release primarily enhances our support of Rails 3 apps and
improves our Ruby API for JMS messaging.  We've spent a fair amount of
time "prettying up" our docs and stabilizing Rails development mode,
including ActiveRecord/JDBC fixes, JBoss VFS improvements, and
automatic class reloading, even for asynchronous tasks like message
handlers and scheduled jobs, making your development experience with
TorqueBox that much more responsive and enjoyable!

We also upgraded to the latest JRuby release (1.5.3) and the latest
JBoss AS release (6.0.0 M5).

But wait, according to JIRA, there's more!

<h2>        Bug
</h2>
<ul>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-54'>TORQUE-54</a>] -         Pooled runtimes (such as queues) should optionally reload Rails applications.
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-94'>TORQUE-94</a>] -         Cannot deploy a servlet
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-97'>TORQUE-97</a>] -         Tasks that access a model asynchronous to a request get a nil.include error with create_time_zone_conversion_attribute
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-99'>TORQUE-99</a>] -         Properly dispose of Ruby runtimes.
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-112'>TORQUE-112</a>] -         File.new Doesn&#39;t Understand VFS Paths
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-113'>TORQUE-113</a>] -         Some examples in the messaging (chapter 6) are not correct 
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-114'>TORQUE-114</a>] -         Double jruby runtime initialization for a Rails app
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-115'>TORQUE-115</a>] -         Https not recognized when redirecting
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-117'>TORQUE-117</a>] -         File Objects Should Be Returned From File.open and File.new When Passed VFS Urls
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-118'>TORQUE-118</a>] -         Null path VFS error on windows
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-119'>TORQUE-119</a>] -         File.exist? Should Handle Pathname Arguments
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-121'>TORQUE-121</a>] -         FileUtils.mkdir_p fails when given a vfs path more than one nonexistent dir deep
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-122'>TORQUE-122</a>] -         Failure for jdbc-postgres and/or activerecord-jdbcpostgresql-adapter on rake db:reset
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-125'>TORQUE-125</a>] -         rake torquebox:undeploy seems to expect 2 arguments and fails
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-127'>TORQUE-127</a>] -         When using Rails3 the templates need to be named .en.html.erb
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-128'>TORQUE-128</a>] -         VFS globbing using curly braces and a trailing comma fails.
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-130'>TORQUE-130</a>] -         Torquebox b21 creates mangled VFS file paths when integrated with Jammit
</li>
</ul>
        
<h2>        Feature Request
</h2>
<ul>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-79'>TORQUE-79</a>] -         Allow creation of queues using code as well as with queues.yml file
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-110'>TORQUE-110</a>] -         Make the models referenced by jobs and tasks reloadable in dev env
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-116'>TORQUE-116</a>] -         Support Rails 3
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-120'>TORQUE-120</a>] -         TB should include more jdbc gems
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-123'>TORQUE-123</a>] -         Rails 3 application template
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-124'>TORQUE-124</a>] -         rake torquebox:rack:deploy
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-126'>TORQUE-126</a>] -         By default, use NON_SHARED ruby pools for messaging and jobs in development mode
</li>
</ul>
                    
<h2>        Task
</h2>
<ul>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-18'>TORQUE-18</a>] -         Add concurrency control for task queues
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-27'>TORQUE-27</a>] -         Adjust Ruby module names from JBoss to TorqueBox
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-129'>TORQUE-129</a>] -         Update to AS6m5
</li>
</ul>