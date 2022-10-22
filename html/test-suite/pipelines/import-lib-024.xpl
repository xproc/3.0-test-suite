<?xml version="1.0" encoding="UTF-8"?>
<p:library version="3.0" 
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:test="http://test">
    
    <p:declare-step type="test:step-a">
        <p:output port="result" />
        <p:identity>
            <p:with-input><not-visible /></p:with-input>
        </p:identity>
    </p:declare-step>
    
    <p:declare-step type="test:sister-step">
        <p:output port="result" />
        <test:step-a />
    </p:declare-step>
</p:library>
