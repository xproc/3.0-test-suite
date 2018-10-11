<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:exf="http://exproc.org/standard/functions"
                name="main">
<p:input port="parameters" kind="parameter"/>

<p:directory-list path="../../test-suite/tests"/>

<p:xslt name="dirlist">
  <p:input port="stylesheet">
    <p:document href="../xsl/sort-files.xsl"/>
  </p:input>
</p:xslt>

<p:viewport match="c:file">
  <p:viewport-source>
    <p:pipe step="dirlist" port="result"/>
  </p:viewport-source>

  <p:variable name="baseuri" select="resolve-uri(/*/@name, base-uri(.))"/>
  <p:load>
    <p:with-option name="href" select="$baseuri"/>
  </p:load>
  <p:add-attribute attribute-name="xml:base" match="/*">
    <p:with-option name="attribute-value" select="$baseuri"/>
  </p:add-attribute>
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

<p:xslt name="indexes">
  <p:input port="stylesheet">
    <p:document href="../xsl/test-indexes.xsl"/>
  </p:input>
</p:xslt>

<p:sink/>

<p:for-each>
  <p:iteration-source>
    <p:pipe step="indexes" port="secondary"/>
  </p:iteration-source>
  <p:store method="xml" indent="true">
    <p:with-option name="href" select="concat('../../build/html/',
                                              substring-after(base-uri(.), '/fakeroot/'))"/>
  </p:store>
</p:for-each>

</p:declare-step>
