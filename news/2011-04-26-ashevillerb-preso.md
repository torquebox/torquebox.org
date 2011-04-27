---
title: 'Slides From My Asheville.rb TorqueBox Presentation'
author: Lance Ball
layout: news
tags: [ presentations ]
---

[firestorm]: http://www.firestormcafe.com
[rvm article]: /news/2011/02/25/using-rvm-with-torquebox/
[aws]: http://aws.amazon.com

Last night I was thrilled to join the ranks of TorqueBox presenters 
world-wide by speaking at Asheville.rb in Asheville.  A nice group
of about 10 folks were there to listen to the talk. Asheville.rb
meets at [Firestorm Cafe][firestorm] thanks to their generous support
for things free and cooperative. 

![Open Source FTW](/images/firestorm.png "Open Source FTW")

Thanks everyone for your questions afterwards. I wanted to follow up
on one question about RVM.  As I mentioned, I don't recommend distinct RVM
gemsets for your applications under TorqueBox unless you don't intend to
run your apps concurrently. If you want to have multiple applications 
running under a single TorqueBox runtime, I recommend using a "torquebox"
gemset which should contain gems for all of your apps.

If you are interested in using RVM with TorqueBox, have a look at this
[article][rvm article] I wrote a couple of months ago.  The gem names are a bit
dated - now you just need the 'torquebox' gem - but it should get you started.

Also, I mentioned trying TorqueBox out by using our [AWS][aws] AMI. We 
just released a CR2 version of the AMI today: `ami-32ab545b`.

For those of you who were interested in the BENchmarks here's the [full
analysis](/news/tags/benchmarks/).  If you missed the talk (or even if you
didn't), you can still peruse the slides:

<div style="width:425px" id="__ss_7755874"> <strong style="display:block;margin:12px 0 4px"><a href="http://www.slideshare.net/lanceball/torquebox-ashevillerb-april-2011" title="Torquebox Asheville.rb April 2011">Torquebox Asheville.rb April 2011</a></strong> <iframe src="http://www.slideshare.net/slideshow/embed_code/7755874" width="425" height="355" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe> <div style="padding:5px 0 12px"> View more <a href="http://www.slideshare.net/">presentations</a> from <a href="http://www.slideshare.net/lanceball">lanceball</a> </div> </div>

