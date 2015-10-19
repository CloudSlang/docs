#Examples
The following simplified examples demonstrate some of the key CloudSlang concepts. 

+ [Example 1 - User-defined Navigation and Publishing Outputs](#example-1-user-defined-navigation-and-publishing-outputs)
+ [Example 2 - Default Navigation](#example-2-default-navigation)
+ [Example 3 - Subflow](#example-3-subflow)
+ [Example 4 - Loops](#example-4-loops)
+ [Example 5 - Asynchronous loop](#example-5-asynchronous-loop)
+ [Example 6 - Operation Paths](#example-6-operation-paths)

Each of the examples below can be run by doing the following:

1. Create a new folder.
2. Create new CloudSlang(.sl) files and copy the code into them.
3. [Use the CLI](cloudslang_cli.md#use-the-cli) to run the flow. 

For more information on getting set up to run flows, see the [CloudSlang CLI](cloudslang_cli.md) and [Hello World Example](hello_world.md) sections.

##Example 1 - User-defined Navigation and Publishing Outputs
This example is a full working version from which many of the example snippets above have been taken. The flow takes in two inputs, divides them and prints the answer. In case of a division by zero, the flow does not print the output of the division, but instead ends with a user-defined result of `ILLEGAL`.

**Flow - division.sl**
```yaml
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
            - text: input1 + "/" + input2 + " = " + str(answer)
        navigate:
          SUCCESS: SUCCESS

  outputs:
    - quotient: answer

  results:
    - ILLEGAL
    - SUCCESS
```
**Operations - divide.sl**
```yaml
namespace: examples.divide

operation:
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
```
**Operation - print.sl**
```yaml
namespace: examples.divide

operation:
  name: print
  inputs:
    - text
  action:
    python_script: print text
  results:
    - SUCCESS
```

##Example 2 - Default Navigation
In this example the flow takes in two inputs, one of which determines the success of its first task. 

+ If the first task succeeds, the flow continues with the default navigation sequentially by performing the next task. That task returns a default result of `SUCCESS` and therefore skips the `on_failure` task, ending the flow with a result of `SUCCESS`.
+ If the first task fails, the flow moves to the `on_failure` task by default navigation. When the `on_failure` task is done, the flow ends with a default result of `FAILURE`.

**Flow - nav_flow.sl**

```yaml
namespace: examples.defualtnav

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

    # default navigation - go to this task on success
    - do_something:
        do:
          something:

    # default navigation - go to this task on failure
    - on_failure:
      - send_error_mail:
          do:
            send_email_mock:
              - recipient: email_recipient
              - subject: "'Flow failure'"
```

**Operation - produce_default_navigation.sl**

```yaml
namespace: examples.defualtnav

operation:
  name: produce_default_navigation
  inputs:
    - navigation_type
  action:
    python_script:
      print 'Default navigation based on input of - ' + navigation_type
  results:
    - SUCCESS: navigation_type == 'success'
    - FAILURE
```

**Operation - something.sl**

```yaml
namespace: examples.defualtnav

operation:
  name: something
  action:
      python_script:
        print 'Doing something important'
```

**Operation - send_email_mock.sl**
```yaml
namespace: examples.defualtnav

operation:
  name: send_email_mock
  inputs:
    - recipient
    - subject
  action:
    python_script:
      print 'Email sent to ' + recipient + ' with subject - ' + subject
```

##Example 3 - Subflow
This example uses the flow from **Example 1** as a subflow. It takes in four numbers (or uses default ones) to call `division_flow` twice. If either division returns the `ILLEGAL` result, navigation is routed to the `on_failure` task and the flow ends with a result of `FAILURE`. If both divisions are successful, the `on_failure` task is skipped and the flow ends with a result of `SUCCESS`.

**Note:** To run this flow, the files from **Example 1** should be placed in the same folder as this flow file or use the `--cp` flag at the command line.

**Flow - master_divider.sl**

```yaml
namespace: examples.divide

flow:
  name: master_divider

  inputs:
    - dividend1: "'3'"
    - divisor1: "'2'"
    - dividend2: "'1'"
    - divisor2: "'0'"

  workflow:
    - division1:
        do:
          division:
            - input1: dividend1
            - input2: divisor1
        publish:
          - ans: quotient
        navigate:
          SUCCESS: division2
          ILLEGAL: failure_task

    - division2:
        do:
          division:
            - input1: dividend2
            - input2: divisor2
        publish:
          - ans: quotient
        navigate:
          SUCCESS: SUCCESS
          ILLEGAL: failure_task
    - on_failure:
      - failure_task:
          do:
            print:
              - text: ans
```

##Example 4 - Loops
This example demonstrates the different types of values that can be looped on and various methods for handling loop breaks. 

**Flow - loops.sl**

```yaml
namespace: examples.loops

flow:
  name: loops

  inputs:
    - sum:
        default: 0
        overridable: false

  workflow:
    - fail3a:
        loop:
          for: value in [1,2,3,4,5]
          do:
            fail3:
              - text: value
        navigate:
          SUCCESS: fail3b
          FAILURE: fail3b
    - fail3b:
        loop:
          for: value in [1,2,3,4,5]
          do:
            fail3:
              - text: value
          break: []
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
    - skip_this:
        do:
          print:
            - text: "'This will not run.'"
    - aggregate:
        loop:
          for: value in range(1,6)
          do:
            print:
              - text: value
          publish:
            - sum: fromInputs['sum'] + out
    - print:
        do:
          ops.print:
            - text: sum
```

**Operation - custom3.sl**

```yaml
namespace: examples.loops

operation:
  name: custom3
  inputs:
    - text
  action:
    python_script: print text
  results:
    - CUSTOM: int(fromInputs['text']) == 3
    - SUCCESS
```

**Operation - fail3.sl**

```yaml
namespace: examples.loops

operation:
  name: fail3
  inputs:
    - text
  action:
    python_script: print text
  results:
    - FAILURE: int(fromInputs['text']) == 3
    - SUCCESS
```

**Operation - print.sl**
```yaml
namespace: examples.loops

operation:
  name: print
  inputs:
    - text
  action:
    python_script: print text
  outputs:
    - out: text
  results:
    - SUCCESS
```

##Example 5 - Asynchronous loop
This example demonstrates the usage of an asynchronous loop including aggregation.

**Flow - async_loop_aggregate.sl**
```yaml
namespace: examples.async

flow:
  name: async_loop_aggregate
  inputs:
    - values: [1,2,3,4]
  workflow:
    - print_values:
        async_loop:
          for: value in values
          do:
            print_branch:
              - ID: value
          publish:
            - name
            - num
        aggregate:
            - name_list: map(lambda x:str(x['name']), branches_context)
            - first_name: branches_context[0]['name']
            - last_name: branches_context[-1]['name']
            - total: sum(map(lambda x:x['num'], branches_context))
  outputs:
    - name_list
    - first_name
    - last_name
    - total
```

**Operation - print_branch.sl**
```yaml
namespace: examples.async

operation:
  name: print_branch
  inputs:
     - ID
  action:
    python_script: |
        name = 'branch ' + str(ID)
        print 'Hello from ' + name
  outputs:
    - name
    - num: ID
```

##Example 6 - Operation Paths
This example demonstrates the various ways to reference an operation or subflow from a flow task.

This example uses the following folder structure:

+ examples
    + paths
        + flow.sl
        + op1.sl 
        + folder_a
            + op2.sl
        + folder_b
            + op3.sl
            + folder_c
                + op4.sl 

**Flow - flow.sl**
```yaml
namespace: examples.paths

imports:
  alias: test_code.paths.folder_b

flow:
  name: flow

  workflow:
    - default_path:
        do:
          op1:
            - text: "'default path'"
    - fully_qualified_path:
        do:
          test_code.paths.folder_a.op2:
            - text: "'fully qualified path'"
    - using_alias:
        do:
          alias.op3:
            - text: "'using alias'"
    - alias_continuation:
        do:
          alias.folder_c.op4:
            - text: "'alias continuation'"
```

**Operation - op1.sl**
```yaml
namespace: examples.paths

operation:
  name: op1
  inputs:
    - text
  action:
    python_script: print text
```

**Operation - op2.sl**
```yaml
namespace: examples.paths.folder_a

operation:
  name: op2
  inputs:
    - text
  action:
    python_script: print text
```

**Operation - op3.sl**
```yaml
namespace: examples.paths.folder_b

operation:
  name: op3
  inputs:
    - text
  action:
    python_script: print text
```

**Operation - op4.sl**
```yaml
namespace: examples.paths.folder_b.folder_c

operation:
  name: op4
  inputs:
    - text
  action:
    python_script: print text
```