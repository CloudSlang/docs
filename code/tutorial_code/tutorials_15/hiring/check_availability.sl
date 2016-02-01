namespace: tutorials_15.hiring

operation:
  name: check_availability

  inputs:
    - address

  action:
    python_script: |
      import random
      rand = random.randint(0, 2)
      vacant = rand != 0
      #print vacant

  outputs:
    - available: ${vacant}

  results:
    - UNAVAILABLE: ${rand == 0}
    - AVAILABLE
