Lesson 3 - First Flow
=====================

Goal
----

In this lesson we'll write a simple flow that will call the print
operation. We'll learn about the main components that make up a flow.

Get Started
-----------

First, we need to create a **new_hire.sl** file in the **hiring** folder so we
can start writing the new hire flow. We'll build it one step at a time. So for
now, all it will do is call the print operation we wrote in the previous lesson.

Namespace
---------

Just like in our operation file, we need to start the flow file with a
namespace. Since we're storing **new_hire.sl** in the
**tutorials/hiring** folder the namespace must reflect that.

.. code-block:: yaml

    namespace: tutorials.hiring

For more information, see :ref:`namespace` in the DSL reference.

Imports
-------

After the namespace you can list the namespace of any CloudSlang files
that you will need to reference in your flow. Our flow will need to
reference the operation in **print.sl**, so we'll add the namespace from
that file, ``tutorials.base``, to the optional ``imports`` key. We map an alias
that we will use as a reference in the flow to the namespace we are importing.
Let's call the alias ``base``.

.. code-block:: yaml

    imports:
      base: tutorials.base

Now we can use ``base.print`` to refer to the ``print`` operation in a step.
We'll do that in a moment.

For more information, see :ref:`imports` in the DSL reference.

For ways to refer to an operation or subflow without creating an alias,
see the :ref:`CloudSlang DSL Reference <do>` and the
:ref:`Operation Paths <example_operation_paths>` example.

Flow Name
---------

Each flow begins with the ``flow`` key which will map to the contents of
the flow body. The first part of that body is a key:value pair defining
the name of the flow. The name of the flow must be the same as the name
of the file it is stored in.

.. code-block:: yaml

    flow:
      name: new_hire

For more information, see :ref:`flow` in the DSL reference.

Steps
-----

The next part of our flow will be the workflow. The ``workflow`` key
maps to a list of all the steps in the flow. We'll start off with just
one step, the one that calls our print operation. Each step in a
workflow starts with a key that is its name. We'll call our step
``print_start``.

.. code-block:: yaml

    workflow:
      - print_start:

For more information, see :ref:`workflow` in the DSL reference.

A step can contain several parts, but we'll start with a simple step
with the only required part, the ``do`` key. We want to call the print
operation. In this case we'll reference it using the alias we created up
in the flow's ``imports`` section. Also, we'll have to pass any required
inputs to the operation. In our case, there's one input named ``text``
which we'll add to a list under the operation call and pass it a value.

.. code-block:: yaml

    do:
      base.print:
        - text: "Starting new hire process"
    navigate:
      - SUCCESS: SUCCESS

In addition to the required ``do``, a step can also contain the optional
``publish`` and ``navigate`` keys. Here we added a ``navigate`` section.
We'll explain more about ``publish`` and ``navigate`` a little later in lessons
:doc:`5 - Default Navigation <05_lesson>` and :doc:`7 - Custom Navigation
<07_lesson>` respectively.

For more information, see :ref:`do`, :ref:`publish` and :ref:`navigate` in the
DSL reference.

Run It
------

Now our flow is all ready to run. To do so, save the file and enter the
following at the prompt.

.. code-block:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials/base

.. note::

   The ``--cp`` flag is used to add folders where the flow's
   dependencies are found to the classpath. For more information, see
   :ref:`Run with Dependencies <run_with_dependencies>` in the DSL reference.

You should see the name of the step and the string sent to the print
operation printed to the screen.

Download the Code
-----------------

:download:`Lesson 3 - Complete code </code/tutorial_code/tutorials_03.zip>`

Up Next
-------

In the next lesson we'll write a more complex operation that also returns
outputs and results.

New Code - Complete
-------------------

**new_hire.sl**

.. code-block:: yaml

    namespace: tutorials.hiring

    imports:
      base: tutorials.base

    flow:
      name: new_hire

      workflow:
        - print_start:
            do:
              base.print:
                - text: "Starting new hire process"
            navigate:
              - SUCCESS: SUCCESS

      results:
        - SUCCESS
