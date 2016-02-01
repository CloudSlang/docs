Lesson 4 - Outputs and Results
==============================

Goal
----

In this lesson we'll write a bit of a more complex operation that
returns an output and results.

Get Started
-----------

Let's create a new file in the **tutorials/hiring** folder named
**check_availability.sl** in which we'll house an operation to check
whether a given email address is available.

We'll also start off our new operation in much the same way we did with
the print operation. We'll put in a ``namespace``, the ``operation``
key, the name of the operation and an input.

.. code-block:: yaml

    namespace: tutorials.hiring

    operation:
      name: check_availability

      inputs:
        - address

Action
------

This time we'll have a little more of a complex action. The idea here is
to simulate checking the availability of the given address. We'll import
and use the Python ``random`` module to get a random number between 0
and 2. If the random number we get is 0 we'll say the requested email
address is already taken.

We've added a commented-out line, using a Python comment (``#``) to
print the random number that was generated. We can uncomment this line
during testing to see that our operation is working as expected.

.. code-block:: yaml

    action:
      python_script: |
        import random
        rand = random.randint(0, 2)
        vacant = rand != 0
        #print rand

YAML Note: Since we're writing a multi-line Python script here we
use the pipe (``|``) character to denote the usage of literal style
block notation where all newlines will be preserved.

Outputs
-------

In the outputs section we put any information we want to send back to
the calling flow. In our case, we want to return whether the requested
address was already taken. The outputs are a list of key:value pairs
where the key is the name of the output and the value is the expression
to be returned. In our case, we'll just return the value in the
``vacant`` variable.

.. code-block:: yaml

    outputs:
      - available: ${vacant}

Notice the special ``${}`` syntax. This indicates that what is inside the braces
is a CloudSlang expression. If we would have just written ``vacant``, it would
be understood as a string literal. We'll see this syntax in action again in a
few moments.

For more information, see :ref:`expressions` in the DSL reference.

At this point we won't be using the output value, but we will soon
enough. In lesson :doc:`5 - Default Navigation <05_lesson>` we publish
the the ``available`` output and use it in another task.

For more information, see :ref:`outputs` in the DSL reference.

Results
-------

The last section of our operation defines the results we return to the
calling flow. The results are used by the navigation of the calling
flow. We'll start by using the default result values, ``SUCCESS`` and
``FAILURE``. If the email address was available, we'll return a result
of ``SUCCESS``, otherwise we'll return a result of ``FAILURE``. When the
operation is run, the first result whose expression is true or empty is
returned. It is therefore important to take care in the ordering of the
results.

.. code-block:: yaml

    results:
      - FAILURE: ${rand == 0}
      - SUCCESS

The results are used by the calling flow for navigation purposes. You
can see the default navigation rules in action in lessons :doc:`5 - Default
Navigation <05_lesson>` and :doc:`6 - Handling Failure
Results <06_lesson>`. And you can learn how to create custom
navigation in lesson :doc:`7 - Custom Navigation <07_lesson>`.

For more information, see :ref:`results` in the DSL reference.

Run It
------

Let's save and run this operation by itself before we start using it in
our flow to make sure everything is working properly. (You might want to
uncomment the line that prints out the random number while testing.) To
run the operation, enter the following in the CLI:

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/check_availability.sl --i address=john.doe@somecompany.com

Run the operation a few times and make sure that both the ``SUCCESS``
and ``FAILURE`` cases are working as expected.

Download the Code
-----------------

:download:`Lesson 4 - Complete code </code/tutorial_code/tutorials_04.zip>`

Up Next
-------

In the next lesson we'll integrate our new operation into our flow,
using the output and results it sends.

New Code - Complete
-------------------

**check_availability.sl**

.. code-block:: yaml

    namespace: tutorials.hiring

    operation:
      name: check_availability

      inputs:
        - address

      action:
        python_script: |
          import random
          rand = random.randint(0, 2)
          vacant = rand != 0
          #print rand

      outputs:
        - available: ${vacant}

      results:
        - FAILURE: ${rand == 0}
        - SUCCESS
