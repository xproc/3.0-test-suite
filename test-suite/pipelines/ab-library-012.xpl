<p:library xmlns:p="http://www.w3.org/ns/xproc" version="3.0">
    <p:import href="ab-library-012.xpl" />
    <p:declare-step type="Q{http://test}one">
        <p:output port="result" />
        <p:identity>
            <p:with-input><one /></p:with-input>
        </p:identity>
    </p:declare-step>
    
    <p:declare-step type="Q{http://test}two">
        <p:output port="result" />
        <p:identity>
            <p:with-input><two /></p:with-input>
        </p:identity>
    </p:declare-step>
    
</p:library>

