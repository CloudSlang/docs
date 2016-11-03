Get Started
+++++++++++

It's easy to get started running CloudSlang flows, especially using the
CLI and ready-made content.

Download, Unzip and Run
=======================

-  `Download <https://github.com/CloudSlang/cloud-slang/releases/tag/cloudslang-1.0.0>`__
   the CLI with content zip file.
-  Unzip the archive.
-  Run the CloudSlang executable in the ``cslang-cli/bin`` folder.
-  At the prompt enter:

.. code-block:: bash

    run --f ../content/io/cloudslang/base/print/print_text.sl --i text=Hi

-  The CLI will run the ready-made ``print_text`` operation that will
   print the value passed to the variable ``text`` to the screen.

Docker
======

There are two CloudSlang Docker images. One (cloudslang/cloudslang) is a
lightweight image meant to get you running CloudSlang flows as quickly as
possible. The other image (cloudslang/cloudslang-dev) adds the tools necessary
to develop CloudSlang flows.

cloudslang/cloudslang
---------------------

This image includes:

- Java
- CloudSlang CLI
- CloudSlang content

To get and run the image: ``docker pull cloudslang/cloudslang``

To run a flow with a CloudSlang prompt:

-  ``docker run -it cloudslang/cloudslang``
-  At the prompt enter: ``run --f ../content/io/cloudslang/base/print/print_text.sl --i text=Hi``

Or, to run the flow without the prompt:

``docker run --rm cloudslang/cloudslang run --f ../content/io/cloudslang/base/print/print_text.sl --i text=first_flow``

The CLI will run the ready-made ``print_text`` operation that will
print the value passed to the variable ``text`` to the screen.

cloudslang/cloudslang-dev
-------------------------

This image includes:

- Java
- CloudSlang CLI
- CloudSlang content
- Python
- Pip
- Vim
- Emacs
- SSH
- Git
- Atom
- language-cloudslang Atom package

To get the image: ``docker pull cloudslang/cloudslang-dev``

Next Steps
==========

Now that you've run your first CloudSlang file, you might want to:

-  Watch a `video <https://www.youtube.com/watch?v=9nYLXx5pRBw>`__ lesson on how to author CloudSlang content using Atom.
-  Learn how to write a print operation yourself using the :doc:`Hello World example <hello_world>`.
-  Learn about the language features using the :doc:`New Hire Tutorial <tutorial/01_lesson>`.
-  Learn about the language in detail using the :doc:`CloudSlang Reference <cloudslang_dsl_reference>`.
-  See an `overview <https://github.com/CloudSlang/cloud-slang-content/blob/cloud-slang-content-1.0/DOCS.md>`__
   of the ready-made content.
-  Learn about the :doc:`ready-made content <cloudslang_content>`.
-  Learn about embedding :doc:`CloudSlang <developer_cloudslang>` or the
   :doc:`CloudSlang Orchestration Engine <developer_score>` into your
   existing application.
-  Learn about the :doc:`architecture <developer_architecture>` of
   CloudSlang and the CloudSlang Orchestration Engine.
