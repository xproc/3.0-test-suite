<p:library xmlns:p="http://www.w3.org/ns/xproc"
           xmlns:test="http://test" version="3.0">
  <p:import href="nw-import-001-lib1.xpl"/>

  <p:declare-step type="test:two">
    <p:output port="result"/>
    <p:identity>
      <p:with-input><two/></p:with-input>
    </p:identity>
  </p:declare-step>

  <p:declare-step type="test:join2">
    <p:output port="result" sequence="true"/>
    <test:one name="one"/>
    <test:two name="two"/>
    <p:identity>
      <p:with-input>
        <p:pipe step="one"/>
        <p:pipe step="two"/>
      </p:with-input>
    </p:identity>
  </p:declare-step>

</p:library>
