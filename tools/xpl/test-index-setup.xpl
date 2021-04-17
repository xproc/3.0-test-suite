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

  <!-- Some of the tests include invalid base URIs. That causes the
       add-attribute step to fail. Just ignore it in those cases. -->
  <p:try>
    <p:group>
      <p:add-attribute attribute-name="xml:base" match="/*">
        <p:with-option name="attribute-value" select="$baseuri"/>
      </p:add-attribute>
    </p:group>
    <p:catch>
      <p:identity/>
    </p:catch>
  </p:try>

  <p:xslt>
    <p:input port="stylesheet">
      <p:document href="../xsl/inline-src.xsl"/>
    </p:input>
  </p:xslt>
  <p:xslt>
    <p:input port="stylesheet">
      <p:document href="../xsl/merge-git-log.xsl"/>
    </p:input>
  </p:xslt>
</p:viewport>

</p:declare-step>
