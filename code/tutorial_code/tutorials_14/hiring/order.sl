namespace: tutorials_14.hiring

operation:
  name: order

  inputs:
    - item
    - price

  action:
    python_script: |
      print 'Ordering: ' + item
      import random
      rand = random.randint(0, 2)
      available = rand != 0
      not_ordered = item + ';' if rand == 0 else ''
      price = 0 if rand == 0 else price
      if rand == 0: print 'Unavailable'

  outputs:
    - unavailable: ${not_ordered}
    - cost: ${price}

  results:
    - UNAVAILABLE: ${rand == 0}
    - AVAILABLE
