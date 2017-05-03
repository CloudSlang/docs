Maven Content Compiler
++++++++++++++++++++++

The CloudSlang Maven Content Compiler can be used to compile CloudSlang source
files and receive indications of errors without using the CloudSlang CLI or
Build tool.

The CloudSlang Maven Content Compiler is an artifact in the cloud-slang module.
It extends the `Plexus Compiler Project <https://codehaus-plexus.github.io/plexus-compiler/>`__
in order to leverage the use of the existing maven-compiler-plugin.

To use the compiler, make the artifact available in the classpath when the
Compiler Plugin runs. This is achieved by adding a dependency when declaring the
plugin in your project's **pom.xml**.

The example below shows how to use the compiler:

.. code-block:: xml

  <project>
     [...]
     <build>
      [...]
      <plugins>
        [...]
        <plugin>
          <artifactId>maven-compiler-plugin</artifactId>
          <version>3.5.1</version>
          <configuration>
            <compilerId>cloudslang</compilerId>
          </configuration>
          <dependencies>
            <dependency>
              <groupId>io.cloudslang.lang</groupId>
              <artifactId>cloudslang-content-maven-compiler</artifactId>
              <version><any_version></version>
            </dependency>
          </dependencies>
        </plugin>
        [...]
      <plugins>
      [...]
     <build>
     [...]
  </project>
