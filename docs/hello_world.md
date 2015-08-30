The following is a simple example to give you an idea of how CloudSlang is structured and can be used to ensure your environment is set up properly to run flows. 

#Prerequisites
This example uses the CloudSlang CLI to run a flow. See the [CloudSlang CLI](cloudslang_cli.md) section for instructions on how to download and run the CLI.

Although CloudSlang files can be composed in any text editor, using a modern code editor with support for YAML syntax highlighting is recommended. See [Sublime Integration](sublime_integration.md) for instructions on how to download, install and use the CloudSlang snippets for [Sublime Text](http://www.sublimetext.com/).    

#Code files
In a new folder, create two new CloudSlang files, hello_world.sl and print.sl, and copy the code below.

**hello_world.sl**
```yaml
namespace: examples.hello_world

flow:
  name: hello_world
  workflow:
    - sayHi:
        do:
          print:
            - text: 'Hello, World'
```
**print.sl**
```yaml
namespace: examples.hello_world

operation:
  name: print
  inputs:
    - text
  action:
    python_script: print text
  results:
    - SUCCESS
```

#Run
Start the CLI from the folder in which your CloudSlang files reside and enter `run hello_world.sl` at the `cslang>` prompt. 

The output will look similar to this:
```bash
- sayHi
Hello, World
Flow : hello_world finished with result : SUCCESS
Execution id: 101600001, duration: 0:00:00.790
```

#Explanation
The CLI runs the [flow](cloudslang_dsl_reference.md#flow) in the file we have passed to it, namely **hello_world.sl**. The [flow](cloudslang_dsl_reference.md#flow) begins with an [import](cloudslang_dsl_reference.md#imports) of the operations file, **print.sl**, using its [namespace](cloudslang_dsl_reference.md#namespace) as the value for the [imports](cloudslang_dsl_reference.md#imports) key. Next, we enter the [flow](cloudslang_dsl_reference.md#flow) named `hello_world` and begin its [workflow](cloudslang_dsl_reference.md#workflow). The [workflow](cloudslang_dsl_reference.md#workflow) has one [task](cloudslang_dsl_reference.md#task) named `sayHi` which calls the `print` [operation](cloudslang_dsl_reference.md#operation) from the operations file that was imported. The [flow](cloudslang_dsl_reference.md#flow) passes the string `'Hello, World'` to the `print` [operation's](cloudslang_dsl_reference.md#operation) `text` [input](cloudslang_dsl_reference.md#inputs). The print [operation](cloudslang_dsl_reference.md#operation) performs its [action](cloudslang_dsl_reference.md#action), which is a simple Python script that prints the [input](cloudslang_dsl_reference.md#inputs), and then returns a [result](cloudslang_dsl_reference.md#results) of `SUCCESS`. Since the flow does not contain any more [tasks](cloudslang_dsl_reference.md#task) the [flow](cloudslang_dsl_reference.md#flow) finishes with a [result](cloudslang_dsl_reference.md#results) of `SUCCESS`.

#More
For a more comprehensive walkthrough of the CloudSlang language's features, see the [New Hire tutorial](http://cloudslang-tutorials.readthedocs.org).