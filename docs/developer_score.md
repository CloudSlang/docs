#Embedded Engine
The CloudSlang Orchestration Engine (Score) can be embedded inside an existing Java application using Maven and Spring. Interaction with Score is done through the [Score API](#score-api). 

##Embed Score in a Java Application

+ Add the Score dependencies to the project's pom.xml file in the `<dependencies>` tag.

```xml
<dependency>
  <groupId>io.cloudslang</groupId>
  <artifactId>score-all</artifactId>
  <version>0.2</version>
</dependency>

<dependency>
  <groupId>com.h2database</groupId>
  <artifactId>h2</artifactId>
  <version>1.3.175</version>
</dependency>
```

+ Add Score configuration to your Spring application context xml file.
  
```xml
<beans xmlns="http://www.springframework.org/schema/beans"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:score="http://www.openscore.org/schema/score"
            xsi:schemaLocation="http://www.springframework.org/schema/beans
            http://www.springframework.org/schema/beans/spring-beans.xsd
            http://www.openscore.org/schema/score 
            http://www.openscore.org/schema/score.xsd">

  <score:engine/>

  <score:worker uuid="-1"/>

  <bean class="io.openscore.example.ScoreEmbed"/>
</beans>  
```
  
+ Interact with Score using the [Score API](#score-api).

```java
package io.cloudslang.example;

import org.apache.log4j.Logger;
import io.cloudslang.score.api.*;
import io.cloudslang.score.events.EventBus;
import io.cloudslang.score.events.EventConstants;
import io.cloudslang.score.events.ScoreEvent;
import io.cloudslang.score.events.ScoreEventListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.io.Serializable;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

public class ScoreEmbed {
  @Autowired
  private Score score;

  @Autowired
  private EventBus eventBus;

  private final static Logger logger = Logger.getLogger(ScoreEmbed.class);
  private ApplicationContext context;
  private final Object lock = new Object();

  public static void main(String[] args) {
      ScoreEmbed app = loadApp();
      app.registerEventListener();
      app.start();
  }

  private static ScoreEmbed loadApp() {
      ApplicationContext context = new ClassPathXmlApplicationContext("/META-INF/spring/scoreContext.xml");
      ScoreEmbed app = context.getBean(ScoreEmbed.class);
      app.context  = context;
      return app;
  }

  private void start() {
      ExecutionPlan executionPlan = createExecutionPlan();
      score.trigger(TriggeringProperties.create(executionPlan));
      waitForExecutionToFinish();
      closeContext();
  }

  private void waitForExecutionToFinish() {
      try {
          synchronized(lock){
              lock.wait(10000);
          }
      } catch (InterruptedException e) {
          logger.error(e.getStackTrace());
      }
  }

  private static ExecutionPlan createExecutionPlan() {
      ExecutionPlan executionPlan = new ExecutionPlan();

      executionPlan.setFlowUuid("1");

      ExecutionStep executionStep0 = new ExecutionStep(0L);
      executionStep0.setAction(new ControlActionMetadata("io.cloudslang.example.controlactions.ConsoleControlActions", "printMessage"));
      executionStep0.setActionData(new HashMap<String, Serializable>());
      executionStep0.setNavigation(new ControlActionMetadata("io.cloudslang.example.controlactions.NavigationActions", "nextStepNavigation"));
      executionStep0.setNavigationData(new HashMap<String, Serializable>());
      executionPlan.addStep(executionStep0);

      ExecutionStep executionStep1 = new ExecutionStep(1L);
      executionStep1.setAction(new ControlActionMetadata("io.cloudslang.example.controlactions.ConsoleControlActions", "printMessage"));
      executionStep1.setActionData(new HashMap<String, Serializable>());
      executionStep1.setNavigation(new ControlActionMetadata("io.cloudslang.example.controlactions.NavigationActions", "nextStepNavigation"));
      executionStep1.setNavigationData(new HashMap<String, Serializable>());
      executionPlan.addStep(executionStep1);

      ExecutionStep executionStep2 = new ExecutionStep(2L);
      executionStep2.setAction(new ControlActionMetadata("io.cloudslang.example.controlactions.ConsoleControlActions", "failed"));
      executionStep2.setActionData(new HashMap<String, Serializable>());
      executionStep2.setNavigation(new ControlActionMetadata("io.cloudslang.example.controlactions.NavigationActions", "endFlow"));
      executionStep2.setNavigationData(new HashMap<String, Serializable>());
      executionPlan.addStep(executionStep2);

      return executionPlan;
  }

  private void registerEventListener() {
      Set<String> handlerTypes = new HashSet<>();
      handlerTypes.add(EventConstants.SCORE_FINISHED_EVENT);
      handlerTypes.add(EventConstants.SCORE_FAILURE_EVENT);
      eventBus.subscribe(new ScoreEventListener() {
          @Override
          public void onEvent(ScoreEvent event) {
              logger.info("Listener " + this.toString() + " invoked on type: " + event.getEventType() + " with data: " + event.getData());
              synchronized (lock) {
                  lock.notify();
              }
          }
      }, handlerTypes);
  }

  private void closeContext() {
      ((ConfigurableApplicationContext) context).close();
  }
}
```

#Score API
The Score API allows a program to interact with the CloudSlang Orchestration Engine (Score). This section describes some of the more commonly used interfaces and methods from the Score API.

##ExecutionPlan
An ExecutionPlan is a map of IDs and steps, called [ExecutionSteps](#executionstep), representing a workflow for Score to run.  Normally, the ID of the first step to be run is 0. 

[ExecutionSteps](#executionstep) can be added to the ExecutionPlan using the `addStep(ExecutionStep step)` method. 

The starting step of the ExecutionPlan can be set using the `setBeginStep(Long beginStep)` method.

##ExecutionStep
An ExecutionStep is the a building block upon which an [ExecutionPlan](#executionplan) is built. It consists of an ID representing its position in the plan, control action information and navigation action information. As each ExecutionStep is reached, its control action method is called followed by its navigation action method. The navigation action method returns the ID of the next ExecutionStep to be run in the [ExecutionPlan](#executionplan) or signals the plan to stop by returning `null`. The ID of an ExecutionStep must be unique among the steps in its [ExecutionPlan](#executionplan).

The control action method and navigation action methods can be set in the ExecutionStep using the following methods, where a `ControlActionMetadata` object is created using string values of the method's fully qualified class name and method name:

+ `setAction(ControlActionMetadata action)`
+ `setNavigation(ControlActionMetadata navigationMetadata)`

###Action Method Arguments
Both the control action and navigation action are regular Java methods which can take arguments. They are invoked by reflection and their arguments are injected by the Score engine, so there is no API or naming convention for them. But there are some names that are reserved for special use. 

There are several ways Score can populate an action method's arguments:

+ From the execution context that is passed to the [TriggeringProperties](#triggeringproperties) when the [ExecutionPlan](#executionplan) is triggered.
  
  When a method such as `public void doSomething(String argName)` is encountered, Score will attempt to populate the argument `argName` with a value mapped to the key `argName` in the execution context. If the key `argName` does not exist in the map, the argument will be populated with `null`.

+ From data values set in the [ExecutionSteps](#executionstep) during the creation of the [ExecutionPlan](#executionplan).

	Data can be set using the `setActionData` and `setNavigationData` methods.

+ From reserved argument names.

  There are some argument names that have a special meaning when used as control action or navigation action method arguments:

+  **executionRuntimeServices** - Score will populate this argument with the [ExecutionRuntimeServices](#executionruntimeservices) object. 
  
```java
public void doWithServices(ExecutionRuntimeServices    executionRuntimeServices)
```

+  **executionContext** - Score will populate this argument with the context tied to the ExecutionPlan during its triggering through the [TriggeringProperties](#triggeringproperties).
  
```java
public void doWithContext(Map<String, Serializable> executionContext) 
```

If an argument is present in both the [ExecutionStep](#executionstep) data and the execution context, the value from the execution context will be used.

###Action Method Return Values
+ Control action methods are `void` and do not return values.
+ Navigation action methods return a value of type `Long`, which is used to determine the next [ExecutionStep](#executionstep). Returning `null` signals the [ExecutionPlan](#executionplan) to finish.

##Score Interface
The Score interface exposes methods for triggering and canceling executions.

###Triggering New Executions
The `trigger(TriggeringProperties triggeringProperties)` method starts an execution with a given [ExecutionPlan](#executionplan) and the additional properties found in the [TriggeringProperies](#triggeringproperties) object. The method returns the ID of the new execution.

By default the first executed step will be the execution plan's start step, and the execution context will be empty.

###Canceling Executions
The `cancelExecution(Long executionId)` method requests to cancel (terminate) a given execution. It is passed the ID that was returned when triggering the execution that is now to be canceled. 

Note that the execution will not necessarily be stopped immediately. 

##TriggeringProperties
A TriggeringProperties object is sent to the [Score interface's](#score-interface) trigger method when the execution begins.
 
 The TriggeringProperties object contains:
  
+ An [ExecutionPlan](#executionplan) to run.
+ The [ExecutionPlan's](#executionplan) dependencies, which are [ExecutionPlans](#executionplan) themselves.
+ A map of names and values to be added to the execution context.
+ A map of names and values to be added to the [ExecutionRuntimeServices](#executionruntimeservices).
+ A start step value, which can cause the [ExecutionPlan](#executionplan) to start from a step that is not necessarily its defined begin step.

The TriggeringProperties class exposes methods to create a TriggeringProperties object from an [ExecutionPlan](#executionplan) and then optionally set the various other properties. 


##ExecutionRuntimeServices
The ExecutionRuntimeServices provide a way to communicate with Score during the execution of an [ExecutionPlan](#executionplan). During an execution, after each [ExecutionStep](#executionstep), the engine will check the ExecutionRuntimeServices to see if there have been any requests made of it and will respond accordingly. These services can be used by a language written on top of Score, as CloundSlang does, to affect the runtime behavior.

The ExecutionRuntimeServices can be injected into an [ExecutionStep's](#executionstep) action or navigation method's arguments by adding the `ExecutionRuntimeServices executionRuntimeServices` parameter to the method's argument list.  

Some of the services provided by ExecutionRuntimeServices are:

+ Events can be added using the `addEvent(String eventType, Serializable eventData)` method.
+ Execution can be paused using the `pause()` method.
+ Errors can be set using the `setStepErrorKey(String stepErrorKey)` method.
+ Branches can be added using the `addBranch(Long startPosition, String flowUuid, Map<String, Serializable> context)` method or the `addBranch(Long startPosition, Long executionPlanId, Map<String, Serializable> context, ExecutionRuntimeServices executionRuntimeServices)` method.
+ Requests can be made to change the ExecutionPlan that is running by calling the  `requestToChangeExecutionPlan(Long executionPlanId)` method.

##EventBus
The EventBus allows you to subscribe and unsubscribe listeners for events. 

Listeners must implement the `ScoreEventListener` interface which consists of a single method – `onEvent(ScoreEvent event)`.

To subscribe a listener for certain events, pass a set of the events to listen for to the `subscribe(ScoreEventListener eventHandler, Set<String> eventTypes)` method.

The event types are defined in the `EventConstants` class.

To unsubscribe a listener from all the events it was listening for call the `unsubscribe(ScoreEventListener listener)` method.

##ScoreEvent
A ScoreEvent is comprised of a string value corresponding to its type and a map containing the event data, which can be accessed using the `getEventType()` and `getData()` methods respectively.

#Score Events
The CloudSlang Orchestration Engine (Score) defines two events that may be fired during execution. Each event is comprised of a string value corresponding to its type and a map containing the event data.

Event Types:

+ SCORE_FINISHED_EVENT
+ SCORE_FAILURE_EVENT

Event Data Keys:

+ IS_BRANCH
+ executionIdContext
+ systemContext
+ EXECUTION_CONTEXT

A language built upon Score can add events during runtime using the [ExecutionRuntimeServices](#executionruntimeservices) API. An example of this usage can be seen in CloudSlang's addition of [Slang events](developer_cloudslang.md#slang-events).
