Before writing CloudSlang code it helps to have a good working knowledge of YAML. The following is a brief overview of some of the YAML specification. See the full [YAML specification](http://www.yaml.org/spec/1.2/spec.html) for more information.

Note: CloudSlang's usage of YAML differs slightly from the official specification in its handling of quoted strings. This is to avoid the need to enclose certain values in two sets of quotes. See the [Strings](#strings) section below.

#Whitespace
Unlike many programming, markup, and data serialization languages, whitespace is syntactically significant. Indentation is used to denote scope and is always achieved using spaces. Never use tabs.

**Example: a CloudSlang task (in this case named divider) contains do, publish and navigate keys**

```yaml
- divider:
    do:
      divide:
        - dividend: input1
        - divisor: input2
    publish:
      - answer: quotient
    navigate:
      ILLEGAL: FAILURE
      SUCCESS: printer
```

#Lists
Lists are denoted with a hypen (`-`) and a space preceding each list item. 

**Example: a CloudSlang flow's possible results are defined using a list mapped to the results key**
```yaml
results:
  - ILLEGAL
  - SUCCESS
```

#Maps
Maps are denoted use a colon (`:`) and a space between each key value pair.

**Example: a CloudSlang task's navigate key is mapped to a mapping of results and their targets**
```yaml
navigate:
  ILLEGAL: FAILURE
  SUCCESS: printer
```

#Strings
Strings can be denoted in several ways. The best method for any given string depends on whether it includes any special characters, leading or trailing whitespace, spans multiple lines, along with other factors.

Strings that span multiple lines can be written using a pipe (`|`) to preserve line breaks or a greater than symbol (`>`) where each line break will be converted to a space.

Note: To comply with the official YAML specification, certain cases of passing string values in CloudSlang would require two sets of quotes. For example, a string with the value `Hello` would need to be passed to an input named `text` like this: `- text: "'Hello'"`. One set of quotes would indicate the value is a Python string and the other set of quotes would indicate that the Python string is itself a YAML string. To avoid the complication of all the extra quotes, CloudSlang deviates from the YAML specification and only requires one set of quotes. 

**Example:  a name of a CloudSlang flow is defined using the YAML unquoted style** 
```yaml
flow:
  name: hello_world
```

**Example:  passing a string to an input parameter** 
```yaml
- sayHi:
    do:
      print:
        - text: 'Hello, World'
```

**Example:  the pipe is used in CloudSlang to indicate a multi-line Python script** 
```yaml
action:
  python_script: |
    if divisor == '0':
      quotient = 'division by zero error'
    else:
      quotient = float(dividend) / float(divisor)
```

#Comments
Comments begin with the `#` symbol.