DSL Reference
+++++++++++++

CloudSlang is a `YAML <http://www.yaml.org>`__ (version 1.2) based
language for describing a workflow. Using CloudSlang you can easily
define a workflow in a structured, easy-to-understand format that can be
run by the CloudSlang Orchestration Engine (Score). CloudSlang files can
be run by the :doc:`CloudSlang CLI <cloudslang_cli>` or by an embedded
instance of Score using the :ref:`Slang API <slang_api>`.

This reference begins with a brief introduction to CloudSlang files and
their structure, an alphabetical listing of CloudSlang keywords and
concepts, and several examples, including one from which many of the
code snippets below are taken.

CloudSlang Files
================

CloudSlang files are written using `YAML <http://www.yaml.org>`__. The
recommended extension for CloudSlang files is **.sl**, but **.sl.yaml**
and **.sl.yml** will work as well.

There are two types of CloudSlang files:

-  flow - contains a list of tasks and navigation logic that calls
   operations or subflows
-  operation - contains an action that runs a script or method

The following properties are for all types of CloudSlang files. For
properties specific to `flows <#flow>`__ or `operations <#operation>`__,
see their respective sections below.

+-----------------+------------+-----------+---------------------------+-------------------------+------------------------------+
| Property        | Required   | Default   | Value Type                | Description             | More Info                    |
+=================+============+===========+===========================+=========================+==============================+
| ``namespace``   | no         | --        | string                    | namespace of the flow   | `namespace <#namespace>`__   |
+-----------------+------------+-----------+---------------------------+-------------------------+------------------------------+
| ``imports``     | no         | --        | list of key:value pairs   | files to import         | `imports <#imports>`__       |
+-----------------+------------+-----------+---------------------------+-------------------------+------------------------------+

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
   -  `overridable <#overridable>`__
   -  `system_property <#system-property>`__

-  `workflow <#workflow>`__

   -  `task(s) <#task>`__
   -  `do <#do>`__
   -  `publish <#publish>`__

      -  `fromInputs <#frominputs>`__

   -  `navigate <#navigate>`__
   -  `iterative task <#iterative-task>`__
   -  `loop <#loop>`__

      -  `for <#for>`__
      -  `do <#do>`__
      -  `publish <#publish>`__
      -  `break <#break>`__

   -  `navigate <#navigate>`__
   -  `asynchronous task <#asynchronous-task>`__
   -  `async\_loop <#async-loop>`__

      -  `for <#for>`__
      -  `do <#do>`__
      -  `publish <#publish>`__

   -  `aggregate <#aggregate>`__
   -  `navigate <#navigate>`__
   -  `on_failure <#on-failure>`__

-  `outputs <#outputs>`__

   -  `fromInputs <#frominputs>`__

-  `results <#results>`__

**Operations file**

-  `namespace <#namespace>`__
-  `imports <#imports>`__
-  `operation <#operation>`__
-  `name <#name>`__
-  `inputs <#inputs>`__

   -  `required <#required>`__
   -  `default <#default>`__
   -  `overridable <#overridable>`__
   -  `system_property <#system-property>`__

-  `action <#action>`__
-  `outputs <#outputs>`__

   -  `fromInputs <#frominputs>`__

-  `results <#results>`__

.. _action:

action
------

The key ``action`` is a property of an `operation <#operation>`__. It is
mapped to a property that defines the type of action, which can be a
`java_action <#java-action>`__ or `python_script <#python-script>`__.

.. _java_action:

java_action
~~~~~~~~~~~~

The key ``java_action`` is a property of `action <#action>`__.
It is mapped to the properties that define the class and method where
the @Action resides.

A ``java_action`` is a valid @Action that conforms to the method
signature: ``public Map<String, String> doSomething(paramaters)`` and
uses the following annotations from
``com.hp.oo.sdk.content.annotations``:

-  Required annotation:

   -  @Param: action parameter

-  Optional annotations:

   -  @Action: specify action information
   -  @Output: action output
   -  @Response: action response

**Example - CloudSlang call to a Java @Action**

.. code-block:: yaml

    name: pull_image
    inputs:
      - input1
      - input2
    action:
      java_action:
        className: org.mypackage.MyClass
        methodName: doMyAction
    outputs:
      - returnResult
    results:
      - SUCCESS : someActionOutput == '0'
      - FAILURE

.. code-block:: java

    public Map<String, String> doMyAction(
            @Param("input1") String input1,
            @Param("input2") String input2) {
        //logic here
        Map<String, String> returnValues = new HashMap<>();
        //prepare return values map
        return returnValues;
    }

.. _python_script:

python_script
~~~~~~~~~~~~~~

The key ``python_script`` is a property of `action <#action>`__.
It is mapped to a value containing a Python version 2.7 script.

**Example - action with Python script that divides two numbers**

