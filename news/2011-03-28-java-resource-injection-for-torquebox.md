---
title: 'Java resource injection for TorqueBox'
author: Bob McWhirter
layout: news
tags: [ cdi, injection ]
---

[JBossMC]: http://jboss.org/jbossmc
[weld]: http://seamframework.org/Weld

While creating TorqueBox, we realized that we are serving two
distinct (but possibly overlapping) audiences:

* Rubyists looking for a great deployment platform
* JavaEE developers looking to try Ruby

The second crowd, we hope, will be excited about the latest
stuff we've enabled: **resource injection**.  I know we said "no more features" a while
ago, but this work grew out of fixing bugs.  Honestly.  It did.

# What, _exactly_, is injection?

As developers, we tend to create modules from trees of smaller components.
We can either stitch these together explicitly, or use a **dependency injection
container**, such as [JBossMC], Guice, or a [CDI implementation][weld]
to handle the run-time creation and management of our components.

Injection allows for our components to stop caring about finding the pieces
they depend on.  That simplifies your code.

Code that is not injection-based has to worry about figuring out which implementation
to use:

    public class OrderShipper {

      private ShippingService shipper;

      public OrderShipper() {
        if ( System.getProperty( "test-env" ).equals( "true" ) ) {
          this.shipper = new MockShippingService();
        } else {
          this.shipper = new PlanetExpress();
        }
      }
    }

Injection-based code lets the container wire it up:

    public class OrderShipper {

      @Inject
      private ShippingService shipper;

      public OrderShipper() {
      }

    }

In a test environment, the injection-based `OrderShipper` code will simply receive the
`MockShippingService` while it'll be provided the `PlanetExpress` shipper in a
live production environment.  

Injection allows the containers to help you out, and ensure all
of your components have what they need, when they need it.  Ensuring
that each component comes up in the correct order (queues before services
that need them, for instance) is one of the primary jobs of the container.

As a design strategy, dependency-injection allows you to write unit tests
against your smaller components, injecting mock instances or other rigging
around the code under test.

# No more JSF, you say?

It might irritate our paymasters, but if you continue reading, you can stop
caring about JSF.  EJBs are actually cool in that you can easily create
stateless services and demarcate transactional boundaries.  Using them
from JSF to draw characters on the screen is significantly less cool.

But you can inject those EJBs (using CDI, see below) into your Ruby
components now.

# Java Context and Dependency Injection (Java-CDI)

The most "exciting" (I guess) aspect of injection these days is known as
**Context and Dependency Injection**, or CDI.  

In its barest form, CDI is embodied through the `@Inject`
annotation.  It's an instruction to the container to find or create
an appropriate implementation, and give it to me at the right time.

    @ApplicationScoped
    public class OrderShipper {

      @Inject 
      private LabelPrinterService printer;

      @Inject 
      private ShippingService shipper;

      public void shipIt(long orderId) {
        this.printer.printLabel( orderId ) 
        this.shipper.shipBox( orderId ) 
      }

    }

The container, using the rules of CDI, will ensure that when `OrderShipper`
is created (by the container), it will have a `LabelPrinterService` and
a `ShippingService` jammed into it and ready to go.

The `@ApplicationScoped` annotation informs the CDI container that we
only need one of these in the application, and use the same instance to
satisfy every component that asks for it.

Elsewhere, you have some existing stateless EJBs implementing some
of the services that the `OrderShipper` requires.

    @Stateless
    public class DotMatrix implements LabelPrinterService {

      public void printLabel(long orderId) {
        ...
      }

    }

and

    @Stateless
    public class PlanetExpress implements ShippingService {

      public void shipBox(long orderId) {
        ...
      }

    }

If you're part of our second audience, you probably have a lot of 
things like this in your code that you're just waiting to use from your
Ruby application.  Am I right?

# Ruby Context and Dependency Injection (Ruby-CDI)

Okay, you have your fancy enterprise components written in Java. They're
annotated for use as CDI injectable things.  Now what?

Let's inject them into some Ruby!

First, throw your JAR full of CDI-enabled things into your application's
`lib/` directory:

    app/
      models/
      views/
      controllers/
      lib/
        mycorp-components.jar

Now, let's inject it into a controller:

    class OrderController < ApplicationController

        include TorqueBox::Injectors

        def create
          ...
          order_shipper = inject( com.mycorp.OrderShipper ) 
          order_shipper.ship_it( @order.id )
        end

    end

There ya go.  Your Java `OrderShipper` and its component tree 
is now available in your Rails controller.

The key parts of injecting:

* Your class must `include TorqueBox::Injectors`
* Use `inject(...)` to inject.  The argument(s) **must** be a literal.

Unfortunately, you cannot use a variable or non-literal as the parameter
to the `inject(...)` call.  We are performing analysis of the code before
evaluating it, in order to set up all of the injection dependencies.  Without
evaluation, we cannot interpret variables or other non-literals.

Currently we don't support CDI qualifiers.  We're investigating how to expand
support for that.

# Inject between your toes

The above example demonstrates injecting into a Rails controller.  You can also 
inject into scheduled jobs, services, tasks, and message-processors, using the
exact same strategy.

    class ShipperAuditer

      include TorqueBox::Injectors

      def initialize(opts={})
        @shipper = inject( com.mycorp.ShippingService )
      end

      def run
        shipments = @shipper.shipments_since( Time.now - 1.day )
        audit( shipments )
      end
    end

# Inject a variety of substances

## Messaging

Sometimes we need message processors that involve other queues and topics, beyond
the one to which they are primarily attached.  Sometimes a job or a service might
need a messaging destination.  We support messaging destination injection, which
will set up your component with the appropriate `TorqueBox::Messaging::Queue` or
`TorqueBox::Messaging::Topic`.

    @some_queue = inject( '/queues/myqueue' )
    @a_topic    = inject( '/topics/that_topic' )

Previously, you'd have to lookup the queue from within your component, and due 
to the order in which components would start, it might fail.  By using injection,
the container will guarantee the correct deployment ordering, so that your service
or job will not start until the queues and topics it relies upon are ready.

Given this, it may be possible to create a dead-locking race condition if you
are talented.

## Hard-core injections

### Naming

Additionally, you can inject arbitrary objects from the JNDI store.  I have no
specific use-case for this one.  But you can do it.

    @whatever = inject( 'java:comp/env/that_thing')

### MCBeans

If you're doing weird stuff, and need direct access to JBossMC beans, you can
inject those also.

    @webserver = inject('jboss.web:service=WebServer')

# Next steps

That's great that you can inject Java components into your Ruby components.
Next, we need to make it possible to cross-inject your Ruby components into
your other Ruby components.  And perhaps (maybe, possibly), we'll let you implement
EJBs in Ruby and inject them into your Java.  Just maybe.
