---
title: TorqueBox Gem Changes
author: Bob McWhirter
layout: news
tags: [ gems ]
---

[ci]: http://localhost:4242/development/#ci

## Party of the first part

Over the past few days, we've worked to make the bits of TorqueBox
that are packaged up and exposed as RubyGems a little less crazytown.

If you recall, you've been in the habit of doing stuff like:

    require 'org.torquebox.torquebox-messaging-client'

Or more recently...

    require 'org.torquebox.messaging-client'

The `org.torquebox` prefix has been leaking in from the fact we
build all of TorqueBox, including RubyGems, using Maven.  

We've found some options, though, to remove that cruft.  And with
these changes, we have some significantly saner gem names.

<table>
  <tr>
    <th>Old</th>
    <th>New</th>
  </tr>
  <tr>
    <td>org.torquebox.messaging-client</td>
    <td>torquebox-messaging</td>
  </tr>
  <tr>
    <td>org.torquebox.naming-client</td>
    <td>torquebox-naming</td>
  </tr>
  <tr>
    <td>org.torquebox.vfs</td>
    <td>torquebox-vfs</td>
  </tr>
  <tr>
    <td>org.torquebox.rake-support</td>
    <td>torquebox-rake-support</td>
  </tr>
  <tr>
    <td>org.torquebox.capistrano-support</td>
    <td>torquebox-capistrano-support</td>
  </tr>
  <tr>
    <td>org.torquebox.messaging-container</td>
    <td>torquebox-messaging-container</td>
  </tr>
  <tr>
    <td>org.torquebox.naming-container</td>
    <td>torquebox-naming-container</td>
  </tr>
</table>

We have included some hooks for backwards-compatibility, which should
issue a deprecation warning if you continue to use the `org.torquebox`-based
require statements.

So, begin doing this:

    require 'torquebox-messaging'

## Party of the second part

The messaging and naming clients are probably the most-used gems in
applications.  To make requiring them even easier, we now have a top-level
`torquebox` gem that depends on both of these client gems.

So, it's **even** easier:

    require 'torquebox'

## Fight for your right to party

Lastly, we have been hosting a RubyGems repository, which is useful when working with
our [CI-built][ci] development builds.  The repository is located here:

* [http://rubygems.torquebox.org/](http://rubygems.torquebox.org/)

Instructions for its use are at that location, along with a list of the current
gems.



