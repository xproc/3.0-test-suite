<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"
            omit-xml-declaration="yes"/>

<xsl:template match="c:directory">
  <xsl:variable name="sorted" as="element()">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:for-each select="c:file">
        <xsl:sort select="@name"/>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:variable>

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates select="$sorted/c:file"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="element()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="c:file">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:if test="preceding-sibling::c:file[1]">
      <xsl:attribute name="prev"
                     select="substring-before(preceding-sibling::c:file[1]/@name, '.xml')"/>
    </xsl:if>
    <xsl:if test="following-sibling::c:file[1]">
      <xsl:attribute name="next"
                     select="substring-before(following-sibling::c:file[1]/@name, '.xml')"/>
    </xsl:if>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>


<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
