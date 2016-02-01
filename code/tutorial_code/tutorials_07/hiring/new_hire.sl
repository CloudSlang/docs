namespace: tutorials_07.hiring

imports:
  base: tutorials_07.base
  hiring: tutorials_07.hiring

flow:
  name: new_hire

  inputs:
    - address

  workflow:
    - print_start:
        do:
          base.print:
            - text: "Starting new hire process"

    - check_address:
        do:
          hiring.check_availability:
            - address
        publish:
          - availability: ${available}
        navigate:
          UNAVAILABLE: print_fail
          AVAILABLE: print_finish

    - print_finish:
        do:
          base.print:
            - text: "${'Availability for address ' + address + ' is: ' + str(availability)}"

    - on_failure:
      - print_fail:
          do:
            base.print:
              - text: "${'Failed to create address: ' + address}"
