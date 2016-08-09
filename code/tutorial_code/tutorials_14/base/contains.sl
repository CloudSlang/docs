namespace: tutorials_14.hiring

decision:
  name: contains

  inputs:
    - container:
        default: ""
        required: false
    - sub

  results:
    - DOES_NOT_CONTAIN: ${container.find(sub) == -1}
    - CONTAINS
