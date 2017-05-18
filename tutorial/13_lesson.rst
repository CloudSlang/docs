Lesson 13 - Existing Content
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

    ########################################################################################################################
    #!!
    #! @description: This operation sends SMTP email.
    #!
    #! @input hostname: The hostname or ip address of the SMTP server.
    #! @input port: The port of the SMTP service.
    #! @input from: From email address.
    #! @input to: A delimiter separated list of email address(es) or recipients where the email will be sent.
    #! @input cc: Optional - A delimiter separated list of email address(es) or recipients, to be placed in the CC.
    #!            Default: ''
    #! @input bcc: Optional - A delimiter separated list of email address(es) or recipients, to be placed in the BCC.
    #!             Default: ''
    #! @input subject: The email subject. If a subject spans on multiple lines, it is formatted to a single one.
    #! @input body: The body of the email.
    #! @input html_email: The value should be true if the email is in rich text/html format.
    #!                    The value should be false if the email is in plain text format.
    #!                    Valid values: 'true', 'false'.
    #!                    Default: 'true'.
    #! @input read_receipt: Optional - The value should be true if read receipt is required, else false.
    #!                                 Valid values: 'true', 'false'.
    #!                                 Default: 'false'
    #! @input attachments: Optional - A delimited separated list of files to attach (must be full path).
    #!                     Default: ''
    #! @input username: Optional - If SMTP authentication is needed, the username to use.
    #!                  Default: ''
    #! @input password: Optional - If SMTP authentication is needed, the password to use.
    #!                  Default: ''
    #! @input character_set: Optional - The character set encoding for the entire email which includes subject, body,
    #!                                  attached file name and the attached file.
    #!                                  Valid values: 'UTF-8', 'UTF-16', 'UTF-32', 'EUC-JP', 'ISO-2022-JP',
    #!                                                'Shift_JIS', 'Windows-31J'.
    #!                                  Default: 'UTF-8'
    #! @input content_transfer_encoding: Optional - The content transfer encoding scheme (such as 7bit, 8bit, base64,
    #!                                              quoted-printable, etc) for the entire email which includes subject,
    #!                                              body, attached file name and the attached file.
    #!                                              Valid values: 'quoted-printable', 'base64', '7bit',
    #!                                                            '8bit', 'binary', 'x-token'.
    #!                                              Default: 'base64'
    #! @input delimiter: Optional -  A delimiter to separate the email recipients and the attachments.
    #!                               Default: ''
    #! @input enable_TLS: Optional - Specify if the connection should be TLS enabled or not.
    #!                               Default: 'false'
    #!
    #! @output return_result: That will contain the 'Sent Mail Successfully' if the mail was sent successfully.
    #! @output return_code: '0' if success, '-1' otherwise.
    #! @output exception: The exception message if the operation goes to failure.
    #!
    #! @result SUCCESS: Succeeds if mail was sent successfully and the return_code = '0'.
    #! @result FAILURE: There was an error while trying to sent the mail and the return code = '-1'.
    #!!#
    ########################################################################################################################

We could get this information by opening the operation from the ready-made
content folder or by running ``inspect`` on the flow.

.. code-block:: bash

    inspect <content folder path>/io/cloudslang/base/mail/send_mail.sl

When calling the operation, we'll need to pass values for all the
arguments listed in the documentation that are not optional.

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
taken directly from the ``print_finish`` step with two slight changes. First, we
turned the ``\n`` into a ``<br>`` since the ``html_email`` input defaults to
true. Second, we added the temporary password published by the
``create_email_address`` step.

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
                'Missing items: ' + all_missing + ' Cost of ordered items: ' + str(total_cost) + '<br>' +
                'Temporary password: ' + password}
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS

Run It
------

We can save the files, run the flow and check that an email was sent
with the proper information.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials,<content folder path>/io/cloudslang/base --i first_name=john,last_name=doe

Download the Code
-----------------

:download:`Lesson 13 - Complete code </code/tutorial_code/tutorials_13.zip>`

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
              - SUCCESS: send_mail

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
                   'Missing items: ' + all_missing + ' Cost of ordered items: ' + total_cost + '<br>' +
                   'Temporary password: ' + password}
           navigate:
             - FAILURE: FAILURE
             - SUCCESS: SUCCESS

        - on_failure:
          - print_fail:
              do:
                base.print:
                  - text: "${'Failed to create address for: ' + first_name + ' ' + last_name}"
