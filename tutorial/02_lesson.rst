Lesson 2 - First Operation
==========================

Goal
----

In this lesson we'll write our first operation. We'll learn the basic
structure of a simple operation by writing one that simply prints out a
message.

Get Started
-----------

First, we need to create the **print.sl** file in the **base** folder so we can
start writing the print operation.
The print operation is as simple as they get. It just takes in a input
and prints it out using Python.

Namespace
---------

All CloudSlang files start with a namespace which mirrors the folder
structure in which the files are found. In our case we've put
**print.sl** in the **tutorials/base** folder so our namespace should
reflect that.

.. code-block:: yaml

    namespace: tutorials.base

The namespace can be used by flows that call this operation.

For more information, see :ref:`namespace` in the DSL reference.

Operation Name
--------------

Each operation begins with the ``operation`` key which will map to the
contents of the operation body. The first part of that body is a
key:value pair defining the name of the operation. The name of the
operation must be the same as the name of the file it is stored in.

.. code-block:: yaml

    operation:
      name: print

.. note::

   **YAML Note:** Indentation is **very** important in YAML. It is used to
   indicate scope. In the example above, you can see that
   ``name: print`` is indented under the ``operation`` key to denote
   that it belongs to the operation. **Always** use spaces to indent.
   **Never** use tabs.

For more information, see :ref:`operation` in the DSL reference.

Inputs
------

After the name, if the operation takes any inputs, they are listed under
the ``inputs`` key. In our case we'll need to take in the text we want
to print. We'll name our input ``text``.

.. code-block:: yaml

    inputs:
      - text

.. note::

   **YAML Note:** The ``inputs`` key maps to a list of inputs. In YAML, a
   list is signified by prepending a hypen and a space (- ) to each
   item.

The values for the inputs are either passed via the :doc:`CloudSlang
CLI <../cloudslang_cli>`, as we do below in this lesson, or from a
step in a flow, as we will do in the next lesson.

Inputs can also have related parameters, such as ``required``,
``default`` and ``private``. We will discuss these parameters in lessons
:doc:`8 - Input Parameters <08_lesson>`.

For more information, see :ref:`inputs`, :ref:`required`, :ref:`default` and
:ref:`private` in the DSL reference.

Action
------

Finally, we've reached the core of the operation, the action. There are
two types of actions in CloudSlang, Python-based actions and Java-based
actions.

We'll start off by creating a Python action that simply prints the text
that was input. To do so, we add ``python_action`` and ``script`` keys that map
to the action contents.

.. code-block:: yaml

    python_action:
      script: print text

.. note::

   CloudSlang uses the `Jython <http://www.jython.org/>`__
   implementation of Python 2.7. For information on Jython's limitations,
   see the `Jython FAQ <https://wiki.python.org/jython/JythonFaq>`__.

Python scripts that need 3rd party packages may import them using the
procedures described in lesson :doc:`14 - 3rd Party Python
Packages <14_lesson>`.

For more information, see :ref:`python_action` in the DSL reference.

The usage of Java-based actions is beyond the scope of this tutorial.
For more information, see the :ref:`java_action` in the DSL reference.

Run It
------

That's it. Our operation is all ready. Our next step will be to create a
flow that uses the operation we just wrote, but we can actually just run
the operation as is.

To do so, save the operation file, fire up the CloundSlang CLI and enter
the following at the prompt to run your operation:

.. code-block:: bash

    run --f <folder path>/tutorials/base/print.sl --i text=Hi

You should see the input text printed out to the screen.

For more information, see :ref:`Use the CLI <use_the_cli>` in the
DSL reference.

Download the Code
-----------------

:download:`Lesson 2 - Complete code </code/tutorial_code/tutorials_02.zip>`

Up Next
-------

In the next lesson we'll write a flow that will call the print
operation.

New Code - Complete
-------------------

**print.sl**

.. code-block:: yaml

    namespace: tutorials.base

    operation:
      name: print

      inputs:
        - text

      python_action:
        script: print text
