<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                name="main"
                version="3.0">
  <p:output port="result"/>

  <p:variable name="a" select="3 + 4"/>

  <!-- this should fail, $a isn't a document -->
  <cx:option-value option="{p:document-property($a, 'a')}"/>

</p:declare-step>
