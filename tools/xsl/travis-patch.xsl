<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="h xs"
                version="2.0">

<xsl:param name="travis" select="''"/>
<xsl:param name="travis-build" select="''"/>
<xsl:param name="travis-commit" select="''"/>

<xsl:variable name="Z" select="xs:dayTimeDuration('PT0H')"/>

<xsl:template match="*[@x-travis]">
  <xsl:if test="not(@x-travis = 'true') or ($travis = 'true')">
    <xsl:copy>
      <xsl:apply-templates select="@* except @x-travis"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:if>
</xsl:template>

<xsl:template match="h:time[@class='now']">
  <xsl:variable name="time" select="adjust-dateTime-to-timezone(current-dateTime(), $Z)"/>
  <time datetime="{$time}" title="{$time}">
    <xsl:value-of select='format-dateTime($time, "[D01] [MNn,*-3] [Y0001] at [H01]:[m01] GMT")'/>
  </time>
</xsl:template>

<xsl:template match="h:span[@class='travis-build']">
  <xsl:copy>
    <xsl:apply-templates select="@* except @title"/>
    <xsl:attribute name="title" select="concat('Commit hash ', $travis-commit)"/>
    <xsl:value-of select="$travis-build"/>
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
