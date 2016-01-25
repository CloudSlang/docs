namespace: tutorials_15.hiring

operation:
  name: fancy_text

  inputs:
    - text

  action:
    python_script: |
      from pyfiglet import Figlet
      f = Figlet(font='slant')
      fancy = '<pre>' + f.renderText(text).replace('\n','<br>').replace(' ', '&nbsp') + '</pre>'

  outputs:
    - fancy
