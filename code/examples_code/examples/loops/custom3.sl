namespace: examples.loops

operation:
  name: custom3

  inputs:
    - text

  python_action:
    script: print text

  results:
    - CUSTOM: ${int(text) == 3}
    - SUCCESS
