<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:test="http://test" version="3.0">
  
  <p:import href="ab-import-033-lib2.xpl" />
  <p:import href="ab-import-033-lib3.xpl" />
  
  <p:declare-step type="test:step1">
    <p:output port="result" />
    
    <p:identity name="first">
      <p:with-input><step-1 att="{$test:option}"/></p:with-input>
    </p:identity>
    <test:step2 name="second"/>
    <test:step3 name="third"/>
    <test:step4 name="fourth"/>
    
    <p:wrap-sequence wrapper="result">
      <p:with-input pipe="@first @second @third @fourth" />
    </p:wrap-sequence>
  </p:declare-step>
  
</p:library>