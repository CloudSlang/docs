FAQ
+++

| :ref:`What is CloudSlang? <what_is>`
| :ref:`What are the use cases and focus for CloudSlang? <focus>`
| :ref:`What is the difference between **orchestration** and **configuration management**? <orchestration_vs_configuaration>`
| :ref:`How is CloudSlang different than configuration management tools like Chef, Puppet, Salt and Ansible? Can I use it with these tools? <cs_vs_config_tools>`
| :ref:`What is the quickest way to try out CloudSlang? <try_out>`
| :ref:`Which languages are supported by CloudSlang? <languages>`
| :ref:`What other technologies does CloudSlang integrate with? <integrate>`

----

.. _what_is:

**What is CloudSlang?**

CloudSlang is an open source project to automate your development and operations
use cases using ready-made workflows. CloudSlang uses a process-based approach
to orchestrating popular technologies, such as Docker and CoreOS in an agentless
manner. You can use the ready-made CloudSlang content or define your own custom
workflows that are reusable, shareable and easy to understand.

.. _focus:

**What are the use cases and focus for CloudSlang?**

CloudSlang can orchestrate a wide variety of technologies. Currently, our
ready-made content focuses on popular DevOps technologies, such as Docker and
CoreOS.

.. _orchestration_vs_configuaration:

**What is the difference between orchestration and configuration management?**

CloudSlang is not a traditional PaaS framework, although it can be used to
orchestrate one. PaaS platforms such as OpenShift or Cloud Foundry focus
primarily on common application stacks and architectures, and are designed to
improve developer productivity by making it easy to develop and deploy new,
simple applications.

CloudSlang, is designed to orchestrate complex, non-trivial, process-based
workflows. For example, CloudSlang content allows you to integrate with the
OpenShift or Cloud Foundry (Stackato) PaaS platforms to orchestrate
application lifecycle creation.

.. _cs_vs_config_tools:

**How is CloudSlang different than configuration management tools like Chef, Puppet, Salt and Ansible? Can I use it with these tools?**

Configuration management (CM) tools like Chef, Puppet, Salt and Ansible are
great for configuring individual servers and preparing them for service. Given a
server and a desired state, they will make sure to take all the required steps
to configure that server so that it ends up in the desired state.

As a Runbook Automation open source product, CloudSlang will allow you automate
many uses cases, such as application or server provisioning. It will take all
the steps required to realize that application stack. This includes provisioning
infrastructure resources on the cloud (compute, storage and network), assigning
the right roles to each provisioned VM, configuring this CM (which is typically
done by CM tools), injecting the right pieces of information into each tier,
starting them up in the right order, continuously monitoring the instances of
each tier, healing on failure and scaling tiers when needed.

CloudSlang can indeed integrate with CM tools as needed for configuring
individual VMs, and in fact this a best practice. For example, CloudSlang
provides ready-made content for integrating with Chef.

.. _try_out:

**What is the quickest way to try out CloudSlang?**

Follow the directions on the CloudSlang
`website <http://cloudslang.io/#/getstarted>`_ or head over to the
:doc:`Get Started <get_started>` section to download CloudSlang
and run your first CloudSlang content.

.. _languages:

**Which langages are supported by CloudSlang?**

Python and Java operations are supported natively in CloudSlang.

.. _integrate:

**What other technologies does CloudSlang integrate with?**

CloudSlang was built out of the box to work with your favorite technologies. For
example, not only are OpenStack and Docker technologies are supported, but also
configuration management tools like Chef. There's also support for bash (for
*nix systems) and PowerShell (for Windows) and basic operations for REST or
SOAP. To see a complete list of technologies that CloudSlang integrates with,
see the ready-made content `repository <https://github.com/CloudSlang/cloud-slang-content/blob/cloud-slang-content-0.9.50/DOCS.md>`_.

We’re not looking to replace great tools, we work with them. So many of the
tools you’re used to working with are already supported by CloudSlang. The
CloudSlang team, along with its growing open source community, are constantly
expanding the list of tools we work with, so if you're favorite tool isn't
supported yet, there's a good chance it will be soon. Of course, we encourage
and support contributions from the community. (In fact, this very answer you're
reading was contributed by a member of the community.)
