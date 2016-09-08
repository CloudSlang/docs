Build Tool
++++++++++

The CloudSlang Build Tool checks the syntactic validity of CloudSlang
files, their adherence to many of the :doc:`best
practices <cloudslang_best_practices>` and runs their associated
tests.

Running the CloudSlang Build Tool performs the following steps, each of which is
written to the console:

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

**Sample Builder Run**

.. code-block:: none

    11:08:12 [INFO]
    11:08:12 [INFO] ------------------------------------------------------------
    11:08:12 [INFO] Building project: C:\CloudSlang\test_code\build_tool
    11:08:12 [INFO] Content root is at: C:\CloudSlang\test_code\build_tool\content
    11:08:12 [INFO] Test root is at: C:\CloudSlang\test_code\build_tool\test
    11:08:12 [INFO] Active test suites are: [default]
    11:08:12 [INFO]
    11:08:12 [INFO] Loading...
    11:08:17 [INFO]
    11:08:17 [INFO] ------------------------------------------------------------
    11:08:17 [INFO] Building project: build_tool
    11:08:17 [INFO] ------------------------------------------------------------
    11:08:17 [INFO]
    11:08:17 [INFO] --- compiling sources ---
    11:08:17 [INFO] Start compiling all slang files under: C:\CloudSlang\test_code\build_tool\content
    11:08:17 [INFO] 1 .sl files were found
    11:08:17 [INFO]
    11:08:17 [INFO] Compiled: 'build_tool.content.operation' successfully
    11:08:17 [INFO] Successfully finished Compilation of: 1 Slang files
    11:08:17 [INFO]
    11:08:17 [INFO] --- compiling tests sources ---
    11:08:17 [INFO] Start compiling all slang files under: C:\CloudSlang\test_code\build_tool\test
    11:08:17 [INFO] 0 .sl files were found
    11:08:17 [INFO]
    11:08:17 [INFO] Compiled: 'build_tool.content.operation' successfully
    11:08:17 [INFO]
    11:08:17 [INFO] --- parsing test cases ---
    11:08:17 [INFO] Start parsing all test cases files under: C:\CloudSlang\test_code\build_tool\test
    11:08:17 [INFO] 1 test cases files were found
    11:08:17 [INFO]
    11:08:17 [INFO] --- running tests ---
    11:08:17 [INFO] Found 2 tests
    11:08:17 [INFO] Running test: testOperationFailure - Tests that operation.sl finishes with FAILURE
    11:08:23 [ERROR] Test case failed: testOperationFailure - Tests that operation.sl finishes with FAILURE
          Expected result: FAILURE
          Actual result: SUCCESS
    11:08:23 [INFO] Running test: testOperationSuccess - Tests that operation.sl finishes with SUCCESS
    11:08:23 [INFO] Test case passed: testOperationSuccess. Finished running: build_tool.content.operation with result: SUCCESS
    11:08:23 [INFO] ------------------------------------------------------------
    11:08:23 [INFO] Following 1 test cases passed:
    11:08:23 [INFO] - testOperationSuccess
    11:08:23 [INFO]
    11:08:23 [INFO] ------------------------------------------------------------
    11:08:23 [INFO] Following 1 executables have tests:
    11:08:23 [INFO] - build_tool.content.operation
    11:08:23 [INFO]
    11:08:23 [INFO] ------------------------------------------------------------
    11:08:23 [INFO] Following 0 executables do not have tests:
    11:08:23 [INFO]
    11:08:23 [INFO] ------------------------------------------------------------
    11:08:23 [INFO] 100% of the content has tests
    11:08:23 [INFO] Out of 1 executables, 1 executables have tests
    11:08:23 [INFO] 1 test cases passed
    11:08:23 [ERROR]
    11:08:23 [ERROR] ------------------------------------------------------------
    11:08:23 [ERROR] BUILD FAILURE
    11:08:23 [ERROR] ------------------------------------------------------------
    11:08:23 [ERROR] CloudSlang build for repository: "C:\CloudSlang\test_code\build_tool" failed due to failed tests.
    11:08:23 [ERROR] Following 1 tests failed:
    11:08:23 [ERROR] - Test case failed: testOperationFailure - Tests that operation.sl finishes with FAILURE

                  Expected result: FAILURE
                  Actual result: SUCCESS
    11:08:23 [ERROR]

