---
title: TorqueBox::Authentication
author: Lance Ball
layout: news
tags: [ security, authentication ]
---

TorqueBox, as you should know by now, is built on top of the JBoss Application
Server.  That's what allows us to bring to Ruby such awesomeness as integrated
queues, messaging and tasks.  One of the other features that JBoss provides is
an implementation of the Java Authentication and Authorization Specification,
usually just referred to as JAAS.  Now, your Ruby apps can JAAS it up as well
with just a few lines of code.  

## What is JAAS?  

The JAAS API is a set of Java packages designed for user authentication and
authorization.  It's bundled as part of the PicketBox implementation in JBoss
and provides a pluggable security model which allows application developers
to authenticate against any multiple providers without changes to application
code. It's what makes it trivial for Java developers to authenticate web users
against a corporate LDAP store or employee database, for example. TorqueBox 
gives Ruby developers the same ability with only a few lines of code.

## Why Use It?

We think there are at least two kinds of developers who might be interested
in TorqueBox - Ruby developers looking for scalability and "enterprise" 
integration; and Java developers looking for a way to get into Ruby. 
TorqueBox::Authentication aims to be useful to both.  If you are a Java
developer in a corporate environment, you can now build Ruby apps that
easily integrate with your corporate user store.  And if you write Ruby apps
it's trivial to lock them down with some basic user authentication.

## Example

### Application Configuration

### Adding a User

### Code Sample

## Advanced Configuration &amp; Usage


If you have any questions, comments, or concerns, don't hesitate to [join our community][contact].

[jboss-docs]: http://www.jboss.org/jbossas/docs/6-x/Core-Documentation/security.html
[tasks]: http://torquebox.org/documentation/current/messaging.html#async-tasks
[repo]: https://github.com/torquebox/torquebox
[template]: https://github.com/torquebox/torquebox/blob/master/system/rake-support/share/rails-template.rb
[marshal]: http://www.ruby-doc.org/core/classes/Marshal.html
[contact]: http://torquebox.org/community/

