---
title: Grand Unification of Deployment Descriptors.  And Knobs!
author: Bob McWhirter
layout: news
tags: [ deployment-descriptors, knobs ]
---


Today I finally landed a large refactoring branch I'd been working on all week.

For a while, a few things have been bugging us:

* TorqueBox supported a crapload of `config/*.yml` files
* Every app required Rails, or at least Rack.

While it's not complete, we've taken a major step today.  For the most
part, we've maintained backward compatibility, and issue deprecation
warnings in the `server.log`.


## `config/torquebox.yml` replaces `config/*.yml`

The various files that TorqueBox supports within `config/`, such as
`web.yml`, `jobs.yml` and `messaging.yml` are now all deprecated.

Instead, the configuration represented by each file is now contained
within a top-level section of the `torquebox.yml`.

For instance, if your `config/web.yml` had this:

    host: mycoolapp.com

You would now have `config/torquebox.yml` with contents such as:

    web:
      host: mycoolapp.com

You'll notice that `torquebox.yml` looks like `*-rails.yml`, which brings
us to our next point.

## `*-knob.yml` replaces `*-rails.yml`/`*-rack.yml`

First, we removed the need to explicitly name the framework in the deployment
descriptor's filename.  Also, by choosing `-knob` as a framework-agnostic 
extension, we open the door for applications that lack _any_ web component.

Now, instead of placing `myapp-rails.yml` or `myapp-rack.yml` into the 
`deploy/` directory, you simply name it `myapp-knob.yml`.

Both `*-knob.yml` and `torquebox.yml` may now contain the same sections.
You may externally override any `config/torquebox.yml` section using
a section of the same name in the externally deployed `*-knob.yml`.

At this point, only entire sections are replaced/overridden.

The final precedence, from most to least, is:

1. External `myapp-knob.yml`
2. Internal `config/torquebox.yml`
3. Internal `config/SOMETHING.yml`

#### *Note*: `rackup` parameter has moved

The `application:` section of an external descriptor previously took a `rackup:`
configuration parameter, optionally providing a path to a non-default `config.ru`.

This configuration parameter has moved to the `web:` section, where it is more appropriate.

## `.knob` archives replace `.rails`/`.rack` archives

Just as external YAML descriptors no longer need to encode `rack` or `rails` into
their filenames, neither do archive-based deployments.

Instead, archives should be named with the extension of `.knob`.

## Backwards compatibility

For now, development builds will continue to support `*-rails.yml` and `*-rack.yml`
external descriptors, along with  `*.rails` and `*.rack` archives.  Expect to see
this support removed before the final 1.0 release.

## Why oh why?

The reasons for these changes are several-fold:

* Simplification of internal code (fewer rails/rack-specific code-paths)
* Simplification of deployment (`-knob.yml` and `.knob` is all you need)
* Simplification of configuration (only `torquebox.yml`, not a swarm of YAML files)
* Moving from being web-centric to component-centric
