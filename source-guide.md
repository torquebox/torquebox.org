---
title: TorqueBox Source Guide
layout: default
---

[jdk]: http://www.oracle.com/technetwork/java/javase/downloads/index.html
[maven]: http://maven.apache.org/

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

    assemblage/assembly/target/stage/torquebox-VERSION/

This directory is appropriate to use as a `$TORQUEBOX_HOME`

## Piece-meal rebuilding

Most pieces can be individually rebuilt and installed into an existing
assembly by changing into the component's directory and invoking

    mvn install

## Very clean rebuilding

From the root of the source-tree, to perform a complete `clean`

    mvn clean -Pinteg,dist

Additionally, to begin from a nil state, you may desire to cleanse
portions of your local Maven repository under `$HOME/.m2/repository/`.

    rm -Rf ~/.m2/repository/org/torquebox/
    rm -Rf ~/.m2/repository/rubygems/torquebox*

# Source layout

The source-tree is broken into a few large sub-trees:

### `build-support/`

Components used during the build, but not at runtime.

### `components/`

Top of the component tree for application-server integrations.
This is further broken down into a tree for each component,
such as `base`, `web`, `jobs`, etc.

Each component may contain:

* `-metadata/` holding configuration classes.
* `-spi/` holding interfaces
* `-core/` holding implementations
* `-int/` holding integration glue to the AS
* `-gem/` holding Ruby portions

### `clients/`

RubyGem clients for services such as messaging and naming.

### `containers/`

Slimmed-down out-of-the-AS containers for messaging and naming.

### `system/`

Integrations with other systems, like rake and capistrano.

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

Windows is weird.

The best strategy for working with Windows is to use the `command.com` shell
instead of bash, and to always build from the root of the source tree.

To build piece-meal on Windows, Maven's `-pl` option is used.

    mvn install -pl components\web\web-core\

Make sure JAVA_HOME does not contain a space. If you installed Java to
the default location, you'll need a JAVA_HOME like

    C:\Progra~1\Java\jdk1.6.0_24

