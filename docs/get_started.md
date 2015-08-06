It's easy to get started running CloudSlang flows, especially using the CLI and ready-made content.

# Download, Unzip and Run

+ [Download](http://cloudslang.io/download) the CLI zip file. 
+ Unzip the archive.
+ Run the CloudSlang executable. 
+ At the prompt enter: 
  
```bash
run --f ../content/io/cloudslang/base/print/print_text.sl --i text=Hi
```

+ The CLI will run the ready-made `print_text` operation that will print the value passed to the variable `text` to the screen.

# Docker

+ docker pull cloudslang/cloudslang
+ docker run -it cloudslang/cloudslang
+ At the prompt enter: 
  
```bash
run --f ../content/io/cloudslang/base/print/print_text.sl --i text=Hi
```

+ The CLI will run the ready-made `print_text` operation that will print the value passed to the variable `text` to the screen.


# Next Steps

Now that you've run your first CloudSlang file, you might want to:

+ Learn how to write a print operation yourself using the [Hello World example](hello_world.md).
+ Learn about the language features using the [New Hire Tutorial](tutorial/01_lesson).
+ Learn about the language in detail using the [CloudSlang Reference](cloudslang_dsl_reference.md).
+ See an [overview](https://github.com/CloudSlang/cloud-slang-content/blob/master/DOCS.md) of the ready-made content.
+ Browse the ready-made content [repository](https://github.com/CloudSlang/cloud-slang-content).
+ Learn about embedding [CloudSlang](developer_cloudslang.md) or the [CloudSlang Orchestration Engine](developer_score.md) into your existing application.
+ Learn about the [architecture](developer_architecture.md) of CloudSlang and the CloudSlang Orchestration Engine.

