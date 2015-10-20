CloudSlang is a [YAML](http://www.yaml.org) (version 1.2) based language for describing a workflow. Using CloudSlang you can easily define a workflow in a structured, easy-to-understand format that can be run by the CloudSlang Orchestration Engine (Score). CloudSlang files can be run by the [CloudSlang CLI](cloudslang_cli.md) or by an embedded instance of Score using the [Slang API](developer_cloudslang.md#slang-api). 

This reference begins with a brief introduction to CloudSlang files and their structure, an alphabetical listing of CloudSlang keywords and concepts, and several examples, including one from which many of the code snippets below are taken.

#CloudSlang Files 
CloudSlang files are written using [YAML](http://www.yaml.org). The recommended extension for CloudSlang files is **.sl**, but **.sl.yaml** and **.sl.yml** will work as well. 

There are two types of CloudSlang files:

+ flow - contains a list of tasks and navigation logic that calls operations or subflows
+ operation - contains an action that runs a script or method

The following properties are for all types of CloudSlang files. For properties specific to [flows](#flow) or [operations](#operation), see their respective sections below.  

Property|Required|Default|Value Type|Description|More Info
---|---|---|---|---
`namespace`|no|-|string|namespace of the flow|[namespace](#namespace)
`imports`|no|-|list of key:value pairs|files to import|[imports](#imports)

The general structure of CloudSlang files is outlined here. Some of the properties that appear are optional. All CloudSlang keywords, properties and concepts are explained in detail below. 

**Flow file**

+ [namespace](#namespace)
+ [imports](#imports)
+ [flow](#flow)
  + [name](#name)
  + [inputs](#inputs)
	  + [required](#required)
	  + [default](#default)
	  + [overridable](#overridable)
	  + [system_property](#system_property)
  + [workflow](#workflow)
    + [task(s)](#task)
      + [do](#do)
      + [publish](#publish)
	    + [fromInputs](#frominputs)
      + [navigate](#navigate) 
    + [iterative task](#iterative-task)
      + [loop](#loop)
        + [for](#for)
        + [do](#do)
        + [publish](#publish)
        + [break](#break)
      + [navigate](#navigate) 
    + [asynchronous task](#asynchronous-task)
      + [async_loop](#async_loop)
        + [for](#for)
        + [do](#do)
        + [publish](#publish)
      + [aggregate](#aggregate)
      + [navigate](#navigate) 
    + [on_failure](#on_failure) 
  + [outputs](#outputs)
    + [fromInputs](#fromInputs)
  + [results](#results)   

**Operations file**

+ [namespace](#namespace)
+ [imports](#imports)
+ [operation](#operation)
  + [name](#name)
  + [inputs](#inputs)
    + [required](#required)
	+ [default](#default)
	+ [overridable](#overridable)
	+ [system_property](#system_property)
  + [action](#action)
  + [outputs](#outputs)
	+ [fromInputs](#fromInputs)
  + [results](#results)   

---

##action
The key `action` is a property of an [operation](#operation).
It is mapped to a property that defines the type of action, which can be a [java_action](#java_action) or [python_script](#python_script).

###java_action
The key `java_action` is a property of [action](#action).  
It is mapped to the properties that define the class and method where the @Action resides.

A `java_action` is a valid @Action that conforms to the method signature: `public Map<String, String> doSomething(paramaters)` and uses the following annotations from `com.hp.oo.sdk.content.annotations`:

+ required annotations:
    - @Param: action parameter
+ optional annotations:
    - @Action: specify action information
    - @Output: action output
    - @Response: action response

**Example - CloudSlang call to  a Java @Action**

```yaml
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
```

```java
public Map<String, String> doMyAction(
        @Param("input1") String input1,
        @Param("input2") String input2) {
    //logic here
    Map<String, String> returnValues = new HashMap<>();
    //prepare return values map
    return returnValues;
}
```

###python_script
The key `python_script` is a property of [action](#action).  
It is mapped to a value containing a Python script.

All variables in scope at the conclusion of the Python script must be serializable. If non-serializable variables are used, remove them from scope by using the `del` keyword before the script exits. 

**Note:** CloudSlang uses the [Jython](http://www.jython.org/) implementation of Python 2.7. For information on Jython's limitations, see the [Jython FAQ](https://wiki.python.org/jython/JythonFaq).

**Example - action with Python script that divides two numbers**

```yaml
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
**Note:** Single-line Python scripts can be written inline with the `python_script` key. Multi-line Python scripts can use the YAML pipe (`|`) indicator as in the example above.

####Importing External Python Packages
There are three approaches to importing and using external Python modules:

+ Installing packages into the **python-lib** folder
+ Editing the executable file
+ Adding the package location to `sys.path` 

**Installing packages into the python-lib folder:**

Prerequisite: **pip** - see **pip**'s [documentation](https://pip.pypa.io/en/latest/installing.html) for how to install. 

1. Edit the **requirements.txt** file in the **python-lib** folder, which is found at the same level as the **bin** folder that contains the CLI executable. 
	+ If not using a pre-built CLI, you may have to create the **python-lib** folder and **requirements.txt** file.
2. Enter the Python package and all its dependencies in the requirements file.
	+ See the **pip** [documentation](https://pip.pypa.io/en/latest/user_guide.html#requirements-files) for information on how to format the requirements file (see example below).
    
3. Run the following command from inside the **python-lib** folder: `pip install -r requirements.txt -t`.

    **Note:** If your machine is behind a proxy you will need to specify the proxy using pip's `--proxy` flag.

4. Import the package as you normally would in Python from within the action's `python_script`:

```yaml
action:
  python_script: |
    from pyfiglet import Figlet
    f = Figlet(font='slant')
    print f.renderText(text)
```

**Example - requirements file**
```
    pyfiglet == 0.7.2
    setuptools
```  

**Note:** If you have defined a `JYTHONPATH` environment variable, you will need to add the **python-lib** folder's path to its value. 

**Editing the executable file**

1. Open the executable found in the **bin** folder for editing.
2. Change the `Dpython.path` key's value to the desired path.
3. Import the package as you normally would in Python from within the action's `python_script`.

**Adding the package location to `sys.path`:**

1. In the action's Pyton script, import the `sys` module.
2. Use `sys.path.append()` to add the path to the desired module.
3. Import the module and use it. 
    
**Example - takes path as input parameter, adds it to sys.path and imports desired module **

```yaml
inputs:
  - path
action:
  python_script: |
    import sys
    sys.path.append(path)
    import module_to_import
    print module_to_import.something()
```

###Importing Python Scripts
To import a Python script in a `python_script` action:

1. Add the Python script to the **python-lib** folder, which is found at the same level as the **bin** folder that contains the CLI executable. 
2. Import the script as you normally would in Python from within the action's `python_script`.

**Note:** If you have defined a `JYTHONPATH` environment variable, you will need to add the **python-lib** folder's path to its value. 

##aggregate
The key `aggregate` is a property of an [asynchronous task](#asynchronous-task) name.
It is mapped to key:value pairs where the key is the variable name to publish to the [flow's](#flow) scope and the value is the aggregation expression.

Defines the aggregation logic for an [asynchronous task](#asynchronous-task), often making us of the [branches_context](#branches_context) construct.

Aggregation is performed after all branches of an [asynchronous task](#asynchronous-task) have completed.

**Example - aggregates all of the published names into name_list**
```yaml
aggregate:
  - name_list: map(lambda x:str(x['name']), branches_context)
```


##async_loop
The key `asyc_loop` is a property of an [asynchronous task's](#asynchronous-task) name.
It is mapped to the [asynchronous task's](#asynchronous-task) properties.

For each value in the loop's list a branch is created and the `do` will run an [operation](#operation) or [subflow](#flow). When all the branches have finished, the [asynchronous task's](#asynchronous-task) [aggregation](#aggregate) and [navigation](#navigate) will run. 

Property|Required|Default|Value Type|Description|More Info
---|
`for`|yes|-|variable `in` list|loop values|[for](#for) 
`do`|yes|-|operation or subflow call|the operation or subflow this task will run in parallel|[do](#do) [operation](#operation) [flow](#flow)
`publish`|no|-|list of key:value pairs|operation or subflow outputs to aggregate and publish to the flow level|[publish](#publish) [aggregate](#aggregate) [outputs](#outputs)

**Example: loop that breaks on a result of custom**
```yaml
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
```

##branches_context
May appear in the [aggregate](#aggregate) section of an [asynchronous task](#asynchronous-task).

As branches of an [async_loop](#async_loop) complete, their published values get placed as a dictionary into the `branches_context` list. The list is therefore in the order the branches have completed. 

A specific value can be accessed using the index representing its branch's place in the finishing order and the name of the variable. 

**Example - retrieves the published name variable from the first branch to finish**

```yaml
aggregate:
  - first_name: branches_context[0]['name']
```

More commonly, the `branches_context` is used to aggregate the values that have been published by all of the branches. 

**Example - aggregates all of the published name values into a list**

```yaml
aggregate:
  - name_list: map(lambda x:str(x['name']), branches_context)
```

##break
The key `break` is a property of a [loop](#loop).
It is mapped to a list of results on which to break out of the loop or an empty list (`[]`) to override the default breaking behavior for a list. When the [operation](#operation) or [subflow](#flow) of the [iterative task](#iterative-task) returns a result in the break's list, the iteration halts and the [interative task's](#iterative-task) [navigation](#navigate) logic is run. 

If the `break` property is not defined, the loop will break on results of `FAILURE` by default. This behavior may be overriden so that iteration will continue even when a result of `FAILURE` is returned by defining alternate break behavior or mapping the `break` key to an empty list (`[]`). 

**Example - loop that breaks on result of CUSTOM **

```yaml
loop:
  for: value in range(1,7)
  do:
    custom_op:
      - text: value
  break:
    - CUSTOM
navigate:
  CUSTOM: print_end
```

**Example - loop that continues even on result of FAILURE **

```yaml
loop:
  for: value in range(1,7)
  do:
    custom_op:
      - text: value
  break: []
```

##default
The key `default` is a property of an [input](#inputs) name.
It is mapped to an expression value.

The expression's value will be passed to the [flow](#flow) or [operation](#operation) if no other value for that [input](#inputs) parameter is explicitly passed or if the input's [overridable](#overridable) parameter is set to `false` and there is no [system_properties](#system_property) parameter defined.   

**Example - default values **

```yaml
inputs:
  - str_literal:
	  default: "'default value'"
  - int_exp:
      default: '5 + 6'
  - from_variable:
	  default: variable_name
```

A default value can also be defined inline by entering it as the value to the [input](#inputs) parameter's key.

**Example - inline default values**
```yaml
inputs:
  - str_literal: "'default value'"
  - int_exp: '5 + 6'
  - from_variable: variable_name
```

##do
The key `do` is a property of a [task](#task) name, a [loop](#loop), or an [async_loop](#async_loop).
It is mapped to a property that references an [operation](#operation) or [flow](#flow).

Calls an [operation](#operation) or [flow](#flow) and passes in relevant [input](#inputs). The [operation](#operation) or [flow](#flow) may be called by its qualified name using an alias created in the [imports](#imports) parameter.

Arguments may be passed to a [task](#task) in one of two ways:

+ list of argument names and optional mapped expressions
+ comma-separated `argument_name = optional_expression` pairs 
 
Expression values will supersede values bound to flow [inputs](#inputs) with the same name. 

**Example - call to a divide operation with list of mapped task arguments**
```yaml
do:
  divide:
    - dividend: input1
    - divisor: input2
```

**Example - call to a divide operation with comma-separated pairs**
```yaml
do:
  divide: dividend = input1, divisor = input2
```

##flow
The key `flow` is mapped to the properties which make up the flow contents.

A flow is the basic executable unit of CloudSlang. A flow can run on its own or it can be used by another flow in the [do](#do) property of a [task](#task).


Property|Required|Default|Value Type|Description|More Info
---|---|---|---|---|---
`name`|yes|-|string|name of the flow|[name](#name)
`inputs`|no|-|list|inputs for the flow|[inputs](#inputs)
`workflow`|yes|-|map of tasks|container for set of tasks|[workflow](#workflow)
`outputs`|no|-|list|list of outputs|[outputs](#outputs)
`results`|no|(`SUCCESS`/`FAILURE`)|list|possible results of the flow|[results](#results)

**Example - a flow that performs a division of two numbers**

```yaml
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
```

##for
The key `for` is a property of a [loop](#loop) or an [async_loop](#async_loop).

###loop: for

A for loop iterates through a [list](#iterating-through-a-list) or a [map](#iterating-through-a-map).

The [iterative task](#iterative-task) will run once for each element in the list or key in the map. 

####Iterating through a list
When iterating through a list, the `for` key is mapped to an iteration variable followed by `in` followed by a list, an expression that evaluates to a list, or a comma delimited string.

**Example - loop that iterates through the values in a list**

```yaml
- print_values:
    loop:
      for: value in [1,2,3]
      do:
        print:
          - text: value
```

**Example - loop that iterates through the values in a comma delimited string**

```yaml
- print_values:
    loop:
      for: value in "1,2,3"
      do:
        print:
          - text: value
```

**Example - loop that iterates through the values returned from an expression**

```yaml
- print_values:
    loop:
      for: value in range(1,4)
      do:
        print:
          - text: value
```

####Iterating through a map
When iterating through a map, the `for` key is mapped to iteration variables for the key and value followed by `in` followed by a map or an expression that evaluates to a map.

**Example - task that iterates through the values returned from an expression**

```yaml
- print_values:
    loop:
      for: k, v in map
      do:
        print2:
          - text1: k
          - text2: v
```

###async_loop: for

An asynchronous for loops in parallel branches over the items in a list.

The [asynchronous task](#asynchronous-task) will run one branch for each element in the list. 

The `for` key is mapped to an iteration variable followed by `in` followed by a list or an expression that evaluates to a list.

**Example - task that asynchronously loops through the values in a list**

```yaml
- print_values:
    async_loop:
      for: value in values_list
      do:
        print_branch:
          - ID: value
```

##fromInputs
May appear in the value of an [output](#outputs) or [publish](#publish).

Special syntax to refer to an [input](#inputs) parameter as opposed to another variable with the same name in a narrower scope.

**Example - output "input1" as it was passed in**

```yaml
outputs:
  - output1: fromInputs['input1']
```

**Example - usage in publish to refer to a variable in the flow's scope**

```yaml
publish:
  - total_cost: fromInputs['total_cost'] + cost
```

##get
May appear in the value of an [input](#inputs), [output](#outputs), [publish](#publish) or [loop expression](#for).

The function in the form of `get('key', 'default_value')` returns the value associated with `key` if the key is defined and its value is not `None`. If the key is undefined or its value is `None` the function returns the `default_value`.

**Example - usage of get function in inputs and outputs**

```yaml
inputs:
  - input1:
      required: false
  - input1_safe:
      default: get('input1', 'default_input')
      overridable: false
      required: false
workflow:
  - task1:
      do:
        print:
          - text: input1_safe
      publish:
        - some_output: get('output1', 'default_output')
outputs:
  - some_output
```

##imports
The key `imports` is mapped to the files to import as follows:  

+ key - alias 
+ value - namespace of file to be imported

Specifies the file's dependencies and the aliases they will be referenced by in the file.

**Example - import operations and sublflow into flow**
```yaml
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
```

##inputs
The key `inputs` is a property of a [flow](#flow) or [operation](#operation).
It is mapped to a list of input names. Each input name may in turn be mapped to its properties.   

Inputs are used to pass parameters to [flows](#flow) or [operations](#operation).

Input properties may also be used in the input list of a [task](#task). 

Property|Required|Default|Value Type|Description|More info
---|
`required`|no|true|boolean|is the input required|[required](#required)
`default`|no|-|expression|default value of the input|[default](#default)
`overridable`|no|true|boolean|if false, the default value always overrides values passed in|[overridable](#overridable)
`system_properties`|no|-|string|the name of a system property variable|[system_property](#system_property)

**Example - two inputs**

```yaml
inputs:
  - input1:
      default: "'default value'"
      overridable: false
  - input2
```

##loop
The key `loop` is a property of an [iterative task's](#iterative-task) name.
It is mapped to the [iterative task's](#iterative-task) properties.

For each value in the loop's list the `do` will run an [operation](#operation) or [subflow](#flow). If the returned result is in the `break` list, or if `break` does not appear and the returned result is `FAILURE`, or if the list has been exhausted, the task's navigation will run. 

Property|Required|Default|Value Type|Description|More Info
---|
`for`|yes|-|variable `in` list or key, value `in` map|iteration logic|[for](#for) 
`do`|yes|-|operation or subflow call|the operation or subflow this task will run iteratively|[do](#do) [operation](#operation) [flow](#flow)
`publish`|no|-|list of key:value pairs|operation or subflow outputs to aggregate and publish to the flow level|[publish](#publish) [outputs](#outputs)
`break`|no|-|list of [results](#result)|operation or subflow [results](#result) on which to break out of the loop|[break](#break)

**Example: loop that breaks on a result of custom**
```yaml
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
```

##name
The key `name` is a property of [flow](#flow) and [operation](#operation).
It is mapped to a value that is used as the name of the [flow](#flow) or [operation](#operation).

The name of a [flow](#flow) or [operation](#operation) may be used when called from a [flow](#flow)'s [task](#task). 

**Example - naming the flow _division_flow_**

```yaml
name: division_flow
```

##namespace
The key `namespace` is mapped to a string value that defines the file's namespace.

The namespace of a file  may be used by other CloudSlang files to [import](#imports) dependencies, such as a flow importing operations.

**Example - definition a namespace**

```yaml
namespace: examples.hello_world
```

**Example - using a namespace in an imports definition**

```yaml
imports:
  ops: examples.hello_world
```

**Note:** If the imported file resides in a folder that is different from the folder in which the importing file resides, the imported file's directory must be added using the `--cp` flag when running from the CLI (see [Run with Dependencies](cloudslang_cli.md#run-with-dependencies)). 

##navigate
The key `navigate` is a property of a [task](#task) name.
It is mapped to key:value pairs where the key is the received [result](#results) and the value is the target [task](#task) or [flow](#flow) [result](#results).

Defines the navigation logic for a [standard task](#standard-task), an [iterative task](#iterative-task) or an [asynchronous task](#asynchronous-task). The flow will continue with the [task](#task) or [flow](#flow) [result](#results) whose value is mapped to the [result](#results) returned by the called [operation](#operation) or [subflow](#flow). 

The default navigation is `SUCCESS` except for the [on_failure](#on_failure) [task](#task) whose default navigation is `FAILURE`. All possible [results](#results) returned by the called [operation](#operation) or subflow must be handled.

For a [standard task](#standard-task) the navigation logic runs when the [task](#task) is completed. 

For an [iterative task](#iterative-task) the navigation logic runs when the last iteration of the [task](#task) is completed or after exiting the iteration due to a [break](#break).

For an [asynchronous task](#asynchronous-task) the navigation logic runs after the last branch has completed. If any of the branches returned a [result](#results) of `FAILURE`, the [flow](#flow) will navigate to the [task](#task) or [flow](#flow) [result](#results) mapped to `FAILURE`. Otherwise, the [flow](#flow) will navigate to the [task](#task) or [flow](#flow) [result](#results) mapped to `SUCCESS`. Note that the only [results](#results) of an [operation](#operation) or [subflow](#flow) called in an [async_loop](#async_loop) that are evaluated are `SUCCESS` and `FAILURE`. Any other results will be evaluated as `SUCCESS`.

**Example - ILLEGAL result will navigate to flow's FAILURE result and SUCCESS result will navigate to task named _printer_**
```yaml
navigate:
  ILLEGAL: FAILURE
  SUCCESS: printer
```

##on_failure
The key `on_failure` is a property of a [workflow](#workflow).
It is mapped to a [task](#task).

Defines the [task](#task), which when using default [navigation](#navigation), is the target of a `FAILURE` [result](#results) returned from an [operation](#operation) or [flow](#flow). The `on_failure` [task's](#task) [navigation](#navigate) defaults to `FAILURE`.

**Example - failure task which call a print operation to print an error message**
```yaml
- on_failure:
  - failure:
      do:
        print:
          - text: error_msg
```

##operation
The key `operation` is mapped to the properties which make up the operation contents.

Property|Required|Default|Value Type|Description|More Info
---|
inputs|no|-|list|operation inputs|[inputs](#inputs)
action|yes|-|`python_script` or `java_action`|operation logic|[action](#action)
outputs|no|-|list|operation outputs|[outputs](#outputs)
results|no|`SUCCESS`|list|possible operation results|[results](#results)


**Example - operation that adds two inputs and outputs the answer**

```yaml
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
```

##outputs
The key `outputs` is a property of a [flow](#flow) or [operation](#operation).
It is mapped to a list of output variable names which may also contain expression values. Output expressions must evaluate to strings. 

Defines the parameters a  [flow](#flow) or [operation](#operation) exposes to possible [publication](#publish) by a [task](#task). The calling [task](#task) refers to an output by its name.

See also [fromInputs](#fromInputs).

**Example - various types of outputs**

```yaml
outputs:
  - existing_variable
  - output2: some_variable
  - output3: 5 + 6
  - output4: fromInputs['input1']
```


##overridable
The key `overridable` is a property of an [input](#inputs) name.
It is mapped to a boolean value.

A value of `false` will ensure that the [input](#inputs) parameter's [default](#default) value will not be overridden by values passed into the [flow](#flow) or [operation](#operation). If `overridable` is not defined, values passed in will override the [default](#default) value.

**Example - default value of text input parameter will not be overridden by values passed in**

```yaml
inputs:
  - text:
      default: "'default text'"
      overridable: false
```

##publish
The key `publish` is a property of a [task](#task) name, a [loop](#loop) or an [async_loop](#async_loop).
It is mapped to a list of key:value pairs where the key is the published variable name and the value is the name of the [output](#outputs) received from an [operation](#operation) or [flow](#flow).

###Standard publish
In a [standard task](#standard-task), `publish` binds the [output](#outputs) from an [operation](#operation) or [flow](#flow) to a variable whose scope is the current [flow](#flow) and can therefore be used by other [tasks](#task) or as the [flow's](#flow) own [output](#outputs).

**Example - publish the quotient output as ans**
```yaml
- division1:
    do:
      division:
        - input1: dividend1
        - input2: divisor1
    publish:
      - ans: quotient
```

###Iterative publish
In an [iterative task](#iterative-task) the publish mechanism is run during each iteration after the [operation](#operation) or [subflow](#flow) has completed, therefore allowing for aggregation.

**Example - publishing in an iterative task to aggregate output**
```yaml
- aggregate:
    loop:
      for: value in range(1,6)
      do:
        print:
          - text: value
      publish:
        - sum: fromInputs['sum'] + out
```

###Asynchronous publish
In an [asynchronous task](#asynchronous-task) the publish mechanism is run during each branch after the [operation](#operation) or [subflow](#flow) has completed. Published variables and their values are added as a dictionary to the [branches_context](#branches_context) list in the order they are received from finished branches, allowing for aggregation.

**Example - publishing in an iterative task to aggregate output**
```yaml
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
```

##results
The key `results` is a property of a [flow](#flow) or [operation](#operation).

The results of a [flow](#flow) or [operation](#operation) can be used by the calling [task](#task) for [navigation](#navigate) purposes.

**Note:** the only results of an [operation](#operation) or [subflow](#flow) called in an [async_loop](#async_loop) that are evaluated are `SUCCESS` and `FAILURE`. Any other results will be evaluated as `SUCCESS`.


###Flow results
In a [flow](#flow), the key `results` is mapped to a list of result names. 

Defines the possible results of the [flow](#flow). By default a [flow](#flow) has two results, `SUCCESS` and `FAILURE`.  The defaults can be overridden with any number of user-defined results. 

When overriding, the defaults are lost and must be redefined if they are to be used. 

All result possibilities must be listed. When being used as a subflow all [flow](#flow) results must be handled by the calling [task](#task). 

**Example - a user-defined result**

```yaml
results:
  - SUCCESS
  - ILLEGAL
  - FAILURE
```

###Operation results
In an [operation](#operation) the key `results` is mapped to a list of key:value pairs of result names and boolean expressions. 

Defines the possible results of the [operation](#operation). By default, if no results exist, the result is `SUCCESS`.  The first result in the list whose expression evaluates to true, or does not have an expression at all, will be passed back to the calling [task](#task) to be used for [navigation](#navigate) purposes.  

All [operation](#operation) results must be handled by the calling [task](#task). 

**Example - three user-defined results**
```yaml
results:
  - POSITIVE: polarity == '+'
  - NEGATIVE: polarity == '-'
  - NEUTRAL
```

##required
The key `required` is a property of an [input](#inputs) name.
It is mapped to a boolean value.

A value of `false` will allow the [flow](#flow) or [operation](#operation) to be called without passing the [input](#inputs) parameter. If `required` is not defined, the [input](#inputs) parameter defaults to being required. 

**Example - input2 is optional**

```yaml
inputs:
  - input1
  - input2:
      required: false
```

##system_property
The key `system_property` is a property of an [input](#inputs) name.
It is mapped to a string of a key from a system properties file.

The value referenced from a system properties file will be passed to the [flow](#flow) or [operation](#operation) if no other value for that [input](#inputs) parameter is explicitly passed in or if the input's [overridable](#overridable) parameter is set to `false`.  

**Note:** If multiple system properties files are being used and they contain a system property with the same fully qualified name, the property in the file that is loaded last will overwrite the others with the same name.  

**Example - system properties **

```yaml
inputs:
  - host:
      system_property: examples.sysprops.hostname
  - port:
      system_property: examples.sysprops.port
```

To pass a system properties file to the CLI, see [Run with System Properties](cloudslang_cli.md#run-with-system-properties).

##task
A name of a task which is a property of [workflow](#workflow) or [on_failure](#on_failure).

There are several types of tasks:

+ [standard](#standard-task) 
+ [iterative](#iterative-task)
+ [asynchronous](#asynchronous-task)

###Standard Task
A standard task calls an [operation](#operation) or [subflow](#flow) once.

The task name is mapped to the task's properties.

Property|Required|Default|Value Type|Description|More Info
---|---
`do`|yes|-|operation or subflow call|the operation or subflow this task will run|[do](#do) [operation](#operation) [flow](#flow)
`publish`|no|-|list of key:value pairs|operation outputs to publish to the flow level|[publish](#publish) [outputs](#outputs)
`navigate`|no|`FAILURE`: on_failure or flow finish; `SUCCESS`: next task|key:value pairs| navigation logic from operation or flow results|[navigation](#navigate) [results](#results)

**Example - task that performs a division of two inputs, publishes the answer and navigates accordingly**

```yaml
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
```

###Iterative Task
An iterative task calls an [operation](#operation) or [subflow](#flow) iteratively, for each value in a list.

The task name is mapped to the iterative task's properties.

Property|Required|Default|Value Type|Description|More Info
---|---
`loop`|yes|-|key|container for loop properties|[for](#for)
`navigate`|no|`FAILURE`: on_failure or flow finish; `SUCCESS`: next task|key:value pairs| navigation logic from [break](#break) or the result of the last iteration of the operation or flow|[navigation](#navigate) [results](#results)

**Example - task prints all the values in value_list and then navigates to a task named "another_task"**

```yaml
- print_values:
    loop:
      for: value in value_list
      do:
        print:
          - text: value
    navigate:
      SUCCESS: another_task
      FAILURE: FAILURE
```

###Asynchronous Task
An asynchronous task calls an [operation](#operation) or [subflow](#flow) asynchronously, in parallel branches, for each value in a list.

The task name is mapped to the asynchronous task's properties.

Property|Required|Default|Value Type|Description|More Info
---|---
`async_loop`|yes|-|key|container for async loop properties|[async_loop](#async_loop)
`aggregate`|no|-|list of key:values|values to aggregate from async branches|[aggregate](#aggregate)
`navigate`|no|`FAILURE`: on_failure or flow finish; `SUCCESS`: next task|key:value pairs| navigation logic|[navigation](#navigate) [results](#results)

**Example - task prints all the values in value_list asynchronously and then navigates to a task named "another_task"**

```yaml
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
```

##workflow
The key `workflow` is a property of a [flow](#flow).
It is mapped to a list of the workflow's [tasks](#task).

Defines a container for the [tasks](#task), their [published variables](#publish) and [navigation](#navigate) logic.

The first [task](#task) in the workflow is the starting [task](#task) of the flow. From there the flow continues sequentially by default upon receiving [results](#results) of `SUCCESS`, to the flow finish or to [on_failure](#on_failure) upon a [result](#results) of `FAILURE`, or following whatever overriding [navigation](#navigate) logic that is present.

Propery|Required|Default|Value Type|Description|More Info
---|
`on_failure`|no|-|task|default navigation target for `FAILURE`|[on_failure](#on_failure) [task](#task)

**Example - workflow that divides two numbers and prints them out if the division was legal**

```yaml
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
```
