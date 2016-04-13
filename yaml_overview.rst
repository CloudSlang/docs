YAML Overview
+++++++++++++

Before writing CloudSlang code it helps to have a good working knowledge
of YAML. This section contains a brief overview of some of the YAML
specification. See the full `YAML
specification <http://www.yaml.org/spec/1.2/spec.html>`__ for more
information.

Whitespace
==========

Unlike many programming, markup, and data serialization languages,
whitespace is syntactically significant. Indentation is used to denote
scope and is always achieved using spaces. Never use tabs.

**Example: a CloudSlang task (in this case named divider) contains do,
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

Lists
=====

Lists are denoted with a hypen (``-``) and a space preceding each list
item.

**Example: a CloudSlang flow's possible results are defined using a list
mapped to the results key**

.. code:: yaml

    results:
      - ILLEGAL
      - SUCCESS

Maps
====

Maps are denoted use a colon (``:``) and a space between each key value
pair.

**Example: a CloudSlang task's navigate key is mapped to a mapping of
results and their targets**

.. code:: yaml

    navigate:
      - ILLEGAL: FAILURE
      - SUCCESS: printer

Strings
=======

Strings can be denoted in several ways: unquoted, single quoted and
double quoted. The best method for any given string depends on whether
it includes any special characters, leading or trailing whitespace,
spans multiple lines, along with other factors.

Strings that span multiple lines can be written using a pipe (``|``) to
preserve line breaks or a greater than symbol (``>``) where each line
break will be converted to a space.

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
            - text: "Hello, World"

**Example: the pipe is used in CloudSlang to indicate a multi-line
Python script**

.. code:: yaml

    action:
      python_script: |
        if divisor == '0':
          quotient = 'division by zero error'
        else:
          quotient = float(dividend) / float(divisor)

Comments
========

Comments begin with the ``#`` symbol.
