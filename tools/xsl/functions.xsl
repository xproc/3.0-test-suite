<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:t="http://xproc.org/ns/testsuite/3.0"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="h p t xs"
                version="2.0">

<xsl:variable name="specs" as="element()" select="doc('../../build/specs.xml')/*"/>

<xsl:variable name="calabash" select="doc('../../reports/xml-calabash.xml')/*"/>
<xsl:variable name="morganaxproc" select="doc('../../reports/MorganaXProc-III.xml')/*"/>

<xsl:key name="id" match="*" use="@id"/>
<xsl:key name="href" match="h:a" use="@href"/>

<xsl:function name="t:error-code">
  <xsl:param name="code" as="xs:string"/>
  <xsl:variable name="name" select="substring($code, 6)"/>

  <xsl:variable name="links" select="key('id', concat('err.',$name), $specs)"/>

  <xsl:choose>
    <xsl:when test="count($links) = 1">
      <xsl:variable name="basename"
                    select="substring-before(substring-after(base-uri($links),'/build/specs/'),'.html')"/>
      <a href="{t:spec-link($basename)}#err.{$name}">
        <xsl:value-of select="$code"/>
      </a>
    </xsl:when>
    <xsl:when test="$links">
      <xsl:value-of select="$code"/>
      <xsl:text> [</xsl:text>
      <xsl:for-each select="$links">
        <xsl:variable name="basename"
                      select="substring-before(substring-after(base-uri(.), '/build/specs/'), '.html')"/>
        <xsl:if test="position() gt 1">, </xsl:if>
        <a href="{t:spec-link($basename)}#err.{$name}">
          <xsl:value-of select="t:spec-name($basename)"/>
        </a>
      </xsl:for-each>
      <xsl:text>]</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$code"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="t:spec-link">
  <xsl:param name="shortname"/>
  <xsl:value-of select="concat('http://spec.xproc.org/master/head/', $shortname, '/')"/>
</xsl:function>

<xsl:function name="t:spec-name">
  <xsl:param name="shortname"/>
  <xsl:choose>
    <xsl:when test="$shortname = 'xproc'">XProc</xsl:when>
    <xsl:when test="$shortname = 'steps'">Core steps</xsl:when>
    <xsl:when test="$shortname = 'file'">File steps</xsl:when>
    <xsl:when test="$shortname = 'json'">JSON steps</xsl:when>
    <xsl:when test="$shortname = 'os'">Operating system steps</xsl:when>
    <xsl:when test="$shortname = 'paged-media'">Paged-media steps</xsl:when>
    <xsl:when test="$shortname = 'run'">Run step</xsl:when>
    <xsl:when test="$shortname = 'text'">Text steps</xsl:when>
    <xsl:when test="$shortname = 'validation'">Validation steps</xsl:when>
    <xsl:otherwise>
      <xsl:message>Unrecognized spec: <xsl:value-of select="$shortname"/></xsl:message>
      <xsl:value-of select="$shortname"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="t:feature-code">
  <xsl:param name="code" as="xs:string"/>

  <xsl:value-of select="$code"/>
</xsl:function>

<xsl:function name="t:gi">
  <xsl:param name="node" as="element()"/>
  <xsl:sequence select="t:gi-from-QName(node-name($node))"/>
</xsl:function>

<xsl:function name="t:gi-from-QName">
  <xsl:param name="name" as="xs:QName"/>

  <xsl:choose>
    <xsl:when test="namespace-uri-from-QName($name) = 'http://www.w3.org/ns/xproc'">
      <xsl:variable name="name" select="local-name-from-QName($name)"/>
      <xsl:choose>
        <xsl:when test="key('id', concat('p.',$name), $specs)">
          <xsl:variable name="links" select="key('id', concat('p.',$name), $specs)[1]"/>
          <xsl:variable name="basename"
                        select="substring-before(substring-after(base-uri($links),
                                                                 '/build/specs/'),'.html')"/>
          <a href="{t:spec-link($basename)}#p.{$name}">
            <xsl:value-of select="concat('p:',$name)"/>
          </a>
        </xsl:when>
        <xsl:when test="key('id', concat('c.',$name), $specs)">
          <xsl:variable name="links" select="key('id', concat('c.',$name), $specs)[1]"/>
          <xsl:variable name="basename"
                        select="substring-before(substring-after(base-uri($links),
                                                                 '/build/specs/'),'.html')"/>
          <a href="{t:spec-link($basename)}#c.{$name}">
            <xsl:value-of select="concat('p:', $name)"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$name"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

</xsl:stylesheet>
