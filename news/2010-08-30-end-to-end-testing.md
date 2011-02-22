---
title: End-to-end testing of TorqueBox with Arquillian
author: Bob McWhirter
layout: news
tags: [ testing, arquillian ]
---

In preparation for the 1.0.0.Beta21 (yes, twenty-one) release, we've set up
some *integration tests* for the TorqueBox build.

At the end of the day, the acceptance-testing for TorqueBox boils down to
"does my Rails/Sinatra/Rack application deploy and work on TorqueBox?"

To validate that, we need to actually stand up the TorqueBox AS we build,
deploy some apps to it, and validate that they worked.

Since TorqueBox is ostensibly a Java (yes, Java) project, it's built with
Maven.  Being built with maven and being centered around a Java app-server,
we're able to use [JBoss Arquillian](http://www.jboss.org/arquillian/) to
control the lifecycle of the AS, orchestrating the deployment of test
artifacts (sample applications) and the execution of tests against them.

While Arquillian can perform in-container testing, we're currently not
using that functionality.

The first thing we have to do is add a `arquillian.xml` to our test classpath,
so that when Arquillian wants to fire up an AS, it knows which AS and how to
do it.  

Note, we do run our `arquillian.xml` through Maven's test-resource filtering
to replace our `${integ.dist.dir}`.

    <?xml version="1.0"?>

    <arquillian xmlns="http://jboss.com/arquillian"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:jboss="urn:arq:org.jboss.arquillian.container.jbossas.managed_6">

      <engine>
        <deploymentExportPath>/tmp</deploymentExportPath>
      </engine>

      <jboss:container>
        <jboss:profileName>default</jboss:profileName>
        <jboss:bindAddress>127.0.0.1</jboss:bindAddress>
        <jboss:httpPort>8080</jboss:httpPort>
        <jboss:jbossHome>${integ.dist.dir}/jboss</jboss:jbossHome>
      </jboss:container> 

    </arquillian>

After that, we write basically normal JUnit test-cases, with two exceptions.

First, we mark the test-cases to run using Arquillian's test-runner. We do this in
and abstract test-case [(AbstractIntegrationTest.java)](http://github.com/torquebox/torquebox/blob/master/integration-tests/src/test/java/org/torquebox/integration/AbstractIntegrationTest.java) that all of our integration tests will descend from.

    @RunWith(Arquillian.class)
    public abstract class AbstractIntegrationTest {
        ...
    }

Also, our test has to create a *deployment*, which is really just a fancy word
for "some archive to deploy into the AS".  In typical Arquillian usage, I gather
this would be a JAR or a WAR holding the components you wanted to test.

For us, though, a *deployment* is simply a sample application we want to toss
into the AS, to see if it works. Since we use tiny little [deployment descriptors](http://torquebox.org/documentation/1.0.0.Beta20/web.html#d0e231)
to deploy applications laying elsehwere on the disk, we just create a minimal
JAR, holding a `*-rails.yml` descriptor.

Now, we can write our actual tests.  For instance, this one deploys a
simple Rails 2.3.8 application, uses Selenium to make a request, and
verifies that it found a `<div>` with the ID of `success`. The test itself
runs outside of the AS.

    @Run(RunModeType.AS_CLIENT)
    public class BasicRails_2_3_8_Test extends AbstractIntegrationTest {

        @Deployment
        public static JavaArchive createDeployment() {
            return createDeployment( "rails/2.3.8/basic-rails.yml" );
        }

        @Test
        public void testHighLevel() {
            driver.get( "http://localhost:8080/basic-rails" );
            WebElement element = driver.findElementById( "success" );
            assertNotNull( element );
            assertEquals( "basic-rails", element.getAttribute( "class" ) );
        }

    }

Now, from the command-line, in our integration tests module, we simply type

    mvn test

And Arquillian will...

1. Launch the TorqueBox AS
1. Deploy the Rails 2.3.8 application
1. Run each `@Test`
1. Undeploy the application
1. Stop the AS

And all of this reports back through normal JUnit test-reports.

That's pretty slick.

