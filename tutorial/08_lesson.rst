Lesson 8 - Input Parameters
===========================

Goal
----

In this lesson we'll learn how to change the way inputs behave using
input properties.

Get Started
-----------

It's time to create a new operation. Create a new file in the
**tutorials/hiring** folder called **generate_user_email.sl**. In here
we'll create an operation that takes in some user information and
produces an email address for that user. We'll write it so that it will
take in which attempt this is at creating an email address for this
user. That way we can use it in conjunction with our
``check_availability`` operation. Eventually, we'll generate an address,
check its availability, and if it's unavailable we'll do it all over
again. The following code does not present any new concepts. We will use
it as a starting point for a discussion on input properties.

.. code-block:: yaml

    namespace: tutorials.hiring

    operation:
      name: generate_user_email

      inputs:
        - first_name
        - middle_name
        - last_name
        - domain
        - attempt

      action:
        python_script: |
          attempt = int(attempt)
          if attempt == 1:
            address = first_name[0:1] + '.' + last_name + '@' + domain
          elif attempt == 2:
            address = first_name + '.' + last_name[0:1] + '@' + domain
          elif attempt == 3 and middle_name != '':
            address = first_name + '.' + middle_name[0:1] + '.' + last_name + '@' + domain
          else:
            address = ''
          # print address

      outputs:
        - email_address: ${address}

      results:
        - FAILURE: ${address == ''}
        - SUCCESS

Test
----

You can save the file and test that the operation is working as expected
by using the following command:

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/generate_user_email.sl --i first_name=john,middle_name=e,last_name=doe,domain=somecompany,attempt=1

It may help to uncomment the print line to see what is being output.
Change the value for ``attempt`` in the run command and see what
happens.

Add to Flow
-----------

Let's add a step in the **new_hire** flow to call our new operation.
That will allow us to demonstrate how input properties affect the way
variables are passed to operations.

Between the ``print_start`` step and ``check_address`` step we'll put
our new step named ``generate_address``.

.. code-block:: yaml

    - generate_address:
        do:
          generate_user_email:
            - first_name
            - middle_name
            - last_name
            - domain
            - attempt
        publish:
          - address: ${email_address}

We'll also have to change the inputs of the flow to reflect our new
addition. We can remove the ``address`` from the flow inputs since we'll
now be getting the address from the ``generate_user_email`` operation
and publishing it in the ``generate_address`` step. Instead, we need to
add the inputs necessary for the ``generate_user_email`` operation to
the flow's inputs section.

.. code-block:: yaml

    inputs:
      - first_name
      - middle_name
      - last_name
      - domain
      - attempt

One last thing to tidy up is the failure message, which no longer receives an
address that was not created.

.. code-block:: yaml

    - on_failure:
      - print_fail:
          do:
            base.print:
              - text: "Failed to create address"

At this point everything is set up to go. We can save the file and run
the flow as long as we pass all the necessary arguments.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials --i first_name=john,middle_name=e,last_name=doe,domain=somecompany.com,attempt=1

Required
--------

By default all flow and operation inputs are required. We can change
that behavior by setting the ``required`` property of an input to false.
Let's make the ``middle_name`` optional. We'll have to set its
``required`` property to ``false`` in both the flow's inputs and the
``generate_user_email`` operation's inputs.

.. code-block:: yaml

    flow:
      name: new_hire

      inputs:
        - first_name
        - middle_name:
            required: false
        - last_name
        - domain
        - attempt

.. code-block:: yaml

    operation:
      name: generate_user_email

      inputs:
        - first_name
        - middle_name:
            required: false
        - last_name
        - domain
        - attempt

**YAML Note:** Don't forget to add a colon (``:``) to the input name
before adding its properties.

For more information, see :ref:`required` in the DSL reference.

Default
-------

We can also make an input optional by providing a default value. If no
value is passed for an input that declares the default property, the
default value is used instead. In our case, we can set the
``generate_user_email`` operation's ``middle_name`` to default to the
empty string.

.. code-block:: yaml

    operation:
      name: generate_user_email

      inputs:
        - first_name
        - middle_name:
            required: false
            default: ""
        - last_name
        - domain
        - attempt

Now the flow can be run after saving the files without providing a value
for the middle name.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials --i first_name=john,last_name=doe,domain=somecompany.com,attempt=1

For more information, see :ref:`default` in the DSL reference.

Private
-------

The default value is only used if another value is not passed to the
operation. But sometimes we want to force the default value to be the
one used, even if a different value is passed from a flow. Let's do that
to the ``domain`` input of the ``generate_user_email`` operation. To do
so, we set the input's ``private`` parameter to ``true``. We'll also
have to set a default value for the input.

.. code-block:: yaml

    operation:
      name: generate_user_email

      inputs:
        - first_name
        - middle_name:
            required: false
            default: ""
        - last_name
        - domain:
            default: "acompany.com"
            private: true
        - attempt

We can save the file and then run the flow using the same command as
above. You'll notice that no matter what is passed to the ``domain``
input, ``acompany.com`` is what ends up in the email address. That's
exactly what we want, but obviously there is no reason to pass values to
the domain variable anymore. So let's just remove it from the flow
inputs and the ``generate_address`` step.

.. code-block:: yaml

    flow:
      name: new_hire

      inputs:
        - first_name
        - middle_name:
            required: false
        - last_name
        - attempt

.. code-block:: yaml

    - generate_address:
        do:
          generate_user_email:
            - first_name
            - middle_name
            - last_name
            - attempt
        publish:
          - address: ${email_address}

For more information, see :ref:`private` in the DSL reference.

Run It
------

Now we can save the file and run the flow without passing the domain. We
can also leave out the middle name if we want, but we can also leave it
in.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials --i first_name=john,last_name=doe,attempt=1

Download the Code
-----------------

:download:`Lesson 8 - Complete code </code/tutorial_code/tutorials_08.zip>`

Up Next
-------

In the next lesson we'll see how to use subflows.

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
        - attempt

      workflow:
        - print_start:
            do:
              base.print:
                - text: "Starting new hire process"

        - generate_address:
            do:
              generate_user_email:
                - first_name
                - middle_name
                - last_name
                - attempt
            publish:
              - address: ${email_address}

        - check_address:
            do:
              check_availability:
                - address
            publish:
              - availability: ${available}
            navigate:
              - UNAVAILABLE: print_fail
              - AVAILABLE: print_finish

        - print_finish:
            do:
              base.print:
                - text: "${'Availability for address ' + address + ' is: ' + str(availability)}"

        - on_failure:
          - print_fail:
              do:
                base.print:
                  - text: "Failed to create address"

**generate_user_email.sl**

.. code-block:: yaml

    namespace: tutorials.hiring

    operation:
      name: generate_user_email

      inputs:
        - first_name
        - middle_name:
            required: false
            default: ""
        - last_name
        - domain:
            default: "acompany.com"
            private: true
        - attempt

      action:
        python_script: |
          attempt = int(attempt)
          if attempt == 1:
            address = first_name[0:1] + '.' + last_name + '@' + domain
          elif attempt == 2:
            address = first_name + '.' + last_name[0:1] + '@' + domain
          elif attempt == 3 and middle_name != '':
            address = first_name + '.' + middle_name[0:1] + '.' + last_name + '@' + domain
          else:
            address = ''
          # print address

      outputs:
        - email_address: ${address}

      results:
        - FAILURE: ${address == ''}
        - SUCCESS
