<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:ex="http://some-extension.org"
    type="ex:step" version="3.0" visibility="private">
    
    <p:output port="result"/>
    <p:identity>
        <p:with-input><result /></p:with-input>
    </p:identity>
</p:declare-step>