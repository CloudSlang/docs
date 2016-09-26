namespace: tutorials_05.hiring

imports:
  base: tutorials_05.base

flow:
  name: new_hire

  inputs:
    - address

  workflow:
    - print_start:
        do:
          base.print:
            - text: "Starting new hire process"
        navigate:
          - SUCCESS: check_address

    - check_address:
        do:
          check_availability:
            - address
        publish:
          - availability: ${available}
          
    - print_finish:
        do:
          base.print:
            - text: "${'Availability for address ' + address + ' is: ' + availability}"
        navigate:
          - SUCCESS: SUCCESS
