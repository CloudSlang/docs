Lesson 3 - Action File
======================

Goal
----

In this lesson we'll start writing the code that gets called from the CloudSlang
operation.

Get Started
-----------

Let's start by creating a new file. In the **src\main\java** folder let's create
a new package named ``io.cloudslang.tutorial.httpclient.actions``. And within
that package, create a new class named ``HttpClientAction``.

Imports
-------

Next, we'll add some imports. We need to import the action annotations and a
couple of other things the annotations will use.

.. code-block:: java

  import com.hp.oo.sdk.content.annotations.Action;
  import com.hp.oo.sdk.content.annotations.Output;
  import com.hp.oo.sdk.content.annotations.Param;
  import com.hp.oo.sdk.content.annotations.Response;
  import com.hp.oo.sdk.content.plugin.ActionMetadata.MatchType;
  import com.hp.oo.sdk.content.plugin.ActionMetadata.ResponseType;

@Action Annotation
------------------

Then we can add the ``@Action`` annotation to the class. It is made up of three
parts. First, we provide a name for the action. Second, we declare an array of
outputs for the action using the ``@Output`` annotation. Third, we decalre an
array of responses for the action using the ``@Response`` annotation.

.. code-block:: java

  @Action(name = "Simple HTTP Client",
          outputs = {
                  @Output("statusCode"),
                  @Output("responseHeaders"),
                  @Output("returnCode"),
                  @Output("returnResult")
          },
          responses = {
                  @Response(text = "success", field = "returnCode", value = "0", matchType = MatchType.COMPARE_EQUAL, responseType = ResponseType.RESOLVED),
                  @Response(text = "failure", field = "returnCode", value = "-1", matchType = MatchType.COMPARE_EQUAL, responseType = ResponseType.ERROR, isOnFail = true)
          }
    )

Here we name the @Action **Simple HTTP Client**. After that we declare some
outputs in an array using the ``@Output`` annotation and we provide a string for
each output's name. This name will be used in the CloudSlang operation to
retrieve the output's value. Finally, in another array we declare the responses
that our action can return. These will be used as the results of the CloudSlang
operation. Each @Response is made of several parts:

  - text: name of the response
  - field: output to be checked
  - value: value to check against
  - matchType: type of check
    (from com.hp.oo.sdk.content.plugin.ActionMetadata.MatchType)
  - responseType: type of response
    (from com.hp.oo.sdk.content.plugin.ActionMetadata.ResponseType)
  - isDefault: whether or not response is the default response
  - isOnFail: whether or not response is the failure response

@Action Method
--------------

Now we'll write the method that will be called by the CloudSlang operation. The
method must conform to the following signature:

.. code-block:: java

  public Map<String, String> methodName(@Param(name) Type param, ...)

The map that is returned contains the names and values of the outputs of the
action. The names are the same ones that were declared using ``@Output`` in the
``@Action`` annotation. The parameters that are declared with the ``@Param``
annotation are the inputs that the method will receive from the CloudSlang
operation. Each @Param will contain at least value for its name. It may also
contain a ``required`` boolean to override the default of ``false``.

Let's create our method and add some parameters:

.. code-block:: java

  public Map<String, String> execute(@Param(value = "url", required = true) String url,
                                     @Param("proxyHost") String proxyHost,
                                     @Param("proxyPort") String proxyPort,
                                     @Param("headers") String headers,
                                     @Param("queryParams") String queryParams,
                                     @Param("formParams") String formParams,
                                     @Param("body") String body,
                                     @Param("contentType") String contentType,
                                     @Param(value = "method", required = true) String method){
  }
