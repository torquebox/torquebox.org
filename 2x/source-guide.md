---
title: TorqueBox Source Guide for TorqueBox 2.0 on JBoss AS 7.x
layout: default
---

[jdk]: http://www.oracle.com/technetwork/java/javase/downloads/index.html
[maven]: http://maven.apache.org/
[msysgit]: http://code.google.com/p/msysgit/downloads/list

The TorqueBox team welcomes anyone brave enough or crazy enough to attempt to dive into the code.  
If that's overwhelming, we also welcome anyone who wants to help out with documentation, articles, 
speaking or other contributions.

For those that want to dive into the code, we offer this rough guide to what's what.

# Software Requirements

To begin building TorqueBox from source, you'll need to ensure you have the following
installed on your system:

* [Java Development Kit (JDK) 1.6+][jdk]
* [Apache Maven 3.0+][maven]
* Git, if building from the repository

If you are on OSX, the JDK that Apple ships is appropriate.

# Obtain the source

If you are contributing to the code, you'll likely want to pull the source from our
GitHub repository:

* [https://github.com/torquebox/torquebox](https://github.com/torquebox/torquebox)

# Maven setup

Building of TorqueBox uses the Maven build system.  Maven pulls dependencies from
repositories through the course of the build.  You must configure Maven to be aware
of the JBoss repository by creating or adjusting your `$HOME/.m2/settings.xml`.

The TorqueBox distribution includes a `settings.xml` that you may use directly
from the commandline, or integrate into your personal `settings.xml`.

In the checked-out source tree, it is located as
`support/settings.xml`.  In GitHub you may find it
[here](https://github.com/torquebox/torquebox/blob/2x-dev/support/settings.xml). To
use our `settings.xml` directly from the commandline, replace all
`mvn` commands below with `mvn -s support/settings.xml`.

You'll also need to give Maven extra memory for the build by setting
the `MAVEN_OPTS` environment variable.

    export MAVEN_OPTS="-Xmx512m"

# Build

## Simple

From the root of the source-tree, a complete build can be performed:

    mvn install

This will build a complete "assembly" of TorqueBox, laid out on disk
in a usable fashion.

Once the build completes successfully, the assembly will be located
under:

    build/assembly/target/stage/torquebox/

This directory is appropriate to use as a `$TORQUEBOX_HOME`

## Piece-meal rebuilding

Most pieces can be individually rebuilt and installed into an existing
assembly by changing into the component's directory and invoking

    mvn install

## Very clean rebuilding

From the root of the source-tree, to perform a complete `clean`:

    mvn clean -Pfull

Additionally, to begin from a nil state, you may desire to cleanse
portions of your local Maven repository under `$HOME/.m2/repository/`.

    rm -Rf ~/.m2/repository/org/torquebox/
    rm -Rf ~/.m2/repository/rubygems/torquebox*

## Running tests under ruby 1.9 

By default, JRuby acts as compatible with ruby 1.8.7. If you want
to run the rspec tests as ruby 1.9.2, use the `19` profile:

    mvn install -P19,integ

# Source layout

The source-tree is broken into a few large sub-trees:

### `support/`

Components used during the build, but not at runtime.

### `modules/`

Contains JBoss Modules type of "modules".  Each subsystem (web,
messaging, jobs, security, etc) is represented by a module directory
under `modules/`.  Additionally, more invisible extensions, such as
CDI-based injections in the `cdi` module is broken out.

If a module has a ruby component, it's counterpart should be located
under `gems/` with the same name.

### `gems/`

Each subsystem may include a ruby portion that is conveniently 
handled as a traditional RubyGem.  These are kept under the
`gems/` top-level directory.

### `build/`

Contains sub-projects for building the assembly (see above)
and packaging it into a ZIP archive.

# Source Patterns and Wayfinding

## JBoss Modules `module.xml`

Each module requires `module.xml`.  It lives under
`src/module/resources/module.xml`.

Currently this file is manually-maintained for each module.  It describes
which other modules it depends upon, and what classes it might optionally export.

Dependency modules may be found under the `$JBOSS_HOME/modules/` tree.  

The `module.xml` is copied and filtered for POM properties during the build,
which allows usage of `${project.version}` and `${version.some.dependency}` to
avoid extra manual book-keeping.

Very few classes should ever be exported.

## JBoss AS 7.x Subsystems/Extensions

Many of the modules under `modules/` represent bonafide JBoss AS 7.x
extensions, or subsystems.  JBoss AS provides certain boilerplate contracts
we must follow to jack into the core.

### Packaging

For a subsystem `foo`, the root package should be:
   
    package org.torquebox.foo

A subpackage of `org.torquebox.foo.as` should include the AS extension
boilerplate classes.

### Classes

Under `org.torquebox.foo.as`:

    FooDependenciesProcessor.java
    FooExtension.java
    FooServices.java
    FooSubsystemAdd.java
    FooSubsystemParser.java
    FooSubsystemProviders.java
    Namespace.java

#### FooExtension.java

This is the primary entry-point to allow our extension to be added into
a booting JBoss AS 7.  This file should be copied from an existing working
module, as it represents pretty much nothing but boilerplate.  

The important operational aspect is the registration of an action-to-take
when the extension gets loaded.

    subsystem.registerOperationHandler( ADD,
        FooSubsystemAdd.ADD_INSTANCE,
        FooSubsystemProviders.SUBSYSTEM_ADD,
        false );

You must specify this class name in a services file, located
at `src/main/resources/META-INF/services/org.jboss.as.controller.Extension`,
whose content should be a single line:

    org.torquebox.foo.as.FooExtension

During the build, the module for the extension gets added to the JBoss AS `standalone.xml`
file:

    <extension>
        <extension module='org.torquebox.jobs'/>
        <extension module='org.torquebox.messaging'/>
        <extension module='org.torquebox.services'/>
        <extension module='org.torquebox.foo'/>
    </extensions>

Additionally, the subsystem is enabled by adding more lines to the same file

    <subsystem xmlns='urn:jboss:domain:torquebox-jobs:1.0'/>
    <subsystem xmlns='urn:jboss:domain:torquebox-messaging:1.0'/>
    <subsystem xmlns='urn:jboss:domain:torquebox-services:1.0'/>
    <subsystem xmlns='urn:jboss:domain:torquebox-foo:1.0'/>

All of this XML editing is performed automatically by the build.

The `<subsystem>` element is handled by our `FooSubsystemParser`

#### FooSubsystemProvider.java

Just copy, adjust, it makes very little sense.

#### FooSubsystemParser.java

When JBoss AS boots and reads the `standalone.xml` file, it reaches
the `<subsystem>` tag in our module's namespace, and hands over parsing
responsibility to our extension's parser.

This class is 99% boilerplate.  The important aspect is the invocation
of the action-to-take that was registered in `FooExtension` above.

    final ModelNode address = new ModelNode();
    address.add(SUBSYSTEM, FooExtension.SUBSYSTEM_NAME);
    address.protect();

    list.add(FooSubsystemAdd.createOperation(address));

This code is responsible, I think, for converting the XML DOM-like model from
`standalone.xml` into operations that should be fired.  When our module
is handed the parsing responsibility, we know we've seen a `<subsystem>`
tag matching our subsystem, so we should add our start-up action
the the list-of-operations to be done.

The 4 lines above basically tell the AS we want our `FooSubsystemAdd`
class to be fired.

If your subsystem provides injection-support through an `InjectableHandler`
this is also the location to inform the injection-subsystem that your
extension would like to participate:

    list.add(InjectableHandlerAdd.createOperation(address, FooExtension.SUBSYSTEM_NAME, Module.getCallerModule().getIdentifier().getName() ) );

#### Namespace.java

Just a fancy way to store a String constant representing the XML namespace
for our subsystem. Used when registering our parser.

#### FooSubsystemAdd.java

The `FooSubsystemAdd` class represents our first real hook to perform subsystem-specific
setup and configuration.  This is where we set up any services that our subsystem provides,
along with registering our `DeploymentUnitProcessors`, aka "deployers".

Copy from an existing working module to get the basic shape.  

To install deployers, the `addDeploymentProcessors(...)` method is called.  Add any
new deployers here.

    protected void addDeploymentProcessors(final BootOperationContext context, final InjectableHandlerRegistry registry) {
        context.addDeploymentProcessor( Phase.STRUCTURE, 10, new KnobStructureProcessor() );
        context.addDeploymentProcessor( Phase.STRUCTURE, 20, new AppKnobYamlParsingProcessor() );
        context.addDeploymentProcessor( Phase.STRUCTURE, 100, new AppJarScanningProcessor() );
    }

Deployment occurs in phases, deterministically, with every deployer in the list getting a chance
to fire.

Available phases are defined in [org.jboss.as.servicer.deployment.Phase](https://github.com/jbossas/jboss-as/blob/master/server/src/main/java/org/jboss/as/server/deployment/Phase.java):

* STRUCTURE - Shape of the deployment, lib/**.jar handling
* PARSE - Reading configuration files, .yml
* DEPENDENCIES - Making modules/classes available to the deployment
* CONFIGURE_MODULE - Additional configuration of the deployment's classes
* POST_MODULE - After the deployment's full classloader has been configured
* INSTALL - Installing services
* CLEANUP - Un-making messes, I guess

Each core JBoss AS `DeploymentUnitProcessor` also has a constant in the same `Phase` file denoting
its phase and order-within-phase.  We should consider our deployers as running within that context.
It is useful to follow uses of various constants to determine what other deployers might affect
deployment, and what services they deploy.

## Services

In the AS6 codebase, anything we ended up describing as a `BeanMetaData<T>` ends up
being a [Service<T>](https://github.com/jbossas/jboss-msc/blob/master/src/main/java/org/jboss/msc/service/Service.java) in MSC's architecture. 
A service can have other values injected into it, and has a start/stop lifecycle.

One distinction from AS6, though, is a service may return a value, which is ultimately
used if the service is injected into another service.

For instance, in psuedo-code

    public class ConnectionFactoryService implements Service<ConnectionFactory> {

      public start(...) {
        this.factory = new ConnectionFactory();
        this.factory.setSomething( getSomeInjectedValue() )
        this.factory.start();
      }

      public getValue() {
        return this.factory;
      }

      public stop(...) {
        this.factory.shutdown();
        this.factory = null;
      }
    }

If the `ConnectionFactoryService` is used as an injected-value, `getValue()` will
be called, and the underlying `ConnectionFactory` is what will actually be injected.

### Lifecycle

Each service must implement `start(StartContext context)` and `stop(StopContext context)`.
In the `start(..)` method, the context is used to report completion, and may be used to
signal an asynchronous start for slow-starting services.  The `StartContext` also
provides facilities for executing a `Runnable` task to perform the async start.

### Injection

Unlike JBoss-MC, where injection used Java reflection, MSC uses the idea of an
[Injector](https://github.com/jbossas/jboss-msc/blob/master/src/main/java/org/jboss/msc/inject/Injector.java).

An `Injector` is a bucket that is handed to MSC to fill with the injected value.  A common
pattern is to use the concrete class of `InjectedValue<T>`.  Typically name the method
as `getFooInjector()`.  Here we inject a `FactoryFinder` into our service, storing
it in an `InjectedValue<FactoryFinder>`.


    public class ConnectionFactoryService implements Service<ConnectionFactory> {
      
      public Injector<FactoryFinder> getFactoryFinderInjector() {
        return this.factoryFinderInjector;
      }

      public start(...) {
        this.factory = this.factoryFinderInjector.getValue().findMyConnectionFactoryPlease();
        this.factory.setSomething( getSomeInjectedValue() ) 
        this.factory.start();
      }
    
      public getValue() {
        return this.factory;
      }

      public stop(...) {
        this.factory.shutdown();
        this.factory = null;
      }

      private InjectedValue<FactoryFinder> factoryFinderInjector = new InjectedValue<FactoryFinder>();
    }

Instead of using an `InjectedValue<T>` bucket to hold the value, you certainly
may use an anonymous implementation class of the `Injector<T>` interface to directly
insert the injected value into some location.

All injections will occur before `start(...)` will be called.

### Setting up services

Most services are set up during deployment of an artifact, by implementations
of `DeploymentUnitProcessors`.  During deployment, you can get ahold of a
[ServiceTarget](https://github.com/jbossas/jboss-msc/blob/master/src/main/java/org/jboss/msc/service/ServiceTarget.java).

When installing a new service, you actually instantiate the service object,
and add it to the registery with a unique `ServiceName`.  You can describe
its dependencies and injections, and then install it.

    ServiceRegistry target = phaseContext.getServiceTarget()

    Foo foo = new Foo();
    FooService service = new FooService( foo );
    ServiceName serviceName = FooServices.someService( "name" );

    target.addService( serviceName, service )
      .addDependency( BarServices.WEB_SERVER )
      .addDependency( FooServices.anotherService( "name" ), AnotherService.class, service.getAnotherServiceInjector() )
      .setInitialMode( Mode.PASSIVE )
      .install();

This code instantiates an actual `Foo`, wraps it in a `FooService` which implements
`Service<Foo>` and adds it to the `ServiceTarget`.

It then adds a dependency upon another service (`BarServices.WEB_SERVER` is a `ServiceName`),
while injecting a second sevice through an `Injector<AnotherService>`.

#### ServiceName and FooServices

Every service is identified through a `ServiceName`, which is composable/hierarchic.

Each extension may provide a `FooServices` class that defines any ServiceName constants
used to compose names, and helper static methods to create names.

For instance, to create unique `ServiceNames` to register ruby runtime pools, we
build the name off the application's own `ServiceName`, plus the name of the pool.

    ServiceName poolName = unit.getServiceName().append( 'torquebox', 'pools', poolName );

Or more easily wrap it in a helper on `CoreServices`

    public static final ServiceName TORQUEBOX = ServiceName.of( "torquebox" );
    public static final ServiceName POOLS = TORQUEBOX.append( "pools" );

    public static ServiceName rubyRuntimePool(DeploymentUnit unit, String poolName) {
        return unit.getServiceName().append( POOLS ).append( poolName );
    }
     
Now, to add a dependency/injection on the application's "messaging" pool, simply do
something akin to

    target.addService( serviceName, service )
      .addDependency( CoreService.rubyRuntimePool( unit, "messaging" ), RubyRuntimePool.class, service.getRubyRuntimePoolInjector() )
      .install();

## DeploymentUnitProcessors

`DeploymentUnitProcessors` are the new deployers.

They implement two methods: `deploy(..)` and `undeploy(..)`.

*Note*: All DeploymentUnitProcessors get called for every
 deployment. This means you need to check for the existence of the
 appropriate attachment (RubyApplicationMetaData,
 RackApplicationMetaData, etc) before writing code that uses those
 attachments.

### deploy(...)

    public void deploy(DeploymentPhaseContext phaseContext) throws DeploymentUnitProcessingException {
        DeploymentUnit unit         = phaseContext.getDeploymentUnit();
        ResourceRoot   resourceRoot = unit.getAttachment( Attachments.DEPLOYMENT_ROOT );
        VirtualFile    root         = resourceRoot.getRoot();

        # do work
    }

### Attachments

You still attach things to the `DeploymentUnit` to carry them between deployers.  The key, though,
is a plural-safe unique identifier, not a string or a class.

Attachable things should define an `ATTACHMENT_KEY` if only one can be attached under that key,
or `ATTACHMENTS_KEY` if multiple may be attached.

Single attachment keys are created on the attachable class such as:

    public static final AttachmentKey<RackApplicationMetaData> ATTACHMENT_KEY = AttachmentKey.create(RackApplicationMetaData.class);

Plural or list attachment keys are created like:

    public static final AttachmentKey<AttachmentList<PoolMetaData>> ATTACHMENTS_KEY = AttachmentKey.createList(PoolMetaData.class);


### Unit markers

FooMarker.mark, isMarked(...)


# Testing

## Running tests

When building each component, maven will run all tests (both JUnit- and RSpec-based)
before installing the component.

## Running individual tests

To run a subset of JUnit tests for a given module, you may use a matching string:

    mvn test -Dtest=*SomeTest
    mvn test -Dtest=*.rails3.*Test

To run single RSpec tests, you can specify `-Dspec=` and provide the path to the
spec, optionally including a line number.

    mvn test -Dspec=./specs/some_spec.rb:82

You may also use the generated `target/rspec-runner.rb` in the same way you would use
the normal `rspec` command-line tool.

    jruby ./target/rspec-runner.rb ./spec/some_spec.rb -l 82

## Running integration tests

By default, integration tests do not run in a typical build.  It you wish to 
include integration tests from a root-level build, add `-Pinteg` to the Maven
command-line:

    mvn install -Pinteg

Additionally, you may run the integration tests by themselves after creating
a complete assembly, by changing into the `integration-tests/` directory
and invoking `mvn test` without any additional parameters.

    cd integration-tests
    mvn test

## Skipping tests

Sometimes you may wish to skip tests

    mvn install -Dmaven.test.skip=true

# Windows notes

* Download a [JDK 1.6+][jdk] and [Maven 3.0+][maven] as mentioned above
* Set the `JAVA_HOME` environment variable, ensuring it has no spaces -
  ex: `C:\Progra~1\Java\jdk.1.6.0_24`
* Prepend `%JAVA_HOME%\bin` to the `Path` environment variable
* Unzip `apache-maven-3.0.3-bin.zip` to a directory
* Add a `M2_HOME` environment variable pointing to that directory
* Add a `M2` environment variable with value `%M2_HOME%\bin`
* Add a `MAVEN_OPTS` environment variable with the value `-Xmx512m`
* Prepend `%M2%` to the `Path` environment variable
* Download and install a recent [Git for Windows][msysgit]
  (Git-1.7.4-preview20110204.exe at the time of this writing). It's
  safe to accept the default installation options or customize as
  needed.
* Use Git Bash to checkout `https://github.com/torquebox/torquebox.git`
* Copy TorqueBox's Maven settings - `cp torquebox/build-support/settings.xml ~/.m2`
* `cd torquebox`
* `mvn install`

The `mvn install` can take quite a while the first time as it
downloads all the necessary dependencies. Be patient and it should
eventually succeed.

You can also build TorqueBox with `command.com` or `cmd` instead of
Git Bash. The same `mvn install` should work there.

To build piece-meal on Windows, Maven's `-pl` option is used.

    mvn install -pl components\web\web-core\

