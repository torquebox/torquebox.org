---
title: JBoss AS7 Snapshot Repository
layout: default
---

[asfork]: https://github.com/torquebox/jboss-as
[asci]: https://torquebox.ci.cloudbees.com/job/jboss-as7/

# These are not the droids you are looking for.

This URL represents a Maven repository serving the snapshot build of
JBoss AS7 that the TorqueBox team is currently developing against.

## What?

The TorqueBox team neither wants to be so staid as to wait for the
JBoss AS7 team to perform official releases nor so extreme to 
track "whatever in's GitHub".

Given this, the team has [taken a fork of the JBoss AS7 repository][asfork],
which we rebase every week or so.  The version we build against
is itself [built by our incremental-builds system][asci].

Ultimately, that built JBoss AS7 is delivered as a Maven repository
**right here**.

## Umm..?

So, given this, our build includes this URL as a repository to satisfy
our dependencies on JBoss AS7:

    <repositories>
      <repository>
        <id>jboss-as-snapshots</id>
        <name>JBoss AS Snapshots</name>
        <url>http://torquebox.org/2x/jboss-as-repo</url>
        <layout>default</layout>
        <releases>
          <enabled>false</enabled>
        </releases>
        <snapshots>
          <enabled>true</enabled>
          <updatePolicy>never</updatePolicy>
        </snapshots>
      </repository>
      ...
    </repositories>
