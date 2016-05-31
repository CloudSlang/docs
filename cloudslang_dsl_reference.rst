DSL Reference
+++++++++++++

CloudSlang is a `YAML <http://www.yaml.org>`__ (version 1.2) based
language for describing a workflow. Using CloudSlang you can easily
define a workflow in a structured, easy-to-understand format that can be
run by the CloudSlang Orchestration Engine (Score). CloudSlang files can
be run by the :doc:`CloudSlang CLI <cloudslang_cli>` or by an embedded
instance of Score using the :ref:`Slang API <slang_api>`.

This reference begins with a brief introduction to CloudSlang files and
their structure, then continues with a brief explanation of CloudSlang
expressions and variable contexts. Finally, there are alphabetical listings of
the CloudSlang keywords and functions. See the
:doc:`examples <cloudslang_examples>` section for the full code examples from
which many of the code snippets in this reference are taken.

.. _cloudslang_files:

CloudSlang Files
================

CloudSlang files are written using `YAML <http://www.yaml.org>`__. The
recommended extension for CloudSlang flow and operation file names is **.sl**,
but **.sl.yaml** and **.sl.yml** will work as well. CloudSlang system properties
file names end with the **.prop.sl** extension.

There are three types of CloudSlang files:

-  flow - contains a list of steps and navigation logic that calls
   operations or subflows
-  operation - contains an action that runs a script or method
-  system properties - contains a list of system property keys and values

The following properties are for all types of CloudSlang files. For
properties specific to `flow <#flow>`__, `operation <#operation>`__, or
`system properties <#properties>`__ files, see their respective sections below.

+----------------+----------+---------+-------------------+---------------------------+----------------------------+
| Property       | Required | Default | Value Type        | Description               | More Info                  |
+================+==========+=========+===================+===========================+============================+
| ``namespace``  | no       | --      | string            | | namespace               | `namespace <#namespace>`__ |
|                |          |         |                   | | of the file             |                            |
+----------------+----------+---------+-------------------+---------------------------+----------------------------+
| ``imports``    | no       | --      | | list of         | files to import           |  `imports <#imports>`__    |
|                |          |         | | key:value pairs |                           |                            |
+----------------+----------+---------+-------------------+---------------------------+----------------------------+
| ``extensions`` | no       | --      | --                | | information to be       | `extensions <#extensions>`_|
|                |          |         |                   | | ignored by the compiler |                            |
+----------------+----------+---------+-------------------+---------------------------+----------------------------+

Variable names in CloudSlang files cannot contain localized characters. In
general, CloudSlang variable names must conform to both `Python's naming
constraints <https://docs.python.org/2/reference/lexical_analysis.html>`__
as well as `Java's naming constraints <https://docs.oracle.com/javase/tutorial/java/nutsandbolts/variables.html>`__.

When using the CLI or Build Tool, CloudSlang will use the encoding found in the
:ref:`CLI configuration file <configure_cli>` or :ref:`Build Tool configuration
file <configure_build_tool>` for input values respectively. If no encoding is
found in the configuration file, the CLI or Build Tool will use the default
charset of the Java virtual machine.

The general structure of CloudSlang files is outlined here. Some of the
properties that appear are optional. All CloudSlang keywords, properties
and concepts are explained in detail below.

**Flow file**

-  `namespace <#namespace>`__
-  `imports <#imports>`__
-  `flow <#flow>`__

   -  `name <#name>`__
   -  `inputs <#inputs>`__

      -  `required <#required>`__
      -  `default <#default>`__
      -  `private <#private>`__

   -  `workflow <#workflow>`__

      -  `step(s) <#step>`__

         -  `do <#do>`__
         -  `publish <#publish>`__
         -  `navigate <#navigate>`__

      -  `iterative step <#iterative-step>`__

         -  `loop <#loop>`__

            -  `for <#for>`__
            -  `do <#do>`__
            -  `publish <#publish>`__
            -  `break <#break>`__

         -  `navigate <#navigate>`__

      -  `parallel step <#parallel-step>`__

         -  `parallel_loop <#parallel-loop>`__

            -  `for <#for>`__
            -  `do <#do>`__

         -  `publish <#publish>`__
         -  `navigate <#navigate>`__

      -  `on_failure <#on-failure>`__

   -  `outputs <#outputs>`__
   -  `results <#results>`__

-  `extensions <#extensions>`__

**Operation file**

-  `namespace <#namespace>`__
-  `operation <#operation>`__

   -  `name <#name>`__
   -  `inputs <#inputs>`__

      -  `required <#required>`__
      -  `default <#default>`__
      -  `private <#private>`__

   -  `python_action <#python-action>`__

      -  `script <#script>`__

   -  `java_action <#java-action>`__

      -  `class_name <#class-name>`__
      -  `method_name <#method-name>`__

   -  `outputs <#outputs>`__
   -  `results <#results>`__

-  `extensions <#extensions>`__

**System properties file**

-  `namespace <#namespace>`__
-  `properties <#properties>`__
-  `extensions <#extensions>`__

.. _expressions:

Expressions
===========

Many CloudSlang keys map to either an expression or literal value.

Literal Values
--------------

Literal values are denoted as they are in standard YAML. Numbers are interpreted
as numerical values and strings may be written unquoted, single quoted or double
quoted.

**Example: literal values**

.. code-block:: yaml

    literal_number: 4
    literal_unquoted_string: cloudslang
    literal_single_quoted_string: 'cloudslang'
    literal_double_quoted_string: "cloudslang"

.. note::

   Where expressions are allowed as values (input defaults, output and
   result values, etc.) and a literal string value is being used, you are
   encouraged to use a quoted style of literal string.

**Example: recommended style for literal strings**

.. code-block:: yaml

  flow:
    name: flow_name #expression not allowed - unquoted literal string

    workflow:
      - step1:
          do:
            print:
              - text: "hello" #expression allowed - quoted literal string

Standard Expressions
--------------------

Expressions are preceded by a dollar sign (``$``) and enclosed in curly brackets
(``{}``).

**Example: expressions**

.. code-block:: yaml

    - expression_1: ${4 + 7}
    - expression_2: ${some_input}
    - expression_3: ${get('input1', 'default_input')}

Expressions with Special Characters
-----------------------------------

