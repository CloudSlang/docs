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
GitHub `repository <https://github.com/cloudslang/cloud-slang-content>`__ and
point to the right location when running the flow.

Ready-Made Operation
--------------------

We'll use the ``send_mail`` operation which is found in the
**base/mail** folder. All ready-made content begins with a commented
explanation of its purpose and its inputs, outputs and results.

Here's the documentation for the ``send_mail`` operation:

.. code-block:: yaml

    ####################################################
    #!!
    #! @description: Sends an email.
    #!
    #! @input hostname: email host
    #! @input port: email port
    #! @input from: email sender
    #! @input to: email recipient
    #! @input cc: cc recipient
    #!            optional
    #!            default: none
    #! @input bcc: bcc recipient
    #!             optional
    #!             default: none
    #! @input subject: email subject
    #! @input body: email text
    #! @input html_email: html formatted email
    #!                    optional
    #!                    default: true
    #! @input read_receipt: request read receipt
    #!                      optional
    #!                      default: false
    #! @input attachments: email attachments
    #!                     optional
    #!                     default: none
    #! @input username: account username
    #!                  optional
    #!                  default: none
    #! @input password: account password
    #!                  optional
    #!                  default: none
    #! @input character_set: email character set
    #!                       optional
    #!                       default: UTF-8
    #! @input content_transfer_encoding: email content transfer encoding
    #!                                   optional
    #!                                   default: base64
    #! @input delimiter: delimiter to separate email recipients and attachments
    #!                   optional
    #!                   default: none
    #! @result SUCCESS: mail was sent successfully (returnCode is equal to 0)
    #! @result FAILURE: otherwise
    #!!#
    ####################################################

We could get this information by opening the operation from the ready-made
content folder or by running ``inspect`` on the flow.

.. code-block:: bash

    inspect <content folder path>/io/cloudslang/base/mail/send_mail.sl

When calling the operation, we'll need to pass values for all the
arguments listed in the documentation that are not optional.

You might have noticed that operation and flow inputs are generally
named using snake_case. This is in keeping with Python conventions,
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

For more information, see :ref:`imports` in the DSL reference.

Step
----

Then, all we really need to do is create a step in our flow that will
call the ``send_mail`` operation. Let's put it right after the
``print_finish`` operation. We need to pass a host, port, from, to,
subject and body. You'll need to substitute the values in angle brackets
(``<>``) to work for your email host. Notice that the body value is
taken directly from the ``print_finish`` step with the slight change of
turning the ``\n`` into a ``<br>`` since the ``html_email`` input
defaults to true.

.. code-block:: yaml

    - send_mail:
        do:
          mail.send_mail:
            - hostname: "<host>"
            - port: "<port>"
            - from: "<from>"
            - to: "<to>"
            - subject: "${'New Hire: ' + first_name + ' ' + last_name}"
            - body: >
                ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
                'Missing items: ' + all_missing + ' Cost of ordered items: ' + str(total_cost)}
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS

Run It
------

We can save the files, run the flow and check that an email was sent
with the proper information.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials/,<content folder path>/io/cloudslang/base --i first_name=john,last_name=doe

Download the Code
-----------------

:download:`Lesson 12 - Complete code </code/tutorial_code/tutorials_12.zip>`

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
        - all_missing:
            default: ""
            private: true
        - total_cost:
            default: 0
            private: true
        - order_map: >
            {'laptop': 1000, 'docking station':200, 'monitor': 500, 'phone': 100}

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
                - total_cost: ${cost + price}
            navigate:
              - AVAILABLE: print_finish
              - UNAVAILABLE: print_finish

        - print_finish:
            do:
              base.print:
                - text: >
                    ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '\n' +
                    'Missing items: ' + all_missing + ' Cost of ordered items: ' + str(total_cost)}

        - send_mail:
            do:
              mail.send_mail:
                - hostname: "<host>"
                - port: "<port>"
                - from: "<from>"
                - to: "<to>"
                - subject: "${'New Hire: ' + first_name + ' ' + last_name}"
                - body: >
                    ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
                    'Missing items: ' + all_missing + ' Cost of ordered items: ' + str(total_cost)}
            navigate:
              - FAILURE: FAILURE
              - SUCCESS: SUCCESS

        - on_failure:
          - print_fail:
              do:
                base.print:
                  - text: "${'Failed to create address for: ' + first_name + ' ' + last_name}"
