---
title: "TorqueBox: A Javaist's Tutorial on Messaging, Services and CDI in Ruby"
author: Marek Goldmann
layout: news
tags: [ cdi, tutorial, confitura, messaging, jms ]
timestamp: 2011-06-13t18:30:00.10+02:00 
---

After my presentation on [Confitura 2011](http://confitura.pl) I decided to write a tutorial describing in details the demo. Please remember that this was a Java conference, we'll look at TorqueBox from a Java developer POV.

If you're new to TorqueBox, please take a look at the [documentation pages](http://torquebox.org/2x/builds/html-docs/) on [torquebox.org](http://torquebox.org).

# Introduction

Let's begin with the idea and architecture of the demo.

## Idea

The purpouse of the demo is to show how easy it is to use CDI beans, messaging and services features in Ruby using TorqueBox.

## Overview

[![Architecture](/images/confitura_arch.png "Architecture")](/images/confitura_arch_big.png)

Basically the system is retrieving tweets containing specified keywords. Messages are put into an JMS queue and proceeded by a consumer with injected CDI bean which allows us to save the tweets into a database using JPA 2.0 API.

To display the data we use [Rails](http://rubyonrails.org) app which controller has access to another CDI bean which retrieves the tweets from database using JPQL queries.

Futhermore, there is one background job that is being executed every 30 seconds and removes from database selected (configurable) amount of tweets longer than 100 chars.

## Before you begin

This demo is prepared to run on TorqueBox 2.x. We'll use nightly snapshots. Although we try to make these builds as stable as possible, but it's cutting edge. Be warned.

### Requirements

* Java 1.6
* [TorqueBox 2.x nightly build](http://torquebox.org/2x/builds/)
* Git
* Maven (optional)
* Some time
* Beer (if you're > 18)

# Setting things up

Let's start with preparing TorqueBox and obtaining the code of the demo.

## TorqueBox

First of all we need to make TorqueBox work on our system. I'm assuming you're on Linux.

Please download and unzip the TorqueBox distribution.

    mkdir ~/torquebox
    cd ~/torquebox
    wget http://torquebox.org/2x/builds/torquebox-dist-bin.zip
    unzip -q torquebox-dist-bin.zip

The unzip command will create a directory in format: `torquebox-2.x.incremental.X` where `X` is the latest successful nightly build number.

Next, we need to export some environment variables so we'll be able to use [JRuby](http://jruby.org) commands everywhere. You can add following lines to your `~/.bashrc` file.

    export TORQUEBOX_HOME=~/torquebox/torquebox-2.x.incremental.X
    export JBOSS_HOME=$TORQUEBOX_HOME/jboss
    export JRUBY_HOME=$TORQUEBOX_HOME/jruby
    export PATH=$JRUBY_HOME/bin:$PATH

> Make sure to replace `X` with the actual build number!

OK, that's it. To make sure everything is set up correctly, start now JBoss AS:

    cd $JBOSS_HOME/bin
    ./standalone.sh

Look at the console if you can find lines similar to this:

    ...
    09:58:12,138 INFO  [org.torquebox.core.as] Welcome to TorqueBox AS - http://torquebox.org/
    09:58:12,139 INFO  [org.torquebox.core.as]   version........... 2.x.incremental.127
    09:58:12,139 INFO  [org.torquebox.core.as]   build............. 127
    ...
    09:58:19,310 INFO  [org.jboss.as] (MSC service thread 1-1) JBoss AS 7.x.incremental.16 "(TBD)" started in 12374ms - Started 114 of 172 services (58 services are passive or on-demand)

## Grab the code

    cd ~/torquebox
    git clone git://github.com/goldmann/confitura-2011-torquebox-demo.git
    cd confitura-2011-torquebox-demo/

### Build the Java part (optional)

> This step is optional because we already built it for you. Binaries are shipped with the source code. You can find them in `~/torquebox/confitura-2011-torquebox-demo/twitter/lib/` directory.

    cd cdi
    mvn clean package

After a few seconds (or minutes, depending on how much of Internet Maven needs to download), you'll have the `cdi.jar` artifact produced in `target/` directory:

    ls target/
    cdi.jar  classes  endorsed  generated-sources  maven-archiver  surefire

# Demo parts

To show some nice TorqueBox features I've decided to split the demo into a few parts. Let's walk through it!

## Services

[Services](http://torquebox.org/2x/builds/html-docs/services.html) are great way to constantly obtain data in background from a (remote) source. In the demo I would like to show how easily is to grab tweets directly from Twitter for selected keywords, in realtime.

Please take a look at `java_twitter_service.rb` located in `~/torquebox/confitura-2011-torquebox-demo/twitter_service` directory.

Services have `start` and `stop` methods. Start method is executed after the service gets deployed, stop method is executed just before the service gets undeployed.

After the start of this service a new Twitter client is created and from now we're tracking tweets with specified keywords. But where I can define the keywords? Keywords are defined in `torquebox.yml` file:

    services:
      JavaTwitterService:
        keywords:
          - ejb
          - java
          - cdi
          - beer
        queue: tweets

Consider `torquebox.yml` as an application descriptor.

The services section contains a list of service classes. In our case we have only one service: `JavaTwitterService`. Values specified under this class name are parameters injected to the constructor of the service. This will be translated to a Hash, so at the end our options Hash from initialize method in  `java_twitter_service.rb` will contain following data:

    options = {'keywords' => ['ejb', 'java', 'cdi', 'beer']}

After receiving a new tweet - we're processing it and putting into a JMS queue. All tweets are going into queue, but on those containing'java' word we're setting addtiional properties. These properties are translated into JMS message properties, so you'll be able to read messages that you are really interested filtering them using usual JMS message selectors.

Oh, wait, did I said a queue? Yep, we need to have a JMS queue. Although [it's easy to create a JMS queue using `torquebox.yml` file](http://torquebox.org/2x/builds/html-docs/messaging.html#messaging-deployment-descriptors), we'll do this using JBoss AS 7 CLI (just to make you comfortable with it). Start JBoss AS:

    cd $JBOSS_HOME/bin
    ./standalone.sh

In different terminal create the actual queue:

    ./jboss-admin.sh
    connect
    create-jms-queue --name=tweets

Simple, huh? Now you have a durable queue available always after you start JBoss AS.

## Deploying the service

We're ready to deploy the service. TorqueBox uses [knobs as deployment descriptors](http://torquebox.org/2x/builds/html-docs/deployment-descriptors.html). Knobs are simple YAML-formatted files informing JBoss AS what the application location is. They can do more, but we don't need to bother with it now.

The `twitter_service-knob.yml` file for our Twitter service is located in  `~/torquebox/confitura-2011-torquebox-demo/` directory.

Before you deploy - make sure you have the tweetstream and json gems installed:

    jgem install tweetstream json

To connect to Twitter API we need to use our Twitter credentials. Let's make these values available to our service as environment variables:

    export USERNAME=twitterusername
    export PASSWORD=twitterpassword

Let's deploy the service using JBoss AS 7 CLI. 

    ./jboss-admin.sh
    connect
    deploy /home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter_service-knob.yml

If everything worked as expected, you'll see on the AS console output like this:

    13:57:09,483 INFO  [stdout] (RubyThread-18: vfs:/home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter_service/java_twitter_service.rb:18) Starting Twitter client...
    13:57:11,514 INFO  [stdout] (RubyThread-18: vfs:/home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter_service/java_twitter_service.rb:18) Current Java tweets received: 0
    13:57:41,017 INFO  [stdout] (RubyThread-18: vfs:/home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter_service/java_twitter_service.rb:18) Current Java tweets received: 10
    13:57:56,033 INFO  [stdout] (RubyThread-18: vfs:/home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter_service/java_twitter_service.rb:18) Current Java tweets received: 20
    13:58:31,126 INFO  [stdout] (RubyThread-18: vfs:/home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter_service/java_twitter_service.rb:18) Current Java tweets received: 30

Time to receive the messages from queue.

## Message processors

TorqueBox has message processors. Think of Ruby Message Driven Beans.

Message processor in our example is part of a bigger app written in Rails. The source you can find in `~/torquebox/confitura-2011-torquebox-demo/twitter/`. We have one processor in `app/processors/` directory: `tweet_processor.rb`.

This is a simple class extending `MessageProcessor` and mixing in `Injectors`. The latter enables us to inject some resources. In our case we'll inject a CDI bean called `TweetSaver` (more about it in a second) to save the tweets to database.

Every message is processed in `on_message` method where we receive the body of the message as a parameter. [You can access](http://torquebox.org/2x/builds/html-docs/messaging.html#low-level-message-consumption) the `javax.jms.Message` object, but this is not what we want now.

When we receive a message, we execute the `save` method on `TweetSaver` which saves the message to a database.

But **how we connect the message processor to a queue?** It's easy - in `config/torquebox.yml` descriptor - we can define which processor is bound to which queue. More, we can even define the filter based on JMS selector properties. Read more about this configuration file [here](http://torquebox.org/2x/builds/html-docs/messaging.html#messaging-deployment-descriptors).

## CDI beans

I'm pretty sure you know what CDI is. If not - I recommend you to read [this tutorial](http://download.oracle.com/javaee/6/tutorial/doc/gjbnr.html). In our demo we'll be using 3 CDI beans: `TweetSaver`, `TweetReader` and `TweetRemover`. Besides this we have an entity called `Tweet`. The entity itself is straightforward, so start with discovering the beans.

`TweetReader` is responsible for reading the tweets from database. Database in our case is an in-memory H2 database which is the default one shipped with JBoss AS 7 meaning no configuration is required. Look at `persistence.xml` file to see the persistence unit configuration.

To `TweetReader` we're injecting `EntityManager`. In `read` method we retrieve latest 20 tweets from database. In `count` method we calculate the number of all tweets in database.

`TweetSaver` is a bit more complicated, because we need to use transaction to store some data in database, therefore besides `EntityManager` we inject also `UserTransaction` object. The save method receives decoupled tweet from which we create the `Tweet` object and save it in database. In case of an error - we rollback the transaction.

The last bean, `TweetRemover` is used to remove oldest X tweets which length exceeds 100 character. Removal process is also bounded in a transaction.

## Scheduled job

There is one more part of TorqueBox which is exposed in this demo: scheduled jobs. These are used for executing some repetitive tasks, like database cleanup, newsletter sending, etc. There is only one method to implement: `run`.

In our case we'll remove some old tweets from database using `TweetRemover` CDI. The source is located in `app/jobs/tweet_remover.rb` file. The goal is simple - inject appropriate CDI bean and execute the `remove` method on it specifying how many tweets at most we would like to remove from the database in a batch. As simple as that.

Hey, wait! You said repetitive tasks! Good catch - we need to have a way to define when we should execute which job. Again, in `config/torquebox.yml` application descriptor, in jobs section we define a job. In cron subsection we specify when the job should be executed. For more info about scheduling jobs take a look at the [documentation](http://torquebox.org/2x/builds/html-docs/scheduled-jobs.html). In our case we'll remove old long tweets every 30s.

## Rails

OK, we have all the back-end, but we would like to show some data. Let's use Rails and, again, CDI beans. We have `tweets_controller.rb` in `app/controllers`. We have here implemented only the `index` method which shows all the tweets. We're injecting a CDI bean - this time it's `TweetReader` on which we execute two methods: read and count which are described in "CDI beans" section above.

After we receive the tweets from a database using JPA - we render the output - in our case we use [HAML](http://haml-lang.com/) language to render the view. This makes it very compact and readable. Just take a look at `app/views/tweets/index.haml` file!

# Make it run!

It's time to finally see this working. We need to install first Rails and it's dependencies. Let's do it!

    cd ~/torquebox/confitura-2011-torquebox-demo/twitter
    rm Gemfile.lock
    bundle install

Now get back to JBoss AS CLI:

    ./jboss-admin.sh
    connect
    deploy /home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter-knob.yml

The application takes up to half a minut to deploy because we need to instantiate several JRuby runtimes. After the deployment finishes - you should see many messages looking similar to this:

    16:01:48,277 INFO  [stdout] (Thread-4 (group:HornetQ-client-global-threads-2025114565)) Hibernate: insert into tweets (message, username, id) values (?, ?, ?)

This means that our database is being invaded with tweets and the app is working. Let's go to [http://localhost:8080/tweets/](http://localhost:8080/tweets/) to see the tweets!

![Rails view](/images/confitura_demo.png "Rails view")

# I need help!

If you stuck with the demo - feel free to join #torquebox IRC channel. We will gladly assist you with the setup and demo itself.

