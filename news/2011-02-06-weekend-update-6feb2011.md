---
title: 'TorqueBox Weekend Update: 6 February 2011'
author: Bob McWhirter
layout: news
---

[MagicRuby]: http://magic-ruby.com/
[stickers]: http://twitpic.com/3u7ogk
[twitter]: http://twitter.com/#!/search/torquebox%20%23magicruby
[tobyblog]: /news/2011/02/01/turn-any-method-into-a-task/
[lanceami]: https://issues.jboss.org/browse/TORQUE-228?focusedCommentId=12579172&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-12579172
[stompbox]: https://github.com/lance/stompbox
[gitdeploy]: https://issues.jboss.org/browse/TORQUE-221
[uniknob]: /news/2011/02/05/grand-unification-and-knobs/
[rss]: /news.atom
[rssjira]: https://issues.jboss.org/plugins/servlet/streams?key=TORQUE
[rssgithub]: https://github.com/torquebox/torquebox/commits/master.atom
[IRC]: /community/#irc

Welcome to the second weekend update about the goings-on of the TorqueBox
project over the last 7 days.

## Jim Crossley speaks at MagicRuby

Jim Crossley presented at the [MagicRuby] conference, with Toby Crawley and Ben Browning 
manning the table at the back and filming the whole affair. Additionally, Toby managed 
the production of [awesome stickers][stickers]
that were given out.  We have stickers remaining, so find us at future events
(listed on the [front page](/)).

We hope to get video of Jim's presentation, along with a downloadable PDF
of his slides online in the next few days.  Stay tuned!

The [reaction on Twitter][twitter] seems quite positive.  **Great job, Jim!**

## Code updates

This week, Ben spent time investigating how the `HASingleton` pattern
(related to high-availability)
works within JBoss AS, and exposing it through TorqueBox.  Now,
on your cluster, you can have a service fail-over from one node
to another. Look for more information about that, soon.

Toby exposed some more messaging features, such as 
HornetQ's message-priority and TTL.  Additionally, he enabled functionality to
easily [run any method asynchronously][tobyblog].

Lance published a checkpoint of a [TorqueBox AMI for use on EC2][lanceami],
and continued to work on [StompBox][stompbox], the easy [git-based deployment][gitdeploy]
solution.  We expect the AMIs to be updated after the 1.0.0.CR1 release.

I (Bob) worked on the [YAML anti-proliferation effort][uniknob], to make
configuration easier and to begin supporting advanced deployments that might lack
a web component.  I also senselessly pushed this code less than 24 hours before
Jim presented his well-prepared slide deck.  **Sorry, Jim!**

## Misc

Don't forget, you can keep up with news like this through our
[news RSS feed][rss] and track a deeper view through our [JIRA activity stream RSS feed][rssjira]
and our [GitHub commits RSS feed][rssgithub].

You can also join us on [IRC] for conversation and assistance.

