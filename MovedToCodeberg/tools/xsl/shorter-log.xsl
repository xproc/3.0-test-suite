<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:g='http://nwalsh.com/ns/git-repo-info'
                xmlns='http://nwalsh.com/ns/git-repo-info'
		exclude-result-prefixes="g xs"
                version="2.0">

<xsl:template match="g:file">
  <xsl:choose>
    <xsl:when test="preceding::g:file[. = current()]"/>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:apply-templates select="@*,node()"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="g:commit">
  <xsl:variable name="commit" as="element()">
    <xsl:copy>
      <xsl:apply-templates select="@*,node()"/>
    </xsl:copy>
  </xsl:variable>
  <xsl:if test="$commit//g:file">
    <xsl:sequence select="$commit"/>
  </xsl:if>
</xsl:template>

<xsl:template match="element()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
