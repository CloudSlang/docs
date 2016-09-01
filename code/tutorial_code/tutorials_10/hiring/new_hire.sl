namespace: tutorials_10.hiring

imports:
  base: tutorials_10.base

flow:
  name: new_hire

  inputs:
    - first_name
    - middle_name:
        required: false
    - last_name

  workflow:
    - print_start:
        do:
          base.print:
            - text: "Starting new hire process"
        navigate:
          - SUCCESS: create_email_address

    - create_email_address:
        loop:
          for: attempt in range(1,5)
          do:
            create_user_email:
              - first_name
              - middle_name
              - last_name
              - attempt: ${str(attempt)}
          publish:
            - address
            - password
          break:
            - CREATED
            - FAILURE
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