Download the Build Tool
=======================

The CloudSlang Build Tool can be downloaded from
`here <https://github.com/CloudSlang/cloud-slang/releases/latest>`__.

.. _configure_build_tool:

Configure the Build Tool
========================

The Build Tool can be configured using the configuration file found at
``cslang-builder/configuration/cslang.properties``.

+-------------------------------------+---------------------------------------------------------+--------------------------+
| Configuration key                   | Default value                                           | Description              |
+=====================================+=========================================================+==========================+
| cslang.encoding                     | utf-8                                                   | | Character encoding     |
|                                     |                                                         | | for input values       |
|                                     |                                                         | | and input files        |
+-------------------------------------+---------------------------------------------------------+--------------------------+
| maven.home                          | ${app.home}/maven/apache-maven-x.y.z                    | | Location of CloudSlang |
|                                     |                                                         | | Maven repository home  |
|                                     |                                                         | | directory              |
+-------------------------------------+---------------------------------------------------------+--------------------------+
| maven.settings.xml.path             | ${app.home}/maven/conf/settings.xml                     | | Location of            |
|                                     |                                                         | | Maven settings file    |
+-------------------------------------+---------------------------------------------------------+--------------------------+
| cloudslang.maven.repo.local         | ${app.home}/maven/repo                                  | | Location of local      |
|                                     |                                                         | | repository             |
+-------------------------------------+---------------------------------------------------------+--------------------------+
| cloudslang.maven.repo.remote.url    | http://repo1.maven.org/maven2                           | | Location of remote     |
|                                     |                                                         | | Maven repository       |
+-------------------------------------+---------------------------------------------------------+--------------------------+
| cloudslang.maven.plugins.remote.url | http://repo1.maven.org/maven2                           | | Location of remote     |
|                                     |                                                         | | Maven plugins          |
+-------------------------------------+---------------------------------------------------------+--------------------------+

Maven Configuration
-------------------

The Build Tool uses Maven to manage Java action dependencies. There are several
Maven configuration properties found in the :ref:`Build Tool's
configuration file <configure_build_tool>`. To configure Maven to use a remote
repository other than Maven Central, edit the values for
``cloudslang.maven.repo.remote.url`` and ``cloudslang.maven.plugins.remote.url``.
Additionally, you can edit the proxy settings in the file found at
``maven.settings.xml.path``.

Maven Troubleshooting
---------------------

It is possible that the Build Tool's Maven repository can become corrupted. In
such a case, delete the entire **repo** folder found at the location indicated
by the ``cloudslang.maven.repo.local`` key in the :ref:`Build Tool's
configuration file <configure_build_tool>` and rerun the builder.

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
| -ts        | none                     | | list of test suites to run - use ``!default``                                                     |
|            |                          | | to skip tests that are not included in a test suite                                               |
+------------+--------------------------+-----------------------------------------------------------------------------------------------------+
| -cov       | false                    | whether or not test coverage data should be output                                                  |
+------------+--------------------------+-----------------------------------------------------------------------------------------------------+

.. note::

   To skip tests not included in a test suite when using Linux,
   the exclamation mark (``!``) needs to be escaped with a preceding
   backslash (``\``). So, to ignore default tests, pass ``\!default``.

.. note::

   Test coverage is calculated as a percentage of flows and
   operations for which tests exist, regardless of how much of each flow or
   operation is covered by the test. Additionally, a flow or operation will
   be considered covered even if its test's suite did not run during the
   current build. The mere existence of a test for a flow or operation is
   enough to consider it as covered.

Build Tool Log
--------------
The builder log is saved at ``cslang-builder/logs/builder.log``.

Maven Log
---------
Log files of Maven activity are saved at ``cslang-builder/logs/maven/``. Each
artifact's activity is stored in a file named with the convention
``<group>_<artifact>_<version>.log``.
