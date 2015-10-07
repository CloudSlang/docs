
#Lesson 14 - 3<sup>rd</sup> Party Python Packages

##Goal
In this lesson we'll learn how to import 3<sup>rd</sup> party Python packages to use in an operation's `python_script` action.

##Get Started
We'll be installing our 3<sup>rd</sup> party Python package in this lesson using **pip**. If you don't already have **pip** installed on your machine, see the **pip** [documentation](https://pip.pypa.io/en/latest/installing.html). We'll also need to add a **requirements.txt** file to a **python-lib** folder which is at the same level as the **bin** folder that the CLI executable resides in. 

The folder structure where the CLI executable is should look something like this:

+ cslang
    + bin
	    + cslang
	    + cslang.bat
	+ content
	    + CloudSlang ready-made content 
	+ lib
		+ includes all the Java .jar files for the CLI
	+ python-lib
		+ requirements.txt

And finally, we'll need a new file, **fancy_text.sl** in the **tutorials/hiring** folder, to house a new operation.

##Requirements
In the **requirements.txt** file we'll list all the Python packages we need for our project. In our case we'll add a package that will allow us to create large lettered strings using ordinary screen characters. The package is called **pyfiglet**. A quick search on [PyPI](https://pypi.python.org/pypi) tells us that the current version (at the time this tutorial was written) is **0.7.2**, so we'll use that one. We also need to install **setuptools** since **pyfiglet** depends on it. Each package we need takes up one line in our **requirements.txt** file. 

```bash
pyfiglet == 0.7.2
setuptools
```

##Installing
Now we need to use **pip** to download and install our packages. 

To do so, run the following command from the **python-lib** directory:
```bash
pip install -r requirements.txt -t .
```

Note: If your machine is behind a proxy you'll need to specify the proxy using **pip**'s `--proxy` flag.

If everything has gone well, you should now see the **pyfiglet** package's files in the **python-lib** folder along with the **setuptools** files. 

##Operation
Next, let's write an operation that will let us turn normal text into something fancy using **pyfiglet**. All we need to do is import **pyfiglet** as we would normally do in Python and use it. We also have to do a little bit of work to turn the regular string we get from calling `renderText` into something that will look right in our HTML email.

```yaml
namespace: tutorials.hiring

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
```

**Note:** CloudSlang uses the [Jython](http://www.jython.org/) implementation of Python 2.7. For information on Jython's limitations, see the [Jython FAQ](https://wiki.python.org/jython/JythonFaq).

##Task 
Now we can create a task in the `new_hire` flow to send some text to the `fancy_text` operation and publish the output so we can use it in our email. We'll put the new task between `print_finish` and `send_mail`.

```yaml
    - fancy_name:
        do:
          fancy_text:
            - text: first_name + ' ' + last_name
        publish:
          - fancy_text: fancy
```

##Use It
Finally, we need to change the body of the email to include our new fancy text.

```yaml
    - send_mail:
        do:
          mail.send_mail:
            - hostname
            - port
            - from
            - to
            - subject: "'New Hire: ' + first_name + ' ' + last_name"
            - body: >
                fancy_text + '<br>' +
                'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
                'Missing items: ' + missing + ' Cost of ordered items: ' + str(total_cost)
        navigate:
          FAILURE: FAILURE
          SUCCESS: SUCCESS
```

##Run It
We can save the files and run the flow. When the email is sent it should include the new fancy text we added to it.

```bash
run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials/base,<folder path>/tutorials/hiring,<content folder path>/base --i first_name=john,last_name=doe --spf <folder path>/tutorials/properties/bcompany.yaml
```

##Up Next
In the next lesson we'll see how to use an asynchronous loop.

##New Code - Complete

**new_hire.sl**
```yaml
namespace: tutorials.hiring

imports:
  base: tutorials.base
  mail: io.cloudslang.base.mail

flow:
  name: new_hire

  inputs:
    - first_name
    - middle_name:
        required: false
    - last_name
    - missing:
        default: "''"
        overridable: false
    - total_cost:
        default: 0
        overridable: false
    - order_map: >
        {'laptop': 1000, 'docking station':200, 'monitor': 500, 'phone': 100}
    - hostname:
        system_property: tutorials.hiring.hostname
    - port:
        system_property: tutorials.hiring.port
    - from:
        system_property: tutorials.hiring.system_address
    - to:
        system_property: tutorials.hiring.hr_address

  workflow:
    - print_start:
        do:
          base.print:
            - text: "'Starting new hire process'"

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
          CREATED: get_equipment
          UNAVAILABLE: print_fail
          FAILURE: print_fail

    - get_equipment:
        loop:
          for: item, price in order_map
          do:
            order:
              - item
              - price
          publish:
            - missing: fromInputs['missing'] + unavailable
            - total_cost: fromInputs['total_cost'] + cost
        navigate:
          AVAILABLE: print_finish
          UNAVAILABLE: print_finish

    - print_finish:
        do:
          base.print:
            - text: >
                'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '\n' +
                'Missing items: ' + missing + ' Cost of ordered items: ' + str(total_cost)

    - fancy_name:
        do:
          fancy_text:
            - text: first_name + ' ' + last_name
        publish:
          - fancy_text: fancy

    - send_mail:
        do:
          mail.send_mail:
            - hostname
            - port
            - from
            - to
            - subject: "'New Hire: ' + first_name + ' ' + last_name"
            - body: >
                fancy_text + '<br>' +
                'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
                'Missing items: ' + missing + ' Cost of ordered items:' + str(total_cost)
        navigate:
          FAILURE: FAILURE
          SUCCESS: SUCCESS

    - on_failure:
      - print_fail:
          do:
            base.print:
              - text: "'Failed to create address for: ' + first_name + ' ' + last_name"
```

**fancy_text.sl**

```yaml
namespace: tutorials.hiring

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
```
