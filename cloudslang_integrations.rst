Integrations
++++++++++++

StackStorm
==========

`StackStorm <https://stackstorm.com/>`__ is a platform for integration and
automation across services and tools. It ties together your existing
infrastructure and application environment so you can more easily automate that
environment — with a particular focus on taking actions in response to events.
One way of taking those actions is to use CloudSlang.

CloudSlang has been part of StackStorm since StackStorm
`version 0.12.0 <https://github.com/StackStorm/st2/releases/tag/v0.12.0>`__.

Benefits of Using CloudSlang with StackStorm
--------------------------------------------

StackStorm builds on CloudSlang’s already powerful flow-based orchestration
solution by adding the ability to run workflows based on rules connected to
events and sensors. CloudSlang and StackStorm can be used together to solve a
wide variety of problems, including facilitated troubleshooting and closed loop
remediation. Together they can automate your operational patterns.

CloudSlang Action Runner
------------------------

StackStorm uses **action runners** as the execution environment for
user-implemented actions. This allows an action author to concentrate on the
implementation of the action itself without having to set up the environment.
StackStorm includes a ``cloudslang`` runner which allows for actions to perform
complex CloudSlang flows. For more information on
`actions <https://docs.stackstorm.com/latest/actions.html>`__ and
`action runners <https://docs.stackstorm.com/latest/runners.html>`__ see the
StackStorm documentation.


CloudSlang Actions
------------------
A custom StackStorm action is composed of two parts:

1. A script file which implements the action logic.
2. A YAML metadata file which describes the action.

A CloudSlang action uses CloudSlang content to implement the action logic. An
example metadata file can be found `here <https://github.com/StackStorm/st2/blob/master/contrib/examples/actions/cloudslang-basic.yaml>`__.
