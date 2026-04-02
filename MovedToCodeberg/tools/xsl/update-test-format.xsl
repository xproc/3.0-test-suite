<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:t="http://xproc.org/ns/testsuite/3.0"
                xmlns:g="http://nwalsh.com/ns/git-repo-info"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="g xs"
                version="2.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"
	    omit-xml-declaration="yes"/>

<xsl:variable name="git-log" select="doc('git-log.xml')/*"/>

<xsl:strip-space elements="*"/>
<xsl:preserve-space xmlns:p="http://www.w3.org/ns/xproc" elements="p:*"/>

<xsl:template match="t:test">
  <xsl:variable name="file" select="substring-after(base-uri(.), '/test-suite/')"/>

  <t:test xmlns:t="http://xproc.org/ns/testsuite/3.0"
          xmlns="http://www.w3.org/1999/xhtml">

    <xsl:if test="@expected = 'fail'">
      <xsl:namespace name="err" select="'http://www.w3.org/ns/xproc-error'"/>
    </xsl:if>

    <xsl:apply-templates select="@*"/>
    <t:info>
      <t:title>
        <xsl:copy-of select="t:title/node()"/>
      </t:title>
      <t:revision-history>
        <xsl:apply-templates select="$git-log/g:commit[g:file=$file]"/>
      </t:revision-history>
    </t:info>
    <xsl:apply-templates select="node()"/>
  </t:test>
</xsl:template>

<xsl:template match="t:title"/>

<xsl:template match="element()">
  <xsl:choose>
    <xsl:when test="ancestor::t:description">
      <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
        <xsl:apply-templates select="@*,node()"/>
      </xsl:element>
    </xsl:when>

    <xsl:when test="namespace-uri(.) = 'http://xproc.org/ns/testsuite/3.0'">
      <xsl:element name="t:{local-name(.)}" namespace="http://xproc.org/ns/testsuite/3.0">
        <xsl:apply-templates select="@*,node()"/>
      </xsl:element>
    </xsl:when>

    <xsl:when test="namespace-uri(.) = 'http://www.w3.org/1999/xhtml'">
      <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
        <xsl:apply-templates select="@*,node()"/>
      </xsl:element>
    </xsl:when>

    <xsl:otherwise>
      <xsl:element name="{node-name(.)}" namespace="{namespace-uri(.)}">
        <xsl:apply-templates select="@*,node()"/>
      </xsl:element>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>

<xsl:template match="g:commit">
  <t:revision>
    <t:date><xsl:value-of select="g:date"/></t:date>
    <t:author>
      <t:name>
        <xsl:choose>
          <xsl:when test="g:committer-name">
            <xsl:value-of select="g:name(g:committer-name)"/>
          </xsl:when>
          <xsl:when test="g:committer">
            <xsl:value-of select="g:name(substring-before(g:committer, ' &lt;'))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'Unknown'"/>
          </xsl:otherwise>
        </xsl:choose>
      </t:name>
    </t:author>
    <t:description>
      <p><xsl:value-of select="g:message"/></p>
    </t:description>
  </t:revision>
</xsl:template>

<xsl:function name="g:name" as="xs:string">
  <xsl:param name="name"/>

  <xsl:choose>
    <xsl:when test="$name eq 'xml-project'">Achim Berndzen</xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$name"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

</xsl:stylesheet>
