---
title: Initial Rails 3.x Support
author: Bob McWhirter
layout: news
tags: [ rails3 ]
---

Today, with commit [9090ebc3](http://github.com/torquebox/torquebox/commit/9090ebc35589f8038f25f102370b28a76e629b19)
TorqueBox now has initial Rails 3.x support.

I must commend the Rails 3 effort for making it pretty easy to support.
They've done a great job making Rails *just another Rack application*.
Which makes our job a *lot* easier.

<a href="http://img.skitch.com/20100917-nihycwwsu6m5c7xkgutr6b9sc1.png" style="display: block; text-align: center;"><img src="http://img.skitch.com/20100917-nihycwwsu6m5c7xkgutr6b9sc1.png" style="width: 200px;"/></a>

On the other hand, adding Rails 3.x support was thwarted by Maven.  Maven likes
any project to have exactly one edition of a given dependency.  We use 
mkristian's [jruby-maven-plugins](http://github.com/mkristian/jruby-maven-plugins) so that all of the RubyGems that go into
TorqueBox have Maven coordinates and participate in normal resolution.

That stops working as soon as you want to concurrently support Rails 2.x
and Rails 3.x.  

We managed to work around using additional POMs (because you just can't
have enough) and scribbling paths outside of their own project.  Good times.

Nonetheless, the next release will include Rails 3.x support for y'all
to start bashing on.