.. code-block:: yaml

    name: divide
    inputs:
      - dividend
      - divisor
    action:
      python_script: |
        if divisor == '0':
          quotient = 'division by zero error'
        else:
          quotient = float(dividend) / float(divisor)
    outputs:
      - quotient
    results:
      - ILLEGAL: quotient == 'division by zero error'
      - SUCCESS

**Note:** Single-line Python scripts can be written inline with the
``python_script`` key. Multi-line Python scripts can use the YAML pipe
(``|``) indicator as in the example above.

Importing External Python Packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are three approaches to importing and using external Python
modules:

-  Installing packages into the **python-lib** folder
-  Editing the executable file
-  Adding the package location to ``sys.path``

**Installing packages into the python-lib folder:**

Prerequisite: **pip** - see **pip**'s
`documentation <https://pip.pypa.io/en/latest/installing.html>`__ for
how to install.

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

   **Note:** If your machine is behind a proxy you will need to specify
   the proxy using pip's ``--proxy`` flag.

4. Import the package as you normally would in Python from within the
   action's ``python_script``:

.. code-block:: yaml

    action:
      python_script: |
        from pyfiglet import Figlet
        f = Figlet(font='slant')
        print f.renderText(text)

**Example - requirements file**

::

        pyfiglet == 0.7.2
        setuptools

**Note:** If you have defined a ``JYTHONPATH`` environment variable, you
will need to add the **python-lib** folder's path to its value.

**Editing the executable file**

1. Open the executable found in the **bin** folder for editing.
2. Change the ``Dpython.path`` key's value to the desired path.
3. Import the package as you normally would in Python from within the
   action's ``python_script``.

**Adding the package location to sys.path:**

1. In the action's Pyton script, import the ``sys`` module.
2. Use ``sys.path.append()`` to add the path to the desired module.
3. Import the module and use it.

**Example - takes path as input parameter, adds it to sys.path and imports desired module**

.. code-block:: yaml

    inputs:
      - path action:
          python_script: |
            import sys sys.path.append(path)
            import module_to_import
            print module_to_import.something()

Importing Python Scripts
~~~~~~~~~~~~~~~~~~~~~~~~

To import a Python script in a ``python_script`` action:

1. Add the Python script to the **python-lib** folder, which is found at
   the same level as the **bin** folder that contains the CLI
   executable.
2. Import the script as you normally would in Python from within the
   action's ``python_script``.

**Note:** If you have defined a ``JYTHONPATH`` environment variable, you
will need to add the **python-lib** folder's path to its value.

.. _aggregate:

aggregate
---------

The key ``aggregate`` is a property of an `asynchronous
task <#asynchronous-task>`__ name. It is mapped to key:value pairs where
the key is the variable name to publish to the `flow's <#flow>`__ scope
and the value is the aggregation expression.

Defines the aggregation logic for an `asynchronous
task <#asynchronous-task>`__, often making us of the
`branches_context <#branches-context>`__ construct.

Aggregation is performed after all branches of an `asynchronous
task <#asynchronous-task>`__ have completed.

**Example - aggregates all of the published names into name\_list**

.. code-block:: yaml

    aggregate:
      - name_list: map(lambda x:str(x['name']), branches_context)

.. _async_loop:

async_loop
-----------

The key ``asyc_loop`` is a property of an `asynchronous
task's <#asynchronous-task>`__ name. It is mapped to the `asynchronous
task's <#asynchronous-task>`__ properties.

For each value in the loop's list a branch is created and the ``do``
will run an `operation <#operation>`__ or `subflow <#flow>`__. When all
the branches have finished, the `asynchronous
task's <#asynchronous-task>`__ `aggregation <#aggregate>`__ and
`navigation <#navigate>`__ will run.

+---------------+------------+-----------+-----------------------------+---------------------------------------------------------------------------+----------------------------------------------------------------------------+
| Property      | Required   | Default   | Value Type                  | Description                                                               | More Info                                                                  |
+===============+============+===========+=============================+===========================================================================+============================================================================+
| ``for``       | yes        | --        | variable ``in`` list        | loop values                                                               | `for <#for>`__                                                             |
+---------------+------------+-----------+-----------------------------+---------------------------------------------------------------------------+----------------------------------------------------------------------------+
| ``do``        | yes        | --        | operation or subflow call   | the operation or subflow this task will run in parallel                   | `do <#do>`__ `operation <#operation>`__ `flow <#flow>`__                   |
+---------------+------------+-----------+-----------------------------+---------------------------------------------------------------------------+----------------------------------------------------------------------------+
| ``publish``   | no         | --        | list of key:value pairs     | operation or subflow outputs to aggregate and publish to the flow level   | `publish <#publish>`__ `aggregate <#aggregate>`__ `outputs <#outputs>`__   |
+---------------+------------+-----------+-----------------------------+---------------------------------------------------------------------------+----------------------------------------------------------------------------+

**Example: loop that breaks on a result of custom**

.. code-block:: yaml

     - print_values:
         async_loop:
           for: value in values
           do:
             print_branch:
               - ID: value
           publish:
             - name
         aggregate:
             - name_list: map(lambda x:str(x['name']), branches_context)
         navigate:
             SUCCESS: print_list
             FAILURE: FAILURE

