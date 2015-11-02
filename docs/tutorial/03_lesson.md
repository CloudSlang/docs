#Lesson 3 - First Flow

##Goal
In this lesson we'll write a simple flow that will call the print operation. We'll learn about the main components that make up a flow.

##Get Started
Let's open the **new_hire.sl** file and start writing the new hire flow. We'll build it one step at a time. So for now, all it will do is call the print operation we wrote in the previous lesson.

##Namespace
Just like in our operation file, we need to start the flow file with a namespace. Since we're storing **new_hire.sl** in the **tutorials/hiring** folder the namespace must reflect that.

```yaml
namespace: tutorials.hiring
```

##Imports
After the namespace you can list the namespace of any CloudSlang files that you will need to reference in your flow. Our flow will need to reference the operation in **print.sl**, so we'll add the namespace from that file to the optional `imports` key.  We map an alias that we will use as a reference in the flow to the namespace we are importing. Let's call the alias `base`.

```yaml
imports:
  base: tutorials.base
``` 

For ways to refer to an operation or subflow without creating an alias, see the [CloudSlang DSL Reference](../cloudslang_dsl_reference.md#do). 

##Flow Name
Each flow begins with the `flow` key which will map to the contents of the flow body. The first part of that body is a key:value pair defining the name of the flow. The name of the flow must be the same as the name of the file it is stored in.

```yaml
flow:
  name: new_hire
```

##Tasks
The next part of our flow will be the workflow. The `workflow` key maps to a list of all the tasks in the flow. We'll start off with just one task, the one that calls our print operation. Each task in a workflow starts with a key that is its name. We'll call our task `print_start`.

```yaml
  workflow:
    - print_start:
```  

A task can contain several parts, but we'll start with a simple task with the only required part, the `do` key. We want to call the print operation. In this case we'll reference it using the alias we created up in the flow's `imports` section. Also, we'll have to pass any required inputs to the operation. In our case, there's one input named `text` which we'll add to a list under the operation call and pass it a value.

```yaml
        do:
          base.print:
            - text: "'Starting new hire process'"
```
Notice the use of both single quotes (`'`) and double quotes (`"`) around the string input value. Both are required, although which pair are on the inside and which are on the outside generally doesn't make a difference. Both pairs are needed to denote that a Python string is inside of a YAML string.

In addition to the required `do`, a task can also contain the optional `publish` and `navigate` keys. We begin to use their functionality in lessons [5 - Default Navigation](05_lesson.md) and [7 - Custom Navigation](07_lesson.md) respectively.

##Run It
Now our flow is all ready to run. To do so, save the file and enter the following at the prompt.

```bash
run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials/base
``` 

> Note: The --cp flag is used to add folders where the flow's dependencies are found to the classpath.

You should see the name of the task and the string sent to the print operation printed to the screen.

##Up Next
In the next lesson we'll write a more complex operation that also returns outputs and results.

##New Code - Complete
**new\_hire.sl**
```yaml
namespace: tutorials.hiring

imports:
  base: tutorials.base

flow:
  name: new_hire

  workflow:
    - print_start:
        do:
          base.print:
            - text: "'Starting new hire process'"
```
