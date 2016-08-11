Lesson 5 - Default Navigation
=============================

Goal
----

In this lesson we'll use the ``check_availability`` operation in our
flow and use the results it returns.

Get Started
-----------

Let's go back to **new_hire.sl** and add in the plumbing to run our new
operation.

Inputs
------

First, we'll add an inputs section to our flow between the name and the
workflow. It works the same way as inputs to an operation.

.. code-block:: yaml

    inputs:
      - address

Just as with an operation, values for the inputs of a flow are either
passed via the :doc:`CloudSlang CLI <../cloudslang_cli>`, as we do below
in this lesson, or from a step in a calling flow, as in lesson :doc:`9 -
Subflows <09_lesson>`.

Inputs can also have related parameters, such as ``required``,
``default``, ``private`` and ``system_property``. We will discuss
these parameters in lessons :doc:`8 - Input Parameters <08_lesson>` and
:doc:`13 - System Properties <13_lesson>`.

New Step
--------

Now we can add a new step to our flow. We'll add it right after the
``print_start`` step and call it ``check_address``. Here, since both the
flow and the operation are in the same folder, the ``do`` section does
not need to use an alias or path to reference the operation like we
needed with the ``print`` operation in the ``print_start`` step.

.. note::

    The :doc:`best practice <../cloudslang_best_practice>` is to use an alias or
    fully qualified name when calling an operation (the same applies for
    subflows and decisions) even when it resides in the same folder as the
    calling flow. For simplicity, we will not follow this practice in this
    tutorial. 


.. code-block:: yaml

    - check_address:
        do:
          check_availability:
            - address
        publish:
          - availability: ${available}

First note that in the ``check_address`` step, the ``address`` input
name is not given an explicit value, as the ``text`` input is given in
the ``print_start`` step. It's not necessary here because the
``address`` input name in the ``check_availability`` operation matches
the ``address`` input name in the flow. The value input to the flow will
get passed to the operation input with the same name.

Publish
-------

Also notice that we've added the ``publish`` section to this step. This
is the spot where we publish the outputs returned from the operation to
the flow's scope. In our case, the ``check_availability`` operation
returns an output named ``available`` and we publish it to the flow's
scope under the name ``availability``. We'll use the ``availability``
variable momentarily in an input expression in another of the flow's
steps.

For more information, see :ref:`publish` in the DSL reference.

Input Expression
----------------

We'll add one more step to our flow for now to demonstrate the default
navigation behavior. This new step calls the ``print`` operation again
to print out whether the email address that was provided is available.
We pass a string which contains a Python expression to the ``text``
input. Note that we are using the published output from the previous
step along with some of the flow input variables in the expression.

.. code-block:: yaml

    - print_finish:
        do:
          base.print:
            - text: "${'Availability for address ' + address + ' is: ' + str(availability)}"

Notice the extra set of quotes (``""``) around the expression. They are
neccessary to escape the colon (``:``) which has special meaning in YAML.

Run It
------

Let's save our files and run the flow and see what happens based on the
output and results of the ``generate_user_mail`` operation. Once again,
make sure to run it a few times so we can see what happens when the
operation returns a result of ``SUCCESS`` and what happens when the
result is ``FAILURE``.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials --i address=john.doe@somecompany.com

When the check_availability operation returns a result of ``SUCCESS``
the flow continues with the next step and prints out the availability
message. However, when the check_availability operation returns a
result of ``FAILURE`` the flow ends immediately with a result of
``FAILURE``. This is the default navigation behavior.

Note that operations which don't explicitly return any results always
return the result ``SUCCESS``.

Download the Code
-----------------

:download:`Lesson 5 - Complete code </code/tutorial_code/tutorials_05.zip>`

Up Next
-------

In the next lesson we'll see one way to handle ``FAILURE`` results.

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
        - address

      workflow:
        - print_start:
            do:
              base.print:
                - text: "Starting new hire process"

        - check_address:
            do:
              check_availability:
                - address
            publish:
              - availability: ${available}

        - print_finish:
            do:
              base.print:
                - text: "${'Availability for address ' + address + ' is: ' + str(availability)}"
