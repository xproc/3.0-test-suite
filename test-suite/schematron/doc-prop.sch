<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron">
  <s:ns prefix="j" uri="http://www.w3.org/2005/xpath-functions"/>

   <s:pattern>
     <s:rule context="/">
       <s:assert test="j:map">The pipeline root is not “map”.</s:assert>
       <s:assert test="j:map/j:number[@key='a']">Element does not has an attribute 'key' with value 'a'.</s:assert>
       <s:assert test="j:map/j:number/text() = '1'">The property value is not 1</s:assert>
     </s:rule>
   </s:pattern>
</s:schema>
