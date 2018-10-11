<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:exf="http://exproc.org/standard/functions"
                name="main">
<p:input port="source"/>
<p:input port="parameters" kind="parameter"/>
<p:output port="result"/>
<p:option name="prev" select="''"/>
<p:option name="next" select="''"/>
<p:serialization port="result" method="html" version="5"/>

<p:xslt>
  <p:input port="stylesheet">
    <p:document href="../xsl/format-test.xsl"/>
  </p:input>
  <p:with-param name="prev" select="$prev"/>
  <p:with-param name="next" select="$next"/>
</p:xslt>

</p:declare-step>
