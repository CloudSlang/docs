Lesson 2 - Project Setup
========================

Goal
----

In this lesson we'll set up our Maven project and write a stub action.

Project
-------

Let's start by creating a project. From the menu in IntelliJ, create a new Maven
project. We'll set the **GroupId** to ``io.cloudslang.tutorial`` and the
**ArtifactId** to ``simple-http-client``. Finally, we'll name the project
``JavaActionTutorial`` and choose our preferred location.

POM
---
At this point, IntelliJ should have created a **pom.xml** file for your project
already. Now we'll add a bit more information to the file within the ``project``
tags.

.. code-block:: xml

  <packaging>jar</packaging>
    <name>${project.groupId}:${project.artifactId}</name>
    <description>A simple http client action</description>
    <dependencies>
      <dependency>
        <groupId>com.hp.score.sdk</groupId>
        <artifactId>score-content-sdk</artifactId>
        <version>1.10.6</version>
      </dependency>
      <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.11</version>
        <scope>test</scope>
      </dependency>
    </dependencies>
    <build>
      <plugins>
        <plugin>
          <artifactId>maven-compiler-plugin</artifactId>
          <version>3.1</version>
          <configuration>
            <source>1.7</source>
            <target>1.7</target>
            </configuration>
        </plugin>
      </plugins>
    </build>

Here we've declared the type of packaging we want, a name, a description and the
dependencies we'll be using in our project. We've started by declaring the score
sdk, which contains some of the Java annotations we need, and JUnit, which we'll
use for testing, as dependencies. We'll add more dependencies along the way as
we need them.


Class File
----------

Now that we have our project set up, let's start by create the class that will
house the method called from CloudSlang. In the **src\\main\\java** folder let's
create a new package named ``io.cloudslang.tutorial.httpclient.actions``. And
within that package, create a new class named ``HttpClientAction``.

Imports
-------

We'll need to start by adding some imports. These imports refer to the action
annotations and a couple of other things the annotations will use. We'll see
what each of these are used for momentarily. Also we import some data structures
that we'll use.

.. code-block:: java

  import com.hp.oo.sdk.content.annotations.Action;
  import com.hp.oo.sdk.content.annotations.Output;
  import com.hp.oo.sdk.content.annotations.Param;
  import com.hp.oo.sdk.content.annotations.Response;
  import com.hp.oo.sdk.content.plugin.ActionMetadata.MatchType;
  import com.hp.oo.sdk.content.plugin.ActionMetadata.ResponseType;

  import java.util.HashMap;
  import java.util.Map;

@Action Annotation
------------------

Next, we'll add the ``@Action`` annotation within the class. This annotation
allows CloudSlang to understand what information needs to be passed to the
action method and what information it will receive from the action method.

An @Action is made up of three parts. First, we provide a name for the action.
Second, we declare an array of outputs for the action using the ``@Output``
annotation. Third, we decalre an array of responses for the action using the
``@Response`` annotation.

.. code-block:: java

  @Action(name = "Stub",
          outputs = {
                  @Output("message"),
                  @Output("returnCode")
          },
          responses = {
                  @Response(text = "success", field = "returnCode", value = "0", matchType = MatchType.COMPARE_EQUAL, responseType = ResponseType.RESOLVED),
                  @Response(text = "failure", field = "returnCode", value = "-1", matchType = MatchType.COMPARE_EQUAL, responseType = ResponseType.ERROR, isOnFail = true)
          }
    )

Here we name the @Action ``Stub``. After that we declare some outputs in an
array using the ``@Output`` annotation and we provide a string for each output's
name. This name will be used in the CloudSlang operation to retrieve the
output's value. Finally, in another array we declare the responses that our
action can return. (These are not actually used by CloudSlang operations.)

