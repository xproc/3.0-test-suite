<p:declare-step version="3.0"
        type="test:step1"
        xmlns:p="http://www.w3.org/ns/xproc"
        xmlns:test="http://test">
    <p:import href="ab-import-006.xpl" />
    <p:output port="result" />
    <p:identity>
        <p:with-input><success /></p:with-input>
    </p:identity>
</p:declare-step>

