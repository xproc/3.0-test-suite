<p:library xmlns:p="http://www.w3.org/ns/xproc"
           xmlns:test="http://test" version="3.0">

  <p:import href="nw-import-002-lib-common.xpl"/>

  <p:declare-step type="test:two">
    <p:output port="result"/>
    <p:identity>
      <p:with-input><two/></p:with-input>
    </p:identity>
  </p:declare-step>

</p:library>
