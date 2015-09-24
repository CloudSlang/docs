#Lesson 2 - First Operation

##Goal
In this lesson we'll write our first operation. We'll learn the basic structure of a simple operation by writing one that simply prints out a message.

##Get Started
Let's open the **print.sl** file and start writing the print operation. The print operation is as simple as they get. It just takes in a input and prints it out using Python.

##Namespace
All CloudSlang files start with a namespace which mirrors the folder structure in which the files are found. In our case we've put **print.sl** in the **tutorials/base** folder so our namespace should reflect that.

```yaml
namespace: tutorials.base
``` 

##Operation Name
Each operation begins with the `operation` key which will map to the contents of the operation body. The first part of that body is a key:value pair defining the name of the operation. The name of the operation must be the same as the name of the file it is stored in.

```yaml
operation:
  name: print
```

>YAML Note: Indentation is **very** important in YAML. It is used to indicate scope. In the example above, you can see that `name: print` is indented under the `operation` key to denote that it belongs to the operation. Always use spaces to indent. **Never** use tabs. 

##Inputs
After the name, if the operation takes any inputs, they are listed under the `inputs` key. In our case we'll need to take in the text we want to print. We'll name our input `text`.

```yaml
  inputs:
    - text
```

> YAML Note: The `inputs` key maps to a list of inputs. In YAML, a list is signified by prepending a hypen and a space (- ) to each item.

##Action
Finally, we've reached the core of the operation, the action. There are two types of actions in CloudSlang, Python-based actions and Java-based actions. We'll start off by creating a Python action that simply prints the text that was input. To do so, we add an `action` key that maps to the action contents. Since our action is a python script we add a key:value pair with `python_script` as the key and the script itself as the value.

```yaml
  action:
    python_script: print text
```

**Note:** CloudSlang uses the [Jython](http://www.jython.org/) implementation of Python 2.7. For information on Jython's limitations, see the [Jython FAQ](https://wiki.python.org/jython/JythonFaq).

##Run It
That's it. Our operation is all ready. Our next step will be to create a flow that uses the operation we just wrote, but we can actually just run the operation as is.

To do so, save the operation file, fire up the CloundSlang CLI and enter the following at the prompt to run your operation:

```bash
run --f <folder path>/tutorials/base/print.sl --i text=Hi
``` 

You should see the input text printed out to the screen.

##Up Next
In the next lesson we'll write a flow that will call the print operation.

##New Code - Complete
**print.sl**
```yaml
namespace: tutorials.base

operation:
  name: print

  inputs:
    - text

  action:
    python_script: print text
```
