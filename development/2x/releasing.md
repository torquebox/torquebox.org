---
title: Releasing a Release
layout: default
---

[release-repo]: http://github.com/torquebox/torquebox-release

# Preparation

Code is released from the `2x-dev` branch of [torquebox/torquebox-release][release-repo].

Set up this repository as an additional remote for your workspace:

    git remote add release git@github.com:torquebox/torquebox-release.git

Ensure that the tag you are attempting to release does not exist in the release repository,
or maven will fail part way through the build

    git push release :2.0.0.cr1

Ensure that the `2x-dev` branch has the contents you wish to release.  Using the `-f`
flag to force is allowed in this case, since the **torquebox-release** repository is not
a public-facing human-cloneable repository.

    git push release 2x-dev:2x-dev -f

# Pre-flight build

Using the [build system](http://projectodd.ci.cloudbees.com/), select the 
**torquebox-2x-release** job.  This job may be easily found under the 
**Release** tab in CI.

<img src="/images/releasing/ci.png" style="width: 100%"/>

Enter in the version to release, followed by the **next** version after the release, and
select the **release-staging** profile.  The **release-staging** profile can build against
other projects also built to the **release-staging** repository.  This is useful when
performing a chain of releasing involving **polyglot**, **torquebox**, and **yaml-schema**
to ensure they all work together before publishing any to public repositories.

<img src="/images/releasing/start-preflight.png" style="width: 100%"/>

After each pre-flight build, you will need to reset the release repository:

    git push release :2.0.0.cr1
    git push release 2x-dev:2x-dev -f
    
When you are happy with the pre-flight build (in other words, it completes successfully), 
you're ready to run the real build.

# Perform the Builds

Using the [build system](http://projectodd.ci.cloudbees.com/), again select the 
**torquebox-2x-release** job, selecting the **release** profile this time.

<img src="/images/releasing/start-build.png" style="width: 100%"/>

# Verify the maven artifacts

Verify that the artifacts you expect have been uploaded and deployed to

[http://repository-projectodd.forge.cloudbees.com/release](http://repository-projectodd.forge.cloudbees.com/release)

# Manually deploy RubyGems

Once the build has completed, grab the gems from 
[https://projectodd.ci.cloudbees.com//job/torquebox-release/lastSuccessfulBuild/artifact/assemblage/assembly/target/stage/gem-repo/gems/](https://projectodd.ci.cloudbees.com//job/torquebox-release/lastSuccessfulBuild/artifact/assemblage/assembly/target/stage/gem-repo/gems/) using the 'all files as zip' link.

The **_support/publish-gems.rb_** will publish the gems for you in the above order. You'll just need to invoke it from
within the gems directory, or you can push each gem manually:

    gem push <gem_name>.gem
    
Either way, you'll need owner rights to do so - bug bobmcw or tcrawley.

# Build the release API documentation

Under the **Release** tab on CI, there is a **torquebox-2x-release-docs** job which builds
against a tag in the release git repository, and publishes the API documentation (JavaDoc
and RDoc) into a maven repository.  

<img src="/images/releasing/ci-docs.png" style="width: 100%"/>

As with the primary release job, you may select either
the **release-staging** or the public **release** repository to target, depending on your
confidence.  No preparation or modification of the release repository is needed.  In fact,
the exact tag pushed by the primary **torquebox-2x-release** job is required to build the docs.

<img src="/images/releasing/start-docs.png" style="width: 100%"/>

# Push changes from the release repository to the official repository

## Fetch the release commits locally:

    git fetch release

## Merge in the release commits:

    git merge release/2x-dev

## Push to the official repository

    git push origin 2x-dev

## Push the tag to the official repository

    git push origin 2.0.0.Beta1

# Release the project in JIRA

<img src="/images/releasing/jira-release.png" style="width: 100%"/>

# Announce it

## Post it on `torquebox.org`

## Notify the `torquebox-users@` list

## Tweet it.

## Set the /topic in #torquebox IRC channel using ChanServ (if you can).
