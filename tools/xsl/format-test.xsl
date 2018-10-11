<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:t="http://xproc.org/ns/testsuite/3.0"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="h p t xs"
                version="2.0">

<xsl:output method="html" encoding="utf-8" omit-xml-declaration="yes"/>

<xsl:param name="prev" select="''"/>
<xsl:param name="next" select="''"/>

<xsl:template match="t:test">
  <xsl:variable name="basename" select="substring-after(base-uri(.), '/test-suite/tests/')"/>

  <html>
    <head>
      <meta charset="utf-8"/>
      <title>
        <xsl:value-of select="(t:info/t:title|t:title)[1]"/>
      </title>
      <link href="../css/testsuite.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
      <nav>
        <a href="../">↑</a>
        <xsl:text> / </xsl:text>
        <xsl:choose>
          <xsl:when test="$prev eq ''">
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$prev}.html">←</a>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> / </xsl:text>
        <xsl:choose>
          <xsl:when test="$next eq ''">
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$next}.html">→</a>
          </xsl:otherwise>
        </xsl:choose>
      </nav>

      <h1><xsl:value-of select="(t:info/t:title|t:title)[1]"/></h1>
      <xsl:apply-templates select="t:description"/>
      <p class="expected">
        <xsl:text>Test </xsl:text>
        <a class="testuri" href="../test-suite/tests/{$basename}">
          <xsl:value-of select="$basename"/>
        </a>
        <xsl:text> is expected to </xsl:text>
        <xsl:value-of select="@expected"/>
        <xsl:if test="@expected ne 'pass'">
          <xsl:variable name="codes" as="xs:string*">
            <xsl:for-each select="tokenize(@code, '\s+')">
              <xsl:sort select="."/>
              <xsl:value-of select="."/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="count($codes) = 1">
              <xsl:text> with error code </xsl:text>
              <xsl:sequence select="t:error-code($codes)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text> with one of the following error codes: </xsl:text>
              <xsl:choose>
                <xsl:when test="count($codes) = 2">
                  <xsl:sequence select="t:error-code($codes[1])"/>
                  <xsl:text> or </xsl:text>
                  <xsl:sequence select="t:error-code($codes[2])"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="$codes">
                    <xsl:if test="position() gt 1">, </xsl:if>
                    <xsl:sequence select="t:error-code(.)"/>
                    <xsl:if test="position() eq last() - 1"> or </xsl:if>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:text>.</xsl:text>
      </p>

      <xsl:choose>
        <xsl:when test="@features">
          <p class="features">
            <xsl:text>It requires the following features: </xsl:text>
            <xsl:variable name="codes" as="xs:string*">
              <xsl:for-each select="tokenize(@features, '\s+')">
                <xsl:sort select="."/>
                <xsl:value-of select="."/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="count($codes) = 2">
                <xsl:sequence select="t:feature-code($codes[1])"/>
                <xsl:text> or </xsl:text>
                <xsl:sequence select="t:feature-code($codes[2])"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="$codes">
                  <xsl:if test="position() gt 1">, </xsl:if>
                  <xsl:sequence select="t:feature-code(.)"/>
                  <xsl:if test="position() eq last() - 1"> or </xsl:if>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>.</xsl:text>
          </p>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>

      <xsl:apply-templates select="(t:pipeline, t:input, t:option, t:schematron,
                                    t:info/t:revision-history)"/>
    </body>
  </html>
</xsl:template>

<xsl:template match="t:info|t:description">
  <div class="{local-name(.)}">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="t:info/t:title"/>

<xsl:template match="t:revision-history">
  <dl class="{local-name(.)}">
    <h2>Revision history</h2>
    <xsl:apply-templates/>
  </dl>
</xsl:template>

<xsl:template match="t:revision">
  <dt>
    <xsl:apply-templates select="t:date"/>
    <xsl:text>, </xsl:text>
    <xsl:choose>
      <xsl:when test="t:author">
        <xsl:apply-templates select="t:author"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="author" select="(//t:author[@initials = current()/@initials])[1]"/>
        <xsl:apply-templates select="$author"/>
      </xsl:otherwise>
    </xsl:choose>
  </dt>
  <dd>
    <xsl:apply-templates select="t:description"/>
  </dd>
</xsl:template>

<xsl:template match="t:revision/t:date">
  <xsl:choose>
    <xsl:when test=". castable as xs:dateTime">
      <!-- ignoring timezone for now -->
      <xsl:value-of select='format-dateTime(xs:dateTime(.),
			              "[D01] [MNn,*-3] [Y0001] [H01]:[m01]")'/>
    </xsl:when>
    <xsl:when test=". castable as xs:date">
      <xsl:value-of select='format-date(xs:date(.),
			              "[D01] [MNn,*-3] [Y0001]")'/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="t:author">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="t:name">
  <span class="name"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="t:author/t:email|t:author/t:uri"/>

