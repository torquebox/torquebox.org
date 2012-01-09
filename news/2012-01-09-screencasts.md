---
title: 'TorqueBox 2.0 iTunes Feed'
author: Lance Ball
layout: news
tags: [ screencasts, howto, rss, itunes ]
---

Back in [December] I wrote about the screencasts we have been putting together
for TorqueBox 2.0. I have been posting the videos to [Vimeo], but it turns out
that Vimeo makes it [difficult if not impossible][vimeo-hassles] to subscribe to
a video feed in iTunes, and this is something the community has asked for.
Drat!

Turns out, the better option is to just wire up [awestruct] to generate a feed
that iTunes can be happy with. To follow all of the TorqueBox screencasts in
iTunes, choose "Subscribe to Podcast" from the Advanced menu and enter
[http://torquebox.org/podcasts.xml][podcasts-xml].

<img src="/images/subscribe-menu.png"/>

Choose "Subscribe to Podcast"

<img src="/images/subscribe-dialog.png"/>

Enter "http://torquebox.org/podcasts.xml"

You can also [browse][podcasts] and view them individually if you just want to
pick and choose. There are four screencasts currently published, with more on
the way.

  * [Installing TorqueBox 2.0][installing]
  * [Getting Started with Rails on TorqueBox 2.0][rails]
  * [Getting Started with Sinatra on TorqueBox 2.0][sinatra]
  * [Long Running Services in TorqueBox 2.0][services]

Thanks for watching! And if there is a topic you would like to see us cover,
please let us know in the comments.

[podcasts]: /podcasts/
[podcasts-xml]: /podcasts.xml
[installing]: /podcasts/2011/12/07/installing-torquebox/
[rails]: /podcasts/2011/12/09/rails-on-torquebox/
[sinatra]: /podcasts/2011/12/20/sinatra-on-torquebox/
[services]: /podcasts/2011/12/21/torquebox-services/
[vimeo-hassles]: http://vimeo.com/forums/topic:5609
[awestruct]: http://awestruct.org
[December]: /news/2011/12/15/torquebox-screencasts/
[Vimeo]: http://vimeo.com/groups/120894
