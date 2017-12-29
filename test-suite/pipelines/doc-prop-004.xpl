<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                name="main"
                version="3.0">
  <p:output port="result"/>

  <p:identity name="id">
    <p:with-input port="source">
      <p:inline document-properties="map { 'a': 1 }">
        <doc/>
      </p:inline>
    </p:with-input>
  </p:identity>

  <p:variable name="a" select="."/>

  <cx:option-value option="{p:document-property($a, 'a')}"/>

</p:declare-step>
