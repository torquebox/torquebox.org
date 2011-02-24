---
title: Benchmarking TorqueBox
author: Ben Browning
layout: news
tags: [performance, jruby, rack, rails3]
---

[benchmail]: http://torquebox.markmail.org/thread/sekbh2cqymgbd7zq
[trinidad]: https://github.com/calavera/trinidad
[unicorn]: http://unicorn.bogomips.org/
[passenger]: http://www.modrails.com/
[thin]: http://code.macournoyer.com/thin/
[jruby]: http://jruby.org
[mri]: http://www.ruby-lang.org
[speedmetal]: https://github.com/torquebox/speedmetal
[rack_hello_world_source]: https://github.com/torquebox/speedmetal/tree/master/apps/rack/hello_world
[rack_hello_world_results]: https://github.com/torquebox/speedmetal/tree/master/results/rack/hello_world
[rack_sleep_source]: https://github.com/torquebox/speedmetal/tree/master/apps/rack/sleep
[rack_sleep_results]: https://github.com/torquebox/speedmetal/tree/master/results/rack/sleep
[rails_hello_world_source]: https://github.com/torquebox/speedmetal/tree/master/apps/rails3/hello_world
[rails_hello_world_results]: https://github.com/torquebox/speedmetal/tree/master/results/rails3/hello_world
[rails_fib_source]: https://github.com/torquebox/speedmetal/tree/master/apps/rails3/fibonacci
[rails_fib_results]: https://github.com/torquebox/speedmetal/tree/master/results/rails3/fibonacci

One question that we'd like to have a more concrete answer to is, "How
does TorqueBox perform compared to project X?" In a quest to answer
that question I enlisted the [help of the community][benchmail] and
started benchmarking TorqueBox against [Trinidad][], [Unicorn][],
[Passenger][], and [Thin][] for some simple applications. If you're
unfamiliar with these servers, TorqueBox and Trinidad run under
[JRuby][] while Unicorn, Passenger, and Thin run under [MRI][].

Obviously most applications are not as simple as those used for this
initial benchmark but our goal was to understand TorqueBox's baseline
performance so we can compare performance across releases and make
realistic claims regarding where we stand relative to the
alternatives.

# Setup

All applications, results and installation instructions are stored on
[GitHub][speedmetal] to be as open as possible. You'll also find the
exact command used to run each server for each test and any other
specific details or comments about the individual tests under the
results/ tree. All the tests were run against an Amazon EC2 m1.large
instance so anyone should be able to reproduce these results by
starting their own instances and running the tests.

# Results

## Rack Hello World

[Source][rack_hello_world_source]
[Raw Results][rack_hello_world_results]

This is an extremely simple Rack application that just prints "hello
world". The test is designed to see how quickly each server can
respond to Rack requests.

**10 Clients**
[<img src="/images/benchmarks/rack_hello_world_10_clients.png" alt="rack hello world 10 clients" style="width: 550px;"/>](/images/benchmarks/rack_hello_world_10_clients.png)

**100 Clients**
[<img src="/images/benchmarks/rack_hello_world_100_clients.png" alt="rack hello world 100 clients" style="width: 550px;"/>](/images/benchmarks/rack_hello_world_100_clients.png)

**Comments**

As you can see above, TorqueBox leads the pack with Trinidad and Thin
not far behind and Unicorn and Passenger bringing up the rear.

The slope you see at the beginning of the graphs with JRuby vs MRI
servers is interesting. The JRuby servers definitely have a warm-up
period before they start running at full speed and I'm not entirely
sure why - if I had to guess I'd say it's related to JIT compilation
of the code.


## Rack Sleep

[Source][rack_sleep_source]
[Raw Results][rack_sleep_results]

This test is identical to the Rack Hello World test except every
request sleeps for 100 milliseconds before responding. This is
designed to simulate a request blocking on an external resource
(database, cache, http). Experimentation showed each server performed
best when started with at least as many workers as concurrent clients.

**100 Clients**
[<img src="/images/benchmarks/rack_sleep_100_clients.png" alt="rack sleep 100 clients" style="width: 550px;"/>](/images/benchmarks/rack_sleep_100_clients.png)

With the exception of Thin, all servers have similar performance with
100 concurrent clients. I'm not sure why Thin's performance was so low
but it was excluded from higher client loads of this test since it
wasn't able to perform adequately.

**250 Clients**
[<img src="/images/benchmarks/rack_sleep_250_clients.png" alt="rack sleep 250 clients" style="width: 550px;"/>](/images/benchmarks/rack_sleep_250_clients.png)

The remaining servers continue to perform well at 250 concurrent
clients. The number of requests per second each was able to handle
increased as expected with the increased client load.

**500 Clients**
[<img src="/images/benchmarks/rack_sleep_500_clients.png" alt="rack sleep 500 clients" style="width: 550px;"/>](/images/benchmarks/rack_sleep_500_clients.png)

I was not able to start Passenger with a max pool size of 500 so it
was omitted from the final sleep test. Unicorn, however, had no
problem managing 500 workers and continued to perform well but lagged
behind the JRuby servers.

**Comments**

The above tests were also done with Passenger and Unicorn using a more
typical number of workers (10 - 20) but both performed substantially
poorer than with a number of workers equal to the number of concurrent
clients. This makes sense because the majority of the time spent
servicing each request is sleeping and not using the CPU.

This test is designed to mimic a real-world use-case but also favors
JRuby since spinning up a few hundred threads is much less
resource-intensive than a few hundred processes.


## Rails Hello World

[Source][rails_hello_world_source]
[Raw Results][rails_hello_world_results]

This is an extremely simple Rails application that just prints "hello
world". The test is designed to see how quickly each server can
respond to Rails requests.

**10 Clients**
[<img src="/images/benchmarks/rails_hello_world_10_clients.png" alt="rails hello world 10 clients" style="width: 550px;"/>](/images/benchmarks/rails_hello_world_10_clients.png)

**Comments**

Unlike the Rack Hello World test, the test server was CPU-bound with
just 10 clients and tests with higher loads yielded very similar
results with no appreciable increase in overall requests/second.

Trinidad and TorqueBox are substantially ahead of the other
servers. I'm a bit surprised that Trinidad outperforms TorqueBox in
this test when TorqueBox outperforms Trinidad in the Rack tests - I'm
sure there are some optimization opportunites here.


## Rails Fibonacci

[Source][rails_fib_source]
[Raw Results][rails_fib_results]

This test is designed to be very CPU-intensive by calculating the Nth
Fibonacci number on every request.

**10 Clients**
[<img src="/images/benchmarks/rails_fib_10_clients.png" alt="rails fibonacci 10 clients" style="width: 550px;"/>](/images/benchmarks/rails_fib_10_clients.png)

**Comments**

These results are very similar to the Rails Hello World results and I
think it's because both tests ended up being CPU-bound with just 10
concurrent clients. Higher concurrent client loads didn't increase
overall requests/second.

# Next Steps

I'm pleasantly surprised with TorqueBox's speed given that we've spent
almost zero time working on performance. Because our Rack performance
is so good, there's probably some low-hanging fruit on our Rails side
of things to bring that performance back in line with Trinidad.

None of these benchmarks actually talked to an external resource like
a cache or database because I wanted to concentrate on web server
performance specifically. In the future I'd like to also incorporate
some tests that store and retrieve data from memcached and a database
to look for any performance gains or losses under JRuby and TorqueBox
specifically.

We welcome any and all feedback on the benchmarks and encourage you to
fork and fix [speedmetal] if you encounter any issues reproducing our
results!
