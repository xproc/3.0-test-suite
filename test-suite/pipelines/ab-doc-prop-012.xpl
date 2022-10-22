<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                name="main"
                version="3.0">
  <p:output port="result"/>
  
  <p:identity name="producer">
    <p:with-input>
      <doc a='1' path="../documents/ab-doc.xml"/>
    </p:with-input>
  </p:identity>
  
  <p:identity name="id">
    <p:with-input port="source">
      <p:document document-properties="map { 'a': xs:integer(/doc/@a) }" href="{/doc/@path}"/>
      
    </p:with-input>
  </p:identity>
  
  <p:cast-content-type content-type="application/xml">
    <p:with-input port="source" select="p:document-properties(.)"/>
  </p:cast-content-type>
  
</p:declare-step>
