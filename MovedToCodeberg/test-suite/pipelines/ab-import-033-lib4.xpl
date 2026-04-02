<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:test="http://test"
  version="3.0">
  
   <p:option name="test:option" static="true" select="42" />
  
   <p:declare-step type="test:step4">
    <p:output port="result" />
    
    <p:identity>
      <p:with-input><step-4 att="{$test:option}"/></p:with-input>
    </p:identity>
  </p:declare-step>
</p:library>