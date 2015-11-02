#Lesson 5 - Default Navigation

##Goal
In this lesson we'll use the `check_availability` operation in our flow and use the results it returns.

##Get Started
Let's go back to **new_hire.sl** and add in the plumbing to run our new operation.

##Inputs
First, we'll add an inputs section to our flow between the name and the workflow. It works the same way as inputs to an operation.

```yaml
  inputs:
    - address
```

Just as with an operation, values for the inputs of a flow are either passed via the [CloudSlang CLI](../cloudslang_cli.md), as we do below in this lesson, or from a task in a calling flow, as in lesson [9 - Subflows](09_lesson.md).  

Inputs can also have related parameters, such as `required`, `default`, `overridable` and `system_property`. We will discuss these parameters in lessons [8 - Input Parameters](08_lesson.md) and [13 - System Properties](13_lesson.md).

##New Task
Now we can add a new task to our flow. We'll add it right after the `print_start` task and call it `check_address`. Here, since both the flow and the operation are in the same folder, the `do` section does not need to use an alias or path to reference the operation like we needed with the `print` operation in the `print_start` task.

```yaml
    - check_address:
        do:
          check_availability:
            - address
        publish:
          - availability: available
```

First note that in the `check_address` task, the `address` input name is not given an explicit value, as the `text` input is given in the `print_start` task. It's not necessary here because the `address` input name in the `check_availability` operation matches the `address` input name in the flow. The value input to the flow will get passed to the operation input with the same name.

##Publish
Also notice that we've added the `publish` section to this task. This is the spot where we publish the outputs returned from the operation to the flow's scope. In our case, the `check_availability` operation returns an output named `available` and we publish it to the flow's scope under the name `availability`. We'll use the `availability` variable momentarily in an input expression in another of the flow's tasks.


##Input Expression
We'll add one more task to our flow for now to demonstrate the default navigation behavior. This new task calls the `print` operation again to print out whether the email address that was provided is available. We pass a string which contains a Python expression to the `text` input. Note that we are using the published output from the previous task along with some of the flow input variables in the expression.

```yaml
    - print_finish:
        do:
          base.print:
            - text: "'Availability for address ' + address + ' is: ' + str(availability)"
```

Once again take note of the quoting that is necessary. The double quotes (`"`) encompass a Python expression which uses single quotes (`'`) for its string literals and no additional quotes for the variable names.

##Run It
Let's save our files and run the flow and see what happens based on the output and results of the `generate_user_mail` operation. Once again, make sure to run it a few times so we can see what happens when the operation returns a result of `SUCCESS` and what happens when the result is `FAILURE`.

```bash
run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials/base,<folder path>/tutorials/hiring --i address=john.doe@somecompany.com
``` 

When the check\_availability operation returns a result of `SUCCESS` the flow continues with the next task and prints out the availability message. However, when the check\_availability operation returns a result of `FAILURE` the flow ends immediately with a result of `FAILURE`. This is the default navigation behavior.

Note that operations which don't explicitly return any results always return the result `SUCCESS`.

##Up Next
In the next lesson we'll see one way to handle `FAILURE` results.

##New Code - Complete
**new\_hire.sl**
```yaml
namespace: tutorials.hiring

imports:
  base: tutorials.base

flow:
  name: new_hire

  inputs:
    - address

  workflow:
    - print_start:
        do:
          base.print:
            - text: "'Starting new hire process'"

    - check_address:
        do:
          check_availability:
            - address
        publish:
          - availability: available

    - print_finish:
        do:
          base.print:
            - text: "'Availability for address ' + address + ' is: ' + str(availability)"
```
