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

  **Note:** if you are behind a proxy server you may need to configure Atom as
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
| for                   | template for a iterative task                       |
+-----------------------+-----------------------------------------------------+
| async                 | template for a asynchronous task                    |
+-----------------------+-----------------------------------------------------+


Sublime Text
============

To ease the CloudSlang coding process you can use our Sublime Text
snippets.

**Note:** we are no longer actively developing our Sublime Text snippets.

Download, Install and Configure Sublime
---------------------------------------

1. Download and install `Sublime Text <http://www.sublimetext.com/>`__.
2. Download the `slang-sublime
   package <https://github.com/orius123/slang-sublime/releases/tag/0.1.1>`__.
3. Copy the downloaded package file into
   C:\\Users<User>\\AppData\\Roaming\\Sublime Text 2\\Installed Packages
4. Restart Sublime Text.
5. New files with the **.sl** extension will be recognized as CloudSlang
   files. For existing files you may have to change the language
   manually.

To use the templates start typing the template name and press enter when
it appears on the screen.

The following templates are provided:

+------------+--------------------------------+
| Keyword    | Description                    |
+============+================================+
| cloudslang | template for a CloudSlang file |
+------------+--------------------------------+
| flow       | template for a flow task       |
+------------+--------------------------------+
| task       | template for a task operation  |
+------------+--------------------------------+
| operation  | template for an operation      |
+------------+--------------------------------+

**Note:** Optional CloudSlang elements are marked as comments (begin
with ``#``).
