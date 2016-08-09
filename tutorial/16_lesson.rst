Lesson 16 - Parallel Loop
=============================

Goal
----

In this lesson we'll learn how to loop in parallel. When looping in parallel, a
new branch is created for each value in a list and the action associated with
the step is run for each branch in parallel.

Get Started
-----------

We'll be creating a new flow that will call the ``new_hire`` flow we've
built in previous lessons as a subflow. Let's begin by creating a new
file named **hire_all.sl** in the **tutorials/hiring** folder for our
new flow. Also, we'll need the **new_hire.sl** because we're going to
make some minor changes to that as well. And finally, we'll pass our
flow inputs using a file, so let's create a **tutorials/inputs** folder
and add a **hires.yaml** file.

Outputs
-------

Since we'll be using the ``new_hire`` flow as a subflow, it will be
helpful if we add some flow outputs for a parent flow to make use of.
We'll simply add an ``outputs`` section at the bottom of our flow to
output a bit of information. This ``outputs`` section is quite a
distance from the ``flow`` key, so be extra careful to place it at the
proper indentation.

.. code-block:: yaml

    outputs:
      - address
      - final_cost: ${total_cost}

Parent Flow
-----------

Our new ``hire_all`` flow is going to take in a list of names of people
being hired and will call the ``new_hire`` flow for each one of them. It
will be looping in parallel, so all the ``new_hire`` flows will be
running simultaneously.

In **hire_all.sl** we can start off as usual by declaring a
``namespace``, specifying the ``imports`` and taking in the ``inputs``,
which in our case is a list of names.

.. code-block:: yaml

    namespace: tutorials.hiring

    imports:
      base: tutorials.base

    flow:
      name: hire_all

      inputs:
        - names_list

      workflow:

Loop Syntax
-----------

A parallel loop looks pretty similar to a normal for loop, but with
a few key differences.

Let's create a new step named ``process_all`` in which we'll do our
looping. Each branch of the loop will call the ``new_hire`` flow.

.. code-block:: yaml

    - process_all:
        parallel_loop:
          for: name in names_list
          do:
            new_hire:
              - first_name: ${name['first']}
              - middle_name: ${name.get('middle','')}
              - last_name: ${name['last']}

As you can see, so far it is almost identical to a regular for loop,
except the ``loop`` key has been replaced by ``parallel_loop``.

The ``names_list`` input will be a list of dictionaries containing name
information with the keys ``first``, ``middle`` and ``last``. For each
``name`` in ``names_list`` the ``new_hire`` flow will be called and
passed the corresponding name values. The various branches running the
``new_hire`` flow will run in parallel and the rest of the flow will
continue only after all the branches have completed.

For more information, see :ref:`parallel_loop <parallel_loop_tag>` in the DSL
reference.

Publish
-------

Next we perform aggregation in the ``publish`` section in a similar manner to
what we do in a normal for loop (as we did in lesson
:doc:`11 - Loop Aggregation <11_lesson>`). Publish occurs only after all
branches have completed.

In most cases the publish will make use of the ``branches_context``
list. This is a list that is populated with all of the outputs from
all of the branches. For example, in our case,
``branches_context[0]`` will contain keys ``address`` and ``final_cost``,
corresponding to the values output by the first branch to complete. Similarly,
``branches_context[1]`` will contain the keys ``address`` and ``final_cost``
mapped to the values output by the second branch to complete.

There is no way to predict the order in which branches will complete, so
the ``branches_context`` is rarely accessed using a particular index. Instead,
Python expressions are used to extract the desired aggregations.

.. code-block:: yaml

    - process_all:
        parallel_loop:
          for: name in names_list
          do:
            new_hire:
              - first_name: ${name['first']}
              - middle_name: ${name.get('middle','')}
              - last_name: ${name['last']}
        publish:
          - email_list: ${filter(lambda x:x != '', map(lambda x:str(x['address']), branches_context))}
          - cost: ${sum(map(lambda x:x['final_cost'], branches_context))}

In our case we use the ``map()``, ``filter()`` and ``sum()`` Python
functions to create a list of all the email addresses that were created
and a sum of all the equipment costs.

Let's look a bit closer at one of the publish aggregations to better understand
what's going on. Each time a branch of the parallel loop is finished running the
``new_hire`` subflow it publishes a ``final_cost`` value. Each of those
individual ``final_cost`` values gets added to the ``branches_context`` list at
index ``n``, where ``n`` indicates the order the branches finish in, under the
``final_cost`` key. So, if we were to loop through the ``branches_context`` we
would find at ``branches_context[n][final_cost]`` the ``final_cost`` value that
was published by the nth ``new_hire`` subflow to finish running. Instead of
looping through the ``branches_context``, we use a Python lambda expression in
conjunction with the ``map`` function to extract just the values of the
``final_cost`` from each ``branches_context[n][final_cost]`` to a new list.
Finally, we use the Python ``sum`` function to add up all the
extracted values in our new list and publish that value as ``cost``.

For more information, see :ref:`publish` and :ref:`branches_context` in the
DSL reference.

For more information on the Python constructs used here, see
`lambda <https://docs.python.org/2.7/reference/expressions.html?highlight=lambda#lambda>`__,
`map <https://docs.python.org/2.7/library/functions.html?highlight=map%20function#map>`__
and `sum <https://docs.python.org/2.7/library/functions.html?highlight=map%20function#sum>`__
in the Python documentation.

Navigate
--------

Navigation also works a bit differently in a parallel loop. If any
of the branches return a result of ``FAILURE`` the flow will follow the
navigation path of ``FAILURE``. Otherwise, the flow will follow the
``SUCCESS`` navigation path.

