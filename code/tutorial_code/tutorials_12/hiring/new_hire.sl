namespace: tutorials_12.hiring

imports:
  base: tutorials_12.base
  hiring: tutorials_12.hiring
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
        private: true
    - total_cost:
        default: 0
        private: true
    - order_map:
        default: {'laptop': 1000, 'docking station': 200, 'monitor': 500, 'phone': 100}

  workflow:
    - print_start:
        do:
          base.print:
            - text: "Starting new hire process"

    - create_email_address:
        loop:
          for: attempt in range(1,5)
          do:
            hiring.create_user_email:
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
            - total_cost: ${cost + spent}
        navigate:
          - AVAILABLE: print_finish
          - UNAVAILABLE: print_finish

    - print_finish:
        do:
          base.print:
            - text: >
                ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '\n' +
                'Missing items: ' + all_missing + ' Cost of ordered items: ' + str(total_cost)}

    - send_mail:
       do:
         mail.send_mail:
           - hostname: "<host>"
           - port: "<port>"
           - from: "<from>"
           - to: "<to>"
           - subject: "${'New Hire: ' + first_name + ' ' + last_name}"
           - body: >
               ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
               'Missing items: ' + all_missing + ' Cost of ordered items: ' + str(total_cost)}
       navigate:
         - FAILURE: FAILURE
         - SUCCESS: SUCCESS

    - on_failure:
      - print_fail:
          do:
            base.print:
              - text: "${'Failed to create address for: ' + first_name + ' ' + last_name}"
