---
title: Releasing a Release
layout: default
---

[release-repo]: http://github.com/torquebox/torquebox-release

# Preparation

Code is released from the `master` branch of the [torquebox/torquebox-release][release-repo].

Set up this repository as an additional remote for your workspace:

    git remote add release git@github.com:torquebox/torquebox-release.git

Ensure that the tag you are attempting to release does not exist in the release repository,
or maven will fail part way through the build

    git push release :1.0.0.CR1

Ensure that the `master` branch has the contents you wish to release.  Using the `-f`
flag to force is allowed in this case, since the **torquebox-release** repository is not
a public-facing human-cloneable repository.

    git push release master -f

# Perform the Builds

Usin the [build system](http://torquebox.ci.cloudbees.com/), select the 
**torquebox-release** job.

<img src="/images/releasing/ci.png" style="width: 100%"/>

Enter in the version to release, followed by the **next** version after the release.

<img src="/images/releasing/start-build.png" style="width: 100%"/>

# Verify the maven artifacts

Verify that the artifacts you expect have been uploaded and deployed to

[http://repository-torquebox.forge.cloudbees.com/release](http://repository-torquebox.forge.cloudbees.com/release)

# Manually deploy RubyGems

Once the build has completed, grab it to your localhost, and for the entire set of 
TorqueBox gems, run this command, several times until successfully deploying all
gems:

    gem push *.gem

# Push changes from the release repository to the official repository

## Fetch the release commits locally:

    git fetch release

## Merge in the release commits:

    git merge release/master

## Push to the official repository

    git push origin master

## Push the tag to the official repository

    git push origin 1.0.0.CR1

# Release the project in JIRA

<img src="/images/releasing/jira-release.png" style="width: 100%"/>

# Announce it

## Post it on `torquebox.org`

## Notify the `torquebox-users@` list

## Tweet it.
