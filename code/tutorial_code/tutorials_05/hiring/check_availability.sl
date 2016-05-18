namespace: tutorials_05.hiring

operation:
  name: check_availability

  inputs:
    - address

  python_action:
    script: |
      import random
      rand = random.randint(0, 2)
      vacant = rand != 0
      #print rand

  outputs:
    - available: ${vacant}

  results:
    - FAILURE: ${rand == 0}
    - SUCCESS
