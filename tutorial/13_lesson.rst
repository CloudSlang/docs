Lesson 13 - System Properties
=============================

Goal
----

In this lesson we'll learn how to use system properties to set the
values of inputs.

Get Started
-----------

We'll need to create a system property file that contains the values we
want to use for the inputs. Let's create a **properties** folder under
**tutorials** and in there create a file named **bcompany.yaml**. We'll
also need to use the system properties somewhere. We'll use then in the
**new_hire.sl** and **generate_user_email.sl** files.

System Properties File
----------------------

The first thing to take note of is that our system properties file ends
with a **.yaml** extension instead of the **.sl** one we've been using
for our flows and operations. That's because the system properties files
are not compiled and there isn't really anything special about them.
They're flat YAML files that contain maps of fully qualified names to
their values.

Here's what the contents of our system properties file looks like:

.. code-block:: yaml

    tutorials.hiring.domain: bcompany.com
    tutorials.hiring.hostname: <host name>
    tutorials.hiring.port: '<port>'
    tutorials.hiring.system_address: <system email>
    tutorials.hiring.hr_address: <hr email>

You'll need to substitute the values in angle brackets (``<>``) to work
for your email host.

Note: the ``port`` property must have quotes (``'``) around the value so
that it is correctly interpreted as a YAML string and not an integer
value.

Inputs
------

Now we need to use the system properties to place values in our inputs.
We'll do this in two places.

First, we'll add a system property to the inputs of
``generate_user_email`` by adding the ``system_property`` property to
the ``domain`` input using the fully qualified name from the system
properties file.

.. code-block:: yaml

    inputs:
      - first_name
      - middle_name:
          default: ""
      - last_name
      - domain:
          system_property: tutorials.hiring.domain
          default: "acompany.com"
          overridable: false
      - attempt

Let's see how the system property works in relation to other possible
values for the input. To do so, we'll just run the
``generate_user_email`` operation by itself and test what happens when
we experiment with explicitly passing values or not and
commenting/uncommenting the default and system property values.

Save the file and try a few of the variations starting with:

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/generate_user_email.sl --i first_name=john,last_name=doe,domain=company.com,attempt=1 --spf <folder path>/tutorials/properties/bcompany.yaml

In general, the order of preference as to which values get bound to the
input variable is:

1. Explicitly passed value
2. System properties
3. Default value

However, if the ``overridable`` property is set to false, explicitly
passed values will not be bound to the input variable. Instead, a system
property or default value will be bound.

The second place we'll add system properties is to the ``new_hire``
flow. Here we'll add the necessary variables with system properties to
the inputs section and use them in the ``send_mail`` task we created
last lesson. We'll have the ``hostname``, ``port``, ``from`` and ``to``
taken from the system properties file.

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
      - hostname:
          system_property: tutorials.hiring.hostname
      - port:
          system_property: tutorials.hiring.port
      - from:
          system_property: tutorials.hiring.system_address
      - to:
          system_property: tutorials.hiring.hr_address

.. code-block:: yaml

    - send_mail:
        do:
          mail.send_mail:
            - hostname
            - port
            - from
            - to
            - subject: "${'New Hire: ' + first_name + ' ' + last_name}"
            - body: >
                ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
                'Missing items: ' + missing + ' Cost of ordered items: ' + str(total_cost)}
        navigate:
          FAILURE: FAILURE
          SUCCESS: SUCCESS

Run It
------

We can save the files and run the flow to see that the values are being
taken from the system properties file we specify. If we want to swap out
the values with another set, all we have to do is point to a different
system properties file.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials,<content folder path>/base --i first_name=john,last_name=doe --spf <folder path>/tutorials/properties/bcompany.yaml

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
        - hostname:
            system_property: tutorials.hiring.hostname
        - port:
            system_property: tutorials.hiring.port
        - from:
            system_property: tutorials.hiring.system_address
        - to:
            system_property: tutorials.hiring.hr_address

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
                - hostname
                - port
                - from
                - to
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
            system_property: tutorials.hiring.domain
            default: "acompany.com"
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

**bcompany.yaml**

.. code-block:: yaml

    tutorials.hiring.domain: bcompany.com
    tutorials.hiring.hostname: <host name>
    tutorials.hiring.port: '<port>'
    tutorials.hiring.system_address: <system email>
    tutorials.hiring.hr_address: <hr email>

**Note:** You need to substitute the values in angle brackets (<>) to
work for your email host.
