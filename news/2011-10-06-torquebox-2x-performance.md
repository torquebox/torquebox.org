---
title: 'TorqueBox 2.x Performance Benchmarks'
author: Ben Browning
layout: news
timestamp: 2011-10-06t12:00:00.0-04:00
tags: [performance, benchmarks, jruby, ruby-1.9]
---

[as7]: http://www.jboss.org/as7
[round1]: /news/2011/02/23/benchmarking-torquebox/
[round2]: /news/2011/03/14/benchmarking-torquebox-round2/
[spree]: http://spreecommerce.com/
[trinidad]: https://github.com/trinidad/trinidad
[passenger]: http://www.modrails.com/
[unicorn]: http://unicorn.bogomips.org/
[jruby]: http://jruby.org/
[ree]: http://www.rubyenterpriseedition.com/
[ruby19]: http://www.ruby-lang.org/
[tsung]: http://tsung.erlang-projects.org/
[application]: https://github.com/torquebox/speedmetal/tree/2011-10-06/apps/rails3/spree
[raw_results]: https://github.com/torquebox/speedmetal/tree/2011-10-06/results/rails3/spree
[torquebox_tsung]: http://dist.torquebox.org/benchmarks-round-3/torquebox-2.x/report.html
[torquebox_raw]: https://github.com/torquebox/speedmetal/tree/2011-10-06/results/rails3/spree/torquebox-2.x/20110930-15:21
[trinidad_tsung]: http://dist.torquebox.org/benchmarks-round-3/trinidad/report.html
[trinidad_raw]: https://github.com/torquebox/speedmetal/tree/2011-10-06/results/rails3/spree/trinidad/20111005-16:59
[passenger_ree_tsung]: http://dist.torquebox.org/benchmarks-round-3/passenger_ree/report.html
[passenger_ree_raw]: https://github.com/torquebox/speedmetal/tree/2011-10-06/results/rails3/spree/passenger_ree/20110930-15:41
[passenger_19_tsung]: http://dist.torquebox.org/benchmarks-round-3/passenger_19/report.html
[passenger_19_raw]: https://github.com/torquebox/speedmetal/tree/2011-10-06/results/rails3/spree/passenger_19/20110930-17:32
[unicorn_ree_tsung]: http://dist.torquebox.org/benchmarks-round-3/unicorn_ree/report.html
[unicorn_ree_raw]: https://github.com/torquebox/speedmetal/tree/2011-10-06/results/rails3/spree/unicorn_ree/20111003-12:40
[unicorn_19_tsung]: http://dist.torquebox.org/benchmarks-round-3/unicorn_19/report.html
[unicorn_19_raw]: https://github.com/torquebox/speedmetal/tree/2011-10-06/results/rails3/spree/unicorn_19/20111003-12:40
[contact_us]: /community

If you haven't heard by now, TorqueBox 2.x is powered by [JBoss
AS7][as7] which claims to be blazingly fast and lightweight. So,
naturally, we want to put those claims to the test and see how
TorqueBox 2.x stacks up against the competition.

Building on what we've learned from previous benchmarks ([round
1][round1], [round 2][round2]), this latest round of benchmarking
compares the performance of [Spree][spree] running under:

* TorqueBox on [JRuby 1.6.4][jruby]
* [Trinidad][] 1.2.3 on [JRuby 1.6.4][jruby]
* [Passenger][] 3.0.9 standalone on [REE][] and [Ruby 1.9.2][ruby19]
* [Unicorn][] 4.1.1 on [REE][] and [Ruby 1.9.2][ruby19]

Even if you're not a fan of JRuby, stick around to see how Ruby 1.9.2
compares to REE. From [round 2][round2] we know REE outperforms Ruby
1.8.7 but how does it compare to 1.9.2?

# Why Spree?

Spree is a well-known Rails 3 application that can run under Ruby 1.8,
1.9, and JRuby. Based on feedback from our Redmine benchmarks, we
wanted to make sure the next application could run under Ruby 1.9 for
an accurate comparison of JRuby vs C Ruby performance.

# The Setup

Spree is nice enough to ship with a set of sample data that we used
for benchmarking. The benchmark script simulates users browsing around
a few pages of the site, starting with a small number of concurrent
users and gradually increasing until it finishes after 80 minutes.

More details about the benchmark and links to the raw results are at
the bottom of the post.

# The Results

**Top Servers**

