---
title: 'Knobs a la carte'
author: Bob McWhirter
layout: news
---

[ben.services]: /news/2011/01/28/services/
[rake.support]: /documentation/1.0.0.Beta23/deployment.html#d0e782
[examples]: https://github.com/torquebox/torquebox/tree/master/integration-tests/apps/alacarte

# The Value Menu

In the past few weeks, we worked on making our deployments a little more
technology-agnostic.  This allowed us to divorce ourselves not only from
Rails and Rack applications, but from just about any constraint.

It's now possible to deploy applications that contain any combination
of components

* web
* messaging (processors, queues & topics)
* jobs
* services

# Loose files or **knob** archives

An application is any directory that contains your files, and optionally
a `torquebox.yml` to wire it all up.  An a-la-carte application is deployed
with a `*-knob.yml` file as with any other.

    application:
      root: /path/to/my/simple_service

Within the root of that you may have a `torquebox.yml` to configure the
actual services, along with your source files implementing them.

    simple_service/
      torquebox.yml
      simple_service.rb

In this case, the `torquebox.yml` only needs to contain a very simple
`services:` section:

    services:
      SimpleService:

For more information on services in general, see [Ben's excellent post][ben.services].

If you'd prefer to make a handle bundle, you can still use the [Rake support][rake.support]:

    $ rake torquebox:archive
    $ rake torquebox:deploy:archive

# Bottom line

There's more to the world than just the World Wide Web.  There's other ports to be served,
things to occur outside of user interactions.  Now you can deploy whichever parts make sense.

You can browse [examples of a-la-carte deployments][examples] in our integration test suite.
