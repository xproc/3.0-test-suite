<p:library version="3.0" 
        xmlns:p="http://www.w3.org/ns/xproc"
        xmlns:x="http://test">
    
    <p:declare-step type="x:step1" visibility="private">
        <p:output port="result" />
        <p:identity>
            <p:with-input><doc /></p:with-input>        
        </p:identity>
    </p:declare-step>
    
    <p:declare-step type="x:step">
        <p:output port="result" />
        
        <x:step1 />
    </p:declare-step>
</p:library>