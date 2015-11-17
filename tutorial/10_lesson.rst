Lesson 10 - For Loop
====================

Goal
----

In this lesson we'll learn how to use a for loop to create an iterative
task.

Get Started
-----------

The idea here is to continually try the ``create_user_email`` subflow
until it either creates an available address or fails. To do so, we
should be able to leave the subflow as is and just work on the
``create_email_address`` task in **new_hire.sl**.

Loop Syntax
-----------

An iterative task looks very similar to a standard task that only runs
once. To transform our ``create_email_address`` task into one that loops
we'll add the ``loop`` key along with a loop expression and indent the
``do`` and ``publish`` sections. For now, we'll loop over a list of
numbers.

.. code-block:: yaml

    - create_email_address:
        loop:
          for: attempt in [1,2,3,4]
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

YAML Note: A list can be written using bracket (``[]``) notation
instead of using indentation and hyphens (``-``).

For each item in our list the ``attempt`` loop variable is assigned the
value and then passed to an iteration of the subflow call.

Since we're assigning a value to ``attempt`` in the loop and not using
it as flow input we can delete it from the flow's input list.

Default Behavior
----------------

We can save the file and run the flow now and see how the loop works. It
won't quite do what we want yet, but it will demonstrate what a
loop's default behavior is. Play around a bit with passing the
optional middle name and not passing it to see what happens. Also try
removing the last item in the loop expression's list.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials --i first_name=john,middle_name=e,last_name=doe

The first thing you'll notice is that the subflow is being run several
times. This is what our loop has done. Next, you'll notice that
depending on whether you've passed a middle name and how big the loop
list is different things will happen. This is due to the default
behavior of loops and our ``create_user_email`` subflow.

By default a loop exits when either the list it is looping on has been
exhausted or the operation or sublfow called returns a result of
``FAILURE``. This will explain the following cases:

+--------+-------------------+-------------+--------------+------------------------------+
| case   | ``middle_name``   | list        | iterations   | flow result                  |
+========+===================+=============+==============+==============================+
| 1      | no                | [1,2,3,4]   | 3            | ``FAILURE``                  |
+--------+-------------------+-------------+--------------+------------------------------+
| 2      | yes               | [1,2,3,4]   | 4            | ``FAILURE``                  |
+--------+-------------------+-------------+--------------+------------------------------+
| 3      | no                | [1,2,3]     | 3            | ``FAILURE``                  |
+--------+-------------------+-------------+--------------+------------------------------+
| 4      | yes               | [1,2,3]     | 3            | ``FAILURE`` or ``SUCCESS``   |
+--------+-------------------+-------------+--------------+------------------------------+

**For all cases:** For ``attempt`` ``1`` and ``2`` the
``create_user_email`` subflow runs it will return a result of either
``CREATED`` or ``UNAVAILABLE`` because the ``generate_user_email``
operation will return a result of ``SUCCESS``. Since neither of those
are ``FAILURE``, the loop will continue to run.

**Case 1:** Since the ``middle_name`` is not present, the
``generate_user_email`` operation will return a result of ``FAILURE``
when the ``3`` is passed to its ``attempt`` input. The loop exits on the
``FAILURE`` result by default and goes to its navigate section which
forwards it to ``print_fail``. Since ``print_fail`` is the
``on_failure`` task, it ends the flow with a result of ``FAILURE``.

**Case 2:** This case is very similar to the previous one. The only
difference is that the ``generate_user_email`` operation will return a
result of ``FAILURE`` when the ``4``, not ``3``, is passed to its
``attempt`` input.

**Case 3:** This case is even more similar to the first case. The first
case never got to the 4th iteration of the loop, so we can expect that
it we removed the 4th item from the list the same thing will happen.

**Case 4:** This time we have a ``middle_name`` so the
``create_user_email`` subflow will run successfully all three times,
returning results of either ``CREATED`` or ``UNAVAILABLE``. Since
neither of those are ``FAILURE``, the loop will only exit when the list
is exhausted. At that point the result from the last iteration of the
task will be used by the navigation to see where the flow goes next. If
the last iteration's result is ``CREATED``, the ``print_finish`` task
will run and the flow will end with a result of ``SUCCESS``. If the last
iteration's result is ``UNAVAILABLE``, the ``print_fail`` task will run
and the flow will end with a result of ``FAILURE``.

Custom Break
------------

Now that we understand what happens in the default case, let's put in a
custom break so the loop will do what we want it to. We want the loop to
stop when we've either found a suitable email address or something has
gone wrong, so we'll add a ``break`` key with a list of results we want
to break on, which in our case is ``CREATED`` or ``FAILURE``.

.. code-block:: yaml

    - create_email_address:
        loop:
          for: attempt in [1,2,3,4]
          do:
            create_user_email:
              - first_name
              - middle_name
              - last_name
              - attempt
          publish:
            - address
          break:
            - CREATED
            - FAILURE
        navigate:
          CREATED: print_finish
          UNAVAILABLE: print_fail
          FAILURE: print_fail

In a case where we want the loop to continue no matter what happens, we
would have to override the default break on a result of failure by
mapping the ``break`` key to an empty list (``[]``).

The published ``address`` variable will contain the ``address`` value
from the last iteration of the loop. We can use at the same way
published variables are used in regular tasks. However, when using
loops, you often want to aggregate the published output. We will do that
in the next lesson.

List Types
----------

One last thing we can change to improve our flow is the loop's list.
Right now we're using a literal list, but we can use any Python
expression that results in a list instead. So here we can substitute
``[1,2,3,4]`` with ``range(1,5)``. We could also use a comma delimited
strings which would be split automatically into a list.

Run It
------

Everything should be working as expected now. We can save our file and
run the flow with or without a middle name. Note: to test a result of
``FAILURE`` it's best not to pass a middle name and run the flow several
times.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials --i first_name=john,last_name=doe

Up Next
-------

In the next lesson we'll write another loop and aggregate the
information that is output.

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

      workflow:
        - print_start:
            do:
              base.print:
                - text: "Starting new hire process"

        - create_email_address:
            loop:
              for: attempt in range(1,5)
              do:
                create_user_email:
                  - first_name
                  - middle_name
                  - last_name
                  - attempt
              publish:
                - address
              break:
                - CREATED
                - FAILURE
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
