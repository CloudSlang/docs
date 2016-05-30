namespace: tutorials_08.hiring

imports:
  base: tutorials_08.base

flow:
  name: new_hire

  inputs:
    - first_name
    - middle_name:
        required: false
    - last_name
    - attempt

  workflow:
    - print_start:
        do:
          base.print:
            - text: "Starting new hire process"

    - generate_address:
        do:
          generate_user_email:
            - first_name
            - middle_name
            - last_name
            - attempt
        publish:
          - address: ${email_address}

    - check_address:
        do:
          check_availability:
            - address
        publish:
          - availability: ${available}
          - password
        navigate:
          - UNAVAILABLE: print_fail
          - AVAILABLE: print_finish

    - print_finish:
        do:
          base.print:
            - text: "${'Availability for address ' + address + ' is: ' + str(availability)}"

    - on_failure:
      - print_fail:
          do:
            base.print:
              - text: "Failed to create address"
