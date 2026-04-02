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

  <s:pattern>
    <s:title>Initials must be defined somewhere</s:title>
    <s:rule context="t:revision[@initials]">
      <s:assert test="//t:author[@initials=current()/@initials]">Initials must be defined</s:assert>
    </s:rule>
  </s:pattern>

  <s:pattern>
    <s:title>Name or initials must be provided</s:title>
    <s:rule context="t:revision">
      <s:assert test="@initials or t:author/t:name">Name or initials must be provided</s:assert>
    </s:rule>
  </s:pattern>

  <s:pattern>
    <s:title>A title must be provided</s:title>
    <s:rule context="t:test">
      <s:assert test="exists(.//t:title)">Title is required</s:assert>
    </s:rule>
  </s:pattern>

  <s:pattern>
    <s:title>A title must not be empty</s:title>
    <s:rule context="t:title">
      <s:assert test="normalize-space(.) != ''">Title must not be empty</s:assert>
    </s:rule>
  </s:pattern>

  <s:pattern>
    <s:title>Descending dates</s:title>
    <s:rule context="t:revision[preceding-sibling::t:revision]">
      <s:assert test="preceding-sibling::t:revision[1]/t:date ge t:date">Dates must be in descending order</s:assert>
    </s:rule>
  </s:pattern>

  <!-- It would be nice to test that t:test/@code contains valid error codes...
       but I can't figure out how to make that work in Schematron. I also suspect
       that XML Calabash isn't supporting Schematron perfectly, but that's a
       bug for another day.
  -->
</s:schema>
