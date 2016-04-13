namespace: tutorials_14.hiring

imports:
  base: tutorials_14.base
  mail: io.cloudslang.base.mail

flow:
  name: new_hire

  inputs:
    - first_name
    - middle_name:
        required: false
    - last_name
    - all_missing:
        default: ""
        overridable: false
    - total_cost:
        default: 0
        overridable: false
    - order_map:
        default: {'laptop': 1000, 'docking station':200, 'monitor': 500, 'phone': 100}

  workflow:
    - print_start:
        do:
          base.print:
            - text: "Starting new hire process"

    - create_email_address:
        loop:
          for: attempt in range(1,5)
          do:
            create_user_email:
              - first_name
              - middle_name
              - last_name
              - attempt
          publish:
            - address
          break:
            - CREATED
            - FAILURE
        navigate:
          - CREATED: get_equipment
          - UNAVAILABLE: print_fail
          - FAILURE: print_fail

    - get_equipment:
        loop:
          for: item, price in order_map
          do:
            order:
              - item
              - price
              - missing: ${all_missing}
              - cost: ${total_cost}
          publish:
            - all_missing: ${missing + not_ordered}
            - total_cost: ${cost + price}
        navigate:
          - AVAILABLE: print_finish
          - UNAVAILABLE: print_finish

    - print_finish:
        do:
          base.print:
            - text: >
                ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '\n' +
                'Missing items: ' + all_missing + ' Cost of ordered items: ' + str(total_cost)}

    - fancy_name:
        do:
          fancy_text:
            - text: ${first_name + ' ' + last_name}
        publish:
          - fancy_text: ${fancy}

    - send_mail:
        do:
          mail.send_mail:
            - hostname: ${get_sp('tutorials.properties.hostname')}
            - port: ${get_sp('tutorials.properties.port')}
            - from: ${get_sp('tutorials.properties.system_address')}
            - to: ${get_sp('tutorials.properties.hr_address')}
            - subject: "${'New Hire: ' + first_name + ' ' + last_name}"
            - body: >
                ${fancy_text + '<br>' +
                'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
                'Missing items: ' + all_missing + ' Cost of ordered items:' + str(total_cost)}
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS

    - on_failure:
      - print_fail:
          do:
            base.print:
              - text: "${'Failed to create address for: ' + first_name + ' ' + last_name}"