.. _branches_context:

branches_context
-----------------

May appear in the `aggregate <#aggregate>`__ section of an `asynchronous
task <#asynchronous-task>`__.

As branches of an `async\_loop <#async-loop>`__ complete, their
published values get placed as a dictionary into the
``branches_context`` list. The list is therefore in the order the
branches have completed.

A specific value can be accessed using the index representing its
branch's place in the finishing order and the name of the variable.

**Example - retrieves the published name variable from the first branch
to finish**

.. code-block:: yaml

    aggregate:
      - first_name: branches_context[0]['name']

More commonly, the ``branches_context`` is used to aggregate the values
that have been published by all of the branches.

**Example - aggregates all of the published name values into a list**

.. code-block:: yaml

    aggregate:
      - name_list: map(lambda x:str(x['name']), branches_context)

.. _break:

break
-----

The key ``break`` is a property of a `loop <#loop>`__. It is mapped to a
list of results on which to break out of the loop or an empty list
(``[]``) to override the default breaking behavior for a list. When the
`operation <#operation>`__ or `subflow <#flow>`__ of the `iterative
task <#iterative-task>`__ returns a result in the break's list, the
iteration halts and the `interative task's <#iterative-task>`__
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
          - text: value
      break:
        - CUSTOM
    navigate:
      CUSTOM: print_end

**Example - loop that continues even on result of FAILURE**

.. code-block:: yaml

    loop:
      for: value in range(1,7)
      do:
        custom_op:
          - text: value
      break: []

.. _default:

default
-------

The key ``default`` is a property of an `input <#inputs>`__ name. It is
mapped to an expression value.

The expression's value will be passed to the `flow <#flow>`__ or
`operation <#operation>`__ if no other value for that
`input <#inputs>`__ parameter is explicitly passed or if the input's
`overridable <#overridable>`__ parameter is set to ``false`` and there
is no `system\_properties <#system-property>`__ parameter defined.

**Example - default values**

.. code-block:: yaml

    inputs:
      - str_literal:
          default: "'default value'"
      - int_exp:
          default: '5 + 6'
      - from_variable:
          default: variable_name

A default value can also be defined inline by entering it as the value
to the `input <#inputs>`__ parameter's key.

**Example - inline default values**

.. code-block:: yaml

    inputs:
      - str_literal: "'default value'"
      - int_exp: '5 + 6'
      - from_variable: variable_name

.. _do:

do
--

The key ``do`` is a property of a `task <#task>`__ name, a
`loop <#loop>`__, or an `async_loop <#async-loop>`__. It is mapped to a
property that references an `operation <#operation>`__ or
`flow <#flow>`__.

Calls an `operation <#operation>`__ or `flow <#flow>`__ and passes in
relevant `input <#inputs>`__. The `input <#inputs>`__ list may contain
`input <#inputs>`__ properties. The `operation <#operation>`__ or
`flow <#flow>`__ is called by its qualified name using an alias created
in the `imports <#imports>`__ parameter.

**Example - call to a divide operation with inputs**

.. code-block:: yaml

    do:
      divide:
        - dividend: input1
        - divisor: input2

.. _flow:

flow
----

The key ``flow`` is mapped to the properties which make up the flow
contents.

A flow is the basic executable unit of CloudSlang. A flow can run on its
own or it can be used by another flow in the `do <#do>`__ property of a
`task <#task>`__.

+----------------+------------+--------------------------------+----------------+--------------------------------+----------------------------+
| Property       | Required   | Default                        | Value Type     | Description                    | More Info                  |
+================+============+================================+================+================================+============================+
| ``name``       | yes        | --                             | string         | name of the flow               | `name <#name>`__           |
+----------------+------------+--------------------------------+----------------+--------------------------------+----------------------------+
| ``inputs``     | no         | --                             | list           | inputs for the flow            | `inputs <#inputs>`__       |
+----------------+------------+--------------------------------+----------------+--------------------------------+----------------------------+
| ``workflow``   | yes        | --                             | map of tasks   | container for set of tasks     | `workflow <#workflow>`__   |
+----------------+------------+--------------------------------+----------------+--------------------------------+----------------------------+
| ``outputs``    | no         | --                             | list           | list of outputs                | `outputs <#outputs>`__     |
+----------------+------------+--------------------------------+----------------+--------------------------------+----------------------------+
| ``results``    | no         | (``SUCCESS`` / ``FAILURE`` )   | list           | possible results of the flow   | `results <#results>`__     |
+----------------+------------+--------------------------------+----------------+--------------------------------+----------------------------+

**Example - a flow that performs a division of two numbers**

