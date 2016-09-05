namespace: tutorials_03.hiring

imports:
  base: tutorials_03.base

flow:
  name: new_hire

  workflow:
    - print_start:
        do:
          base.print:
            - text: "Starting new hire process"
        navigate:
          - SUCCESS: SUCCESS

  results:
    - SUCCESS