Each @Response is made of several parts:

  - ``text``: name of the response
  - ``field``: output to be checked
  - ``value``: value to check against
  - ``matchType``: type of check
    (from com.hp.oo.sdk.content.plugin.ActionMetadata.MatchType)
  - ``responseType``: type of response
    (from com.hp.oo.sdk.content.plugin.ActionMetadata.ResponseType)
  - ``isDefault``: whether or not response is the default response
  - ``isOnFail``: whether or not response is the failure response

@Action Method
--------------

Now we'll write the method that will be called by the CloudSlang operation.
By convention, we name this method ``execute``.The method must conform to the
following signature:

.. code-block:: java

  public Map<String, String> methodName(@Param(name) Type param, ...)

The map that is returned contains the names and values of the outputs of the
action. The names are the same ones that were declared using ``@Output`` in the
``@Action`` annotation. The parameters that are declared with the ``@Param``
annotation are the inputs that the method will receive from the CloudSlang
operation. Each ``@Param`` will contain at least value for its name. It may also
contain a ``required`` boolean to override the default of ``false``.

Let's create our method and add a couple of parameters:

.. code-block:: java

  public Map<String, String> execute(@Param(value = "text", required = true) String text,
                                     @Param("forceFail") String forceFail){
  }

Inside the method we'll just write a few lines of code that will allow us to get
an idea of how CloudSlang communicates with the action method and test it out a
bit.

.. code-block:: java

  Map<String, String> results = new HashMap<>();
  results.put("message", "Hello from Java. The text you sent me is: " + text);
  if(Boolean.parseBoolean(forceFail)){
      results.put("returnCode", "-1");
  }
  else{
      results.put("returnCode", "0");
  }
  return results;

We start by creating a map that will eventually contain the output values of the
method (by convention, we call this map ``results``). Then we add a values for
the two outputs and return the map.

Tests
-----

Next, let's set up some tests. In the **src\\test\\java** folder let's create a new
package named ``io.cloudslang.tutorial.httpclient.actions``. And within that
package, create a new class named ``HttpClientActionTest``.

Here are a couple of quick tests that we can use to make sure everything is
running properly.

.. code-block:: java

  package io.cloudslang.tutorial.httpclient.actions;

  import org.junit.Assert;
  import org.junit.Test;

  import java.util.Map;

  public class HttpClientActionTest {
      @Test
      public void testSpeakSuccess() {
          HttpClientAction saySomething = new HttpClientAction();
          Map<String, String> result = saySomething.execute("hullabaloo", "false");

          Assert.assertEquals("Hello from Java. The text you sent me is: hullabaloo", result.get("message"));
          Assert.assertEquals("0", result.get("returnCode"));
      }

      @Test
      public void testSpeakFailure() {
          HttpClientAction saySomething = new HttpClientAction();
          Map<String, String> result = saySomething.execute("hullabaloo", "true");

          Assert.assertEquals("Hello from Java. The text you sent me is: hullabaloo", result.get("message"));
          Assert.assertEquals("-1", result.get("returnCode"));
      }
  }

Create Jar
----------

Now that our code is all ready, we can package everything into a jar file. In
the **Maven Projects** pane (**View -> Tool Windows -> Maven Projects**), run
the **package** lifecycle phase. The output of the run will contain the path to
the recently created jar. Take note of that location because we'll be using it
in a minute.

Install Jar in CloudSlang Maven Repo
------------------------------------

We'll now use Maven to install the jar file into the local CloudSlang Maven
repo. (Alternatively, you can upload the jar to a remote Maven repository and
:ref:`configure <maven_configuration>` the CloudSlang CLI to automatically
retrieve it from there).

At a command prompt enter the following, replacing the partial paths in angle
brackets (``<>``) with your proper paths:

..code-block::

  mvn install:install-file -Dfile=<path to project>\JavaActionTest\target\java-action-1.0-SNAPSHOT.jar -DgroupId=io.cloudslang.tutorial -DartifactId=java-action -Dversion=1.0-SNAPSHOT -Dpackaging=jar -DlocalRepositoryPath=<path to cli>\cslang-cli\maven\repo

Up Next
-------

We'll create a CloudSlang operation to run the action method we just created.
