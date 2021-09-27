<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:exf="http://exproc.org/standard/functions"
                name="main">
<p:input port="parameters" kind="parameter"/>
<p:output port="result"/>

<p:directory-list path="../../test-suite/tests" include-filter=".*\.xml"/>

<p:xslt>
  <p:input port="stylesheet">
    <p:document href="../xsl/sort-files.xsl"/>
  </p:input>
</p:xslt>

<p:viewport name="tests" match="c:file">
  <p:variable name="baseuri" select="resolve-uri(/*/@name, base-uri(.))"/>
  <p:load>
    <p:with-option name="href" select="$baseuri"/>
  </p:load>

  <!-- You'd like tou se p:add-attribute to add the xml:base attribute,
       but some of the examples contain invalid base URIs and that
       causes the step to fail. We cheat and use XSLT instead. -->
  <p:xslt>
    <p:input port="stylesheet">
      <p:document href="../xsl/inline-src.xsl"/>
    </p:input>
    <p:with-param name="baseuri" select="$baseuri"/>
  </p:xslt>
  <p:xslt>
    <p:input port="stylesheet">
      <p:document href="../xsl/merge-git-log.xsl"/>
    </p:input>
  </p:xslt>
</p:viewport>

</p:declare-step>
