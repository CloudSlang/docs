#Embedded CloudSlang 
CloudSlang content can be run from inside an existing Java application using Maven and Spring by embedding the CloudSlang Orchestration Engine (Score) and interacting with it through the [Slang API](#slang-api). 

##Embed CloudSlang in a Java Application

+ Add the Score and CloudSlang dependencies to the project's pom.xml file in the `<dependencies>` tag.
  
```xml
<dependency>
  <groupId>io.cloudslang</groupId>
  <artifactId>score-all</artifactId>
  <version>0.2.2</version>
</dependency>

<dependency>
  <groupId>io.cloudslang.lang</groupId>
  <artifactId>cloudslang-all</artifactId>
  <version>0.8.0.1</version>
</dependency>

<dependency>
  <groupId>com.h2database</groupId>
  <artifactId>h2</artifactId>
  <version>1.3.175</version>
</dependency>
```

+ Add Score and CloudSlang configuration to your Spring application context xml file.
  
```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:score="http://www.cloudslang.io/schema/score"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                        http://www.springframework.org/schema/beans/spring-beans.xsd
                        http://www.cloudslang.io/schema/score
                        http://www.cloudslang.io/schema/score.xsd">

<bean class="io.cloudslang.lang.api.configuration.SlangSpringConfiguration"/>

  <score:engine />

  <score:worker uuid="-1"/>

</beans>
```

+ Get the Slang bean from the application context xml file and interact with it using the [Slang API](#/docs#slang-api).

```java
ApplicationContext applicationContext =
                new ClassPathXmlApplicationContext("/META-INF/spring/cloudSlangContext.xml");

Slang slang = applicationContext.getBean(Slang.class);

slang.subscribeOnAllEvents(new ScoreEventListener() {
    @Override
    public void onEvent(ScoreEvent event) {
        System.out.println(event.getEventType() + " : " + event.getData());
    }
});
```

#Slang API
The Slang API allows a program to interact with the CloudSlang Orchestration Engine (Score) using content authored in CloudSlang. What follows is a brief discussion of the API using a simple example that compiles and runs a flow while listening for the events that are fired during the run.

##Example
###Code
**Java Class - CloudSlangEmbed.java**

```Java
package io.cloudslang.example;

import io.cloudslang.score.events.ScoreEvent;
import io.cloudslang.score.events.ScoreEventListener;
import io.cloudslang.lang.api.Slang;
import io.cloudslang.lang.compiler.SlangSource;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.io.File;
import java.io.IOException;
import java.io.Serializable;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

public class CloudSlangEmbed {
    public static void main(String[] args) throws URISyntaxException, IOException{
        ApplicationContext applicationContext =
                new ClassPathXmlApplicationContext("/META-INF/spring/cloudSlangContext.xml");

        Slang slang = applicationContext.getBean(Slang.class);

        slang.subscribeOnAllEvents(new ScoreEventListener() {
            @Override
            public void onEvent(ScoreEvent event) {
                System.out.println(event.getEventType() + " : " + event.getData());
            }
        });

        File flowFile = getFile("/content//hello_world.sl");
        File operationFile = getFile("/content/print.sl");

        Set<SlangSource> dependencies = new HashSet<>();
        dependencies.add(SlangSource.fromFile(operationFile));

        HashMap<String, Serializable> inputs = new HashMap<>();
        inputs.put("input1", "Hi. I'm inside this application.\n-CloudSlang");

        slang.compileAndRun(SlangSource.fromFile(flowFile), dependencies, inputs, 
                new HashMap<String, Serializable>());
    }

    private static File getFile(String path) throws URISyntaxException {
        return new File(CloudSlangEmbed.class.getResource(path).toURI());
    }
}
```

**Flow - hello_world.sl**

```yaml
namespace: resources.content

imports:
  ops: resources.content

flow:
  name: hello_world

  inputs:
    - input1

  workflow:
    - sayHi:
        do:
          ops.print:
            - text: input1
```
**Operation - print.sl**
```yaml
namespace: resources.content

operation:
  name: print
  inputs:
    - text
  action:
    python_script: print text
  results:
    - SUCCESS
```

###Discussion
The program begins by creating the Spring application context and getting the Slang bean. In general, most of the interactions with Score are transmitted through the reference to this bean.
 
```java
ApplicationContext applicationContext =
          new ClassPathXmlApplicationContext("/META-INF/spring/cloudSlangContext.xml");

Slang slang = applicationContext.getBean(Slang.class);
```
  
Next, the `subscribeOnAllEvents` method is called and passed a new `ScoreEventListener` to listen to all the [Score](developer_score.md#score-events) and [Slang events](#slang-events) that are fired. 
  
```java
slang.subscribeOnAllEvents(new ScoreEventListener() {
    @Override
    public void onEvent(ScoreEvent event) {
        System.out.println(event.getEventType() + " : " + event.getData());
    }
});
```
  
The `ScoreEventListener` interface defines only one method, the `onEvent` method. In this example the `onEvent` method is overridden to print out the type and data of all events it receives. It can, of course, be overridden to do other things. 
  
The API also contains a method `subscribeOnEvents`, which takes in a set of the event types to listen for and a method `unSubscribeOnEvents`, which unsubscribes the listener from all the events it was listening for.

Next,  the two content files, containing a flow and an operation respectively, are loaded into `File` objects. 
  
```java
File flowFile = getFile("/content//hello_world.sl");
File operationFile = getFile("/content/print.sl");
```

These `File` objects will be used to create the two `SlangSource` objects needed to compile and run the flow and its operation. 

A `SlangSource` object is a representation of source code written in CloudSlang along with the source's name. The `SlangSource` class exposes several `static` methods for creating new `SlangSource` objects from files, URIs or arrays of bytes.      

Next, a set of dependencies is created and the operation is added to the set. 

```java
Set<SlangSource> dependencies = new HashSet<>();
dependencies.add(SlangSource.fromFile(operationFile));
```

A flow containing many operations or subflows would need all of its dependencies loaded into the dependency set.

Next, a map of input names to values is created. The input names are as they appear under the `inputs` key in the flow's CloudSlang file. 

```java
HashMap<String, Serializable> inputs = new HashMap<>();
inputs.put("input1", "Hi. I'm inside this application.\n-CloudSlang");
```

Finally, the flow is compiled and run by providing its `SlangSource`, dependencies, inputs and an empty map of system properties. 

```java
slang.compileAndRun(SlangSource.fromFile(flowFile), dependencies,
        inputs, new HashMap<String, Serializable>());
```

An operation can be compiled and run in the same way. 

Although we compile and run here in one step, the process can be broken up into its component parts. The `Slang` interface exposes a method to compile a flow or operation without running it. That method returns a `CompliationArtifact` which can then be run with a call to the `run` method.

A `CompilationArtifact` is composed of a Score `ExecutionPlan`, a map of dependency names to their `ExecutionPlan`s and a list of CloudSlang `Input`s. 

A CloudSlang `Input` contains its name, expression and the state of all its input properties (e. g. required).

#Slang Events
CloudSlang uses [Score events](developer_score.md#score-events) and its own extended set of Slang events. Slang events are comprised of an event type string and a map of event data that contains all the relevant event information mapped to keys defined in the 
`org.openscore.lang.runtime.events.LanguageEventData` class. All fired events are logged in the [execution log](cloudslang_cli.md#execution-log) file.

Event types from CloudSlang are listed in the table below along with the event data each event contains. 

All Slang events contain the data in the following list. Additional event data is listed in the table below alongside the event type. The event data map keys are enclosed in square brackets - [KEYNAME].

- [DESCRIPTION] - event description
- [TIMESTAMP] - event time-stamp
- [EXECUTIONID] - event execution id
- [PATH] - event path: increased when entering a subflow or operation

Type [TYPE]|Usage|Event Data
---|---
EVENT_INPUT_END|Input binding finished for task|[BOUND_INPUTS], [TASK_NAME]
EVENT_INPUT_END|Input binding finished for flow or operation|[BOUND_INPUTS], [EXECUTABLE_NAME]
EVENT_OUTPUT_START|Output binding started for task|[taskPublishValues], [taskNavigationValues], [operationReturnValues], [TASK_NAME]
EVENT_OUTPUT_START|Output binding started for flow or operation|[executableOutputs],  [executableResults], [actionReturnValues], [EXECUTABLE_NAME]
EVENT_OUTPUT_END|Output binding finished for task|[OUTPUTS], [RESULT], [nextPosition],  [TASK_NAME]
EVENT_OUTPUT_END|Output binding finished for flow or operation|[OUTPUTS], [RESULT],  [EXECUTABLE_NAME]
EVENT_EXECUTION_FINISHED|Execution finished running (in case of subflow)|[OUTPUTS],  [RESULT], [EXECUTABLE_NAME]
EVENT_ACTION_START|Before action invocation|[CALL_ARGUMENTS], action type (Java or Python) in description
EVENT_ACTION_END|After successful action invocation|[RETURN_VALUES]
EVENT_ACTION_ERROR|Exception in action execution|[EXCEPTION]
SLANG_EXECUTION_EXCEPTION|Exception in previous step|[EXCEPTION]