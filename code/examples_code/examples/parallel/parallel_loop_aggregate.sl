namespace: examples.parallel

flow:
  name: parallel_loop_aggregate

  inputs:
    - values: "1 2 3 4"

  workflow:
    - print_values:
        parallel_loop:
          for: value in values.split()
          do:
            print_branch:
              - ID: ${str(value)}
        publish:
            - name_list: "${', '.join(map(lambda x : str(x['name']), branches_context))}"
            - first_name: ${branches_context[0]['name']}
            - last_name: ${branches_context[-1]['name']}
            - total: "${str(sum(map(lambda x : int(x['num']), branches_context)))}"
        navigate:
          - SUCCESS: SUCCESS

  outputs:
    - name_list
    - first_name
    - last_name
    - total

  results:
    - SUCCESS
