---
title: 'See Behind the TorqueBox Curtain with BackStage'
author: Toby Crawley
layout: news
tags: [ backstage jmx ]
---

[repo]: https://github.com/torquebox/backstage
[Sinatra]: http://sinatrarb.com
[torquebox.yml]: https://github.com/torquebox/backstage/blob/master/config/torquebox.yml
[community]: http://torquebox.org/community/

We recently pushed a somewhat stable development version of BackStage to
our [repo], and are ready for folks to start playing with it.

## What is BackStage?##

<img src="/images/backstage-queues.png" alt="BackStage Queues"/>

BackStage is a [Sinatra] application that when deployed into a TorqueBox 
server gives you visibility into its apps, queues, topics, message 
processors, jobs, and services. It allows you to browse settings and stats, 
and exposes some actions that change the operational state of the components.
You can:

* pause/resume queues and topics
* stop/start message processors, services, and jobs
* view stats on all of the above 

In addition, BackStage allows you to browse messages on a queue:

<img src="/images/backstage-message.png" alt="BackStage Message"/>

It basically acts as a friendly overlay for JMX, so is very easy to 
extend if there is more data you want to see. The data & actions that are
available from BackStage are also available from `/jmx-console` (with
the exception of queue message browsing), but are better organized in
BackStage.

## Authentication ##

By default, access to BackStage is wide open. You can secure it by setting 
`USERNAME` and `PASSWORD` environment variables in [torquebox.yml]:

    environment:
      USERNAME: backstage
      PASSWORD: pass

This will enable basic HTTP authentication, and require you to provide
the specified username and password.

## Deployment ##

To deploy BackStage, clone the [git repo][repo], then run bundler:

    jruby -S gem install bundler # if you haven't done so already
    jruby -S bundle install
    
Once that's done, you can either deploy a deployment descriptor pointing at 
the checked out repo:

    jruby -S rake torquebox:deploy
    
or archive and deploy it as a .knob:

    jruby -S rake torquebox:deploy:archive
    
By default, BackStage is deployed to the `/backstage` context (see the `context:` 
setting in [torquebox.yml]).



## API ##

BackStage also provides a RESTful API that allows you to access almost any of the 
data or actions of the web UI (browsing messages via the API is not yet available).
The API provides a top level entry point at `/api` that returns a list of collection 
urls. The data is returned as JSON, and you must either  pass `format=json` as a
query parameter, or set the `Accept:` header to `application/json`. `/api` always
returns JSON, no matter what `Accept:` header or format param you use, and all of 
the urls returned in the JSON include the `format=json` parameter. 

### Example ###

First, we retrieve the API entry point:

    curl http://localhost:8080/backstage/api 

Returns:

    {
      "collections":{
        "apps":"http://localhost:8080/backstage/apps?format=json",
        "queues":"http://localhost:8080/backstage/queues?format=json",
        "topics":"http://localhost:8080/backstage/topics?format=json",
        "message_processors":"http://localhost:8080/backstage/message_processors?format=json",
        "jobs":"http://localhost:8080/backstage/jobs?format=json",
        "services":"http://localhost:8080/backstage/services?format=json"
      }
    }

Then, we'll use the url for services to retrieve the service index:

    curl http://localhost:8080/backstage/services?format=json

Returns:
    
    [
      {
        "resource":"http://localhost:8080/backstage/service/dG9ycXVlYm94LnNlcnZpY2VzOmFwcD1raXRjaGVuLXNpbmsudHJxLG5hbWU9QVNlcnZpY2U=?format=json",
        "name":"AService",
        "app":"http://localhost:8080/backstage/app/dG9ycXVlYm94LmFwcHM6YXBwPWtpdGNoZW4tc2luay50cnE=?format=json",
        "app_name":"kitchen-sink",
        "status":"Started",
        "actions":{
          "stop":"http://localhost:8080/backstage/service/dG9ycXVlYm94LnNlcnZpY2VzOmFwcD1raXRjaGVuLXNpbmsudHJxLG5hbWU9QVNlcnZpY2U=/stop?format=json"
        }
      }
    ]

Each index entry contains the full contents of the entry, along with URL
to access the resource itself. URLs to associated resources are included as
well (the app in this case).

If a resource exposes any actions, they will appear in
the results under `actions`. Action urls must be called via POST, and 
return the JSON encoded resource:

    curl -X POST http://localhost:8080/backstage/service/dG9ycXVlYm94LnNlcnZpY2VzOmFwcD1raXRjaGVuLXNpbmsudHJxLG5hbWU9QVNlcnZpY2U=/stop?format=json
    
Returns:

    {
      "resource":"http://localhost:8080/backstage/service/dG9ycXVlYm94LnNlcnZpY2VzOmFwcD1raXRjaGVuLXNpbmsudHJxLG5hbWU9QVNlcnZpY2U=?format=json",
      "name":"AService",
      "app":"http://localhost:8080/backstage/app/dG9ycXVlYm94LmFwcHM6YXBwPWtpdGNoZW4tc2luay50cnE=?format=json",
      "app_name":"kitchen-sink",
      "status":"Stopped",
      "actions":{
        "start'":"http://localhost:8080/backstage/service/dG9ycXVlYm94LnNlcnZpY2VzOmFwcD1raXRjaGVuLXNpbmsudHJxLG5hbWU9QVNlcnZpY2U=/start'?format=json"
      }
    }

## Caveats ##

BackStage is 'brand new', and probably doesn't give you everything
you'd like to see. if you have any questions, concerns, or feedback,
feel free to [get in touch][community].
