<p:library xmlns:p="http://www.w3.org/ns/xproc"
           xmlns:ex="http://test"
           version="3.0">

  <p:option name="foo" static="true" select="7"/>
  <p:option name="foo" static="true" select="11"/>

  <p:declare-step type="ex:test">
    <p:output port="result"/>
    <p:identity>
      <p:with-input><doc/></p:with-input>
    </p:identity>
  </p:declare-step>
</p:library>
