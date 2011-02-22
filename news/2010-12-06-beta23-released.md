---
title: TorqueBox 1.0.0.Beta23 Released
author: Jim Crossley
version: 1.0.0.Beta23
layout: release
tags: [ releases ]
---
We're happy as clams to announce yet another beta release,
TorqueBox 1.0.0.Beta23.  Please [download it](/download/) and [checkout
the docs](/documentation/1.0.0.Beta23/) now.

We know a 23rd beta is ridiculous, but our API's and configuration
file formats are still coagulating a bit.  We'll have a release
candidate out real soon now.

Speaking of configuration, we've deprecated the use of the `web.yml`
and `rails-env.yml` deployment descriptors.  We prefer the use of
`torquebox.yml` now, which has the exact same syntax as `*-rack.yml`
and `*-rails-yml` deployment descriptors.  We think this is simpler
for the user, and implementing it allowed us to give some love to Rack
applications, making packaging, deployment, messaging and jobs
configuration virtually identical for both Rack and Rails apps.  For
more details, see the
[docs](/documentation/1.0.0.Beta23/deployment-descriptors.html)

Bob fixed up session management for both supported versions of Rails,
too.  We're a little less magic regarding session data storage for
Rails 2 apps, though, now requiring you to explicitly request the
TorqueBox session store in your initializer, as you would any other
session storage backend.  Read more about it
[here](/documentation/1.0.0.Beta23/rails2.html#d0e508).

Speaking of Rails, we upgraded to version 3.0.3.  We also upgraded to
the latest JRuby 1.5.6 and JBoss AS 6.0.0 CR1.

Here's the full rundown.  Enjoy!

<h2>        Bug
</h2>
<ul>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-132'>TORQUE-132</a>] -         Torquebox/VFS attempts to process hidden directories (.svn, .git, etc) as gems when Rails is vendorized
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-133'>TORQUE-133</a>] -         Rack deployer encounters NPE when Rails is vendorized
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-134'>TORQUE-134</a>] -         VFS Fails When Given Windows Path (backslashes)
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-135'>TORQUE-135</a>] -         VFS Fails When Given Path with Spaces
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-138'>TORQUE-138</a>] -         File.expand_path Losing vfs: Prefix
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-139'>TORQUE-139</a>] -         VFS Gem Should Be Required Before Rails Boots
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-140'>TORQUE-140</a>] -         FileTest Methods Should Be VFS-Aware
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-141'>TORQUE-141</a>] -         VFS.resolve_within_archive Gets Stuck In Infinite Loop If Passed Pathname With &quot;vfs:&quot; Prefix
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-143'>TORQUE-143</a>] -         Dir.new Should Handle VFS Paths
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-144'>TORQUE-144</a>] -         VFS::Dir Should Have &#39;entries&#39; Instance Method
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-145'>TORQUE-145</a>] -         File.readable? Never Returns True For Files Inside VFS Archives
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-147'>TORQUE-147</a>] -         Pathname#realpath Breaks on VFS Paths
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-148'>TORQUE-148</a>] -         Any &quot;web&quot; pool defined in pooling.yml has no effect
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-149'>TORQUE-149</a>] -         TorqueBox application archives should support bundler
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-150'>TORQUE-150</a>] -         Deadlock Issue in Quartz 1.8.0 - Upgrade to 1.8.3
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-155'>TORQUE-155</a>] -         Rails 2 applications with frozen rails fail with a nil error 
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-157'>TORQUE-157</a>] -         Only 33% of self-contained-dependencied rack deployment mechanisms work correctly
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-162'>TORQUE-162</a>] -         Cannot upload using flash in a rails3 app
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-166'>TORQUE-166</a>] -         Rack::URLMap.call throws TorqueBox exception
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-168'>TORQUE-168</a>] -         File.chmod Should Work on Files Inside Archive Under Directory Mounted on Real Filesystem
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-172'>TORQUE-172</a>] -         monkeypatching reset_session in Rails2 should only occur if the TorqueBox servlet session is configured to be used.
</li>
</ul>
        
<h2>        Feature Request
</h2>
<ul>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-80'>TORQUE-80</a>] -         Create a CirrAS-compatible RPM for TorqueBox
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-137'>TORQUE-137</a>] -         Put logs somewhere reasonable for rails bundles
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-152'>TORQUE-152</a>] -         TorqueBox should support absolute paths to the rackup file in rack deployment descriptors
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-153'>TORQUE-153</a>] -         Replace internal deployment descriptors with a single torquebox.yml file
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-156'>TORQUE-156</a>] -         Add .bundler/config to torquebox:archive task
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-158'>TORQUE-158</a>] -         Enhance torquebox:archive rake task to work for Rack apps
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-167'>TORQUE-167</a>] -         Update to latest rails version (3.0.3)
</li>
</ul>
                    
<h2>        Task
</h2>
<ul>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-131'>TORQUE-131</a>] -         Post-assembly spot-check test
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-142'>TORQUE-142</a>] -         Support .rack archives
</li>
<li>[<a href='https://jira.jboss.org/browse/TORQUE-173'>TORQUE-173</a>] -         Ensure TorqueBox rails template explicitly sets the servlet session-store
</li>
</ul>
