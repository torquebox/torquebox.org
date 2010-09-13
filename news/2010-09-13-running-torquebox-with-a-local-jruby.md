---
title: Running TorqueBox with a local JRuby
author: Tobias Crawley
layout: news
---

TorqueBox ships with a bundled version of JRuby (version 1.5.2 as of Beta21)
that makes it easy to get TorqueBox up and running quickly. But you can
also use your own install of JRuby instead, by pointing `$JRUBY_HOME` at your 
local JRuby install, and installing the gems included with TorqueBox into
your local `$GEM_HOME` (assuming you have already set your `$TORQUEBOX_HOME` 
according to the [installation instructions](http://torquebox.org/documentation/current/installation.html)):

    cd $TORQUEBOX_HOME/jruby/lib/ruby/gems/1.8/cache
    gem install *.gem

**Note:** If you upgrade to a newer beta, or are tracking 
[TorqueBox edge](http://github.com/torquebox/torquebox), be sure to reinstall 
the TorqueBox gems with each new build, as they will be versioned 1.0.0 for 
each beta until 1.0.0GA ships.

