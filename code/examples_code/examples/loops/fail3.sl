namespace: examples.loops

operation:
  name: fail3

  inputs:
    - text

  python_action:
    script: print text

  results:
    - FAILURE: ${int(text) == 3}
    - SUCCESS
