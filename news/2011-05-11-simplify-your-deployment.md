---
title: 'Using TorqueBox to Simplify Application Deployment'
author: Lance Ball
layout: news
tags: [ deployment, caching, jobs, tasks ]
---

[wiggins]: http://adam.heroku.com/past/2011/5/9/applying_the_unix_process_model_to_web_apps/
[passenger]: http://www.modrails.com/
[trinidad]: https://github.com/trinidad/trinidad
[heroku]: http://heroku.com
[foreman]: https://github.com/ddollar/foreman
[messaging]: http://torquebox.org/documentation/1.0.0/messaging.html
[scheduled-jobs]: http://torquebox.org/documentation/1.0.0/scheduled-jobs.html
[services]: http://torquebox.org/documentation/1.0.0/services.html
[community]: http://torquebox.org/community/

## Traditional Ruby App Deployment

One of the areas where Rails and Sinatra applications have notoriously suffered
over the years is deployment. While not as bad as it was back in the early days,
all of the mainstream deployment options - such as [Trinidad][trinidad] for
JRuby and [Passenger][passenger] for MRI - tend to focus almost exclusively on
the web bits.  This is why I have been a big fan of [Heroku][heroku] over the years.

Heroku is nice because it takes care of lots of those pesky details while staying
out of your way so you can focus on your application code.  Ready to deploy?
Just `git push heroku`.  Need another worker for your `Delayed::Job`? No
problem, just turn it on with `heroku workers 1`. Add cron services with a
single command; it's easy!

But if you're rolling your own, it can be tough. Not only do you have to figure
out what pieces you need - "should I use Resque or Delayed::Job?" - but you
have to have a fair understanding of system administration.  Adam Wiggins over
at Heroku recently wrote a great [article][wiggins] illustrating how to use
Procfiles and [Foreman][foreman] to make your life a lot easier if you're taking
this route.


## TorqueBox App Deployment

Adam's article concludes with a Procfile/Foreman/init.d recipe that manages
your web server, 2 job queues, a scheduled job and a long-running service.  The
configuration is pretty straightforward.  You maintain a Procfile with your
application code, and you use Foreman's export action to generate about a dozen
init scripts. It's a bit to keep track of, but certainly better than some
alternatives.  


### Running TorqueBox on System Boot

About now, you might be wondering how to do this with TorqueBox.  I'll show 
you - it's easy!

The first job is to configure TorqueBox so that it starts at boot time.  In
keeping with Adam's methods, let's use a Procfile and Foreman to generate a set
of Upstart configuration files so JBoss starts on boot.  For this example, put
this Procfile in `$TORQUEBOX_HOME/jboss.`

<script src="https://gist.github.com/966889.js?file=Procfile"></script>

In the terminal, be sure you are in `$TORQUEBOX_HOME/jboss` and run foreman.

<script src="https://gist.github.com/966889.js?file=foreman"></script>

Once you've done this, JBoss will startup on system boot. You can also start and
restart JBoss from the command line.

<script src="https://gist.github.com/966889.js?file=starting-and-stopping-jboss"></script>

That's all you need to get TorqueBox running on system startup.  Easy peasy! 

### Launching Message Queues, Scheduled Jobs and Services

But what about all of those other processes? We've still got 2 job queues,
a scheduled job, and a long running service to deal with.  And we're going 
to want these to be available to our application when it boots.  

Using Procfile and Foreman for these parts of your application is not
necessary.  With TorqueBox these services are an integral part of your app and
as such, they share the same life cycle.  When your application is deployed
under TorqueBox, so are your scheduled jobs, background tasks, and services.
To get all of this automagical goodness, all you have to do is edit your
torquebox.yml configuration file.

<script src="https://gist.github.com/966889.js?file=torquebox.yml"></script>

Now when JBoss fires up and your application is deployed, you've got a web
context, 2 message queues running under HornetQ, a couple of handlers to deal
with those messages, a scheduled job managed by Quartz, and a long-running
service to suck on the Twitter firehose.  Boom!

The message handlers are simple ruby classes that respond to `on_message(payload)`;
while the long running service is a plain ruby class that responds to `start`
and `stop`; and scheduled jobs are just classes that respond to `run`. Don't you
love duck typing?

For more information about how to write message processors in
TorqueBox, check out our [Messaging docs][messaging].  More information about
[scheduled jobs][scheduled-jobs] and how they work in TorqueBox is also
available in our documentation.  And of course, you can read all about
[TorqueBox services][services] in our docs as well.

## Conclusion

There is little doubt that the Unix process model is powerful and exceedingly
flexible for application deployment.  But to my mind, that fragments control of
your application into multiple individual bits.  One of the promises of a true
application server is that you get this kind of lifecycle management out of the box.

Now we have a simple Procfile to generate an init script for TorqueBox, and a
single YAML configuration file to handle everything else.  Your application is
a single, managed entity which launches on system boot.  Yay!

As always, if you've got questions or just want to chat up the TorqueBox team,
there are [lots of ways][community] to accomplish that through IRC, mailing lists
and JIRA. 

