---
title: TorqueBox 1.0.0.Beta17 now supports Rack, Sinatra and Bundles
version: 1.0.0.Beta17
author: Bob McWhirter
layout: release
tags: [ releases, rack, sinatra ]
---
We're happy to announce the release of TorqueBox 1.0.0.Beta17.

Take a moment to [download](/download/) it and [read the documentation](/documentation/#{page.version}/).

This release includes

* [Rack support](/documentation/1.0.0.Beta17/rack-support.html) (including Sinatra)
* [Bundle-based deployment](/documentation/1.0.0.Beta17/rails-support.html#d0e1796)

In all honesty, Rack support was available in Beta16, but we hadn't documented it.

Bundle-based deployment allows you to create a Zip bundle of your application and deploy it.  
This allows TorqueBox to auto-farm your application to other nodes atomically if you're clustering.

The bundle deployments are made possible by VFS, which allows JRuby to treat 
resources within an archive (zip, jar) as if they were files on the filesystem.  
We may document this separately for application usage once we're happy with its quality.

On that note, due to the changes to support VFS and bundles, this release may be somewhat 
fragile.  Even if you're not using bundles.  Please report any issues, problems or bugs 
in JIRA, our bug-tracking system.

Here's what JIRA thinks we've done:

## Bug

* [TORQUE-44](https://jira.jboss.org/jira/browse/TORQUE-44) - TorqueBox does not pass settings from myapp-rack.yml to Merb and Sinatra

## Feature Request

* [TORQUE-15](https://jira.jboss.org/jira/browse/TORQUE-15) - Support myapp.rails bundle deployment
* [TORQUE-32](https://jira.jboss.org/jira/browse/TORQUE-32) - VFS support for everything in Ruby

## Task

* [TORQUE-40](https://jira.jboss.org/jira/browse/TORQUE-40) - Document bare Rack support



