namespace: examples.hello_world

flow:
  name: hello_world

  workflow:
    - sayHi:
        do:
          print:
            - text: "'Hello, World'"
        navigate:
          - SUCCESS: SUCCESS

  results:
    - SUCCESS
