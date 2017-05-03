YAML Overview
+++++++++++++

Before writing CloudSlang code it helps to have a good working knowledge
of YAML. YAML is a human friendly, data serialization language that has
become a popular choice for configuration files and other hand-crafted
data files. CloudSlang uses YAML to define its flows and operations.

This section contains a brief overview of the common YAML syntax and the
best practices for writing it. See the full `YAML specification
<http://www.yaml.org/spec/1.2/spec.html>`__ for more information.

Basics
======

The contents of a YAML file define a single data structure (graph) that
is composed of nested nodes (mappings, sequences and scalars). Well
crafted YAML files are easy to read, and can have comments in the right
places to explain things better.

YAML tries to be human friendly, by minimizing the need for special
syntax characters when the data is simple. The most common YAML special
characters in YAML are:

- ``:`` - Between key/value pairs
- ``-`` - Denotes a sequence entry
- ``#`` - Starts a comment

.. note::

  You should be aware that YAML also supports very complex data, and has
  some special characters that you need to be aware of. Even if you
  never need to use those features, YAML will fail to parse if you
  accidentally use a special character incorrectly. This is pretty easily
  avoided and covered more below.

If you are familiar with the popular data language, JSON, then YAML
should be easy to learn. Effectively YAML can be thought of as JSON
with less syntax (quotes, brackets, etc), although YAML also supports
the JSON style syntax. In fact, YAML is a strict superset of JSON.

Here are some basic YAML facts and guidelines:

- Structure is usually scoped by indentation
- Line comments can be used almost anywhere
- Strings values rarely need quotes
- YAML has 5 string quoting styles

.. _indentation_scoping:

Indentation Scoping
===================

Much like the Python programming language, YAML uses indentation to
denote a change in scope level. This means that leading whitespace is
syntactically significant. Indentation is always achieved using spaces.
Tabs are not allowed.

While any number of spaces can be used for a given scope, it a best
practice to always use 2 spaces. This makes the YAML be more consistent
and readable.

.. note::

  The ``-`` characters at the start of a sequence entry count as
  indentation.

**Example: a CloudSlang step (in this case named divider) contains do,
publish and navigate keys**

.. code:: yaml

    - divider:
        do:
          divide:
            - dividend: ${input1}
            - divisor: ${input2}
        publish:
          - answer: ${quotient}
        navigate:
          - ILLEGAL: FAILURE
          - SUCCESS: printer

YAML calls the indentation style "block" and the JSON style "flow". Flow
style can be used at any point within the block style. Flow style
doesn't need quoting either. It is a best practice to only use flow
style for small structures on a single line.

**Example: above document using flow style**

.. code:: yaml

    - divider:
        do:
          divide:
            - dividend: ${input1}
            - divisor: ${input2}
        publish:
          - answer: ${quotient}
        navigate: [{ILLEGAL: FAILURE}, {SUCCESS: printer}]

Mappings (Hashes, Objects, Dictionaries)
========================================

Mappings (maps) are a set of key/value pairs. Each key and value is
separated be a colon (``:``). The colon must be followed by a whitespace
character (space or newline). The value can be a scalar (string/number)
value, a newly indented mapping or sequence.

**Example: a CloudSlang step's navigate key is mapped to a mapping of
results and their targets**

.. code:: yaml

    navigate:
      - ILLEGAL: FAILURE
      - SUCCESS: printer

Sequences (Lists, Arrays)
=========================

Sequences (seqs) are denoted with a hyphen and a space (``-``) preceding
each entry.

**Example: a CloudSlang flow's possible results are defined using a list
mapped to the results key**

.. code:: yaml

    results:
      - ILLEGAL
      - SUCCESS

.. _scalars:

Scalars (Strings, Numbers, Values)
==================================

Scalars are single values. They are usually strings but (like JSON) can
also be numbers, booleans or null values. If a value is quoted, it is
always a string. If unquoted it is inspected to be something else, but
defaults to being a string.

Strings can be denoted in several ways: unquoted, single quoted and
double quoted. The best method for any given string depends on its
content.

While most strings should be left unquoted, quotes are required for
these cases:

- The string starts with a special character:

  - One of ``!#%@&*`?|>{[`` or ``-``.

- The string starts or ends with whitespace characters.
- The string contains ``:`` or ``#`` character sequences.
- The string ends with a colon.
- The value looks like a number or boolean (``123``, ``1.23``, ``true``,
  ``false``, ``null``) but should be a string.

Multi-line strings can be written using a pipe (``|``) to preserve line
breaks or a greater than symbol (``>``) where each line break will be
converted to a space. Multi-line strings can also use the unquoted or
quoted styles above, but it is best practice to avoid that.

The double-quoted style is the only style that can support any character
string, using escape sequences like ``\n``, ``\\``, and ``\"``). Single
quoted strings only have one escape sequence: two single quotes (``''``)
are used to put a single quote inside the single quoted string.

**Example: a name of a CloudSlang flow is defined using the unquoted
style**

.. code:: yaml

    flow:
      name: hello_world

**Example: a string value is passed to a CloudSlang operation using the double
quoted style**

.. code:: yaml

    - sayHi:
        do:
          print:
            - text: "Hello, World\n"

**Example: the pipe is used in CloudSlang to indicate a multi-line
Python script**

.. code:: yaml

    python_action:
      script: |
        if divisor == '0':
          quotient = 'division by zero error'
        else:
          quotient = float(dividend) / float(divisor)

.. note::

  Learning the scalar styles and their specifics will help you write
  YAML files that are clear and concise.

Comments
========

Comments begin with the ``#`` symbol following a whitespace character or
beginning of line.

.. code:: yaml

    # This is a line comment
    flow:       # Flow definition (trailing comment)
      name: hello_world # This flow is called 'hello_world'

Validate Your YAML
==================

You can use an online YAML validator, such as the ones found here:

  - `YAML Lint <http://www.yamllint.com/>`__
  - `Code Beautify <http://codebeautify.org/yaml-validator>`__

Conclusion
==========

YAML is a simple yet complete data language. This means that most of the
time, simple things are simple. You just need to be aware that some
things have special meaning to YAML that you might not expect.

If you need more help, there are lots of resources about YAML on the
web. You may want to check out the `YAML Reference
Card <http://www.yaml.org/refcard.html>`__.
