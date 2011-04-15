---
title: 'TorqueBox 1.0.0.CR1, for reals'
author: The Entire TorqueBox Team
layout: release
version: 1.0.0.CR1
---

It's April 15; have you paid your taxes?  If not, great news: you have until the
18th. But go ahead and take care of it so you can spend the weekend playing
with the latest TorqueBox release: **1.0.0.CR1**.

That's right, the first-ever non-beta release of TorqueBox is now available.
Go [download it](/download) and [read the docs](/documentation/1.0.0.CR1/).
If you don't recall, "CR" is JBoss short-hand for "Candidate Release",
which is what you might normally call a "Release Candidate".  We change
the byte-order for improved lexical sorting compared to "Final" or "GA".

Through the intense work of Jim Crossley, Ben Browning, Tobias Crawley,
Lance Ball, and innumerable contributions from the community, this release
represents a mass-load of improvements since Beta23 back near the start
of December 2010. Over 153 issues were resolved for this release.

Over the next two weeks, we'll squash bugs as they are reported, and
issue interim CR checkpoints, culimating in the 1.0.0.Final release 
by JBossWorld in early May.

I (Bob) am proud-as-all-get-out with everything the team has accomplished. 

# In This Release
    
<div style="font-size:80%">
<h2>        Bug
</h2>
<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-47'>TORQUE-47</a>] -         AJP not working with virtual hosts
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-164'>TORQUE-164</a>] -         Can&#39;t deploy rack archives when referenced by a *-rack.yml
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-165'>TORQUE-165</a>] -         Rack middleware Rack::Reloader not working
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-170'>TORQUE-170</a>] -         File.new Should Return Object That Responds To &#39;lstat&#39; For Files In An Archive
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-174'>TORQUE-174</a>] -         Rails does not work in production environment with cached JavaScript and CSS
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-175'>TORQUE-175</a>] -         Rails archives won&#39;t deploy without a rails-env.yml file
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-176'>TORQUE-176</a>] -         The javascript_include_tag rails helper doesn&#39;t seem to respect the context path under which the app is deployed.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-178'>TORQUE-178</a>] -         Torquebox isn&#39;t able to create cache files in a non archive app.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-181'>TORQUE-181</a>] -         Rack doesn&#39;t expect CONTENT_LENGTH to ever be less than 0
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-185'>TORQUE-185</a>] -         Dir.entries and Dir.foreach should handle VFS Paths
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-186'>TORQUE-186</a>] -         Only Use &#39;autoload_paths&#39; On Rails 2.3.10+ to Maintain Backwards Compatibility With Older 2.3.x
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-187'>TORQUE-187</a>] -         Template missing error
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-197'>TORQUE-197</a>] -         CachedJavascriptArchiveTest fails on linux with a permission error
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-198'>TORQUE-198</a>] -         Globbing does not support using square-brackets for character alternation
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-199'>TORQUE-199</a>] -         Mark ruby apps as distributable so that session replication works when clustered
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-202'>TORQUE-202</a>] -         Null Path on Windows when instantiating a Java class in a Rack app
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-203'>TORQUE-203</a>] -         Rack applications seemingly not loading lib/java/**.jar to the classpath by default.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-207'>TORQUE-207</a>] -         JMS session should be rolled back in response to exception so that redelivery is attempted
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-211'>TORQUE-211</a>] -         The Rails.cache file_store (the default) fails to write because our File.new monkey patch is wrong
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-226'>TORQUE-226</a>] -         Cannot map a single app to context=/ and hostname=anything in descriptor
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-232'>TORQUE-232</a>] -         TasksDeployer should namespace queues by application
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-239'>TORQUE-239</a>] -         bundler chdir vfs failure when depending on a git gem
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-241'>TORQUE-241</a>] -         torquebox-assembly: Could not resolve dependency on jruby-1.5.6
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-242'>TORQUE-242</a>] -         TorqueBox rake tasks don&#39;t load automatically in rails 2.3.10
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-247'>TORQUE-247</a>] -         Bump up default Xmx to enable more than 2 or 3 consecutive deployments
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-256'>TORQUE-256</a>] -         Backgroundable doesn&#39;t work in a non-Rails app
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-260'>TORQUE-260</a>] -         Backgroundable objects don&#39;t reload properly when :always_background called before method definitions
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-261'>TORQUE-261</a>] -         Deployment descriptors with invalid application:root: values don&#39;t fail to deploy.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-262'>TORQUE-262</a>] -         Backgroundable queue creation fails with a javax.jms.JMSSecurityException
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-263'>TORQUE-263</a>] -         backgroundable queue gets created with a null app name
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-264'>TORQUE-264</a>] -         ServletStore Session Implementation Causes All Requests to Compete For Global Lock
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-265'>TORQUE-265</a>] -         ServletStore Implementation Continually Loads New Classes and Uses Up PermGen
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-267'>TORQUE-267</a>] -         classes don&#39;t reload in task runtimes in development mode
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-273'>TORQUE-273</a>] -         &quot;null&quot; environment when otherwise not defined
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-274'>TORQUE-274</a>] -         HornetQ Stacktrace on App Load -- [HornetQConnection] I&#39;m closing a JMS connection you left open. Please make sure you close all JMS connections explicitly before letting them go out of scope!
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-275'>TORQUE-275</a>] -         Capistrano Support uses older style -rails.yml file naming. Should use -knob.yml
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-276'>TORQUE-276</a>] -         Devise Doesn&#39;t Work With ServletStore
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-278'>TORQUE-278</a>] -         Enabling the file_store cache results in errors due to percent-encoded cache file names
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-279'>TORQUE-279</a>] -         request.raw_post Always nil For Rails Apps
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-282'>TORQUE-282</a>] -         Misleading message when deploying queues using queues.yml
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-283'>TORQUE-283</a>] -         Task classes with more than one underscore in their names cannot find their queues
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-284'>TORQUE-284</a>] -         Static Assets Don&#39;t Render For Rails 2.3.x Applications Hosted at Root Context
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-285'>TORQUE-285</a>] -         Docs have incorrect info on using an external jruby
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-286'>TORQUE-286</a>] -         Cleanly detach clients from destinations
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-289'>TORQUE-289</a>] -         File.readlines fails when given a vfs path
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-291'>TORQUE-291</a>] -         Neither Tasks nor MessageProcessors reload in development mode rails apps.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-293'>TORQUE-293</a>] -         When context lacks a slash prefix, static assets don&#39;t resolve properly
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-294'>TORQUE-294</a>] -         Jars from knob should be mounted
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-295'>TORQUE-295</a>] -         Jobs are fired before deployment completes
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-296'>TORQUE-296</a>] -         TorqueBox::Messaging::Task does not properly handle underscores
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-299'>TORQUE-299</a>] -         VFS paths not properly generated in Windows Environments
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-300'>TORQUE-300</a>] -         IO#read without a block not closing the files
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-302'>TORQUE-302</a>] -         Bootstrap on Windows fails after common/torquebox/ shared-jar rearrangement
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-303'>TORQUE-303</a>] -         File.exists? on a non-existent absolute path on windows infinite loops
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-304'>TORQUE-304</a>] -         Happify integration tests on windows
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-305'>TORQUE-305</a>] -         Typo in install docs /installation.html#running
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-306'>TORQUE-306</a>] -         Overriding rackup to config/config.ru doesn&#39;t work
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-308'>TORQUE-308</a>] -         Boolean environment variables set in torquebox.yaml cause JRuby to barf
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-309'>TORQUE-309</a>] -         Opening a File subclasses doesn&#39;t return an instance of itself
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-320'>TORQUE-320</a>] -         Spurious failures (seen in SinatraQueuesTest) of RackFilter being unable to find its RackAppPool.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-321'>TORQUE-321</a>] -         require &#39;torquebox/messaging&#39; throws exception
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-322'>TORQUE-322</a>] -         MessageProcessor concurrency - handler receiving same message multiple times
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-328'>TORQUE-328</a>] -         Fix script analyzer for 1.9 code
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-330'>TORQUE-330</a>] -         Injection Not Working For Services Unless Parent Folder Is In Load Path
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-333'>TORQUE-333</a>] -         MessageProcessor subclasses eat exceptions tossed in on_message, preventing delivery retries
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-336'>TORQUE-336</a>] -         NPE on client#connect when running in Ruby 1.9 mode
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-340'>TORQUE-340</a>] -         VFS Failure during migration
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-345'>TORQUE-345</a>] -         $TORQUEBOX_HOME/apps isn&#39;t recognized on startup: Illegal character in opaque part at index 2
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-352'>TORQUE-352</a>] -         Overridden DriverManager getConnection Method Breaks oracle-enhanced-adapter
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-353'>TORQUE-353</a>] -         Fix gem dependencies so that torquebox-vfs is installed as a dependency of vanilla torquebox gem
</li>
</ul>
                
