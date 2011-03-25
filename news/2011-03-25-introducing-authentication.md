---
title: TorqueBox::Authentication
author: Lance Ball
layout: news
tags: [ security, authentication ]
---

TorqueBox, as you probably know by now, is built on top of the JBoss Application
Server.  That's what allows us to bring to Ruby such awesomeness as integrated
queues, messaging and tasks.  One of the other features that JBoss provides is
an implementation of the Java Authentication and Authorization Specification,
usually just referred to as JAAS.  Now, your Ruby apps can JAAS it up as well
with just a few lines of code.  

## What is JAAS?  

The [JAAS API][jaas-reference] is a set of Java packages designed for user
authentication and authorization.  It's bundled as part of the [PicketBox][picket-box]
implementation in JBoss and provides a pluggable security model which allows
application developers to authenticate against multiple providers without
changes to application code. It's what makes it trivial for Java developers to
authenticate web users against a corporate LDAP store or employee database, for
example. TorqueBox gives Ruby developers the same ability with only a few lines
of code.

## Why Use It?

We think there are at least two kinds of developers interested in TorqueBox -
Ruby developers looking for scalability, simple deployment and integrated
awesomeness; and Java developers looking for a way out of the nightmare.  Most
of the users we know about at the moment are Ruby developers and so we'll start
there.

First, let's be clear. This is not intended to replace `authlogic`,
`restful_authentication`, or any of the other auth gems you might be familiar
with in the Ruby world. These tools are an awesome way to wire up user
accounts for a web app.  They're most often used in situations where end-users
are creating accounts by signing up online, with the result being a row
somewhere in a `users` table fronted by ActiveRecord. But there are other 
scenarios where you might want authentication without everything else - something
akin to HTTP Basic Authentication but with more flavor and which can be integrated
into your application.

  - You've got a staging server running TorqueBox with 4 different apps for 4
    different clients.  You want a way to keep prying eyes out, but don't want
    to build a complete user model just to allow your clients to have a
    form-based login.

  - You're building apps that have only one or two users and you don't need a
    full ActiveRecord model.  For example, apps running behind a corporate
    firewall with only a few employees having access.

  - You want to authenticate against an LDAP data store or something else not
    inherent to your application.

If you're already familiar with JAAS and are interested in authenticating with
an existing corporate user store, we've got you covered there too.  Want to
learn more about JAAS and how it works inside of JBoss? Check out the JBoss
[security docs][jboss-docs].  We're sorry about that. One of our big goals
with TorqueBox is to expose enterprise awesomeness without a single line of
XML.  We found, however, that the JBoss JAAS implementation is pretty tightly 
tied to XML files and there was not a good way to get rid of this coupling.

We hear that AS7 has much more awesomeness and are looking forward to making
this XML business disappear. Still, it's not all that bad as it is.  
With TorqueBox::Authentication and a few lines of XML in your JBoss configuration
file your LDAP authentication looks like this:

<script src="https://gist.github.com/887584.js?file=torquebox-auth.rb"></script>

Notice that there's no mention of LDAP in your Ruby code. Corporate honchos
decide to move from LDAP to something else? No problem, your app doesn't change.

## Example

So, how does it work? Let's jump straight to the code. It's easy.  TorqueBox
gives your ruby applications access to the `TorqueBox::Authentication` module.
To use it just require `torquebox` and `org/torquebox/auth/authentication`.
Here's a very simple authentication module in Ruby.

<script src="https://gist.github.com/887584.js?file=sample-auth-module.rb"></script>
    
The API has 3 simple methods:

  - `default` : Provides a handle to the default authenticator
  - `[]( name )` : Provides a handle to a named authenticator
  - `authenticate( username, password )` : Authenticates a user 

The `authenticate` method also accepts a block, so you can execute code
within an authenticated context.

Using this module, a Sintra route for the `/login` method might look like this.

<script src="https://gist.github.com/887584.js?file=login_controller.rb"></script>

### Application Configuration

Authentication is enabled out of the box for all Ruby applications in TorqueBox
using the default authenticator wired to the `torquebox-auth` security policy.
If you're interested in the simple use cases, such as locking down an application
to one or two admin users, this is perfectly sufficient.  If you're really 
interested in wiring up to existing authentication services in your corporate
environment, see the Advanced Configuration &amp; Usage setting below.
More [documentation][docs] can be found with our latest dev builds.

### Adding a User

The default authentication domain for TorqueBox uses the `UsersRolesLoginModule`
in JBoss. This is a simple file-based authentication class which looks for users
and roles properties files on the file system.  These can be found in 
`$JBOSS_HOME/server/default/conf/props/torquebox-users.properties` and 
`$JBOSS_HOME/server/default/conf/props/torquebox-roles.properties`. You can edit
these files by hand if you like, or use our rake task.

    $ jruby -S rake torquebox:auth:adduser CREDENTAILS=skoba:p@ssW0rd


## Advanced Configuration &amp; Usage

The JBoss Application Server provides functionality that allows
application developers to authenticate against one of many named and configured
security policies. We refer to these policy names as "domains". TorqueBox ships
with a simple authentication domain, `torquebox-auth` pre-configured in the
Application Server as noted above.  We also ship preconfigured with authentication
policies for the underlying components, such as HornetQ and JMX.  

Of course, if you're already running JBoss servers in a corporate environment, you may
also have LDAP or other policies already in place. To integrate these into TorqueBox,
just add your policy to `$JBOSS_HOME/server/default/conf/login-config.xml`. Details
on how to configure JBoss can be found in the JBoss [security documentation][jboss-docs].

Let's say you're writing an application for a corporate intranet, and your user
data is in 2 different LDAP servers, `internal.corp.com` and
`clients.corp.com`, and you've configured these in JBoss with policy names 
`internal-auth` and `client-auth`.  You can configure these policies in an `auth`
section of `torquebox.yml` or in a separate `auth.yml` file for your application.  

<script src="https://gist.github.com/887584.js?file=auth.yml"></script>
    
Then in your application code, you can authenticate against each of them like so.

<script src="https://gist.github.com/887584.js?file=advanced_auth.rb"></script>

There are lots of other ways you can take advantage of `JAAS` authentication and we
look forward to having folks try it out and give us feedback.  The integration is pretty 
immature at this point.  For example, we've completely ignored the authorization pieces.

If you have any questions, comments, or concerns, don't hesitate to [join our community][contact].

[picket-box]: http://www.jboss.org/picketbox
[jboss-docs]: http://www.jboss.org/jbossas/docs/6-x/Core-Documentation/security.html
[jaas-reference]: http://download.oracle.com/javase/1.4.2/docs/guide/security/jaas/JAASRefGuide.html
[docs]: http://torquebox.org/documentation/DEV/authentication.html
[contact]: http://torquebox.org/community/

