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

# Switch to the `as7` branch

    git checkout -b as7 origin/as7 -u

# Maven setup

Building of TorqueBox uses the Maven build system.  Maven pulls dependencies from
repositories through the course of the build.  You must configure Maven to be aware
of the JBoss repository by creating or adjusting your `$HOME/.m2/settings.xml`.

The TorqueBox distribution includes a `settings.xml` that you may use directly
from the commandline, or integrate into your personal `settings.xml`.

In the checked-out source tree, it is located as
`build-support/settings.xml`.  In GitHub you may find it
[here](https://github.com/torquebox/torquebox/blob/master/build-support/settings.xml). To
use our `settings.xml` directly from the commandline, replace all
`mvn` commands below with `mvn -s build-support/settings.xml`.

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

    mvn clean -Pinteg,dist

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

### `clients/` **DEPRECATED**

Code under `clients/` should move to an appropriate location
under `gems/`

### `system/` **DEPRECATED**

Integrations with other systems, like rake and capistrano.

Code under `system/` should move to an appropriate location
under `gems/`

### `assemblage/` **DEPRECATED**

This should be removed once `build/assembly/` is fully correct.

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
    list.add(InjectableHandlerAdd.createOperation(address, FooExtension.SUBSYSTEM_NAME, Module.getCallerModule().getIdentifier().getName() ) );

This code is responsible, I think, for converting the XML DOM-like model from
`standalone.xml` into operations that should be fired.  When our module
is handed the parsing responsibility, we know we've seen a `<subsystem>`
tag matching our subsystem, so we should add our start-up action
the the list-of-operations to be done.

The 6 lines above basically tell the AS we want our `FooSubsystemAdd`
class to be fired.

# Testing

## Running tests

When building each component, maven will run all tests (both JUnit- and RSpec-based)
before installing the component.

## Running individual tests

To run a subset of JUnit tests for a given module, you may use a matching string:

    mvn test -Dtest=*SomeTest
    mvn test -Dtest=*.rails3.*Test

To run single RSpec tests, you must first run a typical `mvn test` run.  Then
you may use the generated `target/rspec-runner.rb` in the same way you would use
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

