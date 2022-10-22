<?xml version="1.0" encoding="UTF-8"?>
<p:library version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:test="http://test">
    <p:import href="ab-library-027.xpl" />
    
    <p:declare-step type="test:step">
        <p:import href="ab-library-027.xpl" />
        
        <p:output port="result" />
        <p:identity>
            <p:with-input><doc>{$imported-option}</doc></p:with-input>
        </p:identity>
    </p:declare-step>
</p:library>
