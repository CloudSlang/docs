Overview
++++++++

What follows is a brief overview of how CloudSlang and the CloudSlang
Orchestration Engine (Score) work. For more detailed information see the
:ref:`Score API <score_api>` and :ref:`Slang API <slang_api>` sections.

The CloudSlang Orchestration Engine is an engine that runs workflows.
Internally, the workflows are represented as
:ref:`ExecutionPlans <executionplan>`. An
:ref:`ExecutionPlan <executionplan>` is essentially a
map of IDs and :ref:`ExecutionSteps <executionstep>`.
Each :ref:`ExecutionStep <executionstep>` contains
information for calling an action method and a navigation method.

When an :ref:`ExecutionPlan <executionplan>` is
triggered it executes the first
:ref:`ExecutionStep's <executionstep>` action method and
navigation method. The navigation method returns the ID of the next
:ref:`ExecutionStep <executionstep>` to run. Execution
continues in this manner, successively calling the next
:ref:`ExecutionStep's <executionstep>` action and
navigation methods, until a navigation method returns ``null`` to
indicate the end of the flow.

CloudSlang plugs into the CloudSlang Orchestration Engine (Score) by
compiling its workflow and operation files into Score
:ref:`ExecutionPlans <executionplan>` and then
triggering them. Generally, when working with CloudSlang content, all
interaction with Score goes through the :ref:`Slang
API <slang_api>`, not the :ref:`Score API <score_api>`.
