<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:t="http://xproc.org/ns/testsuite/3.0"
                xmlns:h="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="h xs"
                version="2.0">

<xsl:output method="xml" encoding="utf-8" indent="no"
	    omit-xml-declaration="yes"/>

<xsl:template match="t:*">
  <xsl:element name="{node-name(.)}" namespace="{namespace-uri(.)}">
    <xsl:for-each select="namespace::*">
      <xsl:if test="string(.) != 'http://www.w3.org/1999/xhtml'">
        <xsl:sequence select="."/>
      </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:element>
</xsl:template>

<xsl:template match="t:pipeline">
  <xsl:choose>
    <xsl:when test="@src">
      <xsl:next-match/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="{node-name(.)}" namespace="{namespace-uri(.)}">
        <xsl:for-each select="namespace::*">
          <xsl:if test="string(.) != 'http://www.w3.org/1999/xhtml'">
            <xsl:sequence select="."/>
          </xsl:if>
        </xsl:for-each>
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates select="node()" mode="strip-html"/>
      </xsl:element>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="t:description">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="element()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="attribute()">
  <xsl:variable name="tokens" select="tokenize(., '\s+')"/>
  <xsl:for-each select="$tokens">
    <xsl:if test="contains(., ':')">
      <xsl:message>Earning attribute value: <xsl:value-of select="."/></xsl:message>
    </xsl:if>
  </xsl:for-each>

  <xsl:copy/>
</xsl:template>

<xsl:template match="t:test/@code|s:ns/@uri"
              xmlns:s="http://purl.oclc.org/dsdl/schematron">
  <xsl:copy/>
</xsl:template>

<xsl:template match="text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="element()" mode="strip-html">
  <xsl:element name="{node-name(.)}" namespace="{namespace-uri(.)}">
    <xsl:for-each select="namespace::*">
      <xsl:if test="string(.) != 'http://www.w3.org/1999/xhtml'">
        <xsl:sequence select="."/>
      </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates select="@*,node()" mode="strip-html"/>
  </xsl:element>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()"
              mode="strip-html">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
