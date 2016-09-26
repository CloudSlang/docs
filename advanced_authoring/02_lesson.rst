Lesson 2 - Project Setup
========================

Goal
----

In this lesson we'll setup our Maven project.

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
sdk, which contains some of the Java annotations we need, as a dependency. We'll
add more dependencies along the way as we need them.

Up Next
-------

TODO