.. code-block:: yaml

    flow:
      name: division_flow

      inputs:
        - input1
        - input2

      workflow:
        - divider:
            do:
              divide:
                - dividend: input1
                - divisor: input2
            publish:
              - answer: quotient
            navigate:
              ILLEGAL: ILLEGAL
              SUCCESS: printer
        - printer:
            do:
              print:
                - text: input1 + "/" + input2 + " = " + answer
            navigate:
              SUCCESS: SUCCESS

      outputs:
        - quotient: answer

      results:
        - ILLEGAL
        - SUCCESS

.. _for:

for
---

The key ``for`` is a property of a `loop <#loop>`__ or an
`async\_loop <#async-loop>`__.



loop: for
~~~~~~~~~

A for loop iterates through a `list <#iterating-through-a-list>`__ or a
`map <#iterating-through-a-map>`__.

The `iterative task <#iterative-task>`__ will run once for each element
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
              - text: value

**Example - loop that iterates through the values in a comma delimited
string**

.. code-block:: yaml

    - print_values:
        loop:
          for: value in "1,2,3"
          do:
            print:
              - text: value

**Example - loop that iterates through the values returned from an
expression**

.. code-block:: yaml

    - print_values:
        loop:
          for: value in range(1,4)
          do:
            print:
              - text: value

Iterating through a map
^^^^^^^^^^^^^^^^^^^^^^^

When iterating through a map, the ``for`` key is mapped to iteration
variables for the key and value followed by ``in`` followed by a map or
an expression that evaluates to a map.

**Example - task that iterates through the values returned from an
expression**

.. code-block:: yaml

    - print_values:
        loop:
          for: k, v in map
          do:
            print2:
              - text1: k
              - text2: v

async_loop: for
~~~~~~~~~~~~~~~~

An asynchronous for loops in parallel branches over the items in a list.

The `asynchronous task <#asynchronous-task>`__ will run one branch for
each element in the list.

The ``for`` key is mapped to an iteration variable followed by ``in``
followed by a list or an expression that evaluates to a list.

**Example - task that asynchronously loops through the values in a
list**

.. code-block:: yaml

    - print_values:
        async_loop:
          for: value in values_list
          do:
            print_branch:
              - ID: value

.. _from_inputs:

fromInputs
----------

May appear in the value of an `output <#outputs>`__ or
`publish <#publish>`__.

Special syntax to refer to an `input <#inputs>`__ parameter as opposed
to another variable with the same name in a narrower scope.

**Example - output "input1" as it was passed in**

.. code-block:: yaml

    outputs:
      - output1: fromInputs['input1']

**Example - usage in publish to refer to a variable in the flow's
scope**

.. code-block:: yaml

    publish:
      - total_cost: fromInputs['total_cost'] + cost

.. _imports:

imports
-------

The key ``imports`` is mapped to the files to import as follows:

-  key - alias
-  value - namespace of file to be imported

Specifies the file's dependencies and the aliases they will be
referenced by in the file.

**Example - import operations and sublflow into flow**

.. code-block:: yaml

    imports:
      ops: examples.utils
      sub_flows: examples.subflows

    flow:
      name: hello_flow

      workflow:
        - print_hi:
            do:
              ops.print:
                - text: "'Hi'"

.. _inputs:

inputs
------

The key ``inputs`` is a property of a `flow <#flow>`__ or
`operation <#operation>`__. It is mapped to a list of input names. Each
input name may in turn be mapped to its properties.

Inputs are used to pass parameters to `flows <#flow>`__ or
`operations <#operation>`__.

Input properties may also be used in the input list of a
`task <#task>`__.

+-------------------------+------------+-----------+--------------+-----------------------------------------------------------------+-------------------------------------------+
| Property                | Required   | Default   | Value Type   | Description                                                     | More info                                 |
+=========================+============+===========+==============+=================================================================+===========================================+
| ``required``            | no         | true      | boolean      | is the input required                                           | `required <#required>`__                  |
+-------------------------+------------+-----------+--------------+-----------------------------------------------------------------+-------------------------------------------+
| ``default``             | no         | --        | expression   | default value of the input                                      | `default <#default>`__                    |
+-------------------------+------------+-----------+--------------+-----------------------------------------------------------------+-------------------------------------------+
| ``overridable``         | no         | true      | boolean      | if false, the default value always overrides values passed in   | `overridable <#overridable>`__            |
+-------------------------+------------+-----------+--------------+-----------------------------------------------------------------+-------------------------------------------+
| ``system_properties``   | no         | --        | string       | the name of a system property variable                          | `system\_property <#system-property>`__   |
+-------------------------+------------+-----------+--------------+-----------------------------------------------------------------+-------------------------------------------+

**Example - two inputs**

.. code-block:: yaml

    inputs:
      - input1:
          default: "'default value'"
          overridable: false
      - input2

.. _loop:

loop
----

The key ``loop`` is a property of an `iterative
task's <#iterative-task>`__ name. It is mapped to the `iterative
task's <#iterative-task>`__ properties.

For each value in the loop's list the ``do`` will run an
`operation <#operation>`__ or `subflow <#flow>`__. If the returned
result is in the ``break`` list, or if ``break`` does not appear and the
returned result is ``FAILURE``, or if the list has been exhausted, the
task's navigation will run.

