namespace: examples.defaultnav

operation:
  name: produce_default_navigation

  inputs:
    - navigation_type

  python_action:
    script: |
      print 'Default navigation based on input of - ' + navigation_type

  results:
    - SUCCESS: ${navigation_type == 'success'}
    - FAILURE
