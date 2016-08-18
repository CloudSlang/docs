namespace: tutorials_14.hiring

operation:
  name: check_availability

  inputs:
    - address

  python_action:
    script: |
      import random
      import string
      rand = random.randint(0, 2)
      vacant = rand != 0
      # print vacant
      if vacant == True:
        password = ''.join(random.choice(string.letters) for _ in range(6))
      else:
        password = ''
  outputs:
    - available: ${str(vacant)}
    - password:
        value: ${password}
        sensitive: true
  results:
    - UNAVAILABLE: ${rand == 0}
    - AVAILABLE