Here we'll add navigation logic that mimics the default behavior. If any
one of our branches returns a result of ``FAILURE`` because an email
address was not generated or there was a problem sending an email, then
the flow will navigate to the ``print_failure`` step. Otherwise, it will
navigate to the ``print_success`` step.

.. code-block:: yaml

    - process_all:
        parallel_loop:
          for: name in names_list
          do:
            new_hire:
              - first_name: ${name['first']}
              - middle_name: ${name.get('middle','')}
              - last_name: ${name['last']}
        publish:
          - email_list: ${filter(lambda x:x != '', map(lambda x:str(x['address']), branches_context))}
          - cost: ${sum(map(lambda x:x['final_cost'], branches_context))}
        navigate:
          - SUCCESS: print_success
          - FAILURE: print_failure

Input File
----------

We'll use an input file to send the flow our list of names. An input
file is very similar to a system properties file. It is written in plain
YAML which will make it easy for us to format and it will also be more
readable than if we had taken a different approach.

Here is the contents of our **hires.yaml** input file that we created in the
**tutorials/inputs** folder.

.. code-block:: yaml

    names_list:
      - first: joe
        middle: p
        last: bloggs
      - first: jane
        last: doe
      - first: juan
        last: perez

For more information, see :ref:`Using an Inputs File <using_an_inputs_file>` in the CLI documentation.

Steps
-----

Finally, we have to add the steps we referred to in the navigation
section. We can put them right after the ``process_all`` step.

.. code-block:: yaml

    - print_success:
        do:
          base.print:
            - text: >
                ${"All addresses were created successfully.\nEmail addresses created: "
                + str(email_list) + "\nTotal cost: " + str(cost)}

    - on_failure:
        - print_failure:
            do:
              base.print:
                - text: >
                    ${"Some addresses were not created or there is an email issue.\nEmail addresses created: "
                    + str(email_list) + "\nTotal cost: " + str(cost)}

Run It
------

We can save the files and run the flow. It's a bit harder to track what
has happened now because there are quite a few things happening at once.
On careful inspection you will see that each step in the ``new_hire``
flow, and in each of its subflows, is run for each of the people in the
``names_list`` input.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/hire_all.sl --cp <folder path>/tutorials,<content folder path>/base --if <folder path>/tutorials/inputs/hires.yaml --spf <folder path>/tutorials/properties/bcompany.prop.sl

Download the Code
-----------------

:download:`Lesson 16 - Complete code </code/tutorial_code/tutorials_16.zip>`


New Code - Complete
-------------------

**new_hire.sl**

.. code-block:: yaml

    namespace: tutorials.hiring

    imports:
      base: tutorials.base
      mail: io.cloudslang.base.mail

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
            default: 0
            private: true
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
              for: item, price in order_map
              do:
                order:
                  - item
                  - price
                  - missing: ${all_missing}
                  - cost: ${total_cost}
              publish:
                - all_missing: ${missing + not_ordered}
                - total_cost: ${cost + spent}
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

        - print_finish:
            do:
              base.print:
                - text: >
                    ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '\n' +
                    'Missing items: ' + all_missing + ' Cost of ordered items: ' + str(total_cost)}

        - fancy_name:
            do:
              fancy_text:
                - text: ${first_name + ' ' + last_name}
            publish:
              - fancy_text: ${fancy}

        - send_mail:
            do:
              mail.send_mail:
                - hostname: ${get_sp('tutorials.properties.hostname')}
                - port: ${get_sp('tutorials.properties.port')}
                - from: ${get_sp('tutorials.properties.system_address')}
                - to: ${get_sp('tutorials.properties.hr_address')}
                - subject: "${'New Hire: ' + first_name + ' ' + last_name}"
                - body: >
                    ${fancy_text + '<br>' +
                    'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
                    'Missing items: ' + all_missing + ' Cost of ordered items: ' + str(total_cost) + '<br>' +
                    'Temporary password: ' + password}
            navigate:
              - FAILURE: FAILURE
              - SUCCESS: SUCCESS

        - on_failure:
          - print_fail:
              do:
                base.print:
                  - text: "${'Failed to create address for: ' + first_name + ' ' + last_name}"

      outputs:
        - address
        - final_cost: ${total_cost}

**hire_all.sl**

.. code-block:: yaml

    namespace: tutorials.hiring

    imports:
      base: tutorials.base

    flow:
      name: hire_all

      inputs:
        - names_list

      workflow:
        - process_all:
            parallel_loop:
              for: name in names_list
              do:
                new_hire:
                  - first_name: ${name['first']}
                  - middle_name: ${name.get('middle','')}
                  - last_name: ${name['last']}
            publish:
              - email_list: ${filter(lambda x:x != '', map(lambda x:str(x['address']), branches_context))}
              - cost: ${sum(map(lambda x:x['final_cost'], branches_context))}
            navigate:
              - SUCCESS: print_success
              - FAILURE: print_failure

        - print_success:
            do:
              base.print:
                - text: >
                    ${"All addresses were created successfully.\nEmail addresses created: "
                    + str(email_list) + "\nTotal cost: " + str(cost)}

        - on_failure:
            - print_failure:
                do:
                  base.print:
                    - text: >
                        ${"Some addresses were not created or there is an email issue.\nEmail addresses created: "
                        + str(email_list) + "\nTotal cost: " + str(cost)}

**hires.yaml**

.. code-block:: yaml

    names_list:
      - first: joe
        middle: p
        last: bloggs
      - first: jane
        last: doe
      - first: juan
        last: perez
