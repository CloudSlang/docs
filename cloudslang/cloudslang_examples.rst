Examples
++++++++

The following simplified examples demonstrate some of the key CloudSlang
concepts.

-  `Example 1 - User-defined Navigation and Publishing
   Outputs <#example-1-user-defined-navigation-and-publishing-outputs>`__
-  `Example 2 - Default Navigation <#example-2-default-navigation>`__
-  `Example 3 - Subflow <#example-3-subflow>`__
-  `Example 4 - Loops <#example-4-loops>`__
-  `Example 5 - Parallel Loop <#example-5-parallel-loop>`__
-  `Example 6 - Operation Paths <#example-6-operation-paths>`__

Each of the examples below can be run by doing the following:

1. Create a new folder.
2. Create new CloudSlang(.sl) files and copy the code into them.
3. :ref:`Use the CLI <use_the_cli>` to run the flow.

For more information on getting set up to run flows, see the :doc:`CloudSlang
CLI <cloudslang_cli>` and :doc:`Hello World Example <hello_world>` sections.

Example 1 - User-defined Navigation and Publishing Outputs
==========================================================

This example is a full working version from which many of the example
snippets above have been taken. The flow takes in two inputs, divides
them and prints the answer. In case of a division by zero, the flow does
not print the output of the division, but instead ends with a
user-defined result of ``ILLEGAL``.

:download:`Download code </code/examples_code/examples/divide.zip>`

**Flow - division.sl**

.. code-block:: yaml

    namespace: examples.divide

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
                - text: ${input1 + "/" + input2 + " = " + str(answer)}
            navigate:
              - SUCCESS: SUCCESS

      outputs:
        - quotient: ${answer}

      results:
        - ILLEGAL
        - SUCCESS


**Operations - divide.sl**

.. code-block:: yaml

    namespace: examples.divide

    operation:
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

**Operation - print.sl**

.. code-block:: yaml

    namespace: examples.divide

    operation:
      name: print

      inputs:
        - text

      python_action:
        script: print text

      results:
        - SUCCESS

.. _example_default_navigation:

Example 2 - Default Navigation
==============================

In this example the flow takes in two inputs, one of which determines
the success of its first step.

-  If the first step succeeds, the flow continues with the default
   navigation sequentially by performing the next step. That step
   returns a default result of ``SUCCESS`` and therefore skips the
   ``on_failure`` step, ending the flow with a result of ``SUCCESS``.
-  If the first step fails, the flow moves to the ``on_failure`` step by
   default navigation. When the ``on_failure`` step is done, the flow
   ends with a default result of ``FAILURE``.

:download:`Download code </code/examples_code/examples/defaultnav.zip>`

**Flow - nav_flow.sl**

.. code-block:: yaml

    namespace: examples.defaultnav

    flow:
      name: nav_flow

      inputs:
        - navigation_type
        - email_recipient

      workflow:
        - produce_default_navigation:
            do:
              produce_default_navigation:
                - navigation_type

        # default navigation - go to this step on success
        - do_something:
            do:
              something:

        # default navigation - go to this step on failure
        - on_failure:
          - send_error_mail:
              do:
                send_email_mock:
                  - recipient: ${email_recipient}
                  - subject: "Flow failure"

**Operation - produce_default_navigation.sl**

.. code-block:: yaml

    namespace: examples.defaultnav

    operation:
      name: produce_default_navigation

      inputs:
        - navigation_type

      python_action:
        script: |
          print 'Default navigation based on input of - ' + navigation_type

      results:
        - SUCCESS: ${navigation_type == 'success'}
        - FAILURE

**Operation - something.sl**

.. code-block:: yaml

    namespace: examples.defaultnav

    operation:
      name: something

      python_action:
          script: |
            x = 'Doing something important'
            print x

      results:
        - FAILURE: ${x = 'important thing not done'}
        - SUCCESS

**Operation - send_email_mock.sl**

.. code-block:: yaml

    namespace: examples.defaultnav

    operation:
      name: send_email_mock

      inputs:
        - recipient
        - subject

      python_action:
        script: |
          print 'Email sent to ' + recipient + ' with subject - ' + subject

Example 3 - Subflow
===================

This example uses the flow from **Example 1** as a subflow. It takes in
four numbers (or uses default ones) to call ``division_flow`` twice. If
either division returns the ``ILLEGAL`` result, navigation is routed to
the ``on_failure`` step and the flow ends with a result of ``FAILURE``.
If both divisions are successful, the ``on_failure`` step is skipped and
the flow ends with a result of ``SUCCESS``.

.. note::

   To run this flow, the files from **Example 1** should be
   placed in the same folder as this flow file or use the ``--cp`` flag at
   the command line.

:download:`Download code </code/examples_code/examples/divide.zip>`

**Flow - master_divider.sl**

.. code-block:: yaml

    namespace: examples.divide

    flow:
      name: master_divider

      inputs:
        - dividend1: "3"
        - divisor1: "2"
        - dividend2: "1"
        - divisor2: "0"

      workflow:
        - division1:
            do:
              division:
                - input1: ${dividend1}
                - input2: ${divisor1}
            publish:
              - ans: ${quotient}
            navigate:
              - SUCCESS: division2
              - ILLEGAL: failure_step
        - division2:
            do:
              division:
                - input1: ${dividend2}
                - input2: ${divisor2}
            publish:
              - ans: ${quotient}
            navigate:
              - SUCCESS: SUCCESS
              - ILLEGAL: failure_step
        - on_failure:
          - failure_step:
              do:
                print:
                  - text: ${ans}

