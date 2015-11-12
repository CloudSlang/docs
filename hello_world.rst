Hello World
+++++++++++

The following is a simple example to give you an idea of how CloudSlang
is structured and can be used to ensure your environment is set up
properly to run flows.

Prerequisites
=============

This example uses the CloudSlang CLI to run a flow. See the :doc:`CloudSlang
CLI <cloudslang_cli>` section for instructions on how to download
and run the CLI.

Although CloudSlang files can be composed in any text editor, using a
modern code editor with support for YAML syntax highlighting is
recommended. See :doc:`Sublime Integration <sublime_integration>` for
instructions on how to download, install and use the CloudSlang snippets
for `Sublime Text <http://www.sublimetext.com/>`__.

Code files
==========

In a new folder, create two new CloudSlang files, hello\_world.sl and
print.sl, and copy the code below.

**hello\_world.sl**

.. code-block:: yaml

    namespace: examples.hello_world

    flow:
      name: hello_world
      workflow:
        - sayHi:
            do:
              print:
                - text: "'Hello, World'"

**print.sl**

.. code-block:: yaml

    namespace: examples.hello_world

    operation:
      name: print
      inputs:
        - text
      action:
        python_script: print text
      results:
        - SUCCESS

Run
===

Start the CLI from the folder in which your CloudSlang files reside and
enter ``run hello_world.sl`` at the ``cslang>`` prompt.

The output will look similar to this:

.. code-block:: bash

    - sayHi
    Hello, World
    Flow : hello_world finished with result : SUCCESS
    Execution id: 101600001, duration: 0:00:00.790

Explanation
===========

The CLI runs the :ref:`flow` in the file
we have passed to it, namely **hello\_world.sl**. The
:ref:`flow` begins with an :ref:`import <imports>` of the operations file,
**print.sl**, using its :ref:`namespace` as the value for
the :ref:`imports` key. Next, we enter the :ref:`flow` named
``hello_world`` and begin its :ref:`workflow`. The
:ref:`workflow` has one :ref:`task` named ``sayHi`` which calls
the ``print`` :ref:`operation` from the operations file that was imported. The
:ref:`flow` passes the string ``"'Hello, World'"`` to the ``text`` :ref:`input <inputs>`
of the ``print`` :ref:`operation`. The print
:ref:`operation` performs its :ref:`action`, which is a simple
Python script that prints the :ref:`input <inputs>`, and then returns a
:ref:`result <results>` of ``SUCCESS``. Since the flow does not contain any more
:ref:`tasks <task>` the :ref:`flow` finishes with a :ref:`result <results>` of ``SUCCESS``.

More
====

For a more comprehensive walkthrough of the CloudSlang language's
features, see the :doc:`New Hire Tutorial <tutorial/01_lesson>`.
