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
    - fully_qualified_path:
        do:
          examples.paths.folder_a.op2:
            - text: "fully qualified path"
    - using_alias:
        do:
          alias.op3:
            - text: "using alias"
    - alias_continuation:
        do:
          alias.folder_c.op4:
            - text: "alias continuation"
