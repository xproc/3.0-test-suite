<?xml version="1.0" encoding="UTF-8"?>
<p:library version="3.1" xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:test="http://test">
    <p:import href="import-034-lib1.xpl" />
    
    <p:declare-step type="test:step1">
        <p:output port="result" />
        
        <p:identity>
            <p:with-input><dummy /></p:with-input>
        </p:identity>
    </p:declare-step>
</p:library>
