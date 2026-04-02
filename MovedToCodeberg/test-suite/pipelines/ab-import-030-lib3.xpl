<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:test="http://test"
  version="3.0">
  
  <p:declare-step type="test:step3">
    <p:output port="result" />
    
    <p:identity>
      <p:with-input><step-3 /></p:with-input>
    </p:identity>
  </p:declare-step>
</p:library>