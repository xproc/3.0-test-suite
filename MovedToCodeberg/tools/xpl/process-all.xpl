<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:exf="http://exproc.org/standard/functions"
                name="main">
<p:input port="parameters" kind="parameter"/>

<p:option name="base-dir" select="'../../test-suite/tests/'"/>
<p:option name="schema" select="'../../build/test-suite.rng'"/>
<p:option name="schematron" select="'../../build/test-suite.sch'"/>

<p:declare-step type="cx:message">
   <p:input port="source" sequence="true"/>
   <p:output port="result" sequence="true"/>
   <p:option name="log" cx:type="error|warn|info|debug|trace"/>
   <p:option name="message" required="true"/>
</p:declare-step>

<p:directory-list include-filter=".*\.xml">
  <p:with-option name="path" select="$base-dir"/>
</p:directory-list>

<p:xslt>
  <p:input port="stylesheet">
    <p:document href="../xsl/augment-files.xsl"/>
  </p:input>
</p:xslt>

<p:for-each name="loop">
  <p:iteration-source select="/c:directory/c:file"/>

  <cx:message>
    <p:with-option name="message" select="concat('Processing: ', /c:file/@name)"/>
  </cx:message>

  <p:load name="loader">
    <p:with-option name="href" select="resolve-uri(/c:file/@name, base-uri(/c:file))"/>
  </p:load>

<p:choose name="rngschema">
  <p:when test="$schema = ''">
    <p:output port="result"/>
    <p:identity/>
  </p:when>
  <p:otherwise>
    <p:output port="result"/>
    <p:load>
      <p:with-option name="href" select="$schema"/>
    </p:load>
  </p:otherwise>
</p:choose>

<p:choose name="rngvalid">
  <p:when test="$schema = ''">
    <p:output port="result"/>
    <p:identity/>
  </p:when>
  <p:otherwise>
    <p:output port="result"/>

    <p:validate-with-relax-ng>
      <p:input port="source">
        <p:pipe step="loader" port="result"/>
      </p:input>
      <p:input port="schema">
        <p:pipe step="rngschema" port="result"/>
      </p:input>
    </p:validate-with-relax-ng>
  </p:otherwise>
</p:choose>

<p:choose>
  <p:when test="$schematron = ''">
    <p:output port="result"/>
    <p:identity/>
  </p:when>
  <p:otherwise>
    <p:output port="result"/>
    <p:load name="schschema">
      <p:with-option name="href" select="$schematron"/>
    </p:load>
    <p:validate-with-schematron>
      <p:input port="source">
        <p:pipe step="rngvalid" port="result"/>
      </p:input>
      <p:input port="schema">
        <p:pipe step="schschema" port="result"/>
      </p:input>
    </p:validate-with-schematron>
  </p:otherwise>
</p:choose>

  <p:xslt>
    <p:input port="stylesheet">
      <p:document href="../xsl/format-test.xsl"/>
    </p:input>
    <p:with-param name="prev" select="/c:file/@prev">
      <p:pipe step="loop" port="current"/>
    </p:with-param>
    <p:with-param name="next" select="/c:file/@next">
      <p:pipe step="loop" port="current"/>
    </p:with-param>
  </p:xslt>

  <p:store method="html" version="5">
    <p:with-option name="href"
                   select="concat('../../build/html/tests/',
                                  substring-before(/c:file/@name, '.xml'), '.html')">
      <p:pipe step="loop" port="current"/>
    </p:with-option>
  </p:store>
</p:for-each>

</p:declare-step>