Example 4 - Loops
=================

This example demonstrates the different types of values that can be
looped on and various methods for handling loop breaks.

:download:`Download code </code/examples_code/examples/loops.zip>`

**Flow - loops.sl**

.. code-block:: yaml

    namespace: examples.loops

    flow:
      name: loops

      inputs:
        - sum:
            default: '0'
            private: true

      workflow:
        - fail3a:
            loop:
              for: value in [1,2,3,4,5]
              do:
                fail3:
                  - text: ${str(value)}
            navigate:
              - SUCCESS: fail3b
              - FAILURE: fail3b
        - fail3b:
            loop:
              for: value in [1,2,3,4,5]
              do:
                fail3:
                  - text: ${str(value)}
              break: []
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
        - skip_this:
            do:
              print:
                - text: "This will not run."
            navigate:
              - SUCCESS: aggregate
        - aggregate:
            loop:
              for: value in range(1,6)
              do:
                print:
                  - text: ${str(value)}
                  - sum
              publish:
                - sum: ${str(int(sum) + int(out))}
              break: []
            navigate:
              - SUCCESS: print
        - print:
            do:
              print:
                - text: ${sum}
            navigate:
              - SUCCESS: SUCCESS

**Operation - custom3.sl**

.. code-block:: yaml

    namespace: examples.loops

    operation:
      name: custom3

      inputs:
        - text

      python_action:
        script: print text

      results:
        - CUSTOM: ${int(text) == 3}
        - SUCCESS

**Operation - print.sl**

.. code-block:: yaml

    namespace: examples.loops

    operation:
      name: print

      inputs:
        - text

      python_action:
        script: print text

      outputs:
        - out: ${text}

      results:
        - SUCCESS

.. _example_parallel_loop:

Example 5 - Parallel Loop
=========================

This example demonstrates the usage of a parallel loop including
aggregation.

:download:`Download code </code/examples_code/examples/parallel.zip>`

**Flow - parallel_loop_aggregate.sl**

.. code-block:: yaml

    namespace: examples.parallel

    flow:
      name: parallel_loop_aggregate

      inputs:
      - values: "1 2 3 4"

      workflow:
        - print_values:
            parallel_loop:
              for: value in values.split()
              do:
                print_branch:
                  - ID: ${str(value)}
            publish:
              - name_list: "${', '.join(map(lambda x : str(x['name']), branches_context))}"
              - first_name: ${branches_context[0]['name']}
              - last_name: ${branches_context[-1]['name']}
              - total: "${str(sum(map(lambda x : int(x['num']), branches_context)))}"

      outputs:
        - name_list
        - first_name
        - last_name
        - total

**Operation - print_branch.sl**

.. code-block:: yaml

    namespace: examples.parallel

    operation:
      name: print_branch

      inputs:
        - ID

      python_action:
        script: |
            name = 'branch ' + str(ID)
            print 'Hello from ' + name

      outputs:
        - name
        - num: ${ID}

.. _example_operation_paths:

Example 6 - Operation Paths
===========================

This example demonstrates the various ways to reference an operation or
subflow from a flow step.

This example uses the following folder structure:

-  examples

   -  paths

      -  flow.sl
      -  op1.sl
      -  folder_a

         -  op2.sl

      -  folder_b

         -  op3.sl
         -  folder_c

            -  op4.sl

:download:`Download code </code/examples_code/examples/paths.zip>`

**Flow - flow.sl**

.. code-block:: yaml

    namespace: examples.paths

    imports:
      alias: examples.paths.folder_b

    flow:
      name: flow

      workflow:
        - default_path:
            do:
              op1:
                - text: "default path"
            navigate:
              - SUCCESS: fully_qualified_path
        - fully_qualified_path:
            do:
              examples.paths.folder_a.op2:
                - text: "fully qualified path"
            navigate:
              - SUCCESS: using_alias
        - using_alias:
            do:
              alias.op3:
                - text: "using alias"
            navigate:
              - SUCCESS: alias_continuation
        - alias_continuation:
            do:
              alias.folder_c.op4:
                - text: "alias continuation"
            navigate:
              - SUCCESS: SUCCESS

      results:
        - SUCCESS

**Operation - op1.sl**

.. code-block:: yaml

    namespace: examples.paths

    operation:
      name: op1

      inputs:
        - text

      python_action:
        script: print text

**Operation - op2.sl**

.. code-block:: yaml

    namespace: examples.paths.folder_a

    operation:
      name: op2

      inputs:
        - text

      python_action:
        script: print text

**Operation - op3.sl**

.. code-block:: yaml

    namespace: examples.paths.folder_b

    operation:
      name: op3

      inputs:
        - text

      python_action:
        script: print text

**Operation - op4.sl**

.. code-block:: yaml

    namespace: examples.paths.folder_b.folder_c

    operation:
      name: op4

      inputs:
        - text

      python_action:
        script: print text
