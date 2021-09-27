<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:t="http://xproc.org/ns/testsuite/3.0"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="xs t h"
                version="3.0">

<xsl:function name="t:format-markup" as="node()*">
  <xsl:param name="node" as="element()"/>
  <xsl:variable name="serial"
                select="serialize($node, map{'method':'xml', 'indent': true()})"/>
  <xsl:sequence select="t:format(tokenize($serial, '&lt;'))"/>
</xsl:function>

<xsl:function name="t:format" as="node()*">
  <xsl:param name="tokens" as="xs:string*"/>
  <xsl:sequence select="t:text($tokens[1])"/>
  <xsl:for-each select="$tokens[position() gt 1]">
    <xsl:variable name="body" select="tokenize(., '&gt;')[1]"/>
    <xsl:variable name="rest" select="tokenize(., '&gt;')[2]"/>
    <xsl:choose>
      <xsl:when test="starts-with($body, '!--')">
        <span class="com">
          <span class="como">&lt;!--</span>
          <xsl:sequence select="substring-before(substring($body, 4), '--')"/>
          <span class="come">--&gt;</span>
        </span>
      </xsl:when>
      <xsl:when test="starts-with($body, '?')">
        <span class="pi">
          <span class="pio">&lt;?</span>
          <xsl:sequence select="substring($body, 2, string-length($body) - 2)"/>
          <span class="pie">?&gt;</span>
        </span>
      </xsl:when>
      <xsl:when test="starts-with($body, '/')">
        <span class="etag">
          <span class="eto">&lt;/</span>
          <span class="gi endgi">
            <xsl:sequence select="substring($body,2)"/>
          </span>
          <span class="etc">&gt;</span>
        </span>
      </xsl:when>
      <xsl:when test="contains($body, '=')">
        <xsl:sequence select="t:stag($body)"/>
      </xsl:when>
      <xsl:otherwise>
        <span class="stag">
          <span class="sto">&lt;</span>
          <span class="gi">
            <xsl:sequence select="$body"/>
          </span>
          <span class="eto">&gt;</span>
        </span>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:sequence select="t:text($rest)"/>
  </xsl:for-each>
</xsl:function>

<xsl:function name="t:text" as="node()?">
  <xsl:param name="text" as="xs:string?"/>
  <xsl:if test="exists($text) and $text ne ''">
    <xsl:choose>
      <xsl:when test="normalize-space($text) = ''">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:otherwise>
        <span class="text"><xsl:sequence select="$text"/></span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:function>

<xsl:function name="t:stag" as="node()">
  <xsl:param name="text" as="xs:string"/>
  <span class="stag">
    <span class="sto">&lt;</span>
    <span class="gi">
      <xsl:sequence select="substring-before($text,' ')"/>
    </span>
    <xsl:sequence select="t:attr(substring-after($text,' '))"/>
    <span class="eto">&gt;</span>
  </span>
</xsl:function>

<xsl:function name="t:attr" as="node()*">
  <xsl:param name="text" as="xs:string"/>
  <xsl:variable name="name" as="xs:string"
                select="substring-before($text, '=')"/>
  <xsl:variable name="value" as="xs:string">
    <xsl:choose>
      <xsl:when test="matches($text, '^[^=]+=&quot;[^&quot;]*&quot;.*$', 's')">
        <xsl:sequence select="replace($text, '^[^=]+=&quot;([^&quot;]*)&quot;.*$', '$1', 's')"/>
      </xsl:when>
      <xsl:when test="matches($text, '^[^=]+=''[^'']*''.*$', 's')">
        <xsl:sequence select="replace($text, '^[^=]+=''([^'']*)''.*$', '$1', 's')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="error(xs:QName('badattr'), 'Unparseable: [' || $text || ']')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="rest" as="xs:string">
    <xsl:choose>
      <xsl:when test="matches($text, '^[^=]+=&quot;[^&quot;]*&quot;\s+.+$', 's')">
        <xsl:sequence select="replace($text, '^[^=]+=&quot;[^&quot;]*&quot;\s+(.+)$', '$1', 's')"/>
      </xsl:when>
      <xsl:when test="matches($text, '^[^=]+=''.*?''\s+.+$', 's')">
        <xsl:sequence select="replace($text, '^[^=]+=''[^'']*''\s+(.+)$', '$1', 's')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$name eq 'xmlns:t'"/>
    <xsl:when test="$name eq 'xmlns' or starts-with($name, 'xmlns:')">
      <xsl:text> </xsl:text>
      <span class="attr nsattr">
        <span class="aname">
          <xsl:sequence select="$name"/>
        </span>
        <span class="aeq">=</span>
        <span class="aq">"</span>
        <span class="avalue">
          <xsl:value-of select="$value"/>
        </span>
        <span class="aq">"</span>
      </span>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> </xsl:text>
      <span class="attr">
        <span class="aname">
          <xsl:sequence select="$name"/>
        </span>
        <span class="aeq">=</span>
        <span class="aq">"</span>
        <span class="avalue">
          <xsl:value-of select="normalize-space($value)"/>
        </span>
        <span class="aq">"</span>
      </span>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:if test="$rest ne ''">
    <xsl:sequence select="t:attr($rest)"/>
  </xsl:if>
</xsl:function>

</xsl:stylesheet>
