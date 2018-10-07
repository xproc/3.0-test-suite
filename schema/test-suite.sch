<?xml version="1.0" encoding="utf-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron"
          xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
          queryBinding="xslt2">
  <s:ns prefix="t" uri="http://xproc.org/ns/testsuite/3.0"/>
  <s:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>

  <s:pattern>
    <s:title>Root element is a test or test suite</s:title>
    <s:rule context="/*">
      <s:assert test="self::t:test-suite or self::t:test">Root element must test or test-suite</s:assert>
    </s:rule>
  </s:pattern>

  <!-- It would be nice to test that t:test/@code contains valid error codes...
       but I can't figure out how to make that work in Schematron. I also suspect
       that XML Calabash isn't supporting Schematron perfectly, but that's a
       bug for another day.
  -->
</s:schema>
