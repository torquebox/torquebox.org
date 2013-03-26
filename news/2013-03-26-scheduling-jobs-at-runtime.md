---
title: 'Scheduling jobs at runtime'
author: Marek Goldmann
layout: news
timestamp: 2013-03-26T16:00:00.0Z
tags: [ jobs ]
---

# Scheduled jobs?

TorqueBox has support for scheduled jobs since the beginning of the project.
Scheduled jobs can be very helpful when you want to do something not
necessarily now but at some point in the future. If you are familiar with [cron
expressions](/documentation/2.3.0/scheduled-jobs.html#jobs-format) you even
know how to define the job trigger time. If you don't - don't worry - it's easy
to understand. Jobs implementations are plain [Ruby
classes](/documentation/2.3.0/scheduled-jobs.html#ruby-job-classes), nothing
special about them besides the requirement for the `run` method. That's all.
TorqueBox cares about getting the job done at the right time.

Simple and still cool.

But there was one issue related to scheduled jobs - you could create them only
at the deployment time. We fixed this - you can create scheduled jobs at
runtime now too.

# Runtime!

With the latest changes to the TorqueBox codebase we can now use full power of
scheduled jobs with the flexibility of runtime scheduling. Let's start with an
example.

    TorqueBox::ScheduledJob.schedule('Counter', '*/10 * * * * ?')

This simple call will run the `Counter` job every 10s. As simple as this. If
you think the job is executed too often, you can redefine the cron expression
and run it for example once a minute:

    TorqueBox::ScheduledJob.schedule('Counter', '0 * * * * ?')

The `schedule` method is synchronous - it waits until the job is fully deployed
and returns `true` afterwards. There is a default wait time set to 5s. If the job
is not created by this time - the method returns `false`.

There are many other options like customizing the wait time as well as the job
name and others too. Please refer to the [RDoc documentation for the `schedule`
method](/builds/yardocs/TorqueBox/ScheduledJob.html#schedule-class_method).

## Job names

The job replacement feature will work as long as the job name will be the same.
By default the job name is set to the job class name, so in above example it'll
be 'Counter'. When the class name includes module name, like this:
`SomeModule::Counter` the job name will be set to 'SomeModule.Counter'. We
cannot have '::' in the job name because of internal JBoss AS service naming
requirements.

We suggest to define the job name yourself:

    TorqueBox::ScheduledJob.schedule('Counter', '0 * * * * ?', :name => 'job.counter')

This will make it easier to look it up later, for management.

## Job management

It's also easy to do simple management of a scheduled job:

    job = TorqueBox::ScheduledJob.lookup('Counter')
    job.started? # true
    job.stop
    job.status   # STOPPED
    job.start
    job.status   # STARTED

And if you are tired with this job, you can remove it too:

    job.remove

# When we want to have even more control...

Sometimes the cron expression is not flexible enough to meet your needs. We
hear you! Please wolcome 'at' jobs!

## Hi 'at' job!

There are different ways to schedule a job besides using cron expressions.

### At, every, until

    TorqueBox::ScheduledJob.at(
        'Checker',
        :at => Time.now + 10,
        :every => 500,
        :until => Time.now + 70
    )
 
This job will be run for the first time 10 seconds from now (`:at` parameter),
every 500 ms (`:every` parameter) and will stop after 1 minute from the first
execution (`:until` parameter).

If the `:at` parameter is not set, it'll be set to `Time.now`.

### In, every, until

    TorqueBox::ScheduledJob.at(
        'Checker',
        :in => 10_000,
        :every => 500,
        :until => Time.now + 70
    )

This style is very similar to the previous example with the difference that
instead of specifying the time of the first job execution you define the delay
(in ms) from now. This example is equal to the previous one in terms of result.

### At, repeat, every

    TorqueBox::ScheduledJob.at(
        'Checker',
        :at => Time.now + 10,
        :repeat => 5,
        :every => 1_000
    )

This style focuses on the count of job executions. This job will be exevuted
for the first time in 10s and repeated 5 times every 1s. Please note that the
total count of executions will be 6, since the first is not counted.

You can replace the `:at` with `:in` parameter just like shown in the :in,
:every, :until example.

## And there's even more!

Just like the `schedule` method, the `at` method returns `true` or `false`
depending if the job was scheduled or timed-out. 

Every 'at' job has many configurable options like defining the name,
description, or specifying the data to be injected to the job constructor
method. Everything is described in the [Ruby documentation for `at`
method](/builds/yardocs/TorqueBox/ScheduledJob.html#at-class_method).

# When it'll be available?

We plan to include these new features in the next TorqueBox release. But if
you're eager to test them - use one of our [incremental builds](/builds/). It's
already there!

