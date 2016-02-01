namespace: tutorials_13.hiring

imports:
  hiring: tutorials_13.hiring

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
            - middle_name:
                required: false
            - last_name
            - attempt
        publish:
          - address: ${email_address}
        navigate:
          SUCCESS: check_address
          FAILURE: FAILURE

    - check_address:
        do:
          hiring.check_availability:
            - address
        publish:
          - availability: ${available}
        navigate:
          UNAVAILABLE: UNAVAILABLE
          AVAILABLE: CREATED

  outputs:
    - address
    - availability

  results:
    - CREATED
    - UNAVAILABLE
    - FAILURE
