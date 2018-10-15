<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                name="main">
<p:input port="source"/>
<p:input port="parameters" kind="parameter"/>
<p:output port="result"/>
<p:serialization port="result" method="html" version="5"/>

<p:option name="stylesheet" required="true"/>

<p:load name="xslt">
  <p:with-option name="href" select="$stylesheet"/>
</p:load>

<p:xslt>
  <p:input port="source">
    <p:pipe step="main" port="source"/>
  </p:input>
  <p:input port="stylesheet">
    <p:pipe step="xslt" port="result"/>
  </p:input>
  <p:with-param name="specs" select="/*">
    <p:document href="../../build/specs.xml"/>
  </p:with-param>
</p:xslt>

</p:declare-step>
