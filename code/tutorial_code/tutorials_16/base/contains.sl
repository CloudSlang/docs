namespace: tutorials_16.base

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