<xsl:template match="h:*">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="@*,node()"/>
  </xsl:element>
</xsl:template>

<xsl:template match="t:pipeline">
  <div class="pipeline">
    <h2>The pipeline</h2>
    <xsl:call-template name="insert-content"/>
  </div>
</xsl:template>

<xsl:template match="t:input[1]" priority="100">
  <div class="inputs">
    <h2>Inputs</h2>

    <xsl:apply-templates select="../t:input" mode="inputs"/>
  </div>
</xsl:template>

<xsl:template match="t:input"/>

<xsl:template match="t:input" mode="inputs">
  <div class="input">
    <h3>port = <xsl:value-of select="@port"/></h3>
    <xsl:call-template name="insert-content"/>
  </div>
</xsl:template>

<xsl:template match="t:option[1]" priority="100">
  <div class="options">
    <h2>Options</h2>

    <xsl:apply-templates select="../t:option" mode="options"/>
  </div>
</xsl:template>

<xsl:template match="t:option"/>

<xsl:template match="t:option" mode="options">
  <div class="option">
    <h3>$<xsl:value-of select="@name"/></h3>

    <xsl:choose>
      <xsl:when test="@select">
        <xsl:text>select = </xsl:text>
        <xsl:value-of select="@select"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="insert-content"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="t:schematron">
  <div class="schematron">
    <h2>Schematron validation</h2>
    <xsl:call-template name="insert-content"/>
  </div>
</xsl:template>

<xsl:template name="insert-content">
  <pre>
    <code>
      <xsl:choose>
        <xsl:when test="@src">
          <xsl:apply-templates mode="copy" select="doc(resolve-uri(@src, base-uri(.)))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="content" as="node()*">
            <xsl:apply-templates select="node()" mode="namespace-shelter"/>
          </xsl:variable>
          <xsl:apply-templates mode="copy" select="$content"/>
        </xsl:otherwise>
      </xsl:choose>
    </code>
  </pre>
</xsl:template>

<xsl:template match="element()">
  <xsl:message>Unhandled: <xsl:value-of select="node-name(.)"/></xsl:message>
  <span style="color: #aa0000">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="node-name(.)"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="node-name(.)"/>
    <xsl:text>&gt;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="copy">
  <xsl:choose>
    <xsl:when test="empty(*) and string(.) = ''">
      <span class="{if (self::p:*) then 'pelement' else 'element'}">
        <span class="stag">
          <span class="sto">&lt;</span>
          <span class="gi">
            <xsl:value-of select="node-name(.)"/>
          </span>
          <xsl:call-template name="attributes"/>
          <span class="stc">/&gt;</span>
        </span>
      </span>
    </xsl:when>
    <xsl:otherwise>
      <span class="{if (self::p:*) then 'pelement' else 'element'}">
        <span class="stag">
          <span class="sto">&lt;</span>
          <span class="gi">
            <xsl:value-of select="node-name(.)"/>
          </span>
          <xsl:call-template name="attributes"/>
          <span class="stc">&gt;</span>
        </span>

        <xsl:apply-templates mode="copy"/>

        <span class="etag">
          <span class="eto">&lt;/</span>
          <span class="gi endgi">
            <xsl:value-of select="node-name(.)"/>
          </span>
          <span class="etc">&gt;</span>
        </span>
      </span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="attribute()|comment()|processing-instruction()"
              mode="copy">
  <xsl:copy/>
</xsl:template>

<xsl:template match="text()" mode="copy">
  <xsl:copy/>
</xsl:template>

<xsl:template name="attributes">
  <xsl:variable name="ancestors" select="ancestor::*"/>
  <xsl:for-each select="namespace::*">
    <xsl:if test="not(t:ancestor-namespace($ancestors, .))">
      <xsl:text> </xsl:text>
      <span class="attr nsattr">
        <span class="aname">
          <xsl:text>xmlns</xsl:text>
          <xsl:if test="local-name(.) ne ''">
            <xsl:text>:</xsl:text>
            <xsl:value-of select="local-name(.)"/>
          </xsl:if>
        </span>
        <span class="aeq">=</span>
        <span class="aq">"</span>
        <span class="avalue">
          <xsl:value-of select="."/>
        </span>
        <span class="aq">"</span>
      </span>
    </xsl:if>
  </xsl:for-each>

  <xsl:variable name="pdef" select="string(parent::*/namespace::*[local-name(.) = ''])"/>
  <xsl:variable name="tdef" select="string(./namespace::*[local-name(.) = ''])"/>

  <xsl:if test="parent::* and $pdef != $tdef and $tdef ne 'http://test.xproc.org/placeholder/'">
    <xsl:text> </xsl:text>
    <span class="attr nsattr">
      <span class="aname">
        <xsl:text>xmlns</xsl:text>
      </span>
      <span class="aeq">=</span>
      <span class="aq">"</span>
      <span class="avalue">
        <xsl:value-of select="$tdef"/>
      </span>
      <span class="aq">"</span>
    </span>
  </xsl:if>

  <xsl:for-each select="@*">
    <xsl:text> </xsl:text>
    <span class="attr">
      <span class="aname{if (namespace-uri(.) = 'http://www.w3.org/ns/xproc') then ' paname' else ''}">
        <xsl:value-of select="node-name(.)"/>
      </span>
      <span class="aeq">=</span>
      <span class="aq">"</span>
      <span class="avalue">
        <xsl:value-of select="."/>
      </span>
      <span class="aq">"</span>
    </span>
  </xsl:for-each>
