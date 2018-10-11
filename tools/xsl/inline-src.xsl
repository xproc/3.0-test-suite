<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="xs"
                version="2.0">

<xsl:template match="*[@src]">
  <xsl:copy>
    <xsl:apply-templates select="@* except @src"/>
    <xsl:copy-of select="doc(resolve-uri(@src, base-uri(.)))"/>
  </xsl:copy>
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
