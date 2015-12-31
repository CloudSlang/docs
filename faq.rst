FAQ
+++

| :ref:`What is CloudSlang? <what_is>`
| :ref:`What are the use cases and focus for CloudSlang? <focus>`
| :ref:`What is the difference between **orchestration** and **configuration management**? <orchestration_vs_configuaration>`
| :ref:`How is CloudSlang different than configuration management tools like Chef, Puppet, SaltStack, and Ansible? Can I use it with these tools? <cs_vs_config_tools>`
| :ref:`How is CloudSlang different than PaaS platforms like Cloud Foundry or OpenShift? <cs_vs_paas_platform>`
| :ref:`What is the quickest way to try out CloudSlang? <try_out>`
| :ref:`What are the prerequisites for CloudSlang? How can I install it? <install>`
| :ref:`Which langages are supported by CloudSlang? <languages>`
| :ref:`What other technologies does CloudSlang integrate with? <integrate>`
| :ref:`How do you ensure content testing and quality? <testing>`
| :ref:`What is the relationship between HPE Operations Orchestration and CloudSlang? <oo_and_cs>`
| :ref:`Where can I get help for CloudSlang? <help>`
| :ref:`How about support? <support>`
| :ref:`Anything else I should know? <anything_else>`

----

.. _what_is:

**What is CloudSlang?**

CloudSlang is an open source project to automate your DevOps use cases using ready-made workflows. Process-based, CloudSlang orchestrates  popular DevOps technologies, such as Docker and CoreOS in an agentless manner. You can also define custom workflows that are reusable, shareable and easy to understand.

.. _focus:

**What are the use cases and focus for CloudSlang?**

CloudSlang orchestrates popular DevOps technologies, such as Docker and CoreOS in an agentless manner.

.. _orchestration_vs_configuaration:

**What is the difference between orchestration and configuration management?**

CloudSlang is not a traditional PaaS framework, although it can be used to orchestrate one. PaaS platforms such as OpenShift or Cloud Foundry focus primarily on common application stacks and architectures, and are designed to improve developer productivity by making it easy to develop and deploy new, simple applications. 

CloudSlang, is designed to orchestrate complex, non-trivial process-based workflows. For example, CloudSlang content allow you to integrate with OpenShift or Cloud Foundry (Stackato) PaaS platforms to orchestration application lifecycle creation.

.. _cs_vs_config_tools:

**How is CloudSlang different than configuration management tools like Chef, Puppet, Salt, and Ansible? Can I use it with these tools?**

Configuration management (CM) tools like Chef, Puppet, Salt, Ansible are great for configuring individual servers and preparing them for service. Given a server and a desired state, they will make sure to take all the required steps to configure that server so that it ends up in the desired state.
As RunBookAutomation open source product, CloudSlang will allow you run many uses cases like Application or Server Provisioning and it will take all the steps required to realize that application stack. This includes provisioning infrastructure resources on the cloud (compute, storage and network), assigning the right roles to each provisioned VM, configuring this CM (which is typically done by CM tools), injecting the right pieces of information to each tier, starting them up in the right order, and then continuously monitoring the instances of each tier, healing it on failure and scaling that tier when needed. CloudSlang can indeed integrate with these CM tools as needed for configuring individual VM, and in fact this a best practice. For example, CloudSlang provides Chef integration.  

.. _cs_vs_paas_platform:

**How is CloudSlang different than PaaS platforms like Cloud Foundry or OpenShift?**

Placeholder

.. _try_out:

**What is the quickest way to try out CloudSlang?**

Download it here (http://www.cloudslang.io/#/), and then head over to the Getting Started guide (http://cloudslang-docs.readthedocs.org/en/v0.9/), and follow the instructions.

.. _install:

**What are the prerequisites for CloudSlang? How can I install it?**

Placeholder

.. _languages:

**Which langages are supported by CloudSlang?**

Python and Java operations are natively supported by CloudSlang

.. _integrate:

**What other technologies does CloudSlang integrate with?**

CloudSlang was built out of the box to work with our favorite technologies – we’re not looking to replace great tools – we just want to work really well with them. So pretty much any tool you’re used to working with, CloudSlang community likely supports it. For example, OpenStack or Docker technologies are supported, but also configuration management tools like Chef as well as bash (for *nix systems) and PowerShell (for Windows). Basic operations for REST or SOAP are also provided.

.. _testing:

**How do you ensure content testing and quality?**

Placeholder

.. _oo_and_cs:

**What is the relationship between HPE Operations Orchestration and CloudSlang?**

Placeholder

.. _help:

**Where can I get help for CloudSlang?**

Placeholder

.. _support:

**How about support?**

Placeholder

.. _anything_else:

**Anything else I should know?**

Placeholder