[<img src="/images/benchmarks/round3/compare_top_thumb.png" alt="Top Servers"/>](/images/benchmarks/round3/compare_top.png)

Ignoring the latency graph for a minute, it's obvious that the runtime
(JRuby vs Ruby 1.9.2) is the differentiator in throughput, CPU usage,
and free memory. TorqueBox and Trinidad have no appreciable difference
in these categories but both clearly outperform Passenger and
Unicorn. If you're concerned with maximizing throughput, minimizing
CPU usage, or minimizing memory usage under load then you can't go
wrong choosing either JRuby server.

However, what about the latency graph? This is a graph of the average
time taken for each request - in other words the average time a user
would have to wait for a page on the site to load. This is where the
difference in web servers, not runtimes, is readily apparent.

At peak load, TorqueBox has a lower latency than the nearest
competitor, Passenger, by a factor of 8 and beats out Trinidad by a
factor of 32. Note that the latency graph's y-axis has a logarithmic
scale.

So, in a common real-world scenario, let's assume our application has
a requirement that it must have an average response time of 1
second. How many requests per second can each server handle while
staying under this 1 second mark? Looking at the latency and
throughput graphs, we see that Trinidad can handle 45 requests per
second, Passenger 90 requests per second, Unicorn 100 requests per
second, and TorqueBox 130 requests per second. At peak load of 130
requests per seconds the average response time from TorqueBox is only
256ms, well under our 1 second requirement.

If you were still skeptical about the performance benefits of
switching to JRuby, the above graphs should be convincing enough to
give it a shot.

**TorqueBox 2.x vs TorqueBox 1.1.1**

[<img src="/images/benchmarks/round3/compare_torquebox_thumb.png" alt="TorqueBox 2.x vs 1.1.1"/>](/images/benchmarks/round3/compare_torquebox.png)

We've seen how TorqueBox 2.x stacks up against the competition, but
how does it compare to the latest 1.x stable release, TorqueBox 1.1.1?
Thanks in a large part to AS7, TorqueBox 2.x has lower latency, higher
peak throughput, less CPU usage, and less memory usage than TorqueBox
1.1.1.

**REE vs Ruby 1.9.2**

[<img src="/images/benchmarks/round3/compare_ree_19_thumb.png" alt="REE vs 1.9.2"/>](/images/benchmarks/round3/compare_ree_19.png)

Ruby 1.9.2 gives Passenger and Unicorn lower latency, higher
throughput, lower CPU usage, and more free memory than REE. From a
performance standpoint there's no reason why you shouldn't be using
1.9.2 if you must use a C Ruby.

# The Details

All benchmarks were run on Amazon EC2 using an m1.large [Tsung][tsung]
client instance, a c1.xlarge server instance, and a db.m1.large MySQL
database instance. All instances were started in the same availabilty
zone and every benchmark started from a clean database loaded with
Spree's sample data. Each benchmark run was performed twice on
separate days and the best of the two runs used for the graphs.

TorqueBox and Trinidad were set to use a 2GB heap and a maximum of 100
HTTP threads to match the database connection pool size. Unicorn and
Passenger were both started with 50 workers. From testing, 50 was the
sweet spot to get maximum throughput and anything over just increased
CPU usage and memory usage without any further increase in throughput.

The [Spree application][application] used for benchmarking and all
[raw results][raw_results] are available in our GitHub repository.

## Tsung Reports and Raw Results

If you'd prefer to take the raw data and analyze it yourself, the
Tsung-generated reports and raw Tsung results are available for each
server below.

**TorqueBox**

[Tsung Report][torquebox_tsung]
[Raw Results][torquebox_raw]

**Trinidad**

[Tsung Report][trinidad_tsung]
[Raw Results][trinidad_raw]

**Passenger w/ REE**

[Tsung Report][passenger_ree_tsung]
[Raw Results][passenger_ree_raw]

**Passenger w/ 1.9.2**

[Tsung Report][passenger_19_tsung]
[Raw Results][passenger_19_raw]

**Unicorn w/ REE**

[Tsung Report][unicorn_ree_tsung]
[Raw Results][unicorn_ree_raw]

**Unicorn w/ 1.9.2**

[Tsung Report][unicorn_19_tsung]
[Raw Results][unicorn_19_raw]

Questions? Comments? Leave us a comment on this post or get in touch
via [mailing lists, IRC, or twitter][contact_us].
