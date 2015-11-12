Lesson 12 - Existing Content
============================

Goal
----

In this lesson we'll learn how to easily integrate ready-made content
into our flow.

Get Started
-----------

Instead of printing that our flow has completed, let's send an email to
HR to let them know that the new hire's email address has been created
and notify them as to the status of the new hire's equipment order. If
you're using a pre-built CLI you'll have a folder named **content** that
contains all of the ready-made content. If you've built the CLI from the
source code, you'll have to get the content mentioned below from the
GitHub
`repository <https://github.com/cloudslang/cloud-slang-content>`__ and
point to the right location when running the flow.

Ready-Made Operation
--------------------

We'll use the ``send_mail`` operation which is found in the
**base/mail** folder. All ready-made content begins with a commented
explanation of its purpose and its inputs, outputs and results.

Here's the documentation for the ``send_mail`` operation:

.. code-block:: yaml

    ####################################################
    #   This operation sends a simple email.
    #
    #   Inputs:
    #       - hostname - email host
    #       - port - email port
    #       - from - email sender
    #       - to - email recipient
    #       - cc - optional - Default: none
    #       - bcc - optional - Default: none
    #       - subject - email subject
    #       - body - email text
    #       - htmlEmail - optional - Default: true
    #       - readReceipt - optional - Default: false
    #       - attachments - optional - Default: none
    #       - username - optional - Default: none
    #       - password - optional - Default: none
    #       - characterSet - optional - Default: UTF-8
    #       - contentTransferEncoding - optional - Default: base64
    #       - delimiter - optional - Default: none
    #   Results:
    #       - SUCCESS - succeeds if mail was sent successfully (returnCode is equal to 0)
    #       - FAILURE - otherwise
    ####################################################

When calling the operation, we'll need to pass values for all the
arguments listed in the documentation that are not optional.

You might have noticed that operation and flow inputs are generally
named using snake\_case. This is in keeping with Python conventions,
especially when using an operation that has a ``python_script`` type
action. The ``send_mail`` operation though, uses a ``java_action`` so
its inputs follow the Java camelCase convention.

Imports
-------

First, we'll need to set up an import alias for the new operation since
it doesn't reside where our other operations and subflows do.

.. code-block:: yaml

    imports:
      base: tutorials.base
      mail: io.cloudslang.base.mail

Task
----

Then, all we really need to do is create a task in our flow that will
call the ``send_mail`` operation. Let's put it right after the
``print_finish`` operation. We need to pass a host, port, from, to,
subject and body. You'll need to substitute the values in angle brackets
(``<>``) to work for your email host. Notice that the body value is
taken directly from the ``print_finish`` task with the slight change of
turning the ``\n`` into a ``<br>`` since the ``htmlEmail`` input
defaults to true.

.. code-block:: yaml

        - send_mail:
            do:
              mail.send_mail:
                - hostname: "'<host>'"
                - port: "'<port>'"
                - from: "'<from>'"
                - to: "'<to>'"
                - subject: "'New Hire: ' + first_name + ' ' + last_name"
                - body: >
                    'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
                    'Missing items: ' + missing + ' Cost of ordered items: ' + str(total_cost)
            navigate:
              FAILURE: FAILURE
              SUCCESS: SUCCESS

Run It
------

We can save the files, run the flow and check that an email was sent
with the proper information.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials/base,<folder path>/tutorials/hiring,<content folder path>/io/cloudslang/base --i first_name=john,last_name=doe

Up Next
-------

In the next lesson we'll see how to use system properties to send values
to input variables.

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
            default: "''"
            overridable: false
        - total_cost:
            default: 0
            overridable: false
        - order_map: >
            {'laptop': 1000, 'docking station':200, 'monitor': 500, 'phone': 100}

      workflow:
        - print_start:
            do:
              base.print:
                - text: "'Starting new hire process'"

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
                - missing: self['missing'] + unavailable
                - total_cost: self['total_cost'] + cost
            navigate:
              AVAILABLE: print_finish
              UNAVAILABLE: print_finish

        - print_finish:
            do:
              base.print:
                - text: >
                    'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '\n' +
                    'Missing items: ' + missing + ' Cost of ordered items: ' + str(total_cost)

        - send_mail:
            do:
              mail.send_mail:
                - hostname: "'<host>'"
                - port: "'<port>'"
                - from: "'<from>'"
                - to: "'<to>'"
                - subject: "'New Hire: ' + first_name + ' ' + last_name"
                - body: >
                    'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
                    'Missing items: ' + missing + ' Cost of ordered items: ' + str(total_cost)
            navigate:
              FAILURE: FAILURE
              SUCCESS: SUCCESS

        - on_failure:
          - print_fail:
              do:
                base.print:
                  - text: "'Failed to create address for: ' + first_name + ' ' + last_name"