+---------------+------------+-----------+-------------------------------------------------+--------------------------------------------------------------------------------+------------------------------------------------------------+
| Property      | Required   | Default   | Value Type                                      | Description                                                                    | More Info                                                  |
+===============+============+===========+=================================================+================================================================================+============================================================+
| ``for``       | yes        | --        | variable ``in`` list or key, value ``in`` map   | iteration logic                                                                | `for <#for>`__                                             |
+---------------+------------+-----------+-------------------------------------------------+--------------------------------------------------------------------------------+------------------------------------------------------------+
| ``do``        | yes        | --        | operation or subflow call                       | the operation or subflow this task will run iteratively                        | `do <#do>`__ `operation <#operation>`__ `flow <#flow>`__   |
+---------------+------------+-----------+-------------------------------------------------+--------------------------------------------------------------------------------+------------------------------------------------------------+
| ``publish``   | no         | --        | list of key:value pairs                         | operation or subflow outputs to aggregate and publish to the flow level        | `publish <#publish>`__ `outputs <#outputs>`__              |
+---------------+------------+-----------+-------------------------------------------------+--------------------------------------------------------------------------------+------------------------------------------------------------+
| ``break``     | no         | --        | list of `results <#results>`__                  | operation or subflow `results <#result>`__ on which to break out of the loop   | `break <#break>`__                                         |
+---------------+------------+-----------+-------------------------------------------------+--------------------------------------------------------------------------------+------------------------------------------------------------+

**Example: loop that breaks on a result of custom**

.. code-block:: yaml

     - custom3:
         loop:
           for: value in "1,2,3,4,5"
           do:
             custom3:
               - text: value
           break:
             - CUSTOM
         navigate:
           CUSTOM: aggregate
           SUCCESS: skip_this

.. _name:

name
----

The key ``name`` is a property of `flow <#flow>`__ and
`operation <#operation>`__. It is mapped to a value that is used as the
name of the `flow <#flow>`__ or `operation <#operation>`__.

The name of a `flow <#flow>`__ or `operation <#operation>`__ may be used
when called from a `flow <#flow>`__'s `task <#task>`__.

**Example - naming the flow *division\_flow***

.. code-block:: yaml

    name: division_flow

.. _namespace:

namespace
---------

The key ``namespace`` is mapped to a string value that defines the
file's namespace.

The namespace of a file may be used by other CloudSlang files to
`import <#imports>`__ dependencies, such as a flow importing operations.

**Example - definition a namespace**

.. code-block:: yaml

    namespace: examples.hello_world

**Example - using a namespace in an imports definition**

.. code-block:: yaml

    imports:
      ops: examples.hello_world

**Note:** If the imported file resides in a folder that is different
from the folder in which the importing file resides, the imported file's
directory must be added using the ``--cp`` flag when running from the
CLI (see :ref:`Run with Dependencies <run_with_dependencies>`).

.. _navigate:

navigate
--------

The key ``navigate`` is a property of a `task <#task>`__ name. It is
mapped to key:value pairs where the key is the received
`result <#results>`__ and the value is the target `task <#task>`__ or
`flow <#flow>`__ `result <#results>`__.

Defines the navigation logic for a `standard task <#standard-task>`__,
an `iterative task <#iterative-task>`__ or an `asynchronous
task <#asynchronous-task>`__. The flow will continue with the
`task <#task>`__ or `flow <#flow>`__ `result <#results>`__ whose value
is mapped to the `result <#results>`__ returned by the called
`operation <#operation>`__ or `subflow <#flow>`__.

The default navigation is ``SUCCESS`` except for the
`on\_failure <#on-failure>`__ `task <#task>`__ whose default navigation
is ``FAILURE``. All possible `results <#results>`__ returned by the
called `operation <#operation>`__ or subflow must be handled.

For a `standard task <#standard-task>`__ the navigation logic runs when
the `task <#task>`__ is completed.

For an `iterative task <#iterative-task>`__ the navigation logic runs
when the last iteration of the `task <#task>`__ is completed or after
exiting the iteration due to a `break <#break>`__.

For an `asynchronous task <#asynchronous-task>`__ the navigation logic
runs after the last branch has completed. If any of the branches
returned a `result <#results>`__ of ``FAILURE``, the `flow <#flow>`__
will navigate to the `task <#task>`__ or `flow <#flow>`__
`result <#results>`__ mapped to ``FAILURE``. Otherwise, the
`flow <#flow>`__ will navigate to the `task <#task>`__ or
`flow <#flow>`__ `result <#results>`__ mapped to ``SUCCESS``. Note that
the only `results <#results>`__ of an `operation <#operation>`__ or
`subflow <#flow>`__ called in an `async\_loop <#async-loop>`__ that are
evaluated are ``SUCCESS`` and ``FAILURE``. Any other results will be
evaluated as ``SUCCESS``.

**Example - ILLEGAL result will navigate to flow's FAILURE result and
SUCCESS result will navigate to task named *printer***

