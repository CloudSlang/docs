namespace: tutorials_15.hiring

imports:
  base: tutorials_15.base

flow:
  name: hire_all

  inputs:
    - names_list

  workflow:
    - process_all:
        async_loop:
          for: name in names_list
          do:
            new_hire:
              - first_name: ${name['first']}
              - middle_name: ${name.get('middle','')}
              - last_name: ${name['last']}
          publish:
            - address
            - total_cost
        aggregate:
          - email_list: ${filter(lambda x:x != '', map(lambda x:str(x['address']), branches_context))}
          - cost: ${sum(map(lambda x:x['total_cost'], branches_context))}
        navigate:
          - SUCCESS: print_success
          - FAILURE: print_failure

    - print_success:
        do:
          base.print:
            - text: >
                ${"All addresses were created successfully.\nEmail addresses created: "
                + str(email_list) + "\nTotal cost: " + str(cost)}

    - on_failure:
        - print_failure:
            do:
              base.print:
                - text: >
                    ${"Some addresses were not created or there is an email issue.\nEmail addresses created: "
                    + str(email_list) + "\nTotal cost: " + str(cost)}
