Lesson 9 - Subflows
===================

Goal
----

In this lesson we'll learn how to use subflows.

Get Started
-----------

We'll start by creating a new file in the **tutorials/hiring** folder
called **create_user_email.sl** to hold our subflow. A subflow is a
flow itself and therefore it follows all the regular flow syntax.

Move Code
---------

Now we'll steal a bunch of the code that currently sits in
**new_hire.sl**. Let's take everything up until the ``workflow`` key
and copy it into the new flow and make a couple of changes. First, we
won't need the imports, so we can just delete them. Next, we'll change
the name of the flow to ``create_user_email``. That should do it for
this section.

.. code-block:: yaml

    namespace: tutorials.hiring

    flow:
      name: create_user_email

      inputs:
        - first_name
        - middle_name:
            required: false
        - last_name
        - attempt

Next let's create a ``workflow`` section and copy the
``generate_address`` and ``check_address`` tasks into it.

.. code-block:: yaml

    workflow:
      - generate_address:
          do:
            generate_user_email:
              - first_name
              - middle_name
              - last_name
              - attempt
          publish:
            - address: ${email_address}

      - check_address:
          do:
            check_availability:
              - address
          publish:
            - availability: ${available}
          navigate:
            UNAVAILABLE: print_fail
            AVAILABLE: print_finish

Fix Up Subflow
--------------

Now we have to reroute our navigation, add flow outputs and flow
results.

Let's start with adding the flow results. We'll have our flow return one
of three result options.

1. ``CREATED`` - everything went smoothly and a new, available address
   was created
2. ``UNAVAILABLE`` - an address was generated, but it wasn't available
3. ``FAILURE`` - an address was not even generated.

.. code-block:: yaml

    results:
      - CREATED
      - UNAVAILABLE
      - FAILURE

Now we can reroute the tasks' navigation to point to the flow results we
just defined.

For the ``generate_address`` task, whose operation returns ``SUCCESS``
or ``FAILURE``, we can route ``SUCCESS`` to the next task and
``FAILURE`` to the ``FAILURE`` result of the flow.

.. code-block:: yaml

    - generate_address:
        do:
          generate_user_email:
            - first_name
            - middle_name
            - last_name
            - attempt
        publish:
          - address: ${email_address}
        navigate:
          SUCCESS: check_address
          FAILURE: FAILURE

For the ``check_address`` task, whose operation returns ``UNAVAILABLE``
or ``AVAILABLE``, we can route ``UNAVAILABLE`` to the ``UNAVAILABLE``
result of the flow and ``AVAILABLE`` to the ``CREATED`` result of the
flow.

.. code-block:: yaml

    - check_address:
        do:
          check_availability:
            - address
        publish:
          - availability: ${available}
        navigate:
          UNAVAILABLE: UNAVAILABLE
          AVAILABLE: CREATED

Finally, we can pass along the outputs published in the tasks as flow
outputs.

.. code-block:: yaml

    outputs:
      - address
      - availability

Test It
-------

At this point the subflow is ready and we can test it by running it as
we would any other flow. Save the file and run it a few times while
playing with the ``attempt`` input to make sure all three possible
results are being returned at some point.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/create_user_email.sl --cp <folder path>/tutorials --i first_name=john,last_name=doe,attempt=1

Fix Up Parent Flow
------------------

Finally, let's make changes to our original flow so that it makes use of
the subflow we just created.

First let's replace the two tasks we took out with one new task that
calls the subflow instead of an operation. You may have noticed that
both flows and operations take inputs, return outputs and return
results. That allows us to use them almost interchangeably. We've run
both flows and operations using the CLI. Now we see that we can call
them both from tasks as well.

Delete the ``generate_address`` and ``check_address`` tasks. We'll now replace
them with a new task called ``create_email_address``. It will pass along the
flow inputs, publish the necessary outputs and wire up the appropriate
navigation.

.. code-block:: yaml

    - create_email_address:
        do:
          create_user_email:
            - first_name
            - middle_name
            - last_name
            - attempt
        publish:
          - address
        navigate:
          CREATED: print_finish
          UNAVAILABLE: print_fail
          FAILURE: print_fail

All that's left now is to change the text of the messages sent in the
``print_finish`` and ``print_fail`` tasks to better reflect what is
happening.

.. code-block:: bash

    - print_finish:
        do:
          base.print:
            - text: "${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name}"

.. code-block:: bash

        - on_failure:
          - print_fail:
              do:
                base.print:
                  - text: "${'Failed to create address for: ' + first_name + ' ' + last_name}"

Run It
------

Now we can save the files and run the parent flow, which will also run
the subflow. Once again, you should run it a few times and play with the
``attempt`` input to make sure all the possible outcomes are occurring
at some point.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials --i first_name=john,last_name=doe,attempt=1

Download the Code
-----------------

:download:`Lesson 9 - Complete code </code/tutorial_code/tutorials_09.zip>`

Up Next
-------

In the next lesson we'll change our new task to include a loop which
will retry the email creation several times if necessary.

New Code - Complete
-------------------

**new_hire.sl**

.. code-block:: yaml

    namespace: tutorials.hiring

    imports:
      base: tutorials.base

    flow:
      name: new_hire

      inputs:
        - first_name
        - middle_name:
            required: false
        - last_name
        - attempt

      workflow:
        - print_start:
            do:
              base.print:
                - text: "Starting new hire process"

        - create_email_address:
            do:
              create_user_email:
                - first_name
                - middle_name
                - last_name
                - attempt
            publish:
              - address
            navigate:
              CREATED: print_finish
              UNAVAILABLE: print_fail
              FAILURE: print_fail

        - print_finish:
            do:
              base.print:
                - text: "${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name}"

        - on_failure:
          - print_fail:
              do:
                base.print:
                  - text: "${'Failed to create address for: ' + first_name + ' ' + last_name}"

**create_user_email**

.. code-block:: yaml

    namespace: tutorials.hiring

    flow:
      name: create_user_email

      inputs:
        - first_name
        - middle_name:
            required: false
        - last_name
        - attempt

      workflow:
        - generate_address:
            do:
              generate_user_email:
                - first_name
                - middle_name
                - last_name
                - attempt
            publish:
              - address: ${email_address}
            navigate:
              SUCCESS: check_address
              FAILURE: FAILURE

        - check_address:
            do:
              check_availability:
                - address
            publish:
              - availability: ${available}
            navigate:
              UNAVAILABLE: UNAVAILABLE
              AVAILABLE: CREATED

      outputs:
        - address
        - availability

      results:
        - CREATED
        - UNAVAILABLE
        - FAILURE