.. code-block:: yaml

    navigate:
      ILLEGAL: FAILURE
      SUCCESS: printer

.. _on_failure:

on_failure
-----------

The key ``on_failure`` is a property of a `workflow <#workflow>`__. It
is mapped to a `task <#task>`__.

Defines the `task <#task>`__, which when using default
`navigation <#navigation>`__, is the target of a ``FAILURE``
`result <#results>`__ returned from an `operation <#operation>`__ or
`flow <#flow>`__. The ``on_failure`` `task's <#task>`__
`navigation <#navigate>`__ defaults to ``FAILURE``.

**Example - failure task which call a print operation to print an error
message**

.. code-block:: yaml

    - on_failure:
      - failure:
          do:
            print:
              - text: error_msg

.. _operation:

operation
---------

The key ``operation`` is mapped to the properties which make up the
operation contents.

+------------+------------+---------------+----------------------------------------+------------------------------+--------------------------+
| Property   | Required   | Default       | Value Type                             | Description                  | More Info                |
+============+============+===============+========================================+==============================+==========================+
| inputs     | no         | --            | list                                   | operation inputs             | `inputs <#inputs>`__     |
+------------+------------+---------------+----------------------------------------+------------------------------+--------------------------+
| action     | yes        | --            | ``python_script`` or ``java_action``   | operation logic              | `action <#action>`__     |
+------------+------------+---------------+----------------------------------------+------------------------------+--------------------------+
| outputs    | no         | --            | list                                   | operation outputs            | `outputs <#outputs>`__   |
+------------+------------+---------------+----------------------------------------+------------------------------+--------------------------+
| results    | no         | ``SUCCESS``   | list                                   | possible operation results   | `results <#results>`__   |
+------------+------------+---------------+----------------------------------------+------------------------------+--------------------------+

**Example - operation that adds two inputs and outputs the answer**

.. code-block:: yaml

    name: add
    inputs:
      - left
      - right
    action:
      python_script: ans = left + right
    outputs:
      - out: ans
    results:
      - SUCCESS

.. _outputs:

outputs
-------

The key ``outputs`` is a property of a `flow <#flow>`__ or
`operation <#operation>`__. It is mapped to a list of output variable
names which may also contain expression values. Output expressions must
evaluate to strings.

Defines the parameters a `flow <#flow>`__ or `operation <#operation>`__
exposes to possible `publication <#publish>`__ by a `task <#task>`__.
The calling `task <#task>`__ refers to an output by its name.

See also `fromInputs <#frominputs>`__.

**Example - various types of outputs**

.. code-block:: yaml

    outputs:
      - existing_variable
      - output2: some_variable
      - output3: 5 + 6
      - output4: fromInputs['input1']

.. _overridable:

overridable
-----------

The key ``overridable`` is a property of an `input <#inputs>`__ name. It
is mapped to a boolean value.

A value of ``false`` will ensure that the `input <#inputs>`__
parameter's `default <#default>`__ value will not be overridden by
values passed into the `flow <#flow>`__ or `operation <#operation>`__.
If ``overridable`` is not defined, values passed in will override the
`default <#default>`__ value.

**Example - default value of text input parameter will not be overridden
by values passed in**

.. code-block:: yaml

    inputs:
      - text:
          default: "'default text'"
          overridable: false

.. _publish:

publish
-------

The key ``publish`` is a property of a `task <#task>`__ name, a
`loop <#loop>`__ or an `async_loop <#async-loop>`__. It is mapped to a
list of key:value pairs where the key is the published variable name and
the value is the name of the `output <#outputs>`__ received from an
`operation <#operation>`__ or `flow <#flow>`__.

Standard publish
~~~~~~~~~~~~~~~~

In a `standard task <#standard-task>`__, ``publish`` binds the
`output <#outputs>`__ from an `operation <#operation>`__ or
`flow <#flow>`__ to a variable whose scope is the current
`flow <#flow>`__ and can therefore be used by other `tasks <#task>`__ or
as the `flow's <#flow>`__ own `output <#outputs>`__.

**Example - publish the quotient output as ans**

.. code-block:: yaml

    - division1:
        do:
          division:
            - input1: dividend1
            - input2: divisor1
        publish:
          - ans: quotient

Iterative publish
~~~~~~~~~~~~~~~~~

In an `iterative task <#iterative-task>`__ the publish mechanism is run
during each iteration after the `operation <#operation>`__ or
`subflow <#flow>`__ has completed, therefore allowing for aggregation.

**Example - publishing in an iterative task to aggregate output**

.. code-block:: yaml

    - aggregate:
        loop:
          for: value in range(1,6)
          do:
            print:
              - text: value
          publish:
            - sum: fromInputs['sum'] + out

Asynchronous publish
~~~~~~~~~~~~~~~~~~~~

