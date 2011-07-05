---
title: 'Building TorqueBox'
author: Bob McWhirter
layout: news
timestamp: 2011-06-10t12:45:00.0-04:00
tags: [ ci, builds, incremental, cloudbees]
---

[qmx]: http://twitter.com/#!/qmx/status/85571888990003200
[2x-builds]: /2x/builds/
[CloudBees]: http://cloudbees.com/
[ci]: https://torquebox.ci.cloudbees.com/
[matrix]: /images/ci-post/jenkins-matrix.png
[Awestruct]: http://awestruct.org/
[Versions Maven Plugin]: http://mojo.codehaus.org/versions-maven-plugin/
[as7-reversion]: /images/ci-post/as7-reversion.png
[jboss-as-dist]: https://repository-torquebox.forge.cloudbees.com/upstream/org/jboss/as/jboss-as-dist/
[tangle]: https://github.com/torquebox/tangle

# Incremental Builds

Last week, Douglas Campos (@[qmx]) brought attention to our [incremental builds][2x-builds]
page, powered by [CloudBees], and others in the Twitterverse asked how it all works.  

First, what we call **incremental builds** are what other people might refer to as 
**CI builds**, **developer builds**, or **nightly builds**.  We felt that none of those terms
matched what we were doing.  "Nightly" implies that it is produced, well, every night. Our builds 
occur every time there's a commit though.  A "developer build" implies a certain
scariness of a random build produced by a developer on his laptop; yet our builds are produced by
the same sanctioned infrastructure that produces our "real" releases. And "CI builds" focuses
on the tooling, not the product.

So we landed on "incremental builds" as an appropriate name.  These are bonafide builds,
produced using our normal release mechanisms, passing all of our tests (or not), produced every 
time someone changes the code.

# CI as the Core

Our [continuous integration (CI)][ci] server is hosted by [CloudBees], and is a nice
cloud-hosted version of the Jenkins tooling.  

Our build is maven-based, and we build against Ruby 1.8 and and Ruby 1.9 modes all
the time.  Jenkins supports this with its **matrix builds** functionality.  Since we're
in the cloud, the job kicks off both builds simultaneously.

![Matrix configuration][matrix]

This ultimately adds a `-Druby_compat_version=1.8` or `-Druby_compat_version=1.9` to each
leg of the matrix build.

# The friendly page

While Jenkins is awesome for driving the builds, we wanted the results gathered
nicely, along with producing links to the artifacts from the build, and branded
to match the TorqueBox site.   Thankfully, Jenkins supports a rich **jsonp** 
API which we drive with some jQuery to produce the [incremental builds][2x-builds]
page.  The site is produced using [Awestruct] and is 100% static, so being able to
add dynamic data from our build tools using JavaScript is fantastic.

<a href="/images/ci-post/2x-builds.png"><img src="/images/ci-post/2x-builds.png" style="width: 500px"/></a>

The above screenshot shows some passing builds, some failing builds, and a build that
is just getting started (click for a larger view).

In 3 jsonp calls, we are able to populate both the primary historical table of links
and wire up the "last good build" links at the top.  

# Build artifacts

The tail end of the build uses `curl` to push built artifacts from the 1.8 build
to our DAV repository.  We liberally apply `mod_rewrite` in `.htaccess` files to
produce links under `torquebox.org` to the binaries and documentation.

Additionally, TorqueBox includes a handful of RubyGems, and instead of publishing
our incremental gems to **rubygems.org**, our build creates a fresh RubyGem repository
for each build (also linked from the [incremental builds][2x-builds] page for each
build).  Once again using `mod_rewrite` we're able to gather it all under our
`torquebox.org` site, proxying back to our DAV repository.

This enables easy consumption of TorqueBox via:

    gem install torquebox-server --pre \
      --source http://torquebox.org/2x/builds/LATEST/gem-repo/

# Moving target

Since May, the TorqueBox team has been tracking the progress of JBoss AS7. The AS7 team has been 
working fast and furiously, but their official releases (Beta, CR, etc) have included large gaps
between them.  If we had only followed their release schedule, our code would have diverged
entirely too much to be effective.  On the other hand, had we consumed *their* CI builds,
there would have been too much churn.

Instead, we followed the strategy of producing our own AS7 builds, and rebasing TorqueBox
against the JBoss AS code on our own schedule, with builds we created.  Tyipcally every week to
10 days we'd adjust our build to use the latest nightly of AS7.  While we ultimately still
had to accomodate all the changes occurring within AS7 (some of them rather large), we were able
to organize our time and jump through these hoops when convenient for us.  Additionally,
since we consider AS7 our upstream, we were able to submit patches to their repository, and
see the changes much quicker than if we'd waited for their next official drop.

This strategy represented a slight challenge, because working with Maven **SNAPSHOT** dependencies
is a recipe for insanity and non-repeatable builds.  What we wanted was "real" releases
of AS7 to work against, but on our schedule.

To achieve this, we setup a true nightly (once a day) job to build JBoss AS7, but to
also use the [Versions Maven Plugin] to re-version the SNAPSHOT POMs to psuedo-versioned
POMs before performing the build.

![AS7 reversion][as7-reversion]

This produces JBoss AS7 builds with versions like **7.x.incremental.50**.  We collect all
of these artifacts in another [DAV-based Maven repository][jboss-as-dist]. Since these
are not `SNAPSHOT` dependencies, but rather are discretely versioned, we don't have to be
concerned about unintentional version skew.  Additionally, each team member can fetch
the rebased mainline at their own convenience, instead of being forced to take the
latest `SNAPSHOT` at some inopportune moment.

# Tangential

One of the nice things about Jenkins is that you can trigger builds from your repository,
instead of having your CI tool poll routinely.  One of the nice things about Git is that
you can have many branches.  Unfortunately, pushing to any branch on GitHub causes the
trigger to fire against Jenkins.  Our team works with a fair number of branches, and 
this caused some spurious un-needed builds.  In our default case, without any "extra"
branches, we are maintaining both the 1.x and 2.x code-lines currently.  Each has its own
job in Jenkins, but obviously share the same GitHub repository and post-commit hook.

To solve this, a [quick Sinatra app][tangle] sitting between GitHub and Jenkins inspects the 
payload from the post-commit hook, and filters/routes the trigger to the appropriate
Jenkins job based upon the branch that is actually being pushed.

# CI is for more than just code

This site (you're soaking in it) is also produced using CI.  Being a static site, we simply
edit it locally, check it into GitHub, and Jenkins builds it (using [Awestruct]) and publishes
it.  When we push to our `master` branch, CI will publish the results on our staging server,
and when we push to our `production` branch, CI publishes it all to the live production site.

# Helpful links

* [Basic `jenkins.js`](https://github.com/torquebox/torquebox.org/blob/master/javascripts/jenkins.js)
* [Our 2.x page renderer](https://github.com/torquebox/torquebox.org/blob/master/2x/builds/incremental-builds.js)
* [`Tangle` post-commit hook router](https://github.com/torquebox/tangle)
* [`.htaccess` for build artifact proxying](https://github.com/torquebox/torquebox.org/blob/master/2x/builds/.htaccess)
