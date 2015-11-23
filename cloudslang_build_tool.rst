Build Tool
++++++++++

The CloudSlang Build Tool checks the syntactic validity of CloudSlang
files, their adherence to many of the :doc:`best
practices <cloudslang_best_practices>` and runs their associated
tests.

Running the CloudSlang Build Tool performs the following steps:

1. Displays the active project, content and test paths.
2. Displays a list of the active test suites.
3. Compiles all CloudSlang files found in the content directory and all
   of its subfolders.

   -  If there is a compilation error, it is displayed and the build
      terminates.

4. Compiles all CloudSlang test flows found in the test directory and
   all of its subfolders.
5. Parses all test cases files found in the test directory and all of
   its subfolders.
6. Runs all test cases found in the test case files that have no test
   suite or have a test suite that is active.
7. Displays the test cases that were skipped.
8. Reports the build's status.

   -  If the build fails, a list of failed test cases are displayed.

Download the Build Tool
=======================

The CloudSlang Build Tool can be downloaded from
`here <https://github.com/CloudSlang/cloud-slang/releases/latest>`__.

Use the Build Tool
==================

The CloudSlang Build Tool builds projects. A project consists of a
folder that contains the CloudSlang content and a folder containing the
tests for the content.

By default the build tool will look for a folder named **content** and a
folder named **test** in the project folder to use as the content and
test folders respectively. If they are present in the project folder,
they do not have to be passed to the build tool.

To use the CloudSlang Build Tool with default settings, run the
**cslang-builder** executable from the command line and pass the path to
the project folder.

.. code:: bash

    <builder path>\cslang-builder\bin>cslang-builder.bat <project path>

To use the CloudSlang Build Tool with specific settings, run the
**cslang-builder** executable from the command line and pass the
following arguments:

+------------+--------------------------+-----------------------------------------------------------------------------------------------------+
| Argument   | Default                  | Description                                                                                         |
+============+==========================+=====================================================================================================+
| -pr        | current folder           | project root folder                                                                                 |
+------------+--------------------------+-----------------------------------------------------------------------------------------------------+
| -cr        | <project root>/content   | content root folder                                                                                 |
+------------+--------------------------+-----------------------------------------------------------------------------------------------------+
| -tr        | <project root>/test      | test root folder                                                                                    |
+------------+--------------------------+-----------------------------------------------------------------------------------------------------+
| -ts        | none                     | list of test suites to run - use ``!default`` to skip tests that are not included in a test suite   |
+------------+--------------------------+-----------------------------------------------------------------------------------------------------+
| -cov       | false                    | whether or not test coverage data should be output                                                  |
+------------+--------------------------+-----------------------------------------------------------------------------------------------------+

**Note:** To skip tests not included in a test suite when using Linux,
the exclamation mark (``!``) needs to be escaped with a preceding
backslash (``\``). So, to ignore default tests, pass ``\!default``.

**Note:** Test coverage is calculated as a percentage of flows and
operations for which tests exist, regardless of how much of each flow or
operation is covered by the test. Additionally, a flow or operation will
be considered covered even if its test's suite did not run during the
current build. The mere existence of a test for a flow or operation is
enough to consider it as covered.
