CloudSlang Editors
++++++++++++++++++

Although CloudSlang files can be composed in any text editor, using a
modern code editor with support for syntax highlighting is recommended.

Atom
====

The language-cloudslang Atom package includes CloudSlang syntax highlighting
and many code snippets.

Download, Install and Configure Atom
------------------------------------

1. Download and install `Atom <https://atom.io/>`__.
2. Download and install the CloudSlang language package.

  * From the Atom UI: **File > Settings > Install** and search for language-cloudslang
  * From the command line: ``apm install language-cloudslang``

  .. note::

     If you are behind a proxy server you may need to configure Atom as
     described in their
     `package manager documentation <https://github.com/atom/apm/blob/master/README.md>`__.

3. Reload (**View > Reload**) or restart Atom.
4. Files saved with the **.sl** extension will be recognized within Atom as
   CloudSlang files.

Snippets
--------

To use the snippets start typing the snippet name and press enter when
it appears on the screen.

The following snippets are provided:

+----------------------------------+-------------------------------------------------------------+
| Keyword                          | Description                                                 |
+==================================+=============================================================+
| flow                             | template for a flow file                                    |
+----------------------------------+-------------------------------------------------------------+
| operation                        | template for an operation file                              |
+----------------------------------+-------------------------------------------------------------+
| properties                       | template for a system properties file                       |
+----------------------------------+-------------------------------------------------------------+
| java_action                      | template for a Java action                                  |
+----------------------------------+-------------------------------------------------------------+
| python_action                    | template for a Python action                                |
+----------------------------------+-------------------------------------------------------------+
| input                            | template for simple input name and value                    |
+----------------------------------+-------------------------------------------------------------+
| input with properties            | template for an input with all possible properties          |
+----------------------------------+-------------------------------------------------------------+
| output                           | template for an output name and value                       |
+----------------------------------+-------------------------------------------------------------+
| output with properties           | template for an output with all possible properties         |
+----------------------------------+-------------------------------------------------------------+
| result                           | template for a result name and value                        |
+----------------------------------+-------------------------------------------------------------+
| publish                          | template for a published variable name and value            |
+----------------------------------+-------------------------------------------------------------+
| import                           | template for an import alias name and namespace             |
+----------------------------------+-------------------------------------------------------------+
| navigate                         | template for a result mapped to a navigation target         |
+----------------------------------+-------------------------------------------------------------+
| step                             | template for a standard step                                |
+----------------------------------+-------------------------------------------------------------+
| on_failure                       | template for an on_failure step                             |
+----------------------------------+-------------------------------------------------------------+
| for                              | template for an iterative step                              |
+----------------------------------+-------------------------------------------------------------+
| parallel_loop                    | template for a parallel step                                |
+----------------------------------+-------------------------------------------------------------+
| property                         | template for a system property                              |
+----------------------------------+-------------------------------------------------------------+
| property with properties         | template for a system property with all possible properties |
+----------------------------------+-------------------------------------------------------------+
| @input                           | template for input documentation                            |
+----------------------------------+-------------------------------------------------------------+
| @description                     | template for file description documentation                 |
+----------------------------------+-------------------------------------------------------------+
| @prerequisites                   | template for prerequisite documentation                     |
+----------------------------------+-------------------------------------------------------------+
| @output                          | template for output documentation                           |
+----------------------------------+-------------------------------------------------------------+
| @result                          | template for result documentation                           |
+----------------------------------+-------------------------------------------------------------+

Atom Troubleshooting
--------------------
For troubleshooting Atom issues, see the Atom
`documentation <https://atom.io/docs>`__ and
`discussion board <https://discuss.atom.io/>`__.