<h2>        Enhancement
</h2>
<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-227'>TORQUE-227</a>] -         Saner TorqueBox gem names
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-230'>TORQUE-230</a>] -         More consistency of configuration of all the classes we instantiate
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-240'>TORQUE-240</a>] -         Write a minimalist deployment descriptor when torquebox.yml exists.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-292'>TORQUE-292</a>] -         Bump up the default Xmx from 512M to something, well, bigger
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-311'>TORQUE-311</a>] -         Document TorqueBox::Injectors
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-312'>TORQUE-312</a>] -         Document logging alternatives in TorqueBox
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-317'>TORQUE-317</a>] -         Add support for expanding paths for application roots
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-334'>TORQUE-334</a>] -         Create a better global JRuby
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-335'>TORQUE-335</a>] -         Better share ClassCache and MethodCache between Rubies created by an app&#39;s RubyRuntimeFactory
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-342'>TORQUE-342</a>] -         Upgrade Capistrano support for newer features
</li>
</ul>
    
<h2>        Feature Request
</h2>
<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-33'>TORQUE-33</a>] -         Implement a Rails Cache Store that uses JBossCache
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-61'>TORQUE-61</a>] -         Adding JRuby --1.9 support (per application)
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-71'>TORQUE-71</a>] -         Support NewRelic RPM
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-75'>TORQUE-75</a>] -         Push gems to rubygems.org
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-159'>TORQUE-159</a>] -         Generate @version in runtime_constants.rb from the pom and display it somewhere.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-160'>TORQUE-160</a>] -         Provide a torquebox:freeze rake task that does the correct bundler incantations
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-177'>TORQUE-177</a>] -         Support rails/rack archives by exploding them rather than attempt to write to them via VFS
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-179'>TORQUE-179</a>] -         Allow programmatically attach new queue/task consumers outside from TB
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-191'>TORQUE-191</a>] -         Pass messaging client options to constructor of Queue/Topic and doc better
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-192'>TORQUE-192</a>] -         Add support for long-running ruby services
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-194'>TORQUE-194</a>] -         Make it easy to create a ruby HASingleton
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-195'>TORQUE-195</a>] -         Decouple message *delivery* from message *processing* in RubyMessageProcessor
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-213'>TORQUE-213</a>] -         Mimic delayed_job&#39;s AR handle_asynchronously method
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-214'>TORQUE-214</a>] -         Expose HornetQ&#39;s priority to tasks
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-215'>TORQUE-215</a>] -         Inject CDI beans into ruby objects/rails controllers
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-217'>TORQUE-217</a>] -         Create JMX MBeans For Management of application components
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-219'>TORQUE-219</a>] -         Remove unneeded gems from TB distribution
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-221'>TORQUE-221</a>] -         Provide simple deployment to TB via git push
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-229'>TORQUE-229</a>] -         Remove gratuitous JBOSS_CONF configurations that we don&#39;t recommend using.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-231'>TORQUE-231</a>] -         Make app name available as a constant within the ruby runtimes
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-235'>TORQUE-235</a>] -         Expose Methods For Synchronous Messaging via Queues
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-237'>TORQUE-237</a>] -         Full unification of metadata through torquebox.yml
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-238'>TORQUE-238</a>] -         Support durable subscribers
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-248'>TORQUE-248</a>] -         Unify external deployment descriptors
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-249'>TORQUE-249</a>] -         Unify archive deployables
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-250'>TORQUE-250</a>] -         Support non-web deployments
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-255'>TORQUE-255</a>] -         Determine (and implement) what &quot;clustering&quot; means to Quartz and JBossAS
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-258'>TORQUE-258</a>] -         Explicit build number/revision tracking
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-266'>TORQUE-266</a>] -         Queues &amp; Topics Accessed Before Fully Deployed Should Wait Instead of Erroring
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-268'>TORQUE-268</a>] -         Allow setting concurrency for task classes in torquebox.yml
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-269'>TORQUE-269</a>] -         allow for tasks to exist in places other than app/tasks
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-270'>TORQUE-270</a>] -         Provide simple ruby interface for JBoss auth through PicketBox
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-271'>TORQUE-271</a>] -         Slimmer distribution
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-281'>TORQUE-281</a>] -         Implement a queue browser
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-287'>TORQUE-287</a>] -         We should provide a top-level, dependency-aggregator-only, zero-content &#39;torquebox.gem&#39; to make Gemfiles more cleaner.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-297'>TORQUE-297</a>] -         Pull ruby bits out of the web java components, to allow usage of cache and session implementations outside of AS, at least marginally
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-298'>TORQUE-298</a>] -         jms_message properties should be set by type instead of all as strings
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-307'>TORQUE-307</a>] -         Defer Backgroundable queue and message_processor creation until a backgrounded method is called
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-310'>TORQUE-310</a>] -         Expose the JBoss logger to Ruby apps
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-313'>TORQUE-313</a>] -         Queues/Topics should expose the durability option, and be durable by default
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-314'>TORQUE-314</a>] -         Make jruby/bin/rake executable
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-316'>TORQUE-316</a>] -         Provide an IRB console-like debugging tool for Rails/Rack apps
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-324'>TORQUE-324</a>] -         A non-polluted directory not unlike deploy/ to hold user apps and only user apps, which deploys once the whole AS is going would be, like, super cool.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-327'>TORQUE-327</a>] -         Decorate runtimes with usage (web, messaging, etc), and expose the runtimes via jmx
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-338'>TORQUE-338</a>] -         Include the pool name in the message logged on runtime creation
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-341'>TORQUE-341</a>] -         Remove warnings around already initialized constants RAILS_ROOT and RAILS_ENV when booting rails applications.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-343'>TORQUE-343</a>] -         Release BackStage as a gem
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-344'>TORQUE-344</a>] -         Extract the deploy code out of the rake tasks into a helper class
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-348'>TORQUE-348</a>] -         Gemify stompbox
</li>
</ul>
        