In an `asynchronous task <#asynchronous-task>`__ the publish mechanism
is run during each branch after the `operation <#operation>`__ or
`subflow <#flow>`__ has completed. Published variables and their values
are added as a dictionary to the
`branches\_context <#branches-context>`__ list in the order they are
received from finished branches, allowing for aggregation.

**Example - publishing in an iterative task to aggregate output**

.. code-block:: yaml

    - print_values:
        async_loop:
          for: value in values_list
          do:
            print_branch:
              - ID: value
          publish:
            - name
        aggregate:
            - name_list: map(lambda x:str(x['name']), branches_context)

.. _results:

results
-------

The key ``results`` is a property of a `flow <#flow>`__ or
`operation <#operation>`__.

The results of a `flow <#flow>`__ or `operation <#operation>`__ can be
used by the calling `task <#task>`__ for `navigation <#navigate>`__
purposes.

**Note:** The only results of an `operation <#operation>`__ or
`subflow <#flow>`__ called in an `async_loop <#async-loop>`__ that are
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
`task <#task>`__.

**Example - a user-defined result**

.. code-block:: yaml

    results:
      - SUCCESS
      - ILLEGAL
      - FAILURE

Operation results
~~~~~~~~~~~~~~~~~

In an `operation <#operation>`__ the key ``results`` is mapped to a list
of key:value pairs of result names and boolean expressions.

Defines the possible results of the `operation <#operation>`__. By
default, if no results exist, the result is ``SUCCESS``. The first
result in the list whose expression evaluates to true, or does not have
an expression at all, will be passed back to the calling
`task <#task>`__ to be used for `navigation <#navigate>`__ purposes.

All `operation <#operation>`__ results must be handled by the calling
`task <#task>`__.

**Example - three user-defined results**

.. code-block:: yaml

    results:
      - POSITIVE: polarity == '+'
      - NEGATIVE: polarity == '-'
      - NEUTRAL

.. _required:

required
--------

The key ``required`` is a property of an `input <#inputs>`__ name. It is
mapped to a boolean value.

A value of ``false`` will allow the `flow <#flow>`__ or
`operation <#operation>`__ to be called without passing the
`input <#inputs>`__ parameter. If ``required`` is not defined, the
`input <#inputs>`__ parameter defaults to being required.

**Example - input2 is optional**

.. code-block:: yaml

    inputs:
      - input1
      - input2:
          required: false

.. _system_property:

system_property
----------------

The key ``system_property`` is a property of an `input <#inputs>`__
name. It is mapped to a string of a key from a system properties file.

The value referenced from a system properties file will be passed to the
`flow <#flow>`__ or `operation <#operation>`__ if no other value for
that `input <#inputs>`__ parameter is explicitly passed in or if the
input's `overridable <#overridable>`__ parameter is set to ``false``.

**Note:** If multiple system properties files are being used and they
contain a system property with the same fully qualified name, the
property in the file that is loaded last will overwrite the others with
the same name.

**Example - system properties**

.. code-block:: yaml

    inputs:
      - host:
          system_property: examples.sysprops.hostname
      - port:
          system_property: examples.sysprops.port

To pass a system properties file to the CLI, see :ref:`Run with System
Properties <run_with_system_properties>`.

.. _task:

task
----

A name of a task which is a property of `workflow <#workflow>`__ or
`on\_failure <#on-failure>`__.

There are several types of tasks:

-  `standard <#standard-task>`__
-  `iterative <#iterative-task>`__
-  `asynchronous <#asynchronous-task>`__

Standard Task
~~~~~~~~~~~~~

A standard task calls an `operation <#operation>`__ or
`subflow <#flow>`__ once.

The task name is mapped to the task's properties.

+----------------+------------+-------------------------------------------------------------------+-----------------------------+---------------------------------------------------+------------------------------------------------------------+
| Property       | Required   | Default                                                           | Value Type                  | Description                                       | More Info                                                  |
+================+============+===================================================================+=============================+===================================================+============================================================+
| ``do``         | yes        | --                                                                | operation or subflow call   | the operation or subflow this task will run       | `do <#do>`__ `operation <#operation>`__ `flow <#flow>`__   |
+----------------+------------+-------------------------------------------------------------------+-----------------------------+---------------------------------------------------+------------------------------------------------------------+
| ``publish``    | no         | --                                                                | list of key:value pairs     | operation outputs to publish to the flow level    | `publish <#publish>`__ `outputs <#outputs>`__              |
+----------------+------------+-------------------------------------------------------------------+-----------------------------+---------------------------------------------------+------------------------------------------------------------+
| ``navigate``   | no         | ``FAILURE``: on\_failure or flow finish; ``SUCCESS``: next task   | key:value pairs             | navigation logic from operation or flow results   | `navigation <#navigate>`__ `results <#results>`__          |
+----------------+------------+-------------------------------------------------------------------+-----------------------------+---------------------------------------------------+------------------------------------------------------------+

**Example - task that performs a division of two inputs, publishes the
answer and navigates accordingly**

