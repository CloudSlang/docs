Lesson 11 - Loop Aggregation
============================

Goal
----

In this lesson we'll learn how to aggregate output from a loop.

Get Started
-----------

We'll create a new task to simulate ordering equipment. Internally it
will randomly decide whether a piece of equipment is available or not.
Then we'll run that task in a loop from the main flow and record the
cost of the ordered equipment and which items were unavailable. Create a
new file named **order.sl** in the **tutorials/hiring** folder to house
the new operation we'll write and get the **new_hire.sl** file ready
because we'll need to add a task to the main flow.

Operation
---------

The ``order`` operation, as we'll call it, looks very similar to our
``check_availability`` operation. It uses a random number to simulate
whether a given item is available. If the item is available, it will
return the ``cost`` of the item as one output and the ``unavailable``
output will be empty. If the item is unavailable, it will return ``0``
for the cost of the item and the name of the item in the ``unavailable``
output.

.. code-block:: yaml

    namespace: tutorials.hiring

    operation:
      name: order

      inputs:
        - item
        - price

      action:
        python_script: |
          print 'Ordering: ' + item
          import random
          rand = random.randint(0, 2)
          available = rand != 0
          not_ordered = item + ';' if rand == 0 else ''
          price = 0 if rand == 0 else price
          if rand == 0: print 'Unavailable'

      outputs:
        - unavailable: ${not_ordered}
        - cost: ${price}

      results:
        - UNAVAILABLE: ${rand == 0}
        - AVAILABLE

Task
----

First, we'll go back to our flow and create a task, between
``create_email_address`` and ``print_finish``, to call our operation in
a loop. This time we'll loop through a map of items and their prices.

.. code-block:: yaml

    - get_equipment:
        loop:
          for: item, price in order_map
          do:
            order:
              - item
              - price

We'll also need to create some input variables first. One variable, that
we'll call ``order_map``, will contain the map we're looping on. Notice how a
map is most easily passed as an input value using the ``default`` property.

Also, each time through the loop we want to aggregate the data that is output.
We'll create two variables, ``missing`` and ``total_cost``, for this
purpose, defining them as ``overridable`` and giving them default values
to start with.

.. code-block:: yaml

    inputs:
      - first_name
      - middle_name:
          required: false
      - last_name
      - missing:
          default: ""
          overridable: false
      - total_cost:
          default: 0
          overridable: false
      - order_map:
          default: {'laptop': 1000, 'docking station':200, 'monitor': 500, 'phone': 100}

Now we can perform the aggregation. In the ``get_equipment`` task's publish
section, we'll add the output variables to the ones we just created in
the flow inputs and publish them back to the flow. This will run for
each iteration after the operation has completed, aggregating all the
data. For example, each time through the loop a ``cost`` is output from the
``order`` operation. That ``cost`` is added to the ``total_cost`` variable for
each iteration in the publish section of the ``get_equipment`` task.

Notice the usage of the ``self['']`` syntax to indicate that we're
referring to the variable that exists on the flow level and not a
variable with the same name that might have been returned from the
operation.

.. code-block:: yaml

    publish:
      - missing: ${self['missing'] + unavailable}
      - total_cost: ${self['total_cost'] + cost}

Finally we have to rewire all the navigation logic to take into account
our new task.

We need to change the ``create_email_address`` task to forward
successful email address creations to ``get_equipment``.

.. code-block:: yaml

    navigate:
      CREATED: get_equipment
      UNAVAILABLE: print_fail
      FAILURE: print_fail

And we need to add navigation to the ``get_equipment`` task. We'll
always go to ``print_finish`` no matter what happens.

.. code-block:: yaml

    navigate:
      AVAILABLE: print_finish
      UNAVAILABLE: print_finish

Finish
------

The last thing left to do is print out a finish message that also
reflects the status the equipment order.

.. code-block:: yaml

    - print_finish:
        do:
          base.print:
            - text: >
                ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '\n' +
                'Missing items: ' + missing + ' Cost of ordered items: ' + str(total_cost)}

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
        - missing:
            default: ""
            overridable: false
        - total_cost:
            default: 0
            overridable: false
        - order_map:
            default: {'laptop': 1000, 'docking station':200, 'monitor': 500, 'phone': 100}

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
              CREATED: get_equipment
              UNAVAILABLE: print_fail
              FAILURE: print_fail

        - get_equipment:
            loop:
              for: item, price in order_map
              do:
                order:
                  - item
                  - price
              publish:
                - missing: ${self['missing'] + unavailable}
                - total_cost: ${self['total_cost'] + cost}
            navigate:
              AVAILABLE: print_finish
              UNAVAILABLE: print_finish

        - print_finish:
            do:
              base.print:
                - text: >
                    ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '\n' +
                    'Missing items: ' + missing + ' Cost of ordered items: ' + str(total_cost)}

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

      action:
        python_script: |
          print 'Ordering: ' + item
          import random
          rand = random.randint(0, 2)
          available = rand != 0
          not_ordered = item + ';' if rand == 0 else ''
          price = 0 if rand == 0 else price
          if rand == 0: print 'Unavailable'

      outputs:
        - unavailable: ${not_ordered}
        - cost: ${price}

      results:
        - UNAVAILABLE: ${rand == 0}
        - AVAILABLE
