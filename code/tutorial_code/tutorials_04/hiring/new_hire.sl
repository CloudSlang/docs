namespace: tutorials_04.hiring

imports:
  base: tutorials_04.base

flow:
  name: new_hire

  workflow:
    - print_start:
        do:
          base.print:
            - text: "Starting new hire process"
