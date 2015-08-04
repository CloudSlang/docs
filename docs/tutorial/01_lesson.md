#Lesson 1 - Introduction and Setup

##Goal
In this lesson we'll outline our overall goals for this tutorial and set up our environment to write and run flows.

##Overview
In this tutorial we will build a flow that represents the process a new hire must go through to get set up to work. We will build the flow one piece at a time with the goal of highlighting the features of CloudSlang. We recommend you follow along with the process, writing the flows and operations we will build on your own machine and running them using the CloudSlang CLI. To do so, you'll need a text editor to create the CloudSlang files and the CloudSlang CLI to run them.  

##YAML
CloudSlang is a YAML-based language so it's important to know a bit about YAML before getting started. If you're new to YAML, you can take a look at the [YAML Overview](http://www.cloudslang.io/#/docs#yaml-overview) section of the CloudSlang documentation to familiarize yourself with its main structure. This tutorial will also include **YAML Notes** to guide you through potential trouble areas.

##Copy/Pasting Code
Because proper indentation is so important in YAML, take care to copy and paste the code examples at their proper indentation levels. The examples are all written at the indentation within the whole that they are a part of.

##Prerequisites
This tutorial uses the CloudSlang CLI to run flows. See the [CloudSlang CLI](http://www.cloudslang.io/#/docs#cloudslang-cli) section of the documentation for instructions on how to download and run the CLI.

Although CloudSlang files can be composed in any text editor, using a modern code editor with support for YAML syntax highlighting is recommended. See the [Sublime Integration](http://www.cloudslang.io/#/docs#sublime-integration) section of the documentation for instructions on how to download, install and use the CloudSlang snippets for Sublime Text.

##More Information
For more information on any of the topics covered in this tutorial, see the [CloudSlang documentation](http://www.cloudslang.io/#/docs#cloudslang).

##Setup
Now we'll setup our folder structure to get ready to write our flows and operations.

Create a folder named **tutorials**. We'll store our flows and operations in this folder. Since we're going to have some general content as well as content that is specific to our use case, let's create two subfolders under **tutorials** called **base** and **hiring**. 

We'll start off with just one flow and one operation, so create two CloudSlang files. In the **hiring** folder create a file named **new\_hire.sl** and in the **base** folder create a file named **print.sl**. The file **new\_hire.sl** will hold our flow and **print.sl** will hold our first operation.

Your file structure should now look like this:

+ tutorials
    + base
        + print.sl
    + hiring
        + new_hire.sl 

> Note: If your editor requires it for syntax highlighting, you can also use the **.sl.yaml** and **.sl.yml** extensions. 

##Up Next
In the next lesson we'll write and run our first operation.
