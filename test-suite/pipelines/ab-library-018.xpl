<p:library xmlns:p="http://www.w3.org/ns/xproc" version="3.0">
    
    <p:option name="option" select="42" static="true" visibility="false"/>
    
    <p:declare-step type="Q{http://test}step">
        <p:output port="result" />
        <p:identity>
            <p:with-input><doc>{$option -1}</doc></p:with-input>
        </p:identity>
    </p:declare-step>
</p:library>

