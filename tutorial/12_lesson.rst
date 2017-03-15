Lesson 12 - Decisions
======================

Goal
----

In this lesson we'll write a decision. We'll learn the how to use a decision by
creating one that will determine if a given requirement is met.

Get Started
-----------

First, we'll create a **contains.sl** file in the **base** folder. As we'll
see, a decision is very similar to an operation. The only real difference is
that it cannot contain an ``action``.

The ``contains`` decision will determine if a given substring is contained
within a given container string.

Decision
--------

From what we already know, a decision should be pretty self explanatory. So
let's just dive in.

.. code-block:: yaml

    namespace: tutorials.base

    decision:
      name: contains

      inputs:
        - container:
            default: ""
            required: false
        - sub

      results:
        - CONTAINS: ${container.find(sub) >= 0}
        - DOES_NOT_CONTAIN

Just about everything above should be familiar. The only new thing is the
``decision`` keyword which replaces what would have been the ``operation``
keyword in an operation. Other than that, the decision has a ``namespace``,
``name``, ``inputs`` and ``results``. A decision can have ``outputs`` as well,
but we don't use them here.

In terms of function, the decision returns a result of ``CONTAINS`` when ``sub``
is found in ``container`` and a result of ``DOES_NOT_CONTAIN`` otherwise.

Call from Flow
--------------

Now let's call the decision from a flow. Unsurprisingly, a decision is called in
the exact same way an operation or subflow would be called.

In **new_hire.sl**  we'll add a step right after ``get_equipment`` and call it
``check_min_reqs``. That step will call our decision and navigate accordingly.

.. code-block:: yaml

    - check_min_reqs:
        do:
          base.contains:
            - container: ${all_missing}
            - sub: 'laptop'
        navigate:
          - DOES_NOT_CONTAIN: print_finish
          - CONTAINS: print_warning

We pass the ``all_missing`` string to the decision to check if it contains the
word ``'laptop'``. We'll say the if the new hire didn't get a laptop we need to
print a warning.

Clean Up
--------

Finally, to get everything working properly we need to reroute the navigation of
``get_equipment`` add a ``print_warning`` step.

The ``get_equipment`` navigation should now always point to ``check_min_reqs``.

.. code-block:: yaml

    navigate:
      - AVAILABLE: check_min_reqs
      - UNAVAILABLE: check_min_reqs

And we'll add a simple ``print_warning`` step.

.. code-block:: yaml

    - print_warning:
        do:
          base.print:
            - text: >
                ${first_name + ' ' + last_name +
                ' did not receive all the required equipment'}
        navigate:
          - SUCCESS: print_finish

Now let's review the possible scenarios.

#. A laptop was ordered: ``get_equipment`` navigates to ``check_min_reqs``
   which returns a result of ``DOES_NOT_CONTAIN``, therefore navigating to
   ``print_finish`` and then ending the flow. The output is exactly as it was
   before.
#. A laptop was not ordered: ``get_equipment`` navigates to ``check_min_reqs``
   which returns a result of ``CONTAINS``, therefore navigating to
   ``print_warning`` and then ``print_finish`` by default navigation and finally
   ending the flow. The output is as it was before, plus the warning is printed.


Run It
------

We can save the files and run the flow a few times to see that the warning is
printed when appropriate and nothing is changed otherwise.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials --i first_name=john,middle_name=e,last_name=doe

Download the Code
-----------------

:download:`Lesson 12 - Complete code </code/tutorial_code/tutorials_12.zip>`

Up Next
-------

In the next lesson we'll see how to use existing content in your flows.

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
        - all_missing:
            default: ""
            required: false
            private: true
        - total_cost:
            default: '0'
            private: true
        - order_map:
            default: '{"laptop": 1000, "docking station": 200, "monitor": 500, "phone": 100}'

      workflow:
        - print_start:
            do:
              base.print:
                - text: "Starting new hire process"
            navigate:
              - SUCCESS: create_email_address

        - create_email_address:
            loop:
              for: attempt in range(1,5)
              do:
                create_user_email:
                  - first_name
                  - middle_name
                  - last_name
                  - attempt: ${str(attempt)}
              publish:
                - address
                - password
              break:
                - CREATED
                - FAILURE
            navigate:
              - CREATED: get_equipment
              - UNAVAILABLE: print_fail
              - FAILURE: print_fail

        - get_equipment:
            loop:
              for: item, price in eval(order_map)
              do:
                order:
                  - item
                  - price: ${str(price)}
                  - missing: ${all_missing}
                  - cost: ${total_cost}
              publish:
                - all_missing: ${missing + not_ordered}
                - total_cost: ${str(int(cost) + int(spent))}
              break: []
            navigate:
              - AVAILABLE: check_min_reqs
              - UNAVAILABLE: check_min_reqs

        - check_min_reqs:
            do:
              base.contains:
                - container: ${all_missing}
                - sub: 'laptop'
            navigate:
              - DOES_NOT_CONTAIN: print_finish
              - CONTAINS: print_warning

        - print_warning:
            do:
              base.print:
                - text: >
                    ${first_name + ' ' + last_name +
                    ' did not receive all the required equipment'}
            navigate:
              - SUCCESS: print_finish

        - print_finish:
            do:
              base.print:
                - text: >
                    ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '\n' +
                    'Missing items: ' + all_missing + ' Cost of ordered items: ' + total_cost}
            navigate:
              - SUCCESS: SUCCESS

        - on_failure:
          - print_fail:
              do:
                base.print:
                  - text: "${'Failed to create address for: ' + first_name + ' ' + last_name}"

**contains.sl**

.. code-block:: yaml

    namespace: tutorials.base

    decision:
      name: contains

      inputs:
        - container:
            default: ""
            required: false
        - sub

      results:
        - DOES_NOT_CONTAIN: ${container.find(sub) == -1}
        - CONTAINS
