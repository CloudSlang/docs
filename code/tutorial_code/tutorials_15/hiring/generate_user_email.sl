namespace: tutorials_15.hiring

operation:
  name: generate_user_email

  inputs:
    - first_name
    - middle_name:
        default: ""
    - last_name
    - domain:
        system_property: tutorials.hiring.domain
        default: "acompany.com"
        overridable: false
    - attempt

  action:
    python_script: |
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
