---
title: BENchmarking TorqueBox Round 2 - Redmine
author: Ben Browning
layout: news
tags: [performance, benchmarks, jruby]
---

[redmine]: http://www.redmine.org
[trinidad]: https://github.com/calavera/trinidad
[glassfish]: https://github.com/jruby/glassfish-gem
[passenger]: http://www.modrails.com/
[unicorn]: http://unicorn.bogomips.org/
[thin]: http://code.macournoyer.com/thin/
[jruby]: http://www.jruby.org
[ree]: http://www.rubyenterpriseedition.com/
[mri]: http://www.ruby-lang.org/
[first round]: /news/2011/02/23/benchmarking-torquebox/
[tsung]: http://tsung.erlang-projects.org/
[features]: /features/
[tsung_xml]: https://github.com/torquebox/speedmetal/blob/2011-03-14/apps/rails2/redmine-1.1.1/tsung.xml
[server_script]: https://github.com/torquebox/speedmetal/blob/2011-03-14/scripts/setup_server.sh
[redmine source]: https://github.com/torquebox/speedmetal/tree/2011-03-14/apps/rails2/redmine-1.1.1
[redmine_config]: https://github.com/torquebox/speedmetal/blob/2011-03-14/apps/rails2/redmine-1.1.1/README.md
[torquebox_tsung]: http://dist.torquebox.org/benchmarks-round-2/torquebox/report.html
[torquebox_raw]: https://github.com/torquebox/speedmetal/tree/2011-03-14/results/rails2/redmine-1.1.1/torquebox/20110311-14:23/
[trinidad_tsung]: http://dist.torquebox.org/benchmarks-round-2/trinidad/report.html
[trinidad_raw]: https://github.com/torquebox/speedmetal/tree/2011-03-14/results/rails2/redmine-1.1.1/trinidad/20110311-19:30/
[glassfish_tsung]: http://dist.torquebox.org/benchmarks-round-2/glassfish/report.html
[glassfish_raw]: https://github.com/torquebox/speedmetal/tree/2011-03-14/results/rails2/redmine-1.1.1/glassfish/20110312-14:13/
[passenger_ree_tsung]: http://dist.torquebox.org/benchmarks-round-2/passenger_ree/report.html
[passenger_ree_raw]: https://github.com/torquebox/speedmetal/tree/2011-03-14/results/rails2/redmine-1.1.1/passenger_ree/20110311-15:17/
[passenger_tsung]: http://dist.torquebox.org/benchmarks-round-2/passenger/report.html
[passenger_raw]: https://github.com/torquebox/speedmetal/tree/2011-03-14/results/rails2/redmine-1.1.1/passenger/20110312-14:13/
[unicorn_ree_tsung]: http://dist.torquebox.org/benchmarks-round-2/unicorn_ree/report.html
[unicorn_ree_raw]: https://github.com/torquebox/speedmetal/tree/2011-03-14/results/rails2/redmine-1.1.1/unicorn_ree/20110311-16:43/
[unicorn_tsung]: http://dist.torquebox.org/benchmarks-round-2/unicorn/report.html
[unicorn_raw]: https://github.com/torquebox/speedmetal/tree/2011-03-14/results/rails2/redmine-1.1.1/unicorn/20110312-14:13/
[thin_tsung]: http://dist.torquebox.org/benchmarks-round-2/thin/report.html
[thin_raw]: https://github.com/torquebox/speedmetal/tree/2011-03-14/results/rails2/redmine-1.1.1/thin/20110312-14:13/
[contact_us]: /community


Round 2 of our TorqueBox benchmarks compares the performance of
[Redmine][] running under:

* TorqueBox, [Trinidad][], and [GlassFish][] on [JRuby][] 1.5.6
* [Passenger][] and [Unicorn][] on [REE][] and [MRI][] 1.8.7
* [Thin][] on [MRI][] 1.8.7

Our [first round][] gave an idea of the relative performance of these
servers with simple, contrived applications and you predictably asked
to see benchmarks against a real-world application. Thus, we give you
Round 2. Even if you're not a JRuby user stick around for the REE vs
MRI graph at the end.

# Why Redmine?

Redmine was chosen because it was put forth by several members of the
community as a well-known, real-world Rails application. Redmine uses
Rails 2.3.5 and only runs on Ruby 1.8.x. For the next round, we'd like
to do a Rails 3 application that will run on Ruby 1.9 so please leave
well-known, open-source, Ruby 1.8 & 1.9-compatible application
suggestions in the comments.

# The Results

Before we take a look at the results, there are a few important points
you need to know:

* After an initial 10 minute warm-up period, client load increases
  every 10 minutes until the end of the 80 minute benchmark.

* Not all servers were able to complete every benchmark. Once the
  average latency climbs too high the incoming requests back up too
  much and the majority of simulated users receive connection
  timeouts. Eventually our [Tsung][] client crashes, unable to fork
  enough child processes to maintain the needed open connections.

* The latency graph has a logarithmic y-axis and all the rest are
  linear.

If you'd like to see all the information on test setup and server
configurations keep reading after the graphs where we'll go into the
details and provide links to all the raw results with lots of
additional information and metrics not summarized here.

**Top Servers**

[<img src="/images/benchmarks/round2/compare_top_thumb.png" alt="Top Servers"/>](/images/benchmarks/round2/compare_top.png)

**Comments**

