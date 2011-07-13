---
title: Maven Mechanics
layout: narrow
---

[jruby-maven-plugins]: http://github.com/torquebox/jruby-maven-plugins

# Introduction

Maven is a large and complicated beast.  The TorqueBox build sometimes
wildly man-handles Maven to accomplish stuff.  Sometimes the build avoids
Maven.  

These are their stories.

# Layout

## Code modules

The full TorqueBox build is made up of **jars** which are assembled into 
**modules** (in the sense of `JBoss Modules`), and **gems** which may include
3rd-party jars, and are made available through gem repositories, and included
in our distribution.

Java source the becomes a **module** is located under `modules/`, while Ruby
source that becomes a **gem** is located under `gems/`.

We call preparation of the distribution an "assembly", which is built under
`build/assembly/`.  Finally, it is compressed into a ZIP under `build/dist/'
for final distribution.

## Maven POM hierarchy

The entire build is a hierarchy, with a root `pom.xml` acting as both
the top-level "aggregator" which builds its children, and as the top-level
"parent" which provides configuration to its children.  While Maven can treat
aggregation separate from parentage (the TorqueBox 1.x build used this feature),
the 2.x build keeps both roles within the same POM.

The `gems/pom.xml` and `modules/pom.xml` descend from our root POM, and act
as the aggregators and parents to maven modules under each directory.

There also exists a simpler `support/pom.xml` to aggregate a variety of general
support projects (JavaDoc style, testing support modules, etc).

The `build/pom.xml` drives the creation of the assembly and distribution zip.

## Inheritence from other JBoss POMs

Our own root POM inherits from the `jboss-parent.pom` common to all JBoss projects.
This provides us with basic configuration regarding distribution management.

Our POM **imports** the `jboss-as-parent.pom` in order to align dependencies and
versions with our upstream JBoss AS.  This POM is responsibile for denoting the
versions of all jars we can expect to be provided by the AS.  Our own POMs should
**never** specify versions for anything provided by JBoss AS.

The `jboss-as-parent.pom` also controls more obtuse things, such as **dependency exclusions**.
For whatever reason, JBoss AS excludes some transitive dependencies which are **not**
made available to downstream projects such as TorqueBox.  We must respect those.  By importing
this POM, we get all of that.

# Dependency Management

For dependencies **not** provided by JBoss AS, our root-level POM should specify the
version we are bringing into the build.  Our root-level POM **should not** actually
declare the dependency.  The dependency itself should be added to the appropriate
leaf POM, without version.

Any version specified in `<dependencyManagement>` should reference a property defined
in the properties section if required.  Many times, while we may need to specify an
additional jar, the relevant version has been defined by `jboss-as-parent.pom` as
a property we may use.

    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-log4j12</artifactId>
      <version>${version.org.slf4j}</version>
    </dependency>

    <properties>
      <version.org.quartz-scheduler>1.8.5</version.org.quartz-scheduler>
      <version.org.slf4j>1.5.10</version.org.slf4j>
    </properties>

# Plugin Management

Our root-level POM includes `<plugins>` section to define common plugins and settings
which may be used by leaves either automatically or by invoking the correct `<execution>`.

For instance, the `rspec-maven-plugin` is configured for all portions of the build
automatically, adjusting for Ruby 1.8 vs Ruby 1.9 and setting properties such
as the `log4j` configuration.

# RubyGem dependencies

## RubyGems Proxy

We run a web-proxy at [http://rubygems-proxy.torquebox.org/](http://rubygems-proxy.torquebox.org/)
which sites between any Maven build and `rubygems.org`.  The purpose of the proxy is to appear
as a Maven repository which holds artifacts with a `groupId` of `rubygems`, and can provide
a POM for any gem available from `rubygems.org`.

This repository is added to the TorqueBox build through the `build/settings.xml`.  As far as
Maven is concerned, we are adding regular dependencies, and their transitive dependencies,
thanks to the gemspec-to-POM conversion performed by the proxy.

Any RubyGem dependency specified through the POM using a `<dependency>` block is cached
in your local maven repository (`~/.m2/repository`) like any other Maven artifact,
under a deep and repetitive path.

### Caveat

In our CI build, the CloudBees Nexus is transparently inserted between Maven and any
other repository, including our RubyGems Proxy.  Occasionally, for unknown reasons,
the CloudBees Nexus will cache a zero-byte POM for a gem.  This will cause the build
to fail.  98% of all problems involving `json_pure` are related to a CloudBees Nexus
failure.

## Using RubyGems dependencies

The appropriate Ruby plugins will cause any Maven dependency of `<type>gem</type>`
to be installed into a local gem-path, typically `target/rubygems/` of the module
build built. This path is then used when running rspec tests.

When creating TorqueBox gems (modules under `gems/*`), the maven POM and its dependencies
affect the dependencies that will be specified in the resulting `.gemspec`.  

# Building a JBoss-Modules module

For each maven module under `modules/*`, the output is a JBoss-Modules "module".

A JBoss-Modules module is simply a directory containing some Jars, and a `module.xml`
descriptor.  For modules we create, we place the jar built in the same maven module,
along with the `module.xml` from `src/module/resources/module.xml`.

How `module.xml` works is outside the scope of this document.

# Build a RubyGem

For each maven module under `gems/*', the output is a RubyGem, which may or may
not be Java/JRuby-specific.

## Java Gems

For Java-centric gems, such as `torquebox-core.gem` the matching POM specifies
`<packaging>java-gem</packaging>`.  This instructs the Maven to use the 
[jruby-maven-plugins] to produce a Java-centric RubyGem as the primary artifact.

To accomplish this, the project is first built as a regular Java project to
produce a jar, if there are sources under `src/main/java`.  

To produce the RubyGem, sources from `lib/' are copied, along with the project's
own Jar, and any other `runtime` Jar dependency.

A ruby source file is synthesized as `lib/GEMNAME.rb` which performs two duties:

1. Loads all `lib/*.jar` into the classpath when the gem is loaded
2. Calls out to `lib/gem_hook.rb` if it exists, to perform additional load-time initialization

Generally `lib/gem_hook.rb` is where we, as gem authors, would place additional
`require 'gemname/something'` type of statements.

# Documentation

## DocBook

Under the `docs/` directory exist our DocBook sources, in sub-modules per
translation (en-US only at this point).

Under `src/main/fonts/` is the Fedora Liberation font-set used in creation
of the PDF documentation.

Under `src/main/xsl/` are various adjustments to the DocBook/JBoss-PressGang
XSL transformations to make things even prettier.

The JBoss-created `jdocbook-maven-plugin` is used to generate all of the documentation
output.  ePub is currently produced through bastardizatoin of the manpage process.

## JavaDocs

JavaDocs are created in the aggregate instead of for each leaf.  This is accomplished
using the `mvn site` goal and configuration in the root-level POM.

# Assembly

Assembly performs the following actions:

1. Takes stock JBoss AS7 and expands it in a staging directory.
2. Takes stock JRuby and expands it also.
3. Finds all of our JBoss-Modules modules, and installs them in JBoss `modules/` hierarchy.
4. Finds all of our RubyGems and installs them under the JRuby gem path.

This is complex, so the `build/assembly/pom.xml` very quickly invokes JRuby plugin
to execute a ruby script to perform these actions.  We **do not** attempt to do it
through Maven.  We **do** define our dependencies on the JBoss and JRuby distributions
through this POM, though, to take advantage of Maven's fetching and caching of these
artifacts.  We then use them from the local maven repository when unzipping.

# Integration Tests

Integration tests rely on a fully assembly.  Running the tests performs an rsync of the
assembly to copy used for testing.  

Before running tests, just as with other modules, all `<type>gem<type>` dependencies
are installed under `target/rubygems/` to support TorqueSpec and the needs of the
tests themselves.

Additional gems are installed somewhat outside of the maven process, using the 
`gem-maven-plugin`.

Since Maven only allows a single dependency on a given `groupId+artifactId` combination,
and our tests rely on several versions of the same artifact (for example Rails 2, Rails 3.0 
and Rails 3.1), we cannot use the maven mechanisms always.

    <execution>
      <id>install-rails2</id>
      <phase>test-compile</phase>
      <goals>
        <goal>install</goal>
      </goals>
      <configuration>
        <gemHome>${integ.dist.dir}/jruby/lib/ruby/gems/1.8</gemHome>
        <gemPath>${integ.dist.dir}/jruby/lib/ruby/gems/1.8</gemPath>
        <installArgs>rails -v ${version.rails2} --no-rdoc --no-ri</installArgs>
      </configuration>
    </execution>

# Magic on CI

Every action on CI is executed with the profile `-Pci` to provide a hook to do anything
CI-specific. The `-B` helps quiet maven some.

## Clean!

`mvn clean` is executed with `-Pinteg` and `-Pdist` to ensure that everything gets cleaned.

## Reversion

`mvn versions:set -DnewVersion=2.x.incremental.${BUILD_NUMBER}` is then executed, causing
the `SNAPSHOT` POMs we keep to become non-SNAPSHOT, with discrete numbers.  Once again
`-Pinteg` and `-Pdist` are added to ensure the entire build hierarchy gets reversioned.

## Build and test
`mvn install` is then executing, causing the entire build to occur, along with running
integration tests and zipping everything up.

## Create JavaDocs

JavaDocs run as part of the `site` lifecycle after the build complete successfully.

## Publish

`mvn install` is invoked against `build/incremental/pom.xml` instead of the root.
This quickly shells out to a ruby script to invoke curl to publish stuff to our
DAV repository.

## Private settings

Various things in CI need credentials.  These are kept in a private location
on the build machine, and used via `mvn -s /private/settings.xml`
