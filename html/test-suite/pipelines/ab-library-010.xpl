<p:library version="3.0" 
        xmlns:p="http://www.w3.org/ns/xproc"
        xmlns:x="http://test">
    <p:import href="ab-library-011.xpl" />
    
    <p:declare-step type="x:step">
        <p:output port="result" />
        
        <x:step1 />
    </p:declare-step>
</p:library>