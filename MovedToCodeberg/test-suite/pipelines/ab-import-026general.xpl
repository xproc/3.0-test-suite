<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:test="http://test" version="3.0" exclude-inline-prefixes="#all">
    
    <p:declare-step type="test:general">
        <p:input port="source"/>
        <p:output port="result"/>
        
        <p:wrap-sequence wrapper="general"/>
    </p:declare-step>
    
</p:library>
