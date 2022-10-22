<p:library xmlns:p="http://www.w3.org/ns/xproc" version="3.0">
    
    <p:variable name="variable" select="42" static="true" />
    
    <p:declare-step type="Q{http://test}step">
        <p:output port="result" />
        <p:identity>
            <p:with-input><doc>{$variable -1}</doc></p:with-input>
        </p:identity>
    </p:declare-step>
</p:library>

