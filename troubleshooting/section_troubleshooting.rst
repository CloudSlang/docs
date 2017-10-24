Troubleshooting
+++++++++++++++

| :ref:`How to fix the "Failed to download Maven resources" message? <maven>`

----

.. _maven:

**How to fix the "Failed to download Maven resources" message?**

Note: If you are running cslang-cli, close it (otherwise the changes in settings.xml will not be applied).

  - In the cslang-cli or cslang-builder folder, go to ``maven/conf/`` and open ``settings.xml``.
  - Change the proxies tags from:

.. code-block:: xml
    <proxies>
        <proxy>
            <id>http-proxy</id>
            <active>false</active> <!--set to active if behind a proxy-->
            <protocol>http</protocol>
            <host>proxy.example.com</host>
            <port>8080</port>
            <username/>
            <password/>
            <nonProxyHosts>www.google.com|*.example.com</nonProxyHosts>
        </proxy>
        <proxy>
            <id>https-proxy</id>
            <active>false</active> <!--set to active if behind a proxy-->
            <protocol>https</protocol>
            <host>proxy.example.com</host>
            <port>8080</port>
            <username/>
            <password/>
            <nonProxyHosts>www.google.com|*.example.com</nonProxyHosts>
        </proxy>
    </proxies>

to

.. code-block:: xml

    <proxies>
        <proxy>
            <id>http-proxy</id>
            <active>true</active> <- change this value to 'active'
            <protocol>http</protocol>
            <host>add.your.proxy</host> <- change this value to your proxy host
            <port>8080</port> <- change this value to your proxy port
            <username/> <- change this value to your proxy username (only if required)
            <password/> <- change this value to your proxy password (only if required)
            <nonProxyHosts>www.google.com|*.example.com</nonProxyHosts> <- add amy hosts that should be ignored
        </proxy>
        <proxy>
            <id>https-proxy</id>
            <active>active</active> <!--set to active if behind a proxy-->
            <protocol>https</protocol>
            <host>add.your.proxy</host> <- change this value to your proxy host
            <port>8080</port> <- change this value to your proxy port
            <username/> <- change this value to your proxy username (only if required)
            <password/> <- change this value to your proxy password (only if required)
            <nonProxyHosts>www.google.com|*.example.com</nonProxyHosts> <- add amy hosts that should be ignored
        </proxy>
    </proxies>

  - Check the folder `/maven/repo/io/cloudslang/content/cs-package` (cs-package will be the dependency that failed to
  download, delete that folder, as it contains invalid contents and it will not be replaced if you retry the execution.

  - Once all the changes have applied, open the CLI again and run the operation/flow, that has previously failed.
  You should see the following message ``Completed downloading maven resources for cs-example-0.0.1`` and the execution
  will run normally.

