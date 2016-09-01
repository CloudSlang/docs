namespace: tutorials_09.hiring

imports:
  base: tutorials_09.base

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
        navigate:
          - SUCCESS: create_email_address

    - create_email_address:
        do:
          create_user_email:
            - first_name
            - middle_name
            - last_name
            - attempt
        publish:
          - address
          - password
        navigate:
          - CREATED: print_finish
          - UNAVAILABLE: print_fail
          - FAILURE: print_fail

    - print_finish:
        do:
          base.print:
            - text: "${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name}"
        navigate:
          - SUCCESS: SUCCESS
          
    - on_failure:
      - print_fail:
          do:
            base.print:
              - text: "${'Failed to create address for: ' + first_name + ' ' + last_name}"
