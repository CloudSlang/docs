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

  **Note:** If you are behind a proxy server you may need to configure Atom as
  described in their `documentation
  <https://atom.io/docs/v1.1.0/getting-started-installing-atom#setting-up-a-proxy>`__.

3. You may need to restart Atom.
4. Files with the **.sl** extension will be recognized as CloudSlang
   files.

To use the snippets start typing the snippet name and press enter when
it appears on the screen.

The following snippets are provided:

+-----------------------+-----------------------------------------------------+
| Keyword               | Description                                         |
+=======================+=====================================================+
| flow                  | template for a flow file                            |
+-----------------------+-----------------------------------------------------+
| operation             | template for an operation file                      |
+-----------------------+-----------------------------------------------------+
| java_action           | template for a Java action                          |
+-----------------------+-----------------------------------------------------+
| python_action         | template for a Python action                        |
+-----------------------+-----------------------------------------------------+
| input                 | template for simple input name and value            |
+-----------------------+-----------------------------------------------------+
| input with properties | template for an input with all possible properties  |
+-----------------------+-----------------------------------------------------+
| output                | template for an output name and value               |
+-----------------------+-----------------------------------------------------+
| publish               | template for a published variable name and value    |
+-----------------------+-----------------------------------------------------+
| import                | template for an import alias name and namespace     |
+-----------------------+-----------------------------------------------------+
| navigate              | template for a result mapped to a navigation target |
+-----------------------+-----------------------------------------------------+
| task                  | template for a standard task                        |
+-----------------------+-----------------------------------------------------+
| on_failure            | template for an on_failure task                     |
+-----------------------+-----------------------------------------------------+
| for                   | template for an iterative task                      |
+-----------------------+-----------------------------------------------------+
| async                 | template for an asynchronous task                   |
+-----------------------+-----------------------------------------------------+
