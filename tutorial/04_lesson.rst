Lesson 4 - Outputs and Results
==============================

Goal
----

In this lesson we'll write a bit of a more complex operation that
returns an output and results.

Get Started
-----------

Let's create a new file in the **tutorials/hiring** folder named
**check\_availability.sl** in which we'll house an operation to check
whether a given email address is available.

We'll also start off our new operation in much the same way we did with
the print operation. We'll put in a ``namespace``, the ``operation``
key, the name of the operation and an input.

.. code:: yaml

    namespace: tutorials.hiring

    operation:
      name: check_availability

      inputs:
        - address

Action
------

This time we'll have a little more of a complex action. The idea here is
to simulate checking the availability of the given address. We'll import
and use the Python random module to get a random number between 0 and 2.
If the random number we get is 0 we'll say the requested email address
is already taken.

We've added a commented out line, using a Python comment (#) to print
the random number that was generated. We can uncomment this line during
testing to see that our operation is working as expected.

.. code:: yaml

      action:
        python_script: |
          import random
          rand = random.randint(0, 2)
          vacant = rand != 0
          #print rand

YAML Note: Since we're writing a multi-line Python script here we
use the pipe (\|) character to denote the usage of literal style
block notation where all newlines will be preserved.

Outputs
-------

In the outputs section we put any information we want to send back to
the calling flow. In our case, we want to return whether the requested
address was already taken. The outputs are a list of key:value pairs
where the key is the name of the output and the value the expression to
be returned. In our case, we'll just return the value in the ``vacant``
variable.

.. code:: yaml

      outputs:
        - available: vacant

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

.. code:: yaml

      results:
        - FAILURE: rand == 0
        - SUCCESS

Run It
------

Let's save and run this operation by itself before we start using it in
our flow to make sure everything is working properly. (You might want to
uncomment the line that prints out the random number while testing.) To
run the operation, enter the following in the CLI:

.. code:: bash

    run --f <folder path>/tutorials/hiring/check_availability.sl --i address=john.doe@somecompany.com

Run the operation a few times and make sure that both the ``SUCCESS``
and ``FAILURE`` cases are working as expected.

Up Next
-------

In the next lesson we'll integrate our new operation into our flow,
using the output and results it sends.

New Code - Complete
-------------------

**check\_availability.sl**

.. code:: yaml

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
        - available: vacant

      results:
        - FAILURE: rand == 0
        - SUCCESS
