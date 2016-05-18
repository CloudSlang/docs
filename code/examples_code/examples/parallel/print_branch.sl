namespace: examples.parallel

operation:
  name: print_branch

  inputs:
     - ID

  python_action:
    script: |
        name = 'branch ' + str(ID)
        print 'Hello from ' + name

  outputs:
    - name
    - num: ${ID}
