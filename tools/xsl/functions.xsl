<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:t="http://xproc.org/ns/testsuite/3.0"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="h p t xs"
                version="2.0">

<xsl:param name="xproc-spec" select="''"/>
<xsl:param name="steps-spec" select="''"/>
<xsl:param name="xproc-link" select="''"/>
<xsl:param name="steps-link" select="''"/>

<xsl:variable name="xproc" select="if ($xproc-spec = '') then () else doc($xproc-spec)"/>
<xsl:variable name="steps" select="if ($steps-spec = '') then () else doc($steps-spec)"/>
<xsl:variable name="calabash" select="doc('../../reports/xml-calabash.xml')/*"/>

<xsl:key name="id" match="*" use="@id"/>
<xsl:key name="href" match="h:a" use="@href"/>

<xsl:function name="t:error-code">
  <xsl:param name="code" as="xs:string"/>
  <xsl:variable name="name" select="substring($code, 6)"/>

  <xsl:choose>
    <xsl:when test="starts-with($code, 'err:XS') or starts-with($code, 'err:XD')
                    and key('id', concat('err.',$name), $xproc)">
      <a href="{$xproc-link}#err.{$name}">
        <xsl:value-of select="$code"/>
      </a>
    </xsl:when>
    <xsl:when test="starts-with($code, 'err:XC') and key('id', concat('err.',$name), $steps)">
      <a href="{$steps-link}#err.{$name}">
        <xsl:value-of select="$code"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$code"/>
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
        <xsl:when test="key('id', concat('p.',$name), $xproc)">
          <a href="{$xproc-link}#p.{$name}">
            <xsl:value-of select="$name"/>
          </a>
        </xsl:when>
        <xsl:when test="key('id', concat('c.',$name), $steps)">
          <a href="{$steps-link}#c.{$name}">
            <xsl:value-of select="$name"/>
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
