Lesson 13 - System Properties
=============================

Goal
----

In this lesson we'll learn how to use system properties to set the
values of inputs.

Get Started
-----------

We'll need to create a system properties file that contains the values we
want to use for the inputs. Let's create a **properties** folder under
**tutorials** and in there create a file named **bcompany.prop.sl**. We'll
also need to use the system properties somewhere. We'll use them in the
**new_hire.sl** and **generate_user_email.sl** files.

System Properties File
----------------------

A system properties file ends with the **.prop.sl** extension and can include a
namespace. A system properties file also contains the ``properties`` keyword
which is mapped to ``key:value`` pairs that define system property names and
values.

Here's what the contents of our system properties file looks like:

.. code-block:: yaml

    namespace: tutorials.properties

    properties:
      domain: bcompany.com
      hostname: <host>
      port: 25
      system_address: <test@test.com>
      hr_address: <test@test.com>


You'll need to substitute the values in angle brackets (``<>``) to work
for your email host.

**Note:** All system property values are interpreted as strings. So in our case,
even if the port is a numeric value, it's value when used as a system
property will be a string representation. For example, entering a value of
``25`` will create a system property whose value is ``'25'``.

For more information, see :ref:`properties <properties>` in the DSL Reference
and :ref:`Run with System Properties <run_with_system_properties>` in the CLI
documentation.

Retrieve Values
---------------

Now we'll use the system properties to place values in our inputs and task
arguments. We retrieve system property values using the ``get_sp()`` function.
We'll do this in two places.

**Note:** The ``get_sp()`` function can also be used to retrieve system property
values in publish, output and result expressions.

First, we'll use a system property in the inputs of ``generate_user_email``
by calling the ``get_sp()`` function in the ``default`` property of the
the ``domain`` input. The ``get_sp()`` function will retrieve the value
associated with the property defined by the fully qualified name in its first
argument. If no such property if found, the function will return the second
argument.

.. code-block:: yaml

    inputs:
      - first_name
      - middle_name:
          default: ""
      - last_name
      - domain:
          default: ${get_sp('tutorials.properties.domain', 'acompany.com')}
          overridable: false
      - attempt

The second place we'll use system properties is in the ``new_hire``
flow. Here we'll retrieve the system properties in the arguments of
the ``send_mail`` task we created last lesson. We'll use the ``get_sp()``
function to get the ``hostname``, ``port``, ``from`` and ``to`` default
values from the system properties file.

.. code-block:: yaml

    - send_mail:
        do:
          mail.send_mail:
            - hostname: ${get_sp('tutorials.properties.hostname')}
            - port: ${get_sp('tutorials.properties.port')}
            - from: ${get_sp('tutorials.properties.system_address')}
            - to: ${get_sp('tutorials.properties.hr_address')}
            - subject: "${'New Hire: ' + first_name + ' ' + last_name}"
            - body: >
                ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
                'Missing items: ' + missing + ' Cost of ordered items: ' + str(total_cost)}
        navigate:
          FAILURE: FAILURE
          SUCCESS: SUCCESS

For more information, see :ref:`get_sp() <get_sp>` in the DSL Reference.

Run It
------

We can save the files and run the flow to see that the values are being
taken from the system properties file we specify. If we want to swap out
the values with another set, all we have to do is point to a different
system properties file.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials,<content folder path>/base --i first_name=john,last_name=doe --spf <folder path>/tutorials/properties/bcompany.prop.sl

For more information on running with a system properties file, see
:ref:`Run with System Properties <run_with_system_properties>` in the CLI
documentation.

Download the Code
-----------------

:download:`Lesson 13 - Complete code </code/tutorial_code/tutorials_13.zip>`

Up Next
-------

In the next lesson we'll see how to use 3rd Python packages in your
operation's actions.

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
                  - middle_name:
                      required: false
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

        - send_mail:
            do:
              mail.send_mail:
                - hostname: ${get_sp('tutorials.properties.hostname')}
                - port: ${get_sp('tutorials.properties.port')}
                - from: ${get_sp('tutorials.properties.system_address')}
                - to: ${get_sp('tutorials.properties.hr_address')}
                - subject: "${'New Hire: ' + first_name + ' ' + last_name}"
                - body: >
                    ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
                    'Missing items: ' + missing + ' Cost of ordered items:' + str(total_cost)}
            navigate:
              FAILURE: FAILURE
              SUCCESS: SUCCESS

        - on_failure:
          - print_fail:
              do:
                base.print:
              - text: "${'Failed to create address for: ' + first_name + ' ' + last_name}"

**generate_user_email.sl**

.. code-block:: yaml

    namespace: tutorials.hiring

    operation:
      name: generate_user_email

      inputs:
        - first_name
        - middle_name:
            default: ""
        - last_name
        - domain:
            default: ${get_sp('tutorials.properties.domain', 'acompany.com')}
            overridable: false
        - attempt

      action:
        python_script: |
          attempt = int(attempt)
          if attempt == 1:
            address = first_name[0:1] + '.' + last_name + '@' + domain
          elif attempt == 2:
            address = first_name + '.' + first_name[0:1] + '@' + domain
          elif attempt == 3 and middle_name != '':
            address = first_name + '.' + middle_name[0:1] + '.' + last_name + '@' + domain
          else:
            address = ''
          #print address

      outputs:
        - email_address: ${address}

      results:
        - FAILURE: ${address == ''}
        - SUCCESS


**bcompany.prop.sl**

.. code-block:: yaml

    namespace: tutorials.properties

    properties:
      domain: bcompany.com
      hostname: <host>
      port: 25
      system_address: <test@test.com>
      hr_address: <test@test.com>

**Note:** You need to substitute the values in angle brackets (<>) to
work for your email host.
