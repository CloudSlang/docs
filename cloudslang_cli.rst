CLI
+++

There are several ways to get started with the CloudSlang CLI.

Download and Run Pre-built CLI
==============================

**Prerequisites :** To run the CloudSlang CLI, Java JRE version 7 or
higher is required.

1. `Download <http://cloudslang.io/download>`__ the CLI zip file.
2. Locate the downloaded file and unzip the archive.
   The decompressed file contains:

   -  A folder named **cslang** with the CLI tool and its necessary
      dependencies.
   -  A folder named **content** with ready-made CloudSlang flows and
      operations.
   -  A folder named **python-lib**.

3. Navigate to the folder ``cslang-cli\cslang\cslang\bin\``.
4. Run the executable:

-  For Windows : ``cslang.bat``.
-  For Linux : ``bash cslang``.

Download, Build and Run CLI
===========================

**Prerequisites :** To build the CloudSlang CLI, Java JDK version 7 or
higher and Maven version 3.0.3 or higher are required.

1. Git clone (or GitHub fork and then clone) the `source
   code <https://github.com/cloudslang/cloud-slang>`__.
2. Using the Command Prompt, navigate to the project root directory.
3. Build the project by running ``mvn clean install``.
4. After the build finishes, navigate to the
   ``cloudslang-cli\target\cloudslang\bin`` folder.
5. Run the executable:

-  For Windows : ``cslang.bat``.
-  For Linux : ``bash cslang``.

Download and Install npm Package
================================

**Prerequisites :** To download the package, Node.js is required. To run
the CloudSlang CLI, Java JRE version 7 or higher is required.

1. At a command prompt, enter ``npm install -g cslang-cli``.

   -  If using Linux, the sudo command might be neccessary:
      ``sudo npm install -g cslang-cli``.

2. Enter the ``cslang`` command at any command prompt.

.. _use_the_cli:

Use the CLI
===========

When a flow is run, the entire directory in which the flow resides is
scanned recursively (including all subfolders) for files with a valid
CloudSlang extension. All of the files found are compiled by the CLI. If
the ``--cp`` flag is used, all of the directories listed there will be
scanned and compiled recursively as well.

The usage of forward slashes (``/``) in all file paths is recommended
even on Windows.

Run a Flow or Operation
-----------------------

To run a flow or operation located at ``c:/.../your_flow.sl``, use the
``--f`` flag to specify the location of the flow to be run:

.. code:: bash

    cslang>run --f c:/.../your_flow.sl

Run with Inputs
---------------

If the flow or operation takes in input parameters, use the ``--i`` flag
and a comma-separated list of key=value pairs:

.. code:: bash

    cslang>run --f c:/.../your_flow.sl --i input1=root,input2=25

Commas (``,``) can be used as part of input values by escaping them with
a backslash (``\``).

.. code:: bash

    cslang>run --f c:/.../your_flow.sl --i list=1\,2\,3

To use inputs that include spaces, enclose the entire input list in
quotes (``"``):

.. code:: bash

    cslang>run --f c:/.../your_flow.sl --i "input1=Hello World, input2=x"

Double quotes (``"``) can be used as part of quoted input values by
escaping them with a backslash (``\``). When using a quoted input list,
spaces between input parameters will be trimmed.

To pass the value **"Hello" World** to a flow:

.. code:: bash

    cslang>run --f c:/.../your_flow.sl --i "input1=\"Hello\" World"

Alternatively, inputs made be loaded from a file. Input files are
written in flat `YAML <http://www.yaml.org>`__, containing a map of
names to values. Input files end with the **.yaml** or **.yml**
extensions. If multiple input files are being used and they contain an
input with the same name, the input in the file that is loaded last will
overwrite the others with the same name.

**Example - inputs file**

.. code:: yaml

    input: hello
    input_list:
      - one
      - two
      - three
    input_map:
      one: a
      two: b
      three: c

Input files that contain ``inputs`` in their name can be loaded
automatically if placed in a folder named ``inputs`` in the directory
from which the CLI is run. If the flow requires an input file that is
not loaded automatically, use the ``--if`` flag and a comma-separated
list of file paths. Inputs passed with the ``--i`` flag will override
the inputs passed using a file.

.. code:: bash

    cslang>run --f c:/.../your_flow.sl --if c:/.../inputs.yaml --i input1=value1

.. _run_with_dependencies:

Run with Dependencies
---------------------

Dependencies from the content folder packaged with the CLI are added to
the classpath by default. If the flow requires dependencies from another
location, use the ``--cp`` flag with a comma-separated list of
dependency paths. Note that explicitly declaring a classpath using
``--cp`` overrides the default classpath, and therefore if there also is
a dependency in the content folder, the folder must be added to the
classpath explicitly.

.. code:: bash

    cslang>run --f c:/.../your_flow.sl --i input1=root,input2=25 --cp c:/.../yaml

.. _run_with_system_properties:

Run with System Properties
--------------------------

System properties files are written in flat
`YAML <http://www.yaml.org>`__, containing a map of names to values.
System property files end with the .yaml or .yml extensions. If multiple
system properties files are being used and they contain a system
property with the same fully qualified name, the property in the file
that is loaded last will overwrite the others with the same name.

**Example - system properties file**

.. code:: yaml

    examples.properties.text: hello
    examples.properties.list:
      - one
      - two
      - three
    examples.properties.map:
      one: a
      two: b
      three: c

System property files can be loaded automatically if placed in a folder
named ``properties`` in the directory from which the CLI is run. If the
flow or operation requires a system properties file that is not loaded
automatically, use the ``--spf`` flag and a comma-separated list of file
paths.

.. code:: bash

    cslang>run --f c:/.../your_flow.sl --spf c:/.../yaml

Run in Quiet Mode
-----------------

Normally a flow's task names are printed to the screen as they are run.
To disable the task names from being printed, use the ``--q`` flag.

.. code:: bash

    cslang>run --f c:/.../your_flow.sl --q

Run in Debug Mode
-----------------

To print each task's published variables to the screen, use the ``--d`` flag.

.. code:: bash

    cslang>run --f c:/.../your_flow.sl --d

Run in Non-Interactive Mode
---------------------------

A flow can be run without first starting up the CLI using the
non-interactive mode.

From a shell prompt:

**Windows**

.. code:: bash

    >cslang.bat run --f c:/.../your_flow.sl

**Linux**

.. code:: bash

    >cslang run --f c:/.../your_flow.sl

Other Commands
--------------

Some of the available commands are:

-  ``env --setAsync`` - Sets the execution mode to be synchronous
   (``false``) or asynchronous (``true``). By default the execution mode
   is synchronous, meaning only one flow can run at a time.

.. code:: bash

    cslang>env --setAsync true

-  ``inputs`` - Lists the inputs of a given flow.

.. code:: bash

    cslang>inputs --f c:/.../your_flow.sl

-  ``cslang --version`` - Displays the version of **score** being used.

.. code:: bash

    cslang>cslang --version

.. _execution_log:

Execution Log
-------------

The execution log is saved at ``cslang/logs/execution.log``. The log file stores
all the :ref:`events <slang_events>` that have been fired, and
therefore allows for tracking a flow's execution.

History
-------------

The CLI history is saved at ``cslang/cslang-cli.history``.

Help
----

To get a list of available commands, enter ``help`` at the CLI
``cslang>`` prompt. For further help, enter ``help`` and the name of the
command.
