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

## Traditional Ruby App Deployment

One of the areas where Rails and Sinatra applications have notoriously suffered
over the years is deployment. While not as bad as it was back in the early days,
all of the mainstream deployment options - such as [Trinidad][trinidad] for
JRuby and [Passenger][passenger] for MRI - tend to focus almost exclusively on
the web bits.  This is why I have been a big fan of [Heroku][heroku] over the years.

Heroku is nice because it takes care of lots of those niggly details while staying
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
application code, and you use Foreman's export action to generate init.d
scripts. It's a bit to keep track of, but certainly better than some
alternatives.  

About now, you might be wondering how to do this with TorqueBox.  I'll show 
you - it's easy!

