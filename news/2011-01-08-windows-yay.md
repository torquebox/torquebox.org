---
title: Windows, yay!
author: Bob McWhirter
layout: news
tags: [ windows ]
---

[windows.jira]: https://issues.jboss.org/secure/IssueNavigator.jspa?reset=true&jqlQuery=project+%3D+TORQUE+AND+%28summary+%7E+windows+OR+description+%7E+windows%29
[Git for Windows]: http://code.google.com/p/msysgit/
[jruby-maven-plugins]: https://github.com/mkristian/jruby-maven-plugins

After a number of JIRA issues [filed against TorqueBox on Windows][windows.jira] and 
learning that nagging Jim to expense a copy of Windows doesn't work, I
found myself at microsoft.com purchasing Windows 7 Home Ultimate Frisbee Edition.

I installed it into VMware Fusion, apparently wrongly choosing to be more
integrated with my host OSX machine.  This left my `$HOME` on the Windows side
as some synthetic, read-only aggregation of my `Documents`, `Pictures`, and other
useless folders.  Being read-only, though, irritated Maven a lot.

So I installed Windows 7 into VMware Fusion *again*, as a more isolated environment.
This is *highly recommended*.  Keep Windows as far as possible away from your OSX
treasures.

It took a solid 4 days of adjustments to the core TorqueBox code, our test
code, and our Maven build.  In the end, though, you can now build TorqueBox,
from sources, passing both unit and integration tests, on Windows. Yay!

All you need is a good JDK and Maven.  I also used [Git for Windows], which seemed to helpfully include
`bash`, `less`, `vim`, `tee` and anything else I thought I needed.  Quite a nice package.

Below are some of the items I learned or had to adjust during this past week.

## Build-related

### You can't expect to have `/bin/sh`

I know this seems fundamental, but living in the world of Unix-like operating-systems,
I don't even think before scratching out a shell script.  And our build had a shell script
to set up the integration-testing environment.

The obvious answer is to rewrite the script in Ruby.

### You can't expect to have `/bin/ruby`

Another part of build used a Rakefile to accomplish the construction of a RubyGem.
This is legacy, and not strictly required any longer, but it was still hooked into the
Maven build process.  Plus the aforementioned shell script that was rewritten into
a Ruby script; don't forget him.  He *is* important.

Everyone has `ruby` and `rake`, except Windows, apparently.  This we solved by
using the [jruby-maven-plugins] to use JRuby to execute the Ruby helper scripts from
within Maven.

### You can't have long command-lines

The previously-mentioned JRuby Maven plugins can either run Ruby scripts within
the maven process, or they can fork a new process.  We also use the RSpec plugin,
and it's good form to fork when running tests, to ensure your environment is clean.

Unfortunately, the JRuby Maven plugins, when forking, also setup the classpath of
the forked process to match the project's classpath.  This is actually sensible, except
in our case, that's a *cartload of jars*.  When you string them together on the command-line
launching JRuby, you very quickly exceed the 8k limit Windows has for command-line length.

The quick solution to this, best that I could find, is "don't fork". 

The longer-term solution, since I'm a committer to the JRuby Maven plugins, is to figure
out how to fork without automatically assuming the entire classpath needs to be set
on the forked process.

### Bash on Windows is nice, but sometimes problematic

I couldn't imagine doing any work on Windows without a sane shell, such as `bash`.  
It normally was awesome, except in some cases where the `$PWD` would end up having
a lowercase drive-letter, instead of an uppercase one.  This did not occur while using
`cmd.exe` as my command shell. 

## Code-related

### Paths, paths, paths

Java is supposedly *write once, run anywhere*, but that's a big fat lie.  There are
many places where users supply relative paths, typically in Unix format with forward slashes,
which might get joined to some base path, probably using the OS's *native* delimiters.

You can end up with whack paths such as

    C:\path\to\some\app/path/to/some/config.ru

Mix in some `bash` confusion on drive-letter case, code that assumes capitals, or
figures `C:\foo` is a relative path, and things start to break real bad.

In TorqueBox, we've already had a constant battle mixing the JBossAS sense of 
filesystems (using JBoss VFS) with Ruby's natural inclination to assume
local filesystem.  Mix in some confused path separator delimeters, bad
assumptions, and components that like to auto-escape back-slashes,
and you start seeing incomprehensible paths such as:

    vfs:///c:/path/to/some/app\c\:path\\to\\some\\app/path/to/some/config.ru

Awesome!

### Did I mention paths?

Being smarter than the average bear, we've been writing a fair number of unit
and integration tests.  Some of these tests provide inputs, and check for matching
outputs, to make sure our deployment-descriptors are all parsed and processed correctly.

On Unix, an input path of `/path/to/myapp` results in an output path of `/path/to/myapp`,

Our tests basically assert:

    rackRoot = "/path/to/myapp";
    deploy( ... );
    assertEquals( rackRoot, deployment.getRackRoot() );

On Windows, though, an input path of `/path/to/myapp` results in an output path
of `C:\path\to\myapp`.

The underlying code actually worked-as-expected, but the test's own expectations
were incorrect given the platform.  A fair bit of effort went into ensuring that
all of the tests' expectations were correct for both Unix and Windows.

It pained me, but now there are `isWindows()` checks scattered about some of the
tests, to adjust accordingly.

### Sketchy filesystem

It may be because I'm running Windows within VMware on my Mac, but in general, I felt
like the filesystem was sluggish to sync and reflect reality.

We have a test for `Rack::Reloader`, to ensure that modified files are indeed correctly
reloaded by this middleware.  This test deploys a simple Sinatra app that rewrites itself
after time passes.  On OSX, after the time had elapsed, test immediately detected
that the app had been modified and reloaded.  Success!

On Windows, there was a definite lag between the the application rewriting itself
and file-system tests noticing the modification.

I found one checkbox in the Windows control panels to make the filesystem
sync faster, but I might've missed some other setting.  Or my hypervisor might
be to blame. 

Another test involved setting up a copy of test data, then performing tests against it.

Simple file-existence checks fail immediately after copying the files into place. 

## Bottom line

In general, this has not been the most fun week I can remember.  But in the end, I think
the exercise has been worthwhile.

It should result in higher-quality releases for Windows platforms, plus lower the bar
for Windows community members to start actively contributing to the code.  
