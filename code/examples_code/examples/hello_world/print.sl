namespace: examples.hello_world

operation:

  name: print

  inputs:
    - text

  python_action:
    script: print text

  results:
    - SUCCESS
