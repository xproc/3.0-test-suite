<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:exf="http://exproc.org/standard/functions"
                name="main">
<p:output port="result"/>
<p:option name="spec-dir"/>

<p:directory-list>
  <p:with-option name="path" select="$spec-dir">
    <p:empty/>
  </p:with-option>
</p:directory-list>

<p:viewport name="specs" match="c:file">
  <p:variable name="baseuri" select="resolve-uri(/*/@name, base-uri(.))"/>
  <p:load>
    <p:with-option name="href" select="$baseuri"/>
  </p:load>
  <p:add-attribute attribute-name="xml:base" match="/*">
    <p:with-option name="attribute-value" select="$baseuri"/>
  </p:add-attribute>
</p:viewport>

</p:declare-step>
