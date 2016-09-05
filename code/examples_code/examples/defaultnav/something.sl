namespace: examples.defaultnav

operation:
  name: something

  python_action:
      script: |
        x = 'Doing something important'
        print x

  results:
    - FAILURE: ${x = 'important thing not done'}
    - SUCCESS
