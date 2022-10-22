<p:library xmlns:p="http://www.w3.org/ns/xproc"
           xmlns:test="http://test" version="3.0">
  <p:import href="nw-import-001-lib2.xpl"/>

  <p:declare-step type="test:one">
    <p:output port="result"/>
    <p:identity>
      <p:with-input><one/></p:with-input>
    </p:identity>
  </p:declare-step>

  <p:declare-step type="test:join1">
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
