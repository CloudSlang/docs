namespace: tutorials_11.hiring

imports:
  hiring: tutorials_11.hiring

flow:
  name: create_user_email

  inputs:
    - first_name
    - middle_name:
        required: false
    - last_name
    - attempt

  workflow:
    - generate_address:
        do:
          hiring.generate_user_email:
            - first_name
            - middle_name
            - last_name
            - attempt
        publish:
          - address: ${email_address}
          - password
        navigate:
          - SUCCESS: check_address
          - FAILURE: FAILURE

    - check_address:
        do:
          hiring.check_availability:
            - address
        publish:
          - availability: ${available}
        navigate:
          - UNAVAILABLE: UNAVAILABLE
          - AVAILABLE: CREATED

  outputs:
    - address
    - password
    - availability

  results:
    - CREATED
    - UNAVAILABLE
    - FAILURE
