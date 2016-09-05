namespace: tutorials_13.hiring

operation:
  name: generate_user_email

  inputs:
    - first_name
    - middle_name:
        required: false
        default: ""
    - last_name
    - domain:
        default: "acompany.com"
        private: true
    - attempt

  python_action:
    script: |
      attempt = int(attempt)
      if attempt == 1:
        address = first_name[0:1] + '.' + last_name + '@' + domain
      elif attempt == 2:
        address = first_name + '.' + first_name[0:1] + '@' + domain
      elif attempt == 3 and middle_name != '':
        address = first_name + '.' + middle_name[0:1] + '.' + last_name + '@' + domain
      else:
        address = ''
      #print address

  outputs:
    - email_address: ${address}

  results:
    - FAILURE: ${address == ''}
    - SUCCESS
