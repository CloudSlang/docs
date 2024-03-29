Content
+++++++

Ready-made CloudSlang content is hosted on GitHub in the
`cloud-slang-content <https://github.com/CloudSlang/cloud-slang-content>`__
repository. The repository contains CloudSlang content written by the CloudSlang
team as well as content contributed by the community.

The cloud-slang-content repository contains ready-made CloudSlang flows and
operations for many common tasks as well as content that integrates with several
other systems.

The repository may contain some beta content. Beta content is not verified or
tested by the CloudSlang team. Beta content is named with the ``beta_`` prefix.
The community is encouraged to assist in setting up testing environments for the
beta content.

For more information on the content contained in the repository, see the
`docs <https://github.com/CloudSlang/cloud-slang-content/blob/master/DOCS.md>`__
page.

Running CloudSlang Content
==========================

The simplest way to get started running ready-made CloudSlang content is to
download and run the pre-packaged cslang-cli-with-content file as described in
the :doc:`Get Started </overview/get_started>` section.

Alternatively, you can build the CLI from source and download the content
separately. To build the CLI yourself and for more information on using the CLI,
see the :doc:`CLI <cloudslang_cli>` section.

.. note::

   When using a locally built CLI you may need to include a classpath to
   properly reference ready-made content. For information on using classpaths, see
   :ref:`Run with Dependencies <run_with_dependencies>`.

Running Content Dependent on Java Actions
=========================================

Some of the content is dependent on Java actions from the cs-actions repository.
CloudSlang uses Maven to manage these dependencies. When executing an operation
that declares a dependency, the required Maven project and all the resources
specified in its pom's ``dependencies`` will be resolved and downloaded (if
necessary).

.. note::

    Maven version used in the CLI, Builder and cs-actions is ``3.3.9`` with JRE version ``8u282-8.52.0.23``.
    There might be some issues while building the Java Actions with
    other versions.

Running Content Dependent on External Python Modules
====================================================

Some of the content is dependent on external python modules. To run this content
follow the instructions found in the :ref:`python_action` section of the DSL
Reference.

Contributing Content
====================

We welcome and encourage community contributions to CloudSlang. Please see the
:doc:`contribution </developer/developer_contribution>` section to familiarize yourself
with the Contribution Guidelines and `Project Roadmap
<https://github.com/CloudSlang/cloud-slang/wiki/Project-Roadmap>`__
before contributing.
