Hello World
+++++++++++

The following is a simple example to give you an idea of how CloudSlang
is structured and can be used to ensure your environment is set up
properly.

Prerequisites
=============

This example uses the CloudSlang CLI to run a flow. See the :doc:`CloudSlang
CLI <cloudslang_cli>` section for instructions on how to download and run the
CLI.

Although CloudSlang files can be composed in any text editor, using a
modern code editor with support for YAML syntax highlighting is
recommended. See :doc:`CloudSlang Editors <cloudslang_editors>` for
instructions on how to download, install and use the CloudSlang language
package for Atom.

Code files
==========

:download:`Download </code/examples_code/examples/hello_world.zip>` the code or
use the following instructions:

Create a folder **examples** and then another folder **hello_world** inside the
**examples** folder. In the **hello_world** folder, create two new CloudSlang
files, **hello_world.sl** and **print.sl**.

You should now have the following folder structure:

- examples

    - hello_world

        - hello_world.sl
        - print.sl

Copy the code below into the corresponding files.

**hello_world.sl**

.. code-block:: yaml

    namespace: examples.hello_world

    flow:
      name: hello_world

      workflow:
        - sayHi:
            do:
              print:
                - text: "Hello, World"

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

Start the CLI and enter the following command at the ``cslang>`` prompt:

.. code-block:: bash

   run --f <path_to_files>/examples/hello_world/hello_world.sl --cp <path_to_files>/examples/hello_world

.. note::
   Use forward slashes in the file paths.

The output will look similar to this:

.. code-block:: bash

    - sayHi
    Hello, World
    Flow : hello_world finished with result : SUCCESS
    Execution id: 101600001, duration: 0:00:00.790

Explanation
===========

The CLI runs the :ref:`flow` contained in the file passed to it using the ``--f``
flag, namely **hello_world.sl**. The ``--cp`` flag is used to specify the
classpath where the flow's dependencies can be found. In our case, the flow refers
to the ``print`` operation, so we must add its location to the classpath.

.. note::
   If you are using a CLI without the **content** folder, specifying the
   classpath in this instance is not necessary.

The :ref:`flow` named ``hello_world`` begins its :ref:`workflow`. The
:ref:`workflow` has one :ref:`step` named ``sayHi`` which
calls the ``print`` :ref:`operation`. The :ref:`flow` passes the string
``"Hello, World"`` to the ``text`` :ref:`input <inputs>` of the ``print``
:ref:`operation`. The print :ref:`operation` performs its :ref:`action`, which
is a simple Python script that prints the :ref:`input <inputs>`, and then
returns a :ref:`result <results>` of ``SUCCESS``. Since the flow does not
contain any more :ref:`steps <step>` the :ref:`flow` finishes with a
:ref:`result <results>` of ``SUCCESS``.

More
====

For a more comprehensive walkthrough of the CloudSlang language's
features, see the :doc:`tutorial <tutorial/01_lesson>`.