</xsl:template>

<xsl:template name="x-attributes">
  <!--
      <xsl:message>=== <xsl:value-of select="node-name(.)"/></xsl:message>
  -->
  <xsl:variable name="ancestors" select="ancestor::*"/>
  <xsl:for-each select="namespace::*">
    <xsl:if test="not(t:ancestor-namespace($ancestors, .))">
      <xsl:text> </xsl:text>
      <span class="attr nsattr">
        <span class="aname">
          <xsl:text>xmlns</xsl:text>
          <xsl:if test="local-name(.) ne ''">
            <xsl:text>:</xsl:text>
            <xsl:value-of select="local-name(.)"/>
          </xsl:if>
        </span>
        <span class="aeq">=</span>
        <span class="aq">"</span>
        <span class="avalue">
          <xsl:value-of select="."/>
        </span>
        <span class="aq">"</span>
      </span>
    </xsl:if>
  </xsl:for-each>
    
  <xsl:variable name="pdef" select="string(parent::*/namespace::*[local-name(.) = ''])"/>
  <xsl:variable name="tdef" select="string(./namespace::*[local-name(.) = ''])"/>

  <xsl:if test="parent::* and $pdef != $tdef and $tdef ne 'http://test.xproc.org/placeholder/'">
    <xsl:text> </xsl:text>
    <span class="attr nsattr">
      <span class="aname">
        <xsl:text>xmlns</xsl:text>
      </span>
      <span class="aeq">=</span>
      <span class="aq">"</span>
      <span class="avalue">
        <xsl:value-of select="$tdef"/>
      </span>
      <span class="aq">"</span>
    </span>
  </xsl:if>

  <xsl:for-each select="@*">
    <xsl:text> </xsl:text>
    <span class="attr">
      <span class="aname{if (namespace-uri(.) = 'http://www.w3.org/ns/xproc') then ' paname' else ''}">
        <xsl:value-of select="node-name(.)"/>
      </span>
      <span class="aeq">=</span>
      <span class="aq">"</span>
      <span class="avalue">
        <xsl:value-of select="."/>
      </span>
      <span class="aq">"</span>
    </span>
  </xsl:for-each>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="namespace-shelter">
  <xsl:element name="{node-name(.)}" namespace="{namespace-uri(.)}">
    <!--
    <xsl:message>===<xsl:value-of select="node-name(.)"/></xsl:message>
    <xsl:message><xsl:value-of select="exists(parent::t:*)"/></xsl:message>
    <xsl:message><xsl:value-of select="namespace-uri(.) = ''"/></xsl:message>
    <xsl:message><xsl:value-of select="prefix-from-QName(node-name(.)) != ''"/></xsl:message>
    -->
    <xsl:if test="exists(parent::t:*) and prefix-from-QName(node-name(.)) != ''">
      <xsl:namespace name="" select='"http://test.xproc.org/placeholder/"'/>
    </xsl:if>
    <xsl:apply-templates mode="namespace-shelter" select="@*,node()"/>
  </xsl:element>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()"
              mode="namespace-shelter">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:function name="t:ancestor-namespace" as="xs:boolean">
  <xsl:param name="ancestors" as="element()*"/>
  <xsl:param name="namespace" as="namespace-node()"/>

  <xsl:choose>
    <xsl:when test="local-name($namespace) eq 'xml'
                    or string($namespace) = 'http://test.xproc.org/placeholder/'">
      <xsl:sequence select="true()"/>
    </xsl:when>
    <xsl:when test="empty($ancestors)">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$ancestors[1][namespace::*[local-name(.) = local-name($namespace)
                                               and string(.) = string($namespace)]]">
      <xsl:sequence select="true()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="rest" select="subsequence($ancestors, 1, count($ancestors) - 1)"/>
      <xsl:sequence select="t:ancestor-namespace($rest, $namespace)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="t:error-code">
  <xsl:param name="code" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="starts-with($code, 'err:XS') or starts-with($code, 'err:XD')">
      <a href="http://spec.xproc.org/master/head/xproc/#err.{substring($code, 6)}">
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

</xsl:stylesheet>