<h2>        Patch
</h2>
<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-347'>TORQUE-347</a>] -         Specify version for wagon-webdav-jackrabbit to make NetBeans happy
</li>
</ul>
    
<h2>        Quality Risk
</h2>
<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-251'>TORQUE-251</a>] -         Job components have bad linkage between a cached IRubyObject and a pool.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-331'>TORQUE-331</a>] -         Refactor the 1.9 logic out of container.rb and into the pom, letting a maven profile dictate what goes where.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-332'>TORQUE-332</a>] -         Ruby runtime pools do not stop, and clean up resources.
</li>
</ul>
            
<h2>        Task
</h2>
<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-48'>TORQUE-48</a>] -         Document capistrano support
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-163'>TORQUE-163</a>] -         Explain session management in the documentation
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-184'>TORQUE-184</a>] -         Passing attributes between the Rack and ServletSessions should work for symbol-based keys
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-200'>TORQUE-200</a>] -         Rework packaging of the capistrano support gem.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-206'>TORQUE-206</a>] -         Juggle dependencies and -int-deployer.jar content
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-208'>TORQUE-208</a>] -         Refactor StructureMetaData management between RackStructure and AppRackYamlParsingDeployer
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-209'>TORQUE-209</a>] -         Add vendor/jars/**.jar to the application&#39;s classpath
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-210'>TORQUE-210</a>] -         Update to JRuby 1.6
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-236'>TORQUE-236</a>] -         Plus CI builds as a rubygem repository also
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-243'>TORQUE-243</a>] -         Install copyrights in all source files.
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-290'>TORQUE-290</a>] -         Use RubySpec to Ensure Our VFS Changes Don&#39;t Break Non-VFS Operations
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-318'>TORQUE-318</a>] -         Integration Tests Should Run Headless
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-325'>TORQUE-325</a>] -         Review docs before CR1
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-326'>TORQUE-326</a>] -         Remove Need For VFS Jars in jruby/lib/
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-350'>TORQUE-350</a>] -         Fix logging output for Sinatra (and maybe any rack app?)
</li>
</ul>
        
<h2>        Sub-task
</h2>
<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-233'>TORQUE-233</a>] -         Add rails initializer to extend AR
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-234'>TORQUE-234</a>] -         Update documentation for tasks to describe Backgroundable features
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-244'>TORQUE-244</a>] -         Add concurrency configuration for Backgroundable processors
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-252'>TORQUE-252</a>] -         Support Jobs a-la-carte
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-253'>TORQUE-253</a>] -         Support message processors a-la-carte
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-254'>TORQUE-254</a>] -         Support services a-la-carte
</li>
</ul>

</div>
