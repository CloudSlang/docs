namespace: examples.paths

imports:
  alias: examples.paths.folder_b

flow:
  name: flow

  workflow:
    - default_path:
        do:
          op1:
            - text: "default path"
        navigate:
          - SUCCESS: fully_qualified_path
    - fully_qualified_path:
        do:
          examples.paths.folder_a.op2:
            - text: "fully qualified path"
        navigate:
          - SUCCESS: using_alias
    - using_alias:
        do:
          alias.op3:
            - text: "using alias"
        navigate:
          - SUCCESS: alias_continuation
    - alias_continuation:
        do:
          alias.folder_c.op4:
            - text: "alias continuation"
        navigate:
          - SUCCESS: SUCCESS

  results:
    - SUCCESS
