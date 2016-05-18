Lesson 14 - 3rd Party Python Packages
=====================================

Goal
----

In this lesson we'll learn how to import 3rd party Python packages to
use in an operation's ``python_action``.

Get Started
-----------

In this lesson we'll be installing a 3rd party Python package. In order to do so
you'll need to have Python and pip installed on your machine. You can download
Python (version 2.7) from `here <https://www.python.org/>`__. Python 2.7.9 and
later include pip by default. If you already have Python but don't have pip
installed on your machine, see the pip
`documentation <https://pip.pypa.io/en/latest/installing.html>`__ for
installation instructions.

We'll also need to add a **requirements.txt** file to a **python-lib** folder
which is at the same level as the **bin** folder that the CLI executable
resides in. If you downloaded a pre-built CLI the **requirements.txt** file is
already there and we will be appending to its contents.

The folder structure where the CLI executable is should look something
like this:

-  cslang

   -  bin

      -  cslang
      -  cslang.bat

   -  content

      -  CloudSlang ready-made content

   -  lib

      -  includes all the Java .jar files for the CLI

   -  python-lib

      -  requirements.txt

And finally, we'll need a new file, **fancy_text.sl** in the
**tutorials/hiring** folder, to house a new operation.

Requirements
------------

In the **requirements.txt** file we'll list all the Python packages we
need for our project. In our case we'll add a package that will allow us
to create large lettered strings using ordinary screen characters. The
package is called **pyfiglet**. A quick search on
`PyPI <https://pypi.python.org/pypi>`__ tells us that the current
version (at the time this tutorial was written) is **0.7.2**, so we'll
use that one. We also need to install **setuptools** since **pyfiglet**
depends on it. Each package we need takes up one line in our
**requirements.txt** file.

.. code:: bash

    setuptools
    pyfiglet == 0.7.2

Installing
----------

Now we need to use **pip** to download and install our packages.

To do so, run the following command from the **python-lib** directory:

.. code:: bash

    pip install -r requirements.txt -t .

.. note::

   If your machine is behind a proxy you'll need to specify the proxy
   using **pip**'s ``--proxy`` flag.

If everything has gone well, you should now see the **pyfiglet**
package's files in the **python-lib** folder along with the
**setuptools** files.

Operation
---------

Next, let's write an operation that will let us turn normal text into
something fancy using **pyfiglet**. All we need to do is import
**pyfiglet** as we would normally do in Python and use it. We also have
to do a little bit of work to turn the regular string we get from
calling ``renderText`` into something that will look right in our HTML
email.

.. code:: yaml

    namespace: tutorials.hiring

    operation:
      name: fancy_text

      inputs:
        - text

      python_action:
        script: |
          from pyfiglet import Figlet
          f = Figlet(font='slant')
          fancy = '<pre>' + f.renderText(text).replace('\n','<br>').replace(' ', '&nbsp') + '</pre>'

      outputs:
        - fancy

.. note::

   CloudSlang uses the `Jython <http://www.jython.org/>`__
   implementation of Python 2.7. For information on Jython's limitations,
   see the `Jython FAQ <https://wiki.python.org/jython/JythonFaq>`__.

Step
----

Now we can create a step in the ``new_hire`` flow to send some text to
the ``fancy_text`` operation and publish the output so we can use it in
our email. We'll put the new step between ``print_finish`` and
``send_mail``.

.. code:: yaml

    - fancy_name:
        do:
          fancy_text:
            - text: ${first_name + ' ' + last_name}
        publish:
          - fancy_text: ${fancy}

Use It
------

Finally, we need to change the body of the email to include our new
fancy text.

.. code:: yaml

    - send_mail:
        do:
          mail.send_mail:
            - hostname: ${get_sp('tutorials.properties.hostname')}
            - port: ${get_sp('tutorials.properties.port')}
            - from: ${get_sp('tutorials.properties.system_address')}
            - to: ${get_sp('tutorials.properties.hr_address')}
            - subject: "${'New Hire: ' + first_name + ' ' + last_name}"
            - body: >
                ${fancy_text + '<br>' +
                'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
                'Missing items: ' + all_missing + ' Cost of ordered items: ' + str(total_cost)}
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS

Run It
------

We can save the files and run the flow. When the email is sent it should
include the new fancy text we added to it.

.. code:: bash

    run --f <folder path>/tutorials/hiring/new_hire.sl --cp <folder path>/tutorials,<content folder path>/base --i first_name=john,last_name=doe --spf <folder path>/tutorials/properties/bcompany.prop.sl

Download the Code
-----------------

:download:`Lesson 14 - Complete code </code/tutorial_code/tutorials_14.zip>`

Up Next
-------

In the next lesson we'll see how to use an asynchronous loop.

New Code - Complete
-------------------

**new_hire.sl**

.. code:: yaml

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
        - all_missing:
            default: ""
            private: true
        - total_cost:
            default: 0
            private: true
        - order_map:
            default: {'laptop': 1000, 'docking station':200, 'monitor': 500, 'phone': 100}

      workflow:
        - print_start:
            do:
              base.print:
                - text: "Starting new hire process"

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
                - total_cost: ${cost + price}
            navigate:
              - AVAILABLE: print_finish
              - UNAVAILABLE: print_finish

        - print_finish:
            do:
              base.print:
                - text: >
                    ${'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '\n' +
                    'Missing items: ' + all_missing + ' Cost of ordered items: ' + str(total_cost)}

        - fancy_name:
            do:
              fancy_text:
                - text: ${first_name + ' ' + last_name}
            publish:
              - fancy_text: ${fancy}

        - send_mail:
            do:
              mail.send_mail:
                - hostname: ${get_sp('tutorials.properties.hostname')}
                - port: ${get_sp('tutorials.properties.port')}
                - from: ${get_sp('tutorials.properties.system_address')}
                - to: ${get_sp('tutorials.properties.hr_address')}
                - subject: "${'New Hire: ' + first_name + ' ' + last_name}"
                - body: >
                    ${fancy_text + '<br>' +
                    'Created address: ' + address + ' for: ' + first_name + ' ' + last_name + '<br>' +
                    'Missing items: ' + all_missing + ' Cost of ordered items:' + str(total_cost)}
            navigate:
              - FAILURE: FAILURE
              - SUCCESS: SUCCESS

        - on_failure:
          - print_fail:
              do:
                base.print:
                  - text: "${'Failed to create address for: ' + first_name + ' ' + last_name}"

**fancy_text.sl**

.. code:: yaml

    namespace: tutorials.hiring

    operation:
      name: fancy_text

      inputs:
        - text

      python_action:
        script: |
          from pyfiglet import Figlet
          f = Figlet(font='slant')
          fancy = '<pre>' + f.renderText(text).replace('\n','<br>').replace(' ', '&nbsp') + '</pre>'

      outputs:
        - fancy
