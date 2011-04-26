---
title: 'TorqueBox 1.0.0.CR2: now!'
author: The Entire TorqueBox Team
layout: release
version: 1.0.0.CR2
tags: [ release ]
---

[download]: /download
[docs]: /documentation/1.0.0.CR2/
[epub]: http://repository-torquebox.forge.cloudbees.com/release/org/torquebox/torquebox-docs-en_US/1.0.0.CR2/torquebox-docs-en_US-1.0.0.CR2.epub

Our schedule originally called for 1.0.0.CR2 to be released on Friday, 22 April, but we
then realized that was a holiday.  We considered releasing a day early but just weren't feeling
it.  Which was good, because Amazon broke on Thursday.  We perform our builds and releases on
EC2.

So, today, 25 April, TorqueBox 1.0.0.CR2 is available.  Go [download it][download] and [read the documentation][docs].
Heck, maybe even read the documentation in [ePub][epub] format on your electronic reading device.

Trying to keep to a pure CR release cycle, this release includes no new features, but
a small handful of bug-fixes, including solving some resource-leaks.

Here's what we've done since the CR1 release on 15 April:


<h2>        Bug
</h2>
<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-355'>TORQUE-355</a>] -         Cannot inject a class from a pl. top-level package
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-356'>TORQUE-356</a>] -         Invalid &#39;require&#39; statement causes a LoadError which results in an un-redeployable app
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-358'>TORQUE-358</a>] -         Cannot boot a sinatra application
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-364'>TORQUE-364</a>] -         Managed runtime pools are limited to (minInstances + 1) runtimes even when maxInstances &gt; (minInstances + 1)
</li>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-367'>TORQUE-367</a>] -         Dir[] barfs on multiple args
</li>
</ul>
                
<h2>        Enhancement
</h2>
<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-368'>TORQUE-368</a>] -         Use non-leaking form of LoadServiceResource from VFSLoadService
</li>
</ul>
    
<h2>        Feature Request
</h2>
<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-357'>TORQUE-357</a>] -         Provide docs in .mobi format
</li>
</ul>
                        
<h2>        Task
</h2>
<ul>
<li>[<a href='https://issues.jboss.org/browse/TORQUE-359'>TORQUE-359</a>] -         Stash the .gems somewhere on CI when we build a release
</li>
</ul>
        
