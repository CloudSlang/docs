Tests
+++++

CloudSlang tests are written to test CloudSlang content and are run
during the build process by the :doc:`CloudSlang Build Tool <cloudslang_build_tool>`.

Wrapper Flows
=============

Test cases either test a flow or operation directly or use a wrapper
flow that calls the flow or operation to be tested.

Wrapper flows are often used to set up an environment before the test
runs and to clean up the environment after the test. They are also
sometimes necessary for complex tests of a flow or operation's outputs.

Wrapper flows are written in CloudSlang using the **.sl** extension and
use the normal flow syntax.

Test Suites
===========

Test suites are groups of tests that are only run if the build declares
them as active. Test suites are often used to group tests that require a
certain environment that may or may not be present in order to run. When
the environment is present the suite can be activated and when it is not
present the tests will not run.

Tests declare which test suites they are a part of, if any, using the
``testSuites`` property.

If no test suites are defined for a given test case, the test will run
unless ``!default`` is passed to the :doc:`CloudSlang Build Tool <cloudslang_build_tool>`.

**Note:** When using Linux, the exclamation mark (``!``) needs to be
escaped with a preceding backslash (``\``). So, to ignore default tests,
pass ``\!default`` to the CloudSlang Build Tool.

Test Case Syntax
================

CloudSlang test files are written in YAML with the .inputs.yaml
extension and contain one or more test cases.

Each test case begins with a unique key that is the test case name. The
name is mapped to the following test case properties:

+----------------------------+------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Property                   | Required   | Value Type                 | Description                                                                                                                                                                                                                       |
+============================+============+============================+===================================================================================================================================================================================================================================+
| ``inputs``                 | no         | list of key:value pairs    | inputs to pass to the flow or operation being tested                                                                                                                                                                              |
+----------------------------+------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``systemPropertiesFile``   | no         | string                     | path to the system properties file for the flow or operation - ``${project_path}`` can be used for specifying a path relative to the project path (e.g. systemPropertiesFile: ``${project_path}\content\base\properties.yaml``)   |
+----------------------------+------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``description``            | no         | string                     | description of test case                                                                                                                                                                                                          |
+----------------------------+------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``testFlowPath``           | yes        | string                     | qualified name of the flow, operation or wrapper flow to test                                                                                                                                                                     |
+----------------------------+------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``testSuites``             | no         | list                       | list of suites this test belongs to                                                                                                                                                                                               |
+----------------------------+------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``outputs``                | no         | list of key:value pairs    | expected output values of the flow, operation or wrapper flow being tested                                                                                                                                                        |
+----------------------------+------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``result``                 | no         | flow or operation result   | expected result of the flow, operation or wrapper flow being tested                                                                                                                                                               |
+----------------------------+------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``throwsException``        | no         | boolean                    | whether or not to expect an exception                                                                                                                                                                                             |
+----------------------------+------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

**Note:** The ``outputs`` parameter does not need to test all of a flow
or operation's outputs.

**Example - test cases that test the match\_regex operation**

.. code-block:: yaml

    testMatchRegexMatch:
      inputs:
        - regex: 'a+b'
        - text: aaabc
      description: Tests that match_regex.sl operation finishes with MATCH for specified regex/text
      testFlowPath: io.cloudslang.base.strings.match_regex
      outputs:
        - match_text: 'aaab'
      result: MATCH

    testMatchRegexMissingInputs:
      inputs:
        - text: HELLO WORLD
      description: Tests that match_regex.sl operation throws an exception when a required input is missing
      testFlowPath: io.cloudslang.base.strings.match_regex
      outputs:
        - match_text: ''
      throwsException: true

Run Tests
=========

To run test cases use the :doc:`CloudSlang Build Tool <cloudslang_build_tool>`. Test cases are not run by the
:doc:`CloudSlang CLI <cloudslang_cli>`.
