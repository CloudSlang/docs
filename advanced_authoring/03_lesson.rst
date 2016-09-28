Lesson 3 - Operation
====================

Goal
----

In this lesson we'll start writing a CloudSlang operation to test the action
method stub we made in the previous lesson. We want to make sure the action
method is called, the inputs are passed and the outputs are received.

File Setup
----------

First let's create some folders and files so we have the following structure:

- tutorials

  - advanced

    - java_op.sl

Operation Code
--------------

In the **java_op.sl** file let's enter the following code:

.. code-block:: yaml

    namespace: tutorials.advanced

    operation:
      name: java_op

      inputs:
        - text: "I came, I ran, I'm back."
        - force_fail:
            default: "true"
            required: false
        - forceFail:
            default: ${get("force_fail", "")}
            required: false
            private: true

This is pretty standard CloudSlang code. You can see that we've declared a
namespaces that matches our folder structure, a name that matches the file name
and a few inputs.

One thing to take note of is the two versions of the input to force a failure.
In the Java code we wrote we followed Java conventions and named our variable
using camelCase (``forceFail``). The CloudSlang convention however, is to use
snake_case (``force_fail``). So we create a ``force_fail`` input to be used to
pass a value to the CloudSlang operation and we use the ``get()`` function to
put that value into the ``private`` variable ``forceFail`` which will be used by
the Java method.

Next we'll add the code to call the Java action:

.. code-block:: yaml

    java_action:
        gav: 'io.cloudslang.tutorial:java-action:1.0-SNAPSHOT'
        class_name: io.cloudslang.tutorial.actions.SaySomething
        method_name: execute

We refer to the Java action using three pieces of information.

  #.  ``gav`` - the Maven group ID, artifact ID and version (note: the use of
      quotes (``''``) is necessary in YAML due to the colons (``:``) in the
      ``gav`` value)
  #.  ``class_name`` - the fully qualified name of the class where the method we
      want to call resides
  #.  ``method_name`` - the name of the method we want to call

Finally, we'll add some code to deal with the outputs and to return a meaningful
result.

.. code-block:: yaml

  outputs:
    - message
    - return_code: ${returnCode}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

Once again this is fairly standard CloudSlang code. And again you'll notice how
we take the ``returnCode`` output that we receive from the Java funtion and
rename it to ``return_code`` as per the CloudSlang convention.

Run It
------

Now we can run the CloudSlang operation using the CLI and see if the action
method is called, the inputs are passed properly and the outputs are received
properly.

Fire up the CLI and enter the following command, replacing the partial path in
angle brackets (``<>``) with your proper path:

.. code-block:: bash

  run --f <path to folder>/tutorials/advanced/java_op.sl

Also try running the operation with inputs to change the result.

.. code-block:: bash

  run --f <path to folder>/tutorials/advanced/java_op.sl --i force_fail=true
