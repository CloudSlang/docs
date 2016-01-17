Get Started
+++++++++++

It's easy to get started running CloudSlang flows, especially using the
CLI and ready-made content.

Download, Unzip and Run
=======================

-  `Download <http://cloudslang.io/download>`__ the CLI zip file.
-  Unzip the archive.
-  Run the CloudSlang executable.
-  At the prompt enter:

.. code-block:: bash

    run --f ../content/io/cloudslang/base/print/print_text.sl --i text=Hi

-  The CLI will run the ready-made ``print_text`` operation that will
   print the value passed to the variable ``text`` to the screen.

Docker
======

-  docker pull cloudslang/cloudslang
-  docker run -it cloudslang/cloudslang
-  At the prompt enter:

.. code-block:: bash

    run --f ../content/io/cloudslang/base/print/print_text.sl --i text=Hi

Or, to run the flow without the prompt:

.. code-block:: bash

    docker run --rm -ti cloudslang run --f ../content/io/cloudslang/base/print/print_text.sl --i text=first_flow

-  The CLI will run the ready-made ``print_text`` operation that will
   print the value passed to the variable ``text`` to the screen.

Next Steps
==========

Now that you've run your first CloudSlang file, you might want to:

-  Watch a `video <https://www.youtube.com/watch?v=9nYLXx5pRBw>`__ lesson on how to author CloudSlang content using Atom.
-  Learn how to write a print operation yourself using the :doc:`Hello World example <hello_world>`.
-  Learn about the language features using the :doc:`New Hire Tutorial <tutorial/01_lesson>`.
-  Learn about the language in detail using the :doc:`CloudSlang Reference <cloudslang_dsl_reference>`.
-  See an `overview <https://github.com/CloudSlang/cloud-slang-content/blob/master/DOCS.md>`__
   of the ready-made content.
-  Learn about the :doc:`ready-made content <cloudslang_content>`.
-  Learn about embedding :doc:`CloudSlang <developer_cloudslang>` or the
   :doc:`CloudSlang Orchestration Engine <developer_score>` into your
   existing application.
-  Learn about the :doc:`architecture <developer_architecture>` of
   CloudSlang and the CloudSlang Orchestration Engine.
