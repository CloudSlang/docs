namespace: examples.defaultnav

operation:
  name: send_email_mock

  inputs:
    - recipient
    - subject

  python_action:
    script: |
      print 'Email sent to ' + recipient + ' with subject - ' + subject
