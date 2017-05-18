CloudSlang documentation.
=========================

[![Circle CI](https://circleci.com/gh/CloudSlang/docs/tree/master.svg?style=svg)](https://circleci.com/gh/CloudSlang/docs/tree/master)


The documentation has been generated with reStructuredText and built using Sphinx.

### Prerequisites: Python 2.7 and pip.

You can download Python (version 2.7) from [here] (https://www.python.org/). 

Python 2.7.9 and later include pip by default. If you already have Python but don't have pip, see the pip [documentation] (https://pip.pypa.io/en/latest/installing.html) for installation instructions.

Run the following command from the root folder:
 
    pip install Sphinx sphinx_rtd_theme

> Note: If your machine is behind a proxy you will need to specify the proxy using pip's --proxy flag.

After you have finished your changes, run the following command to build the project:

    make.bat html - for Windows
    Makefile html - for Linux
    
    Your project will be available in the _build folder.

Documentation available at [readTheDocs](http://cloudslang-docs.readthedocs.org/)

