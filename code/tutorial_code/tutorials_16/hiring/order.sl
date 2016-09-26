namespace: tutorials_16.hiring

operation:
  name: order

  inputs:
    - item
    - price

  python_action:
    script: |
      print 'Ordering: ' + item + '\n'
      import random
      rand = random.randint(0, 2)
      available = rand != 0
      not_ordered = item + ';' if rand == 0 else ''
      spent = 0 if rand == 0 else price
      if rand == 0: print 'Unavailable'

  outputs:
    - not_ordered
    - spent: ${str(spent)}

  results:
    - UNAVAILABLE: ${rand == 0}
    - AVAILABLE
