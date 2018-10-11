<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://xproc.org/ns/testsuite/3.0"
                xmlns:g='http://nwalsh.com/ns/git-repo-info'
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="g xs"
                version="2.0">

<xsl:variable name="log" select="doc('../../build/git-log-shorter.xml')/*"/>

<xsl:template match="t:test">
  <xsl:variable name="file"
                select="concat('test-suite/tests/', substring-after(@xml:base, '/tests/'))"/>
  <xsl:variable name="commit" select="$log/g:commit[g:file = $file]"/>

  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="log-date">
      <xsl:choose>
        <xsl:when test="$commit">
          <xsl:value-of select="substring($commit/g:date, 1, 10)"/>
        </xsl:when>
        <xsl:otherwise>1970-01-01</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates/>
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
