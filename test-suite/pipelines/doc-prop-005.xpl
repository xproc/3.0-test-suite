<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                name="main"
                version="3.0">
  <p:output port="result"/>

  <p:variable name="a" select="3 + 4"/>

  <p:cast-content-type content-type="application/xml">
    <p:with-input port="source" select="p:document-properties($a)">
      <p:empty/>
    </p:with-input>
  </p:cast-content-type>

</p:declare-step>