.. code-block:: yaml

    - divider:
        do:
          divide:
            - dividend: input1
            - divisor: input2
        publish:
          - answer: quotient
        navigate:
          ILLEGAL: FAILURE
          SUCCESS: printer

Iterative Task
~~~~~~~~~~~~~~

An iterative task calls an `operation <#operation>`__ or
`subflow <#flow>`__ iteratively, for each value in a list.

The task name is mapped to the iterative task's properties.

+----------------+------------+-------------------------------------------------------------------+-------------------+---------------------------------------------------------------------------------------------------------+-----------------------------------------------------+
| Property       | Required   | Default                                                           | Value Type        | Description                                                                                             | More Info                                           |
+================+============+===================================================================+===================+=========================================================================================================+=====================================================+
| ``loop``       | yes        | --                                                                | key               | container for loop properties                                                                           | `for <#for>`__                                      |
+----------------+------------+-------------------------------------------------------------------+-------------------+---------------------------------------------------------------------------------------------------------+-----------------------------------------------------+
| ``navigate``   | no         | ``FAILURE``: on\_failure or flow finish; ``SUCCESS``: next task   | key:value pairs   | navigation logic from `break <#break>`__ or the result of the last iteration of the operation or flow   | `navigation <#navigate>`__ `results <#results>`__   |
+----------------+------------+-------------------------------------------------------------------+-------------------+---------------------------------------------------------------------------------------------------------+-----------------------------------------------------+

**Example - task prints all the values in value\_list and then navigates
to a task named "another\_task"**

.. code-block:: yaml

    - print_values:
        loop:
          for: value in value_list
          do:
            print:
              - text: value
        navigate:
          SUCCESS: another_task
          FAILURE: FAILURE

Asynchronous Task
~~~~~~~~~~~~~~~~~

An asynchronous task calls an `operation <#operation>`__ or
`subflow <#flow>`__ asynchronously, in parallel branches, for each value
in a list.

The task name is mapped to the asynchronous task's properties.

+------------------+------------+-------------------------------------------------------------------+----------------------+-------------------------------------------+-----------------------------------------------------+
| Property         | Required   | Default                                                           | Value Type           | Description                               | More Info                                           |
+==================+============+===================================================================+======================+===========================================+=====================================================+
| ``async_loop``   | yes        | --                                                                | key                  | container for async loop properties       | `async\_loop <#async-loop>`__                       |
+------------------+------------+-------------------------------------------------------------------+----------------------+-------------------------------------------+-----------------------------------------------------+
| ``aggregate``    | no         | --                                                                | list of key:values   | values to aggregate from async branches   | `aggregate <#aggregate>`__                          |
+------------------+------------+-------------------------------------------------------------------+----------------------+-------------------------------------------+-----------------------------------------------------+
| ``navigate``     | no         | ``FAILURE``: on\_failure or flow finish; ``SUCCESS``: next task   | key:value pairs      | navigation logic                          | `navigation <#navigate>`__ `results <#results>`__   |
+------------------+------------+-------------------------------------------------------------------+----------------------+-------------------------------------------+-----------------------------------------------------+

**Example - task prints all the values in value\_list asynchronously and
then navigates to a task named "another\_task"**

.. code-block:: yaml

    - print_values:
        async_loop:
          for: value in values_list
          do:
            print_branch:
              - ID: value
          publish:
            - name
        aggregate:
            - name_list: map(lambda x:str(x['name']), branches_context)
        navigate:
            SUCCESS: another_task
            FAILURE: FAILURE

.. _workflow:

workflow
--------

The key ``workflow`` is a property of a `flow <#flow>`__. It is mapped
to a list of the workflow's `tasks <#task>`__.

Defines a container for the `tasks <#task>`__, their `published
variables <#publish>`__ and `navigation <#navigate>`__ logic.

The first `task <#task>`__ in the workflow is the starting
`task <#task>`__ of the flow. From there the flow continues sequentially
by default upon receiving `results <#results>`__ of ``SUCCESS``, to the
flow finish or to `on\_failure <#on-failure>`__ upon a
`result <#results>`__ of ``FAILURE``, or following whatever overriding
`navigation <#navigate>`__ logic that is present.

+------------------+------------+-----------+--------------+---------------------------------------------+--------------------------------------------------+
| Propery          | Required   | Default   | Value Type   | Description                                 | More Info                                        |
+==================+============+===========+==============+=============================================+==================================================+
| ``on_failure``   | no         | --        | task         | default navigation target for ``FAILURE``   | `on\_failure <#on-failure>`__ `task <#task>`__   |
+------------------+------------+-----------+--------------+---------------------------------------------+--------------------------------------------------+

**Example - workflow that divides two numbers and prints them out if the
division was legal**

.. code-block:: yaml

    workflow:
      - divider:
          do:
            divide:
              - dividend: input1
              - divisor: input2
          publish:
            - answer: quotient
          navigate:
            ILLEGAL: FAILURE
            SUCCESS: printer
      - printer:
          do:
            print:
              - text: input1 + "/" + input2 + " = " + answer
