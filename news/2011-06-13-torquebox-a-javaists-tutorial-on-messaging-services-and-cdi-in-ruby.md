---
title: "TorqueBox: A Javaist's Tutorial on Messaging, Services and CDI in Ruby"
author: Marek Goldmann
layout: news
tags: [ cdi, tutorial, confitura, messaging, jms ]
timestamp: 2011-06-13t21:10:00.10+02:00 
---

After my presentation at [Confitura 2011](http://confitura.pl), I decided to write a tutorial describing the details of my demo. Please remember that this was a Java conference, so we'll look at TorqueBox from a Java developer point of view.

If you're new to TorqueBox, please take a look at the [documentation](http://torquebox.org/2x/builds/html-docs/).

# Introduction

Let's begin with the goals and architecture of the demo.

## Goals

The goal of the demo is to show how easy it is to use CDI beans, messaging and services features in Ruby using TorqueBox.

## Overview

[![Architecture](/images/confitura_arch.png "Architecture")](/images/confitura_arch_big.png)

Basically the system is retrieving tweets containing specified keywords. Messages are put into a JMS queue and processed by a consumer with an injected CDI bean which allows it to save the tweets into a database using the JPA 2.0 API.

To display the data we use a [Rails](http://rubyonrails.org) app that has access to another CDI bean which retrieves the tweets from the database using JPQL queries.

Futhermore, there is one background job that is executed every 30 seconds which removes a configurable amount of tweets longer than 100 characters from the database.

## Before you begin

This demo is designed to run on TorqueBox 2.x. We'll use a nightly snapshot since there has not yet been an official 2.x release. Although we strive to make these builds as stable as possible, it is cutting edge. Be warned.

### Requirements

* Java 1.6
* [TorqueBox 2.x nightly build](http://torquebox.org/2x/builds/)
* Git
* Maven (optional)
* Some time
* Beer - if you're of legal age :)

# Setting things up

Let's start with setting up TorqueBox and obtaining the source code of the demo.

## TorqueBox

First, we need set up TorqueBox on your machine. I'm assuming you're on *nix based system.

Download and unzip the TorqueBox distribution:

    mkdir ~/torquebox
    cd ~/torquebox
    wget http://torquebox.org/2x/builds/torquebox-dist-bin.zip
    unzip -q torquebox-dist-bin.zip

The unzip command will create a directory named like: `torquebox-2.x.incremental.X` where `X` is the latest successful nightly build number.

Next, we need to export some environment variables so we'll be able to use the bundled [JRuby](http://jruby.org) commands everywhere. You can add following lines to your `~/.bashrc` file:

    export TORQUEBOX_HOME=~/torquebox/torquebox-2.x.incremental.X
    export JBOSS_HOME=$TORQUEBOX_HOME/jboss
    export JRUBY_HOME=$TORQUEBOX_HOME/jruby
    export PATH=$JRUBY_HOME/bin:$PATH

> Make sure to replace `X` with the actual build number!

OK, that's it. To make sure everything is set up correctly, start JBoss AS:

    cd $JBOSS_HOME/bin
    ./standalone.sh

Verify that you see output in the console similar to:

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

> This step is optional since the binaries are already part of the repo. You can find them in the `~/torquebox/confitura-2011-torquebox-demo/twitter/lib/` directory.

    cd cdi
    mvn clean package

After a few seconds (or minutes, depending on how much of the Internet Maven needs to download), you'll have the `cdi.jar` artifact available in the `target/` directory:

    ls target/
    cdi.jar  classes  endorsed  generated-sources  maven-archiver  surefire

# And now, the demo!

To demonstrate some of TorqueBox features clearly, I've split the demo into a few sections. Let's walk through it!

## Services

[Services](http://torquebox.org/2x/builds/html-docs/services.html) are a great way to constantly obtain data in the background from a (remote) source. In the demo I would like to show how easily it is to grab tweets directly from Twitter for selected keywords, in realtime.

Please take a look at `java_twitter_service.rb` located in the `~/torquebox/confitura-2011-torquebox-demo/twitter_service` directory.

Services have `start` and `stop` methods. The start method is executed after the service gets deployed, and the stop method is executed just before the service gets undeployed. 

> Since `start` is invoked as part of the deployment process, it should delegate the processing of the service to a thread and return quickly.

After the start of this service a new Twitter client is created and starts tracking tweets with the specified keywords. But where I can define the keywords? The keywords are defined in the `torquebox.yml` file:

    services:
      JavaTwitterService:
        keywords:
          - ejb
          - java
          - cdi
          - beer
        queue: tweets

Think of `torquebox.yml` as an application descriptor.

The services section contains a list of service classes. In our case we have only one service: `JavaTwitterService`. Values specified under this class name are parameters injected into the initializer (constructor) of the service. This will be translated into a Hash, and passed as the `options` parameter to the initialize method in `java_twitter_service.rb` with the following data:

    options = {'keywords' => ['ejb', 'java', 'cdi', 'beer']}

After receiving a new tweet we process it and put it onto a JMS queue. All of the tweets are going into the queue, but we're setting additional properties on any containing 'java'. These properties are translated into JMS message properties, so you'll be able to filter these messages using standard JMS message selectors.

Oh, wait, did I said a queue? Yep, we need to have a JMS queue. Although [it's easy to create a JMS queue from `torquebox.yml`](http://torquebox.org/2x/builds/html-docs/messaging.html#messaging-deployment-descriptors), we'll do this using the JBoss AS 7 CLI (just to make you more comfortable with it). Start JBoss AS:

    cd $JBOSS_HOME/bin
    ./standalone.sh

And in different terminal create the actual queue:

    ./jboss-admin.sh
    connect
    create-jms-queue --name=tweets

Simple, huh? Now you have a durable queue that will be available even after you restart JBoss AS.

## Deploying the service

We're ready to deploy the service. TorqueBox uses [custom deployment descriptors](http://torquebox.org/2x/builds/html-docs/deployment-descriptors.html). These deployment descriptors are simple YAML-formatted files specifying the application root to JBoss AS. They can do more, but we won't get into that right now.

The `twitter_service-knob.yml` file for our Twitter service is located in the `~/torquebox/confitura-2011-torquebox-demo/` directory.

Before you deploy - make sure you have the tweetstream and json gems installed:

    jgem install tweetstream json

To connect to to Twitter API we need to use our Twitter credentials. Let's make these values available to our service as environment variables:

    export USERNAME=twitterusername
    export PASSWORD=twitterpassword

Let's deploy the service using the JBoss AS 7 CLI. 

    ./jboss-admin.sh
    connect
    deploy /home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter_service-knob.yml

If everything worked as expected, you'll output like the following in the terminal where AS is running:

    13:57:09,483 INFO  [stdout] (RubyThread-18: vfs:/home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter_service/java_twitter_service.rb:18) Starting Twitter client...
    13:57:11,514 INFO  [stdout] (RubyThread-18: vfs:/home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter_service/java_twitter_service.rb:18) Current Java tweets received: 0
    13:57:41,017 INFO  [stdout] (RubyThread-18: vfs:/home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter_service/java_twitter_service.rb:18) Current Java tweets received: 10
    13:57:56,033 INFO  [stdout] (RubyThread-18: vfs:/home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter_service/java_twitter_service.rb:18) Current Java tweets received: 20
    13:58:31,126 INFO  [stdout] (RubyThread-18: vfs:/home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter_service/java_twitter_service.rb:18) Current Java tweets received: 30

Time to receive the messages from queue.

## Message processors

TorqueBox provides message processors - think of them as Ruby's Message Driven Beans.

The message processor in our example is part of a bigger app written in Rails. The source can be found in `~/torquebox/confitura-2011-torquebox-demo/twitter/`. We have one processor in the `app/processors/` directory: `tweet_processor.rb`.

This is a simple class extending `MessageProcessor` and mixing in `Injectors`. The latter enables us to inject some resources. In our case we'll inject a CDI bean called `TweetSaver` (more about it in a second) to save the tweets to the database.

Every message is processed in the `on_message` method where we receive the body of the message as a parameter. [You can access](http://torquebox.org/2x/builds/html-docs/messaging.html#low-level-message-consumption) the `javax.jms.Message` object, but we don't need that for this demo.

When we receive a message, we execute the `save` method on `TweetSaver` which saves the message to the database.

But **how do we connect the message processor to a queue?** It's easy - in the `config/torquebox.yml` descriptor we can define which processor is bound to which queue. We can also define the filter based on JMS selector properties. Read more about this configuration file [here](http://torquebox.org/2x/builds/html-docs/messaging.html#messaging-deployment-descriptors).

## CDI beans

I'm pretty sure you know what CDI is. If not - I recommend you to read [this tutorial](http://download.oracle.com/javaee/6/tutorial/doc/gjbnr.html). In our demo we'll be using 3 CDI beans: `TweetSaver`, `TweetReader` and `TweetRemover`. We also have an entity called `Tweet`. The entity itself is straightforward, so we'll start with discovering the beans.

`TweetReader` is responsible for reading the tweets from the database. The database in our case is an in-memory H2 database which is the default one shipped with JBoss AS 7 (meaning no configuration is required). Look at the `persistence.xml` file to see the persistence unit configuration.

We're injecting an `EntityManager` into `TweetReader`. In the `read` method we retrieve the latest 20 tweets from the database. In the `count` method we calculate the number of all tweets in the database.

`TweetSaver` is a bit more complicated, because we need to use a transaction to store some data in the database. We inject a `UserTransaction` object in addition to the `EntityManager`. The save method receives a decoupled tweet from which we create the `Tweet` object and save it in the database. We rollback the transaction if an error occurs.

The last bean - `TweetRemover` - is used to remove the oldest X tweets who's length exceeds 100 characters. The removal process is also bounded in a transaction.

## Scheduled jobs

There is one more part of TorqueBox which is exposed in this demo: scheduled jobs. These are used for executing some repetitive tasks, like database cleanup, newsletter sending, etc. There is only one method to implement: `run`.

In our case we'll remove some old tweets from database using the `TweetRemover` CDI. The source is located in `app/jobs/tweet_remover.rb`. The goal is simple - inject the appropriate CDI bean and execute the `remove` method on it specifying how many tweets at most we would like to remove from the database in a batch. As simple as that.

Hey, wait! You said repetitive tasks! Good catch - we need to have a way to define when we should execute each job. Again, in the `config/torquebox.yml` application descriptor, we define a job in the jobs section. In the cron subsection we specify when the job should be executed. For more info about scheduling jobs take a look at the [documentation](http://torquebox.org/2x/builds/html-docs/scheduled-jobs.html). In our case we'll remove old long tweets every 30 seconds.

## Rails

OK, we've wired up the back-end, but we would like to show some data. Let's use Rails and, again, CDI beans. We have `tweets_controller.rb` in `app/controllers`. It only implements the `index` method which shows all of the tweets. We're injecting a CDI bean (this time it's `TweetReader`) on which we execute two methods: `read` and `count` which are described in the "CDI beans" section above.

After we receive the tweets from the database using JPA, we render the output (we're using [HAML](http://haml-lang.com/) to render the view). This makes it very compact and readable. Just take a look at `app/views/tweets/index.haml`!

# Make it run!

It's time to finally see this working. We need to first install Rails and it's dependencies. Let's do it!

    cd ~/torquebox/confitura-2011-torquebox-demo/twitter
    rm Gemfile.lock
    bundle install

Now, switch back to the JBoss AS CLI:

    ./jboss-admin.sh
    connect
    deploy /home/goldmann/torquebox/confitura-2011-torquebox-demo/twitter-knob.yml

The application takes up to half a minute to deploy because we need to instantiate several JRuby runtimes. After the deployment finishes, you should see many messages looking similar to this:

    16:01:48,277 INFO  [stdout] (Thread-4 (group:HornetQ-client-global-threads-2025114565)) Hibernate: insert into tweets (message, username, id) values (?, ?, ?)

This means that our database is being loaded with tweets and the app is working. Let's go to [http://localhost:8080/tweets/](http://localhost:8080/tweets/) to see the tweets!

![Rails view](/images/confitura_demo.png "Rails view")

# I need help!

If you get stuck with the demo, feel free to join the #torquebox IRC channel on freenode.net. We will gladly assist you with any questions or issues you may have.

