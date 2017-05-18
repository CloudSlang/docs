Lesson 11 - Loop Aggregation
============================

Goal
----

In this lesson we'll learn how to aggregate output from a loop.

Get Started
-----------

We'll create a new step to simulate ordering equipment. Internally it
will randomly decide whether a piece of equipment is available or not.
Then we'll run that step in a loop from the main flow and record the
cost of the ordered equipment and which items were unavailable. Create a
new file named **order.sl** in the **tutorials/hiring** folder to house
the new operation we'll write and get the **new_hire.sl** file ready
because we'll need to add a step to the main flow.

Operation
---------

The ``order`` operation, as we'll call it, looks very similar to our
``check_availability`` operation. It uses a random number to simulate
whether a given item is available. If the item is available, it will
return the amount ``spent`` as one output and the ``not_ordered``
output will be empty. If the item is unavailable, it will return ``0``
for the ``spent`` output and the name of the item in the ``not_ordered``
output.

.. code-block:: yaml

    namespace: tutorials.hiring

    operation:
      name: order

      inputs:
        - item
        - price

      python_action:
        script: |
          print 'Ordering: ' + item
          import random
          rand = random.randint(0, 2)
          available = rand != 0
          not_ordered = item + ';' if rand == 0 else ''
          spent = 0 if rand == 0 else price
          if rand == 0: print 'Unavailable'

      outputs:
        - not_ordered
        - spent: ${spent}

      results:
        - UNAVAILABLE: ${rand == 0}
        - AVAILABLE

Step
----

Now let's go back to our flow and create a step, between
``create_email_address`` and ``print_finish``, to call our operation in
a loop. This time we'll loop through a map of items and their prices, named,
``order_map`` that we'll define at the flow level in a few moments. We use the
Python ``eval()`` function to turn a string into a Python dictionary that we can
loop over.

.. code-block:: yaml

    - get_equipment:
        loop:
          for: item, price in eval(order_map)
          do:
            order:
              - item
              - price: ${str(price)}
              - missing: ${all_missing}
              - cost: ${total_cost}
          break: []

Notice the ``missing`` and ``cost`` variables. These are not for inputs in the
``order`` operation. That operation only takes the ``item`` and ``price``
inputs. We will be using ``missing`` and ``cost`` together with some flow-level
variables to perform the loop aggregation.

Also notice how we've added a ``break`` which maps to an empty list of break
results. This is necessary because the ``order`` operation does not contain a
result of ``FAILURE`` which is the default for breaking out of a loop.

Now let's create those flow-level variables in the flow's ``inputs`` section.
Each time through the loop we want to aggregate the data that the ``order``
operation outputs. We'll create two variables, ``all_missing`` and
``total_cost``, for this purpose, defining them as ``private`` and giving
them default values to start with.

Also, we'll declare another variable called ``order_map`` that will contain the
map we're looping on.

.. code-block:: yaml

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

Now we can perform the aggregation. In the ``get_equipment`` step's publish
section, we'll add the values output from the ``order`` operation
(``not_ordered`` and ``spent``) to the step arguments we just created in
the ``get_equipment`` step (``missing`` and ``cost``) and publish them back to
the flow-level variables (``all_missing`` and ``total_cost``). This will run for
each iteration after the operation has completed, aggregating all the
data. For example, each time through the loop the ``cost`` is updated with the
current ``total_cost``. Then the ``order`` operation runs and a ``spent`` value
is output. That ``spent`` value is added to the step's ``cost`` variable and
published back into the flow-level ``total_cost`` for each iteration of the
``get_equipment`` step.

.. code-block:: yaml

    publish:
      - all_missing: ${missing + not_ordered}
      - total_cost: ${str(int(cost) + int(spent))}

Finally we have to rewire all the navigation logic to take into account
our new step.

We need to change the ``create_email_address`` step to forward
successful email address creations to ``get_equipment``.

.. code-block:: yaml

    navigate:
      - CREATED: get_equipment
      - UNAVAILABLE: print_fail
      - FAILURE: print_fail

And we need to add navigation to the ``get_equipment`` step. We'll
always go to ``print_finish`` no matter what happens.

.. code-block:: yaml

    navigate:
      - AVAILABLE: print_finish
      - UNAVAILABLE: print_finish

Finish
------

The last thing left to do is print out a finish message that also
reflects the status of the equipment order.

.. code-block:: yaml

    - print_finish:
        do:
          base.print:
            - text: >
                ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '\n' +
                'Missing items: ' + all_missing + ' Cost of ordered items: ' + total_cost}
        navigate:
          - SUCCESS: SUCCESS

Run It
------

We can save the files, run the flow and see that the ordering takes
place, the proper information is aggregated and then it is printed.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials --i first_name=john,middle_name=e,last_name=doe

Download the Code
-----------------

:download:`Lesson 11 - Complete code </code/tutorial_code/tutorials_11.zip>`

Up Next
-------

In the next lesson we'll see how to write a decision.

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
              - AVAILABLE: print_finish
              - UNAVAILABLE: print_finish

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

**order.sl**

.. code-block:: yaml

    namespace: tutorials.hiring

    operation:
      name: order

      inputs:
        - item
        - price

      python_action:
        script: |
          print 'Ordering: ' + item
          import random
          rand = random.randint(0, 2)
          available = rand != 0
          not_ordered = item + ';' if rand == 0 else ''
          price = 0 if rand == 0 else price
          if rand == 0: print 'Unavailable'

      outputs:
        - not_ordered
        - spent: ${str(spent)}

      results:
        - UNAVAILABLE: ${rand == 0}
        - AVAILABLE