Expressions that contain characters that are considered special characters in
YAML must be enclosed in quotes or use YAML block notation. If using quotes, use
the style of quotes that are not already used in the expression. For example, if
your expression contains single quotes (``'``), enclose the expression using
double quotes (``"``).

**Example: escaping special characters**

.. code-block:: yaml

    - expression1: "${var1 + ': ' + var2}"
    - expression2: >
        ${var1 + ': ' + var2}
    - expression3: |
        ${var1 + ': ' + var2}

Maps
----

To pass a map where an expression is allowed use the `default <#default>`__
property.

**Example: passing a map using the default property**

.. code-block:: yaml

    - map1:
        default: {a: 1, b: c}
    - map2:
        default: {'a key': 1, b: c}

It is also possible to use two sets of quotes and an expression marker, but the
approach detailed above is the recommended one.

**Example: passing a map using the expression marker and quotes**

.. code-block:: yaml

    - map3: "${{'a key': 1, 'b': 'c'}}"
    - map4: >
        ${{'a key': 1, 'b': 'c'}}

.. _contexts:

Contexts
========

Throughout the execution of a flow, its steps, operations and subflows there are
different variable contexts that are accessible. Which contexts are accessible
depends on the current section of the flow or operation.

The table below summarizes the accessible contexts at any given location in a
flow or operation.

+------------------+--------------+-----------+-------------+-----------+-------------+-------------+--------------------+----------------+
| | Contexts/      | | Context    | | Flow    | | Operation | | Action  | | Subflow/  | | Step      | | Branched         | | Already      |
| | Location       | | Passed To  | | Context | | Context   | | Outputs | | Operation | | Arguments | | Step             | | Bound        |
|                  | | Executable |           |             | | Context | | Outputs   |             | | Output           | | Values       |
|                  |              |           |             |           | | Context   |             | | Values           |                |
+==================+==============+===========+=============+===========+=============+=============+====================+================+
| | **flow**       | Yes          |           |             |           |             |             |                    | Yes            |
| | **inputs**     |              |           |             |           |             |             |                    |                |
+------------------+--------------+-----------+-------------+-----------+-------------+-------------+--------------------+----------------+
| | **flow**       |              | Yes       |             |           |             |             |                    | Yes            |
| | **outputs**    |              |           |             |           |             |             |                    |                |
+------------------+--------------+-----------+-------------+-----------+-------------+-------------+--------------------+----------------+
| | **operation**  | Yes          |           |             |           |             |             |                    | Yes            |
| | **inputs**     |              |           |             |           |             |             |                    |                |
+------------------+--------------+-----------+-------------+-----------+-------------+-------------+--------------------+----------------+
| | **operation**  |              |           | Yes         | Yes       |             |             |                    | Yes            |
| | **outputs**    |              |           |             |           |             |             |                    |                |
+------------------+--------------+-----------+-------------+-----------+-------------+-------------+--------------------+----------------+
| | **operation**  |              |           | Yes         | Yes       |             |             |                    |                |
| | **results**    |              |           |             |           |             |             |                    |                |
+------------------+--------------+-----------+-------------+-----------+-------------+-------------+--------------------+----------------+
| | **step**       |              | Yes       |             |           |             |             |                    | Yes            |
| | **arguments**  |              |           |             |           |             |             |                    |                |
+------------------+--------------+-----------+-------------+-----------+-------------+-------------+--------------------+----------------+
| | **step**       |              |           |             |           | Yes         | Yes         | | Yes - using      | Yes            |
| | **publish**    |              |           |             |           |             |             | | branches_context |                |
+------------------+--------------+-----------+-------------+-----------+-------------+-------------+--------------------+----------------+
| | **step**       |              |           |             |           | Yes         | Yes         |                    |                |
| | **navigation** |              |           |             |           |             |             |                    |                |
+------------------+--------------+-----------+-------------+-----------+-------------+-------------+--------------------+----------------+
| | **action**     |              |           | Yes         |           |             |             |                    |                |
| | **inputs**     |              |           |             |           |             |             |                    |                |
+------------------+--------------+-----------+-------------+-----------+-------------+-------------+--------------------+----------------+

Keywords (A-Z)
==============

.. _branches_context:

branches_context
----------------

May appear in the `publish <#publish>`__ section of a `parallel
step <#parallel-step>`__.

As branches of a `parallel_loop <#parallel-loop>`__ complete, values that have
been output and the branch's result get placed as a dictionary into the
``branches_context`` list. The list is therefore in the order the
branches have completed.

A specific value can be accessed using the index representing its
branch's place in the finishing order and the name of the variable or the
`branch_result <#branch-result>`__ key.

**Example - retrieves the name variable from the first branch to finish**

.. code-block:: yaml

    publish:
      - first_name: ${branches_context[0]['name']}

More commonly, the ``branches_context`` is used to aggregate the values
that have been published by all of the branches.

**Example - aggregates name values into a list**

.. code-block:: yaml

    publish:
      - name_list: ${map(lambda x:str(x['name']), branches_context)}

.. _branch_result:

branch_result
-------------

May appear in the `publish <#publish>`__ section of a `parallel
step <#parallel-step>`__.

As branches of a `parallel_loop <#parallel-loop>`__ complete, branch results get
placed into the `branches_context <#branches-context>`__ list under the
``branch_result`` key.

**Example - aggregates branch results**

.. code-block:: yaml

    publish:
      - branch_results_list: ${map(lambda x:str(x['branch_result']), branches_context)}

.. _break:

break
-----

The key ``break`` is a property of a `loop <#loop>`__. It is mapped to a
list of results on which to break out of the loop or an empty list
(``[]``) to override the default breaking behavior for a list. When the
`operation <#operation>`__ or `subflow <#flow>`__ of the `iterative
step <#iterative-step>`__ returns a result in the break's list, the
iteration halts and the `iterative step's <#iterative-step>`__
`navigation <#navigate>`__ logic is run.

If the ``break`` property is not defined, the loop will break on results
of ``FAILURE`` by default. This behavior may be overriden so that
iteration will continue even when a result of ``FAILURE`` is returned by
defining alternate break behavior or mapping the ``break`` key to an
empty list (``[]``).

**Example - loop that breaks on result of CUSTOM**

.. code-block:: yaml

    loop:
      for: value in range(1,7)
      do:
        custom_op:
          - text: ${value}
      break:
        - CUSTOM
    navigate:
      - CUSTOM: print_end

**Example - loop that continues even on result of FAILURE**

.. code-block:: yaml

    loop:
      for: value in range(1,7)
      do:
        custom_op:
          - text: ${value}
      break: []

.. _class_name:

class_name
----------

The key ``class_name`` is a property of a `java_action <#java-action>`__. It is
mapped to the name of the Java class where an annotated @Action resides.

.. _default:

default
-------

The key ``default`` is a property of an `input <#inputs>`__ name. It is
mapped to an `expression <#expressions>`__ value.

The expression's value will be passed to the `flow <#flow>`__ or
`operation <#operation>`__ if no other value for that
`input <#inputs>`__ parameter is explicitly passed or if the input's
`private <#private>`__ parameter is set to ``true``.

**Example - default values**

.. code-block:: yaml

    inputs:
      - str_literal:
          default: "default value"
      - int_exp:
          default: ${5 + 6}
      - from_variable:
          default: ${variable_name}
      - from_system_property:
          default: $ { get_sp('system.property.key') }

A default value can also be defined inline by entering it as the value
to the `input <#inputs>`__ parameter's key.

**Example - inline default values**

.. code-block:: yaml

    inputs:
      - str_literal: "default value"
      - int_exp: ${5 + 6}
      - from_variable: ${variable_name}
      - from_system_property: $ { get_sp('system.property.key') }

.. _do:

do
--

The key ``do`` is a property of a `step <#step>`__ name, a
`loop <#loop>`__, or a `parallel_loop <#parallel-loop>`__. It is mapped to a
property that references an `operation <#operation>`__ or
`flow <#flow>`__.

Calls an `operation <#operation>`__ or `flow <#flow>`__ and passes in
relevant arguments.

The `operation <#operation>`__ or `flow <#flow>`__ may be called in
several ways:

-  by referencing the `operation <#operation>`__ or `flow <#flow>`__ by
   name when it is in the default namespace (the same namespace as the
   calling `flow <#flow>`__)
-  by using a fully qualified name, for example, ``path.to.operation.op_name``

   -  a path is recognized as a fully qualified name if the prefix
      (before the first ``.``) is not a defined alias

-  by using an alias defined in the flow's `imports <#imports>`__
   section followed by the `operation <#operation>`__ or
   `flow <#flow>`__ name (e.g ``alias_name.op_name``)
-  by using an alias defined in the flow's `imports <#imports>`__
   section followed by a continuation of the path to the
   `operation <#operation>`__ or `flow <#flow>`__ and its name (e.g
   ``alias_name.path.cont.op_name``)

For more information, see the :ref:`Operation Paths <example_operation_paths>`
example.

Arguments are passed to a `step <#step>`__ using a list of argument names and
optional mapped `expressions <#expressions>`__. The step must pass values for
all `inputs <#inputs>`__ found in the called `operation <#operation>`__ or
`subflow <#flow>`__ that are required and don't have a default value. Argument
names should be different than the `output <#outputs>`__ names found in the
`operation <#operation>`__ or `subflow <#flow>`__ being called in the step.

An argument name without an expression, or with a ``null`` value will take its
value from a variable with the same name in the flow context.
`Expression <#expressions>`__ values will supersede values bound to flow
`inputs <#inputs>`__ with the same name. To force the `operation <#operation>`__
or `subflow <#flow>`__ being called to use it's own default value, as opposed to
a value passed in via expression or the flow context, omit the variable from the
calling `step's <#step>`__ argument list.

For a list of which contexts are available in the arguments section of a
`step <#step>`__, see `Contexts <#contexts>`__.

**Example - call to a divide operation with list of mapped step arguments**

.. code-block:: yaml

    do:
      divide:
        - dividend: ${input1}
        - divisor: ${input2}

**Example - force an operation to use default value for punctuation input**

.. code-block:: yaml

    flow:
      name: flow

      inputs:
          - punctuation: "!"

      workflow:
        - step1:
            do:
              punc_printer:
                - text: "some text"
                #- punctuation
                #commenting out the above line forces the operation to use its default value (".")
                #leaving it in would cause the operation to take the value from the flow context ("!")

.. code-block:: yaml

    operation:
      name: operation
      inputs:
        - text
        - punctuation: "."
      python_action:
        script: |
          print text + punctuation

.. _extensions_tag:

extensions
----------

The key ``extensions`` is mapped to information that the compiler will ignore
and can therefore be used for various purposes.

**Example - a flow that contains an extensions section**

.. code-block:: yaml

    namespace: examples.extensions

    flow:
      name: flow_with_extensions_tag

      workflow:
        - noop_step:
          do:
            noop: []

    extensions:
      - some_key:
          a: b
          c: d
      - another

.. _flow:

flow
----

The key ``flow`` is mapped to the properties which make up the flow
contents.

A flow is the basic executable unit of CloudSlang. A flow can run on its
own or it can be used by another flow in the `do <#do>`__ property of a
`step <#step>`__.

+--------------+----------+------------------+----------------+---------------------+--------------------------+
| Property     | Required | Default          | Value Type     | Description         | More Info                |
+==============+==========+==================+================+=====================+==========================+
| ``name``     | yes      | --               | string         | name of the flow    | `name <#name>`__         |
+--------------+----------+------------------+----------------+---------------------+--------------------------+
| ``inputs``   | no       | --               | list           | inputs for the flow | `inputs <#inputs>`__     |
+--------------+----------+------------------+----------------+---------------------+--------------------------+
| ``workflow`` | yes      | --               | list of steps  | | container for     | `workflow <#workflow>`__ |
|              |          |                  |                | | workflow steps    |                          |
+--------------+----------+------------------+----------------+---------------------+--------------------------+
| ``outputs``  | no       | --               | list           | list of outputs     | `outputs <#outputs>`__   |
+--------------+----------+------------------+----------------+---------------------+--------------------------+
| ``results``  | no       | | (``SUCCESS`` / | list           | | possible results  | `results <#results>`__   |
|              |          | | ``FAILURE`` )  |                | | of the flow       |                          |
+--------------+----------+------------------+----------------+---------------------+--------------------------+

**Example - a flow that performs a division of two numbers**

.. code-block:: yaml

    flow:
      name: division

      inputs:
        - input1
        - input2

      workflow:
        - divider:
            do:
              divide:
                - dividend: ${input1}
                - divisor: ${input2}
            publish:
              - answer: ${quotient}
            navigate:
              - ILLEGAL: ILLEGAL
              - SUCCESS: printer
        - printer:
            do:
              print:
                - text: ${input1 + "/" + input2 + " = " + answer}
            navigate:
              - SUCCESS: SUCCESS

      outputs:
        - quotient: ${answer}

      results:
        - ILLEGAL
        - SUCCESS

.. _for:

for
---

The key ``for`` is a property of a `loop <#loop>`__ or an
`parallel_loop <#parallel-loop>`__.

loop: for
~~~~~~~~~

A for loop iterates through a `list <#iterating-through-a-list>`__ or a
`map <#iterating-through-a-map>`__.

The `iterative step <#iterative-step>`__ will run once for each element
in the list or key in the map.

Iterating through a list
^^^^^^^^^^^^^^^^^^^^^^^^

When iterating through a list, the ``for`` key is mapped to an iteration
variable followed by ``in`` followed by a list, an expression that
evaluates to a list, or a comma delimited string.

**Example - loop that iterates through the values in a list**

.. code-block:: yaml

    - print_values:
        loop:
          for: value in [1,2,3]
          do:
            print:
              - text: ${value}

**Example - loop that iterates through the values in a comma delimited
string**

.. code-block:: yaml

    - print_values:
        loop:
          for: value in "1,2,3"
          do:
            print:
              - text: ${value}

**Example - loop that iterates through the values returned from an
expression**

.. code-block:: yaml

    - print_values:
        loop:
          for: value in range(1,4)
          do:
            print:
              - text: ${value}

Iterating through a map
^^^^^^^^^^^^^^^^^^^^^^^

When iterating through a map, the ``for`` key is mapped to iteration
variables for the key and value followed by ``in`` followed by a map or
an expression that evaluates to a map.

**Example - step that iterates through the values returned from an
expression**

.. code-block:: yaml

    - print_values:
        loop:
          for: k, v in map
          do:
            print2:
              - text1: ${k}
              - text2: ${v}

parallel_loop: for
~~~~~~~~~~~~~~~~~~

A parallel for loop loops in parallel branches over the items in a list.

The `parallel step <#parallel-step>`__ will run one branch for
each element in the list.

The ``for`` key is mapped to an iteration variable followed by ``in``
followed by a list or an expression that evaluates to a list.

**Example - step that loops in parallel through the values in a list**

.. code-block:: yaml

    - print_values:
        parallel_loop:
          for: value in values_list
          do:
            print_branch:
              - ID: ${value}

.. _imports:

imports
-------

The key ``imports`` is mapped to the files to import as follows:

-  key - alias
-  value - namespace of file to be imported

Specifies the file's dependencies, `operations <#operation>`__ and
`subflows <#flow>`__, by the namespace defined in their source file and the
aliases they will be referenced by in the file.

Using an alias is one way to reference the
`operations <#operation>`__ and `subflows <#flow>`__ used in a
`flow's <#flow>`__ `steps <#step>`__. For all the ways to reference
`operations <#operation>`__ and `subflows <#flow>`__ used in a
`flow's <#flow>`__ `steps <#step>`__, see the `do <#do>`__ keyword and the
:ref:`Operation Paths example <example_operation_paths>`.

**Example - import operations and sublflow into flow**

.. code-block:: yaml

    imports:
      ops: examples.utils
      subs: examples.subflows

    flow:
      name: hello_flow

      workflow:
        - print_hi:
            do:
              ops.print:
                - text: "Hi"
        - run_subflow:
            do:
              subs.division:
                - input1: "5"
                - input2: "3"

In this example, the ``ops`` alias refers to the ```examples.utils`` namespace.
This alias is used in the ``print_hi`` step to refer to the ``print`` operation,
whose source file defines its namespace as ``examples.utils``. Similarly, the
``subs`` alias refers to the ``examples.subflows`` namespace. The ``subs`` alias
is used in the ``run_subflow`` step to refer to the ``division`` subflow, whose
source file defines its namespace as ``examples.subflows``.

.. _inputs:

inputs
------

The key ``inputs`` is a property of a `flow <#flow>`__ or
`operation <#operation>`__. It is mapped to a list of input names. Each
input name may in turn be mapped to its properties or an input
`expression <#expressions>`__.

Inputs are used to pass parameters to `flows <#flow>`__ or
`operations <#operation>`__. Input names for a specific `flow <#flow>`__ or
`operation <#operation>`__ must be different than the `output <#outputs>`__
names of the same `flow <#flow>`__ or `operation <#operation>`__.

For a list of which contexts are available in the ``inputs`` section of a
`flow <#flow>`__ or `operation <#operation>`__, see `Contexts <#contexts>`__.

+--------------+----------+---------+-------------+-----------------------------+--------------------------+
| Property     | Required | Default | Value Type  | Description                 | More info                |
+==============+==========+=========+=============+=============================+==========================+
| ``required`` | no       | true    | boolean     | is the input required       | `required <#required>`__ |
+--------------+----------+---------+-------------+-----------------------------+--------------------------+
| ``default``  | no       | --      | expression  | default value of the input  | `default <#default>`__   |
+--------------+----------+---------+-------------+-----------------------------+--------------------------+
| ``private``  | no       | false   | boolean     | | if true, the default      | `private <#private>`__   |
|              |          |         |             | | value always overrides    |                          |
|              |          |         |             | | values passed in          |                          |
+--------------+----------+---------+-------------+-----------------------------+--------------------------+

**Example - several inputs**

.. code-block:: yaml

    inputs:
      - input1:
          default: "default value"
          private: true
      - input2
      - input3: "default value"
      - input4: ${'var1 is ' + var1}

.. _java_action:

java_action
-----------

The key ``java_action`` is a property of an `operation <#operation>`__. It is
mapped to the properties `class_name <#class-name>`__ and
`method_name <#method-name>`__ that define the class and method where an
annotated Java @Action resides.

**Example - CloudSlang call to a Java action**

.. code-block:: yaml

    namespace: io.cloudslang.base.mail

    operation:
      name: send_mail

      inputs:
        - hostname
        - port
        - from
        - to
        - subject
        - body

      java_action:
        class_name: io.cloudslang.content.mail.actions.SendMailAction
        method_name: execute

      results:
        - SUCCESS: ${ returnCode == '0' }
        - FAILURE

Existing Java Actions
~~~~~~~~~~~~~~~~~~~~~

There are many existing Java actions which are bundled with the
:doc:`CloudSlang CLI <cloudslang_cli>`. The source code for these Java actions
can be found in the
`score-actions <https://github.com/CloudSlang/score-actions>`__ repository.

Adding a New Java Action
~~~~~~~~~~~~~~~~~~~~~~~~

To add a new Java action:

  - `Write an annotated Java method <#write-an-annotated-java-method>`__
  - `Package the method in a Jar <#package-the-method-in-a-jar>`__
  - `Add the Jar to the lib folder in the CLI <#add-the-jar-to-the-lib-folder-in-the-cli>`__

Write an Annotated Java Method
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create a Java method that conforms to the signature
``public Map<String, String> doSomething(paramaters)`` and use the following
annotations from ``com.hp.oo.sdk.content.annotations``:

   -  @Action: specifies action information

        - name: name of the action
        - outputs: array of ``@Output`` annotations
        - responses: array of ``@Response`` annotations

   -  @Output: action output name
   -  @Response: action response

        - text: name of the response
        - field: result to be checked
        - value: value to check against
        - matchType: type of check
        - responseType: type of response
        - isDefault: whether or not response is the default response
        - isOnFail: whether or not response is the failure response

   -  @Param: action parameter

        - value: name of the parameter
        - required: whether or not the parameter is required

Values are passed to a Java action from an operation using CloudSlang inputs
that match the annotated parameters.

Values are passed back from the Java action to an operation using the returned
``Map<String, String>``, where the map's elements each correspond to a name:value
that matches a CloudSlang output.

**Example - Java action**

.. code-block:: java

    package com.example.content.actions;

    import com.hp.oo.sdk.content.annotations.Action;
    import com.hp.oo.sdk.content.annotations.Output;
    import com.hp.oo.sdk.content.annotations.Param;
    import com.hp.oo.sdk.content.annotations.Response;
    import com.hp.oo.sdk.content.plugin.ActionMetadata.MatchType;

    import java.util.Map;
    import java.util.HashMap;

    public class SaySomething {

          @Action(name = "Example Test Action",
                  outputs = {
                          @Output("message")
                  },
                  responses = {
                          @Response(text = "success", field = "message", value = "fail", matchType = MatchType.COMPARE_NOT_EQUAL),
                          @Response(text = "failure", field = "message", value = "fail", matchType = MatchType.COMPARE_EQUAL, isDefault = true, isOnFail = true)
                  }
          )
          public Map<String, String> speak(@Param(value = "text", required = true) String text) {
              Map<String, String> results = new HashMap<>();

              System.out.println("I say " + text);

              results.put("message", text);

              return  results;
          }
    }

Package the Method in a Jar
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use Maven to package the class containing the Java action method. Below is an
example **pom.xml** file that can be used for your Maven project.

**Example - sample pom.xml**

.. code-block:: xml

    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>com.example.content</groupId>
        <artifactId>action-example</artifactId>
        <version>0.0.1-SNAPSHOT</version>
        <packaging>jar</packaging>
        <name>${project.groupId}:${project.artifactId}</name>
        <description>Test Java action</description>
        <dependencies>
            <dependency>
                <groupId>com.hp.score.sdk</groupId>
                <artifactId>score-content-sdk</artifactId>
                <version>1.10.6</version>
            </dependency>
        </dependencies>
        <build>
            <plugins>
                <plugin>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <version>3.1</version>
                    <configuration>
                        <source>1.7</source>
                        <target>1.7</target>
                    </configuration>
                </plugin>
            </plugins>
        </build>
    </project>

Add the Jar to the lib Folder in the CLI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Place the Jar created by Maven in the **cslang/lib** folder and restart the CLI.
You can now call the Java action from a CloudSlang operation as explained
`above <#java-action>`__.

.. _loop:

loop
----

The key ``loop`` is a property of an `iterative
step's <#iterative-step>`__ name. It is mapped to the `iterative
step's <#iterative-step>`__ properties.

For each value in the loop's list the ``do`` will run an
`operation <#operation>`__ or `subflow <#flow>`__. If the returned
result is in the ``break`` list, or if ``break`` does not appear and the
returned result is ``FAILURE``, or if the list has been exhausted, the
step's navigation will run.

+-------------+----------+---------+--------------------------------+-----------------------------------------------+------------------------------+
| Property    | Required | Default | Value Type                     | Description                                   | More Info                    |
+=============+==========+=========+================================+===============================================+==============================+
| ``for``     | yes      | --      | variable ``in`` list           | iteration logic                               | `for <#for>`__               |
|             |          |         |                                |                                               |                              |
|             |          |         |                                |                                               |                              |
+-------------+----------+---------+--------------------------------+-----------------------------------------------+------------------------------+
| ``do``      | yes      | --      | | operation or                 | | the operation or                            | | `do <#do>`__               |
|             |          |         | | subflow call                 | | subflow this step                           | | `operation <#operation>`__ |
|             |          |         |                                | | will run iteratively                        | | `flow <#flow>`__           |
+-------------+----------+---------+--------------------------------+-----------------------------------------------+------------------------------+
| ``publish`` | no       | --      | | list of                      | | operation or subflow                        | | `publish <#publish>`__     |
|             |          |         | | key:value pairs              | | outputs to aggregate and                    | | `outputs <#outputs>`__     |
|             |          |         |                                | | publish to the flow level                   |                              |
+-------------+----------+---------+--------------------------------+-----------------------------------------------+------------------------------+
| ``break``   | no       | --      | list of `results <#results>`__ | | operation or subflow                        | `break <#break>`__           |
|             |          |         |                                | | `results <#results>`__ on which to          |                              |
|             |          |         |                                | | break out of the loop                       |                              |
+-------------+----------+---------+--------------------------------+-----------------------------------------------+------------------------------+

**Example: loop that breaks on a result of custom**

.. code-block:: yaml

     - custom3:
         loop:
           for: value in "1,2,3,4,5"
           do:
             custom3:
               - text: ${value}
           break:
             - CUSTOM
         navigate:
           - CUSTOM: aggregate
           - SUCCESS: skip_this

.. _method_name:

method_name
-----------

The key ``method_name`` is a property of a `java_action <#java-action>`__. It is
mapped to the name of the Java method where an annotated @Action resides.

.. _name:

name
----

The key ``name`` is a property of `flow <#flow>`__ and
`operation <#operation>`__. It is mapped to a value that is used as the
name of the `flow <#flow>`__ or `operation <#operation>`__.

The name of a `flow <#flow>`__ or `operation <#operation>`__ may be used
when called from a `flow <#flow>`__'s `step <#step>`__.

The name of a `flow <#flow>`__ or `operation <#operation>`__ must match the name
of the file in which it resides, excluding the extension.

**Example - naming the flow found in the file** ``division_flow.sl``

.. code-block:: yaml

    name: division_flow

.. _namespace:

namespace
---------

The key ``namespace`` is mapped to a string value that defines the
file's namespace.

The namespace of a file may be used by a flow to `import <#imports>`__
dependencies.

**Example - definition a namespace**

.. code-block:: yaml

    namespace: examples.hello_world

**Example - using a namespace in an imports definition**

.. code-block:: yaml

    imports:
      ops: examples.hello_world

For more information about choosing a file's namespace, see the
:ref:`CloudSlang Content Best Practices <cloudslang_content_best_practices>`
section.

.. note::

   If the imported file resides in a folder that is different
   from the folder in which the importing file resides, the imported file's
   directory must be added using the ``--cp`` flag when running from the
   CLI (see :ref:`Run with Dependencies <run_with_dependencies>`).

.. _navigate:

navigate
--------

The key ``navigate`` is a property of a `step <#step>`__ name. It is
mapped to a list of key:value pairs where the key is the received
`result <#results>`__ and the value is the target `step <#step>`__,
`flow <#flow>`__ `result <#results>`__ or ``on_failure``.

Defines the navigation logic for a `standard step <#standard-step>`__,
an `iterative step <#iterative-step>`__ or a `parallel
step <#parallel-step>`__. The flow will continue with the
`step <#step>`__ or `flow <#flow>`__ `result <#results>`__ whose value
is mapped to the `result <#results>`__ returned by the called
`operation <#operation>`__ or `subflow <#flow>`__.

By default, if no ``navigate`` section navigation is present, the flow continues
with the next `step <#step>`__ or navigates to the ``SUCCESS`` result of the
flow if the `step <#step>`__ is the final non-on_failure step. By default the
`on_failure <#on-failure>`__ `step <#step>`__ navigates to the ``FAILURE``
result of the flow. For more information, see the
:ref:`Default Navigation <example_default_navigation>` example.

All possible `results <#results>`__ returned by the
called `operation <#operation>`__ or `subflow <#flow>`__ must be handled.

For a `standard step <#standard-step>`__ the navigation logic runs when
the `step <#step>`__ is completed.

For an `iterative step <#iterative-step>`__ the navigation logic runs
when the last iteration of the `step <#step>`__ is completed or after
exiting the iteration due to a `break <#break>`__.

For a `parallel step <#parallel-step>`__ the navigation logic
runs after the last branch has completed. If any of the branches
returned a `result <#results>`__ of ``FAILURE``, the `flow <#flow>`__
will navigate to the `step <#step>`__ or `flow <#flow>`__
`result <#results>`__ mapped to ``FAILURE``. Otherwise, the
`flow <#flow>`__ will navigate to the `step <#step>`__ or
`flow <#flow>`__ `result <#results>`__ mapped to ``SUCCESS``. Note that
the only `results <#results>`__ of an `operation <#operation>`__ or
`subflow <#flow>`__ called in a `parallel_loop <#parallel-loop>`__ that are
evaluated are ``SUCCESS`` and ``FAILURE``. Any other results will be
evaluated as ``SUCCESS``.

For a list of which contexts are available in the ``navigate`` section of a
`step <#step>`__, see `Contexts <#contexts>`__.

**Example - ILLEGAL result will navigate to flow's FAILURE result and
SUCCESS result will navigate to step named *printer***

.. code-block:: yaml

    navigate:
      - SUCCESS: printer
      - ILLEGAL: ILLEGAL
      - FAILURE: on_failure

.. _on_failure:

on_failure
-----------

The key ``on_failure`` is a property of a `workflow <#workflow>`__. It
is mapped to a `step <#step>`__.

Defines the `step <#step>`__, which when using default
`navigation <#navigate>`__, is the target of a ``FAILURE``
`result <#results>`__ returned from an `operation <#operation>`__ or
`flow <#flow>`__. The ``on_failure`` `step's <#step>`__
`navigation <#navigate>`__ defaults to ``FAILURE``.

**Example - failure step which call a print operation to print an error
message**

.. code-block:: yaml

    - on_failure:
      - failure:
          do:
            print:
              - text: ${error_msg}

.. _operation:

operation
---------

The key ``operation`` is mapped to the properties which make up the
operation contents.

+-------------------+----------+-------------+----------------+----------------------+------------------------------------+
| Property          | Required | Default     | Value Type     | Description          | More Info                          |
+===================+==========+=============+================+======================+====================================+
| ``name``          | yes      | --          | string         | | name of the        | `name <#name>`__                   |
|                   |          |             |                | | operation          |                                    |
+-------------------+----------+-------------+----------------+----------------------+------------------------------------+
| ``inputs``        | no       | --          | list           | operation inputs     | `inputs <#inputs>`__               |
+-------------------+----------+-------------+----------------+----------------------+------------------------------------+
| ``python_action`` | no       | --          | ``script`` key | operation logic      | `python_action <#python-action>`__ |
+-------------------+----------+-------------+----------------+----------------------+------------------------------------+
| ``java_action``   |          |             | map            | operation logic      | `java_action <#java-action>`__     |
+-------------------+----------+-------------+----------------+----------------------+------------------------------------+
| ``outputs``       | no       | --          | list           | operation outputs    | `outputs <#outputs>`__             |
+-------------------+----------+-------------+----------------+----------------------+------------------------------------+
| ``results``       | no       | ``SUCCESS`` | list           | | possible operation | `results <#results>`__             |
|                   |          |             |                | | results            |                                    |
+-------------------+----------+-------------+----------------+----------------------+------------------------------------+

**Example - operation that adds two inputs and outputs the answer**

.. code-block:: yaml

    name: add

    inputs:
      - left
      - right

    python_action:
      script: ans = left + right

    outputs:
      - out: ${ans}

    results:
      - SUCCESS

.. _outputs:

outputs
-------

The key ``outputs`` is a property of a `flow <#flow>`__ or
`operation <#operation>`__. It is mapped to a list of output variable
names which may also contain `expression <#expressions>`__ values.
Output `expressions <#expressions>`__ must evaluate to strings.

Defines the parameters a `flow <#flow>`__ or `operation <#operation>`__
exposes to possible `publication <#publish>`__ by a `step <#step>`__.
The calling `step <#step>`__ refers to an output by its name.

Output names for a specific `flow <#flow>`__ or `operation <#operation>`__ must
be different than the `input <#inputs>`__ names of the same `flow <#flow>`__ or
`operation <#operation>`__.

For a list of which contexts are available in the ``outputs`` section of a
`flow <#flow>`__ or `operation <#operation>`__, see `Contexts <#contexts>`__.

**Example - various types of outputs**

.. code-block:: yaml

    outputs:
      - existing_variable
      - output2: ${some_variable}
      - output3: ${5 + 6}

.. _parallel_loop_tag:

parallel_loop
-------------

The key ``parallel_loop`` is a property of a `parallel
step's <#parallel-step>`__ name. It is mapped to the `parallel
step's <#parallel-step>`__ properties.

For each value in the loop's list a branch is created and the ``do``
will run an `operation <#operation>`__ or `subflow <#flow>`__. When all
the branches have finished, the `parallel
step's <#parallel-step>`__ `publish <#publish>`__ and
`navigation <#navigate>`__ will run.

+-------------+----------+---------+-------------------+---------------------------------+------------------------------+
| Property    | Required | Default | Value Type        | Description                     | More Info                    |
+=============+==========+=========+===================+=================================+==============================+
| ``for``     | yes      | --      | | variable ``in`` | loop values                     | `for <#for>`__               |
|             |          |         | | list            |                                 |                              |
+-------------+----------+---------+-------------------+---------------------------------+------------------------------+
| ``do``      | yes      | --      | | operation or    | | operation or subflow          | | `do <#do>`__               |
|             |          |         | | subflow call    | | this step will                | | `operation <#operation>`__ |
|             |          |         |                   | | run in parallel               | |                            |
+-------------+----------+---------+-------------------+---------------------------------+------------------------------+

**Example: loop that breaks on a result of custom**

.. code-block:: yaml

     - print_values:
         parallel_loop:
           for: value in values
           do:
             print_branch:
               - ID: ${value}
         publish:
             - name_list: ${map(lambda x:str(x['name']), branches_context)}
         navigate:
             - SUCCESS: print_list
             - FAILURE: FAILURE

.. _private:

private
-------

The key ``private`` is a property of an `input <#inputs>`__ name. It
is mapped to a boolean value.

A value of ``true`` will ensure that the `input <#inputs>`__
parameter's `default <#default>`__ value will not be overridden by
values passed into the `flow <#flow>`__ or `operation <#operation>`__. An
`input <#inputs>`__ set as ``private: true`` must also declare a
`default <#default>`__ value. If ``private`` is not defined, values passed
in will override the `default <#default>`__ value.

**Example - default value of text input parameter will not be overridden by values passed in**

.. code-block:: yaml

    inputs:
      - text:
          default: "default text"
          private: true

.. _properties:

properties
----------

The key ``properties`` is mapped to a list of ``key:value`` pairs that define
one or more system properties.

System property names (keys) can contain alphanumeric characters (A-Za-z0-9),
underscores (_) and hyphens (-).

System property values are retrieved using the `get_sp() <#get-sp>`__ function.

.. note::

   System property values that are non-string types (numeric, list, map,
   etc.) are converted to string representations. A system property may have a
   value of ``null``.

**Example - system properties file**

.. code-block:: yaml

    namespace: examples.sysprops

    properties:
      - host: 'localhost'
      - port: 8080

An empty system properties file can be defined using an empty list.

**Example - empty system properties file**

.. code-block:: yaml

     namespace: examples.sysprops

     properties: []

.. _publish:

publish
-------

The key ``publish`` is a property of a `step <#step>`__ name, a
`loop <#loop>`__ or a `parallel_loop <#parallel-loop>`__. It is mapped to a
list of key:value pairs where the key is the published variable name and
the value is an `expression <#expressions>`__, usually involving an `output <#outputs>`__ received
from an `operation <#operation>`__ or `flow <#flow>`__.

For a list of which contexts are available in the ``publish`` section of a
`step <#step>`__, see `Contexts <#contexts>`__.

Standard publish
~~~~~~~~~~~~~~~~

In a `standard step <#standard-step>`__, ``publish`` binds an
`expression <#expressions>`__, usually involving an
`output <#outputs>`__ from an `operation <#operation>`__ or
`flow <#flow>`__, to a variable whose scope is the current
`flow <#flow>`__ and can therefore be used by other `steps <#step>`__ or
as the `flow's <#flow>`__ own `output <#outputs>`__.

**Example - publish the quotient output as ans**

.. code-block:: yaml

    - division1:
        do:
          division:
            - input1: ${dividend1}
            - input2: ${divisor1}
        publish:
          - ans: ${quotient}

Iterative publish
~~~~~~~~~~~~~~~~~

In an `iterative step <#iterative-step>`__ the publish mechanism is run
during each iteration after the `operation <#operation>`__ or
`subflow <#flow>`__ has completed, therefore allowing for aggregation.

**Example - publishing in an iterative step to aggregate output: add the squares of values in a range**

.. code-block:: yaml

    - aggregate:
        loop:
          for: value in range(1,6)
          do:
            square:
              - to_square: ${value}
              - sum
          publish:
            - sum: ${sum + squared}

Parallel publish
~~~~~~~~~~~~~~~~

In a `parallel step <#parallel-step>`__ the publish mechanism defines the
step's aggregation logic, generally making use of the
`branches_context <#branches-context>`__ construct.

After all branches of a `parallel step <#parallel-step>`__ have
completed, execution of the flow continues with the ``publish`` section. The
expression of each name:value pair is evaluated and published to the
`flow's <#flow>`__ scope. The expression generally makes use of the
`branches_context <#branches-context>`__ construct to access the values
published by each of the `parallel loop's <#parallel_loop>`__ branches and their
results using the `branch_result <#branch-result>`__ key.

For a list of which contexts are available in the ``publish`` section of a
`step <#step>`__, see `Contexts <#contexts>`__.

For more information, see the :ref:`Parallel Loop <example_parallel_loop>`
example.

**Example - publishing in an parallel step to aggregate output**

.. code-block:: yaml

    - print_values:
        parallel_loop:
          for: value in values_list
          do:
            print_branch:
              - ID: ${value}
        publish:
            - name_list: ${map(lambda x:str(x['name']), branches_context)}

**Example - extracting information from a specific branch**

.. code-block:: yaml

    - print_values:
        parallel_loop:
          for: value in values_list
          do:
            print_branch:
              - ID: ${value}
        publish:
            - first_name: ${branches_context[0]['name']}

**Example - create a list of branch results**

.. code-block:: yaml

    - print_values:
        parallel_loop:
          for: value in values
          do:
            print_branch:
              - ID: ${ value }
        publish:
          - branch_results_list: ${map(lambda x:str(x['branch_result']), branches_context)}

.. _python_action:

python_action
-------------

The key ``python_action`` is a property of an `operation <#operation>`__. It is
mapped to a `script <#script>`__ property that contains the actual Python script.

.. _results:

results
-------

The key ``results`` is a property of a `flow <#flow>`__ or
`operation <#operation>`__.

The results of a `flow <#flow>`__ or `operation <#operation>`__ can be
used by the calling `step <#step>`__ for `navigation <#navigate>`__
purposes.

.. note::

   The only results of an `operation <#operation>`__ or
   `subflow <#flow>`__ called in a `parallel_loop <#parallel-loop>`__ that are
   evaluated are ``SUCCESS`` and ``FAILURE``. Any other results will be
   evaluated as ``SUCCESS``.

Flow results
~~~~~~~~~~~~

In a `flow <#flow>`__, the key ``results`` is mapped to a list of result
names.

Defines the possible results of the `flow <#flow>`__. By default a
`flow <#flow>`__ has two results, ``SUCCESS`` and ``FAILURE``. The
defaults can be overridden with any number of user-defined results.

When overriding, the defaults are lost and must be redefined if they are
to be used.

All result possibilities must be listed. When being used as a subflow
all `flow <#flow>`__ results must be handled by the calling
`step <#step>`__.

**Example - a user-defined result**

.. code-block:: yaml

    results:
      - SUCCESS
      - ILLEGAL
      - FAILURE

Operation results
~~~~~~~~~~~~~~~~~

In an `operation <#operation>`__ the key ``results`` is mapped to a list
of key:value pairs of result names and boolean `expressions <#expressions>`__.

Defines the possible results of the `operation <#operation>`__. By
default, if no results exist, the result is ``SUCCESS``. The first
result in the list whose expression evaluates to true, or does not have
an expression at all, will be passed back to the calling
`step <#step>`__ to be used for `navigation <#navigate>`__ purposes.

All `operation <#operation>`__ results must be handled by the calling
`step <#step>`__.

For a list of which contexts are available in the ``results`` section of an
`operation <#operation>`__, see `Contexts <#contexts>`__.

**Example - three user-defined results**

.. code-block:: yaml

    results:
      - POSITIVE: ${polarity == '+'}
      - NEGATIVE: ${polarity == '-'}
      - NEUTRAL

.. _required:

required
--------

The key ``required`` is a property of an `input <#inputs>`__ name. It is
mapped to a boolean value.

A value of ``false`` will allow the `flow <#flow>`__ or
`operation <#operation>`__ to be called without passing the
`input <#inputs>`__ parameter. If ``required`` is not defined, the
`input <#inputs>`__ parameter defaults to being required. Required inputs must
receive a value or declare a `default <#default>`__ value.

**Example - input2 is optional**

.. code-block:: yaml

    inputs:
      - input1
      - input2:
          required: false

.. _script:

script
------

The key ``script`` is a property of `python_action <#python-action>`__.
It is mapped to a value containing a Python script.

All variables in scope at the conclusion of the Python script must be
serializable. If non-serializable variables are used, remove them from
scope by using the ``del`` keyword before the script exits.

.. note::

   CloudSlang uses the `Jython <http://www.jython.org/>`__
   implementation of Python 2.7. For information on Jython's limitations,
   see the `Jython FAQ <https://wiki.python.org/jython/JythonFaq>`__.

**Example - action with Python script that divides two numbers**

.. code-block:: yaml

    name: divide

    inputs:
      - dividend
      - divisor

    python_action:
      script: |
        if divisor == '0':
          quotient = 'division by zero error'
        else:
          quotient = float(dividend) / float(divisor)

    outputs:
      - quotient

    results:
      - ILLEGAL: ${quotient == 'division by zero error'}
      - SUCCESS

.. note::

   Single-line Python scripts can be written inline with the
   ``script`` key. Multi-line Python scripts can use the YAML pipe
   (``|``) indicator as in the example above.

Importing External Python Packages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are three approaches to importing and using external Python
modules:

-  Installing packages into the **python-lib** folder
-  Editing the executable file
-  Adding the package location to ``sys.path``

Installing Packages into the python-lib Folder
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Prerequisites:  Python 2.7 and pip.

You can download Python (version 2.7) from `here <https://www.python.org/>`__.
Python 2.7.9 and later include pip by default. If you already have Python but
don't have pip, see the pip
`documentation <https://pip.pypa.io/en/latest/installing.html>`__ for
installation instructions.

1. Edit the **requirements.txt** file in the **python-lib** folder,
   which is found at the same level as the **bin** folder that contains
   the CLI executable.

   -  If not using a pre-built CLI, you may have to create the
      **python-lib** folder and **requirements.txt** file.

2. Enter the Python package and all its dependencies in the requirements
   file.

   -  See the **pip**
      `documentation <https://pip.pypa.io/en/latest/user_guide.html#requirements-files>`__
      for information on how to format the requirements file (see
      example below).

3. Run the following command from inside the **python-lib** folder:
   ``pip install -r requirements.txt -t``.

   .. note::

      If your machine is behind a proxy you will need to specify
      the proxy using pip's ``--proxy`` flag.

4. Import the package as you normally would in Python from within the
   action's ``script``:

.. code-block:: yaml

    python_action:
      script: |
        from pyfiglet import Figlet
        f = Figlet(font='slant')
        print f.renderText(text)

**Example - requirements file**

::

        pyfiglet == 0.7.2
        setuptools

.. note::

   If you have defined a ``JYTHONPATH`` environment variable, you
   will need to add the **python-lib** folder's path to its value.

Editing the Executable File
^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Open the executable found in the **bin** folder for editing.
2. Change the ``Dpython.path`` key's value to the desired path.
3. Import the package as you normally would in Python from within the
   action's ``script``.

Adding the Package Location to sys.path
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. In the action's Pyton script, import the ``sys`` module.
2. Use ``sys.path.append()`` to add the path to the desired module.
3. Import the module and use it.

**Example - takes path as input parameter, adds it to sys.path and
imports desired module**

.. code-block:: yaml

    inputs:
      - path
    python_action:
      script: |
        import sys
        sys.path.append(path)
        import module_to_import
        print module_to_import.something()

Importing Python Scripts
~~~~~~~~~~~~~~~~~~~~~~~~

To import a Python script in a ``python_action``:

1. Add the Python script to the **python-lib** folder, which is found at
   the same level as the **bin** folder that contains the CLI
   executable.
2. Import the script as you normally would in Python from within the
   action's ``script``.

.. note::

   If you have defined a ``JYTHONPATH`` environment variable, you
   will need to add the **python-lib** folder's path to its value.

.. _step:

step
----

A name of a step which is a property of `workflow <#workflow>`__ or
`on_failure <#on-failure>`__.

Every step which is not an `on_failure <#on-failure>`__ step must be reachable
from another step.

There are several types of steps:

-  `standard <#standard-step>`__
-  `iterative <#iterative-step>`__
-  `parallel <#parallel-step>`__

**Example - step with two inputs, one of which contains a default value**

.. code-block:: yaml

    - divider:
        do:
          some_op:
            - host
            - port: 25

Standard Step
~~~~~~~~~~~~~

A standard step calls an `operation <#operation>`__ or
`subflow <#flow>`__ once.

The step name is mapped to the step's properties.

+--------------+----------+---------------------------+--------------+---------------------+---------------------------------------------+
| Property     | Required | Default                   | Value Type   | Description         | More Info                                   |
+==============+==========+===========================+==============+=====================+=============================================+
| ``do``       | yes      | --                        | | operation  | | the operation or  | | `do <#do>`__                              |
|              |          |                           | | or subflow | | subflow this step | | `flow <#flow>`__                          |
|              |          |                           | | call       | | will run          | | `operation <#operation>`__                |
+--------------+----------+---------------------------+--------------+---------------------+---------------------------------------------+
| ``publish``  | no       | --                        | | list of    | | operation outputs | | `publish <#publish>`__,                   |
|              |          |                           | | key:value  | | to publish to the | | `outputs <#outputs>`__                    |
|              |          |                           | | pairs      | |  flow level       |                                             |
+--------------+----------+---------------------------+--------------+---------------------+---------------------------------------------+
| ``navigate`` | no       | | ``FAILURE``: on_failure | | list of    | | navigation logic  | | `navigation <#navigate>`__                |
|              |          | | or flow finish          | | key:value  | | from operation or | | `results <#results>`__                    |
|              |          | | ``SUCCESS``: next step  | | pairs      | | flow results      |                                             |
+--------------+----------+---------------------------+--------------+---------------------+---------------------------------------------+

**Example - step that performs a division of two inputs, publishes the
answer and navigates accordingly**

.. code-block:: yaml

    - divider:
        do:
          divide:
            - dividend: ${input1}
            - divisor: ${input2}
        publish:
          - answer: ${quotient}
        navigate:
          - ILLEGAL: FAILURE
          - SUCCESS: printer

Iterative Step
~~~~~~~~~~~~~~

An iterative step calls an `operation <#operation>`__ or
`subflow <#flow>`__ iteratively, for each value in a list.

The step name is mapped to the iterative step's properties.

+--------------+----------+---------------------------+-------------+------------------------------------+------------------------------+
| Property     | Required | Default                   | Value Type  | Description                        | More Info                    |
+==============+==========+===========================+=============+====================================+==============================+
| ``loop``     | yes      | --                        | key         | | container for                    | `for <#for>`__               |
|              |          |                           |             | | loop properties                  |                              |
+--------------+----------+---------------------------+-------------+------------------------------------+------------------------------+
| ``navigate`` | no       | | ``FAILURE``:            | | key:value | | navigation logic from            | | `navigation <#navigate>`__ |
|              |          | | on_failure              | | pairs     | | `break <#break>`__ or the result | | `results <#results>`__     |
|              |          | | or flow finish          |             | | of the last iteration of         |                              |
|              |          | | ``SUCCESS``:            |             | | the operation or flow            |                              |
|              |          | | next step               |             |                                    |                              |
+--------------+----------+---------------------------+-------------+------------------------------------+------------------------------+

**Example - step prints all the values in value_list and then navigates
to a step named "another_step"**

.. code-block:: yaml

    - print_values:
        loop:
          for: value in value_list
          do:
            print:
              - text: ${value}
        navigate:
          - SUCCESS: another_step
          - FAILURE: FAILURE

Parallel Step
~~~~~~~~~~~~~

A parallel step calls an `operation <#operation>`__ or
`subflow <#flow>`__ in parallel branches, for each value
in a list.

The step name is mapped to the parallel step's properties.

+-------------------+----------+---------------------------+--------------+-----------------------+----------------------------------+
| Property          | Required | Default                   | Value Type   | Description           | More Info                        |
+===================+==========+===========================+==============+=======================+==================================+
| ``parallel_loop`` | yes      | --                        | key          | | container for       | `parallel_loop <#parallel-loop>`_|
|                   |          |                           |              | | parallel loop       |                                  |
|                   |          |                           |              | | properties          |                                  |
+-------------------+----------+---------------------------+--------------+-----------------------+----------------------------------+
| ``publish``       | no       | --                        | | list of    | | values to           | `publish <#publish>`__           |
|                   |          |                           | | key:values | | aggregate from      |                                  |
|                   |          |                           |              | | parallel branches   |                                  |
|                   |          |                           |              | | loop properties     |                                  |
+-------------------+----------+---------------------------+--------------+-----------------------+----------------------------------+
| ``navigate``      | no       | | ``FAILURE``: on_failure | | key:value  | navigation logic      | | `navigation <#navigate>`_      |
|                   |          | | or flow finish          | | pairs      |                       | | `results <#results>`__         |
|                   |          | | ``SUCCESS``: next step  |              |                       |                                  |
+-------------------+----------+---------------------------+--------------+-----------------------+----------------------------------+

**Example - step prints all the values in value_list in parallel and
then navigates to a step named "another_step"**

.. code-block:: yaml

    - print_values:
        parallel_loop:
          for: value in values_list
          do:
            print_branch:
              - ID: ${value}
        publish:
            - name_list: ${map(lambda x:str(x['name']), branches_context)}
        navigate:
            - SUCCESS: another_step
            - FAILURE: FAILURE

.. _workflow:

workflow
--------

The key ``workflow`` is a property of a `flow <#flow>`__. It is mapped
to a list of the workflow's `steps <#step>`__.

Defines a container for the `steps <#step>`__, their `published
variables <#publish>`__ and `navigation <#navigate>`__ logic.

The first `step <#step>`__ in the workflow is the starting
`step <#step>`__ of the flow. From there the flow continues sequentially
by default upon receiving `results <#results>`__ of ``SUCCESS``, to the
flow finish or to `on_failure <#on-failure>`__ upon a
`result <#results>`__ of ``FAILURE``, or following whatever overriding
`navigation <#navigate>`__ logic that is present.

+----------------+----------+---------+------------+--------------------------+--------------------------------+
| Propery        | Required | Default | Value Type | Description              | More Info                      |
+================+==========+=========+============+==========================+================================+
| ``on_failure`` | no       | --      | step       | | default navigation     | | `on_failure <#on-failure>`__ |
|                |          |         |            | | target for ``FAILURE`` | | `step <#step>`__             |
+----------------+----------+---------+------------+--------------------------+--------------------------------+

**Example - workflow that divides two numbers and prints them out if the
division was legal**

.. code-block:: yaml

    workflow:
      - divider:
          do:
            divide:
              - dividend: ${input1}
              - divisor: ${input2}
          publish:
            - answer: ${quotient}
          navigate:
            - ILLEGAL: FAILURE
            - SUCCESS: printer
      - printer:
          do:
            print:
              - text: ${input1 + "/" + input2 + " = " + answer}

Functions (A-Z)
===============

.. _check_empty:

check_empty()
-------------

May appear in the value of an `input <#inputs>`__,
`output <#outputs>`__, `publish <#publish>`__ or `result <#results>`__
`expression <#expressions>`__.

The function in the form of ``check_empty(expression1, expression2)`` returns
the value associated with ``expression1`` if ``expression1`` does not evaluate
to ``None``. If ``expression1`` evaluates to ``None`` the function returns the
value associated with ``expression2``.

**Example - usage of check_empty to check operation output in a flow**

.. code-block:: yaml

    flow:
      name: flow
      inputs:
        - in1
      workflow:
        - step1:
            do:
              operation:
                - in1
            publish:
              - pub1: ${check_empty(out1, 'x marks the spot')}
              #if in1 was not 'x' then out1 is 'not x' and pub1 is therefore 'not x'
              #if in1 was 'x' then out1 is None and pub1 is therefore 'x marks the spot'
      outputs:
        - pub1

.. code-block:: yaml

    operation:
      name: operation
      inputs:
        - in1
      python_action:
        script: |
          out1 = 'not x' if in1 != 'x' else None
      outputs:
        - out1

.. _get:

get()
-----

May appear in the value of an `input <#inputs>`__,
`output <#outputs>`__, `publish <#publish>`__ or `result <#results>`__
`expression <#expressions>`__.

The function in the form of ``get('key')`` returns the value associated with
``key`` if the key is defined. If the key is undefined the function returns
``None``.

The function in the form of ``get('key', 'default_value')`` returns the
value associated with ``key`` if the key is defined and its value is not
``None``. If the key is undefined or its value is ``None`` the function
returns the ``default_value``.

**Example - usage of get function in inputs and outputs**

.. code-block:: yaml

    inputs:
      - input1:
          required: false
      - input1_safe:
          default: ${get('input1', 'default_input')}
          private: true

    workflow:
      - step1:
          do:
            print:
              - text: ${input1_safe}
          publish:
            - some_output: ${get('output1', 'default_output')}

    outputs:
      - some_output

.. _get_sp:

get_sp()
--------
May appear in the value of an `input <#inputs>`__,
`step <#step>`__ argument, `publish <#publish>`__, `output <#outputs>`__ or
`result <#results>`__ `expression <#expressions>`__.

The function in the form of ``get_sp('key', 'default_value')`` returns the
value associated with the `system property <#properties>`__ named ``key`` if the
key is defined and its value is not ``null``. If the key is undefined or its
value is ``null`` the function returns the ``default_value``. The ``key`` is the
fully qualified name of the `system property <#properties>`__, meaning the
namespace (if there is one) of the file in which it is found followed by a dot
``.`` and the name of the key.

`System property <#properties>`__ values are always strings or ``null``. Values
of other types (numeric, list, map, etc.) are converted to string
representations.

`System properties <#properties>`__ are not enforced at compile time. They are
assigned at runtime.

.. note::

   If multiple system properties files are being used and they
   contain a `system property <#properties>`__ with the same fully qualified name,
   the property in the file that is loaded last will overwrite the others with
   the same name.

**Example - system properties file**

.. code-block:: yaml

    namespace: examples.sysprops

    properties:
      - host: 'localhost'
      - port: 8080


**Example - system properties used as input values**

.. code-block:: yaml

    inputs:
      - host: ${get_sp('examples.sysprops.hostname')}
      - port: ${get_sp('examples.sysprops.port', '8080')}

To pass a system properties file to the CLI, see :ref:`Run with System
Properties <run_with_system_properties>`.
