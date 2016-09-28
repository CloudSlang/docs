Lesson 1 - Introduction
=======================

Goal
----

In this lesson we'll outline our overall goals for this tutorial.

Overview
--------

In this tutorial we will build a Java @Action that performs a simple HTTP
request. We will write the code incrementally, with the goal of learning the
building blocks for writing your own @Actions. We recommend you follow along
with the process, writing the code on your own machine. We will use IntelliJ as
our IDE, but you are free to use any IDE that supports Maven and JUnit.

This tutorial is for advanced authoring. The regular tutorial can be found
:doc:`here <../tutorial/01_lesson>`.

@Actions
--------

CloudSlang operations contain an action, which is either a ``python_action`` or
a ``java_action``. The Python script that makes up a ``python_action`` is
written directly in the CloudSlang operation file. However, the Java code that
is called from a ``java_action`` is contained in an external Maven artifact. The
``java_action`` refers to the appropriate method to call using the artifact's
``group:artifact:version``, a ``class_name`` and a ``method_name``. @Actions are
used, as opposed to a Python script, for various reasons. Most often, @Actions
are used because of the complexity of the action or because of the availability
of 3rd party libraries in Java.

To review how a CloudSlang ``java_action`` is called, see the
:ref:`DSL Reference <java_action>`.

Prerequisites
-------------

This tutorial assumes a working knowledge of CloudSlang, Java, Maven and JUnit.
As mentioned above, we will use IntelliJ as our Java development environment. We
will also write and run a CloudSlang operation that calls our @Action. To do so,
you will need the :doc:`CloudSlang CLI <../cloudslang_cli>` and optionally the
:ref:`Atom <atom>` text editor with the CloudSlang language package installed.

@Actions Repository
-------------------

There is a repository of existing Java @Actions which can be found on
`GitHub <https://github.com/CloudSlang/cs-actions>`__. Included in that
repository is the `HTTP Client Action <https://github.com/CloudSlang/cs-actions/tree/master/cs-http-client/src/main/java/io/cloudslang/content/httpclient>`__
which is a more robust version of the @Action we will create.

In this tutorial will create our @Action as a standalone project, not part of
the **cs-actions** repository. You can, of course, create your @Actions as
additional actions in the **cs-actions** repository and contribute them to the
community.

Conventions
-----------

There are many ways to write @Actions for CloudSlang. In this tutorial we will
not attempt to cover all possible options. Instead we will focus on the best
practices and conventions adopted in many of the actions found in the
`cs-actions repository <https://github.com/CloudSlang/cs-actions>`__.

Up Next
-------

In the next lesson we'll setup our project to start writing code.
