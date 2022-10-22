<p:library xmlns:p="http://www.w3.org/ns/xproc" version="3.0">
    <p:import href="ab-library-026.xpl" />
    <p:variable name="variable" select="$variable1 +1" static="true"/>
    
    <p:declare-step type="Q{http://test}step">
        <p:output port="result" />
        <p:identity>
            <p:with-input><doc>{$variable}</doc></p:with-input>
        </p:identity>
    </p:declare-step>
</p:library>

