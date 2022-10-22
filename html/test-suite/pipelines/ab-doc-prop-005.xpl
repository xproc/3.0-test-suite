<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                name="main"
                version="3.0">
  <p:output port="result"/>
  
  <p:identity name="producer">
    <p:with-input>
      <doc a='1' />
    </p:with-input>
  </p:identity>
  
  <p:identity name="id">
    <p:with-input port="source">
      <p:inline document-properties="map { 'a': xs:integer(/doc/@a) }">
        <doc/>
      </p:inline>
    </p:with-input>
  </p:identity>

  <p:cast-content-type content-type="application/xml">
    <p:with-input port="source" select="p:document-properties(.)"/>
  </p:cast-content-type>

</p:declare-step>
