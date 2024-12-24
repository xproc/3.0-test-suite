<p:library xmlns:p="http://www.w3.org/ns/xproc"
           xmlns:test="http://test" version="3.0">

  <p:declare-step type="test:common-step">
    <p:output port="result"/>
    <p:identity>
      <p:with-input><common/></p:with-input>
    </p:identity>
  </p:declare-step>

</p:library>
