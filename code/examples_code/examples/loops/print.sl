namespace: examples.loops

operation:
  name: print

  inputs:
    - text

  python_action:
    script: print text

  outputs:
    - out: ${text}

  results:
    - SUCCESS
