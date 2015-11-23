Lesson 7 - Custom Navigation
============================

Goal
----

In this lesson we'll learn how to override the default navigation,
declaring our own results and navigating based on them.

Get Started
-----------

Once again, we'll continue working on the flow in **new\_hire.sl**. This
time though, we'll try to replicate the default navigation behavior
using explicit custom navigation. To do that we'll have to change
**check\_availability.sl** as well.

Custom Results
--------------

Let's change the results of the ``check_availability`` operation to more
closely reflect what is actually going on. Instead of using the default
``SUCCESS`` and ``FAILURE`` we'll create our own result labels named
``AVAILABLE`` and ``UNAVAILABLE``.

.. code:: yaml

      results:
        - UNAVAILABLE: rand == 0
        - AVAILABLE

Custom Navigation
-----------------

Now that we've customized the result labels, the flow doesn't know what
to do upon receipt of these results. Instead of relying on the default
navigation, we'll have to explicitly tell the flow what to do next. For
now, we'll just replicate what the flow would have done in the default
navigation. We have to add navigation logic to the task for all possible
results. We do so under the ``navigate`` key. Each possible result is
mapped to the task that should be navigated to when returned.

.. code:: yaml

        - check_address:
            do:
              check_availability:
                - address
            publish:
              - availability: available
            navigate:
              UNAVAILABLE: print_fail
              AVAILABLE: print_finish

Run It
------

This time, not only can we save the file and then run the flow using the
exact command we used in the last lesson, but we expect everything to
work exactly as it did before.

.. code:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials/base,<folder path>/tutorials/hiring --i first_name=john,last_name=doe,domain=somedomain.com

Up Next
-------

In the next lesson we'll look at how to use the various properties of
inputs.

New Code - Complete
-------------------

**new\_hire.sl**

.. code:: yaml

    namespace: tutorials.hiring

    imports:
      base: tutorials.base

    flow:
      name: new_hire

      inputs:
        - address

      workflow:
        - print_start:
            do:
              base.print:
                - text: "'Starting new hire process'"

        - check_address:
            do:
              check_availability:
                - address
            publish:
              - availability: available
            navigate:
              UNAVAILABLE: print_fail
              AVAILABLE: print_finish

        - print_finish:
            do:
              base.print:
                - text: "'Availability for address ' + address + ' is: ' + str(availability)"

        - on_failure:
          - print_fail:
              do:
                base.print:
                  - text: "'Failed to create address: ' + address"

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
          #print vacant

      outputs:
        - available: vacant

      results:
        - UNAVAILABLE: rand == 0
        - AVAILABLE
