<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step type="test:step-b" version="3.0"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:test="http://test">
    
    <p:output port="result" />
    
    <p:identity>
        <p:with-input>
            <is-visible>{p:step-available('test:step-a')}</is-visible>
        </p:with-input>
    </p:identity>
</p:declare-step>
