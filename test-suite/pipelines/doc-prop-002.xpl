<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                name="main"
                version="3.0">
  <p:output port="result"/>

  <p:identity name="id">
    <p:with-input port="source">
      <p:document href="../tests/doc-prop-002.xml"
                  document-properties="map { 'a': 1 }"/>
    </p:with-input>
  </p:identity>

  <p:cast-content-type content-type="application/xml">
    <p:with-input port="source" select="p:document-properties(.)"/>
  </p:cast-content-type>

</p:declare-step>
