Best Practices
++++++++++++++

The following is a list of best practices for authoring CloudSlang
files. Many of these best practices are checked when using the
:doc:`CloudSlang Build Tool <cloudslang_build_tool>`.

CloudSlang Content Best Practices
=================================

-  The namespace for a file matches the suffix of the file path in which
   the file resides, for example, the send\_mail operation is found in the
   **cloudslang-content/io/cloudslang/base** folder, so it uses the
   namespace ``io.cloudslang.base.mail``.
-  Namespaces should be comprised of only lowercase alphanumeric
   characters (a-z and 0-9), underscores (\_), periods(.) and hyphens
   (-).
-  A flow or operation has the same name as the file it is in.
-  Each file has one flow or one operation.
-  Flows and operations reside together in the same folders.
-  Identifiers (flow names, operation names, input names, etc.) are
   written:

    -  In snake\_case, lowercase letters with underscores (\_) between
       words, in all cases other than inputs to a Java @Action.
    -  In camelCase, starting with a lowercase letter and each additional
       word starting with an uppercase letter appended without a delimiter,
       for inputs to a Java @Action.

-  Flow and operation files begin with a commented description and list
   of annotated inputs, outputs and results (see `CloudSlang Comments
   Style Guide <#cloudslang-comments-style-guide>`__).
-  Optional parameters and default values are noted.

CloudSlang Tests Best Practices
===============================

-  Tests are contained in a directory with a folder structure identical
   to the structure of the directory they are testing.
-  Tests for a particular CloudSlang file are written in a file with the
   same name, but with the **.inputs.yaml** extension, for example, the flow
   **print\_text.sl** is tested by tests in **print\_text.inputs.yaml**.
-  Wrapper flows reside in the same folder as the tests call them.

**Note:** In future releases some of the above best practices may be
required by the CloudSlang compiler.

CloudSlang Comments Style Guide
===============================

All CloundSlang flows and operations should begin with a documentation
block that describes the flow or operation, and lists the inputs,
outputs and results.

Structure
---------

The structure and spacing of the comments are as in the example below:

::

    ####################################################
    # Does something fantastic.
    #
    # Prerequisites: some Python module
    #
    # Inputs:
    #   - input1 - first input
    #   - input2 - optional - port for something - Default: 8080
    #   - list - a list of things - Format: comma delimited list of things
    # Outputs:
    #   - output1 - some sort of message
    # Results:
    #   - SUCCESS - everything went well
    #   - FAILURE - otherwise
    ####################################################

Description
-----------

-  Written as a sentence, beginning with a capital letter and ending
   with a period.
-  Written in the present tense, for exampel, "Prints text.".
-  Does not include "This flow" or "This operation" or anything similar.

Prerequisites
-------------

-  Flows and operations that assume prerequisites include a prerequisite
   line beginning with "Prerequisites:", followed by a comma delimited
   list of prerequisites.

Inputs, Outputs and Results
---------------------------

-  Fields appear in the same order as they appear in the code.
-  Description begins with a lowercase letter (unless a proper name or
   capitalized acronym) and does not end with a period.
-  Usage of the words "the" and "a" are strongly discouraged, especially
   at the beginning of the description.
-  Does not include "this flow", "this operation", "this field" or
   anything similar.
-  Proper names and acronyms that are normally capitalized are
   capitalized, for example, HTTP, Docker, ID.

Inputs and Outputs
------------------

-  Written in the present tense, for example, "true if job exists".
-  Non-required fields contain the "optional" label.
-  Additional labels are "Default:", "Example:", "Valid:" and "Format:".

Results
-------

-  Actions written in the past tense, for example, "error occurred". States
   written in the present tense, for example, "application is up".
-  Results are always included, even if just listing the default results
   without explanations.

Recurring Fields
----------------

-  Fields that appear often with the same meaning should have the same
   name and description across flows and operations. However, if the
   meaning is specific to the flow or operation, the field description
   may be different. Some examples are.

   -  FAILURE - otherwise
   -  error\_message - error message if error occurred
   -  command - command to execute
