<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:exf="http://exproc.org/standard/functions"
                name="main">
<p:input port="source"/>
<p:input port="parameters" kind="parameter"/>
<p:output port="result"/>

<p:option name="schema" select="'../../build/test-suite.rng'"/>
<p:option name="schematron" select="'../../build/test-suite.sch'"/>

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
        <p:pipe step="main" port="source"/>
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

</p:declare-step>
