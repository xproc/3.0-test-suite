<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:test="http://test" version="3.0" exclude-inline-prefixes="#all">
    <p:import href="../pipelines/ab-import-026general.xpl"/>
    
    <p:declare-step type="test:a">
        <p:import href="../pipelines/ab-import-026general.xpl"/>
        <p:input port="source"/>
        <p:output port="result"/>
        
        <test:general/>    
        <p:wrap-sequence wrapper="A"/>
    </p:declare-step>
    
</p:library>