The latency graph is quite interesting - TorqueBox maintains an
average latency of < 512ms and Passenger a respectable 1
second. Unicorn has similar latency to Passenger until about 30
minutes into the benchmark when Unicorn climbs to an average of over
30 seconds. Trinidad's latency climbs the most at the start and ends
with an average of over 16 seconds.

Trinidad and TorqueBox have similar throughput despite Trinidad's
latency issues. Similarly, Passenger and Unicorn are about the same on
throughput but both lower than Trinidad and TorqueBox.

Unsurprisingly, TorqueBox uses the most memory. We have a lot of
application server pieces ([messaging, scheduling,
services][features]) loaded that the other servers don't, so a
comparison between a web-only TorqueBox and these same servers might
be interesting.

**JRuby Servers**

[<img src="/images/benchmarks/round2/compare_jruby_thumb.png" alt="JRuby Servers"/>](/images/benchmarks/round2/compare_jruby.png)

**Comments**

GlassFish fares far worse than TorqueBox and Trinidad on all
fronts. We double-checked the configuration to make sure it's running
in production environment and with the same amount of memory and http
threads as the other JRuby servers but it still performs very
poorly. The CPU usage is so low that it looks like it may be
processing requests serially but `config.threadsafe!` was enabled and
the JRuby min/max runtimes set to 1 just like with the others. If
anyone experienced with the GlassFish gem has insight on what we may
be doing wrong, please let us know.

**MRI Servers**

[<img src="/images/benchmarks/round2/compare_mri_thumb.png" alt="MRI Servers"/>](/images/benchmarks/round2/compare_mri.png)

**Comments**

Note these graphs show Passenger and Unicorn running under MRI 1.8.7,
not REE as shown on the Top Servers graph. As expected, Thin's
throughput, CPU usage, and memory usage were substantially lower than
Passenger or Unicorn because Thin can only utilize 1 of the 8 CPU
cores. Because of this we won't include it in any future benchmarks
unless clustered behind Apache or Nginx.


**REE vs MRI**

[<img src="/images/benchmarks/round2/compare_ree_thumb.png" alt="REE Comparison"/>](/images/benchmarks/round2/compare_ree.png)

**Comments**

While not directly related to TorqueBox, we thought it would be
interesting to show an MRI vs REE comparison. REE provides a definite
advantage to all metrics, especially under low to medium client load.

The throughput is 80% better and latency stays lower longer under REE
while using 20% less CPU and 500MB less memory than MRI.

# The Details

All the benchmarks were run on Amazon EC2 using a separate m1.large
client instance, c1.xlarge server instance, and db.m1.large Amazon RDS
database instance for each test. All instances were started in the
same availability zone and every test started from a clean database
with only Redmine's default data loaded.

## Client Setup

Our benchmarking client was [Tsung][], chosen for its ability to
simulate large, distributed client loads with minimal resources and I
have previous experience with it. If you're familiar with Tsung,
here's the [xml file][tsung_xml] used in these benchmarks.

We start with 2 new users arriving every second, increasing up to 45
users arriving every second by the end of the 80 minute
benchmark. Each user has a 98% chance to browse around the site and a
2% chance to create a new issue in Redmine. We initially tested the
servers using a 20% chance to create a new issue but the volume of
issues created during the benchmark was making the write speed of our
database a major bottleneck. Even with just a 2% chance we still
create over 2,500 issues during the benchmark.

## Server Setup

We have a [script][server_script] to install the necessary server
software on each instance. A copy of the exact [Redmine source][] is
in our GitHub repository. The only changes from a vanilla Redmine
1.1.1 download are to enable `config.threadsafe!` and load the
`activerecord-jdbc-adapter` gem when running under JRuby.

The exact command and/or config file used to launch each server is
contained in a [README.md][redmine_config] inside our Redmine
directory. The important bit is TorqueBox, Trinidad, and GlassFish
were started with a 2GB heap size and 100 maximum threads (to match
our database pool size) and Passenger and Unicorn were started with 18
workers to go by the guidelines of 2N+2 where N is the number of CPU
cores. For thoroughness I did test Passenger with a higher
`max-pool-size` but actually saw a slight decrease in throughput.

# Tsung Reports and Raw Results

In addition to the graphs shown above, I've provided links below to
the Tsung-generated reports and the raw Tsung results and logs
containing graphs and statistics over more metrics for each server.

**TorqueBox**

[Tsung Report][torquebox_tsung]
[Raw Results][torquebox_raw]

**Trinidad**

[Tsung Report][trinidad_tsung]
[Raw Results][trinidad_raw]

**GlassFish**

[Tsung Report][glassfish_tsung]
[Raw Results][glassfish_raw]

**Passenger w/ REE**

[Tsung Report][passenger_ree_tsung]
[Raw Results][passenger_ree_raw]

**Passenger**

[Tsung Report][passenger_tsung]
[Raw Results][passenger_raw]

**Unicorn w/ REE**

[Tsung Report][unicorn_ree_tsung]
[Raw Results][unicorn_ree_raw]

**Unicorn**

[Tsung Report][unicorn_tsung]
[Raw Results][unicorn_raw]

**Thin**

[Tsung Report][thin_tsung]
[Raw Results][thin_raw]


As always we encourage questions and feedback. If you need some help
reproducing these results or interpreting the Tsung reports and raw
results leave us a comment or ping us via [mailing lists, IRC, or
Twitter][contact_us].
