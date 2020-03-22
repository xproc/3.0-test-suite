<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:t="http://xproc.org/ns/testsuite/3.0"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="h p t xs"
                version="2.0">

<xsl:import href="functions.xsl"/>

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
      <link href="../css/prism.css" rel="stylesheet" type="text/css" />
      <link href="../css/db-prism.css" rel="stylesheet" type="text/css" />
      <link rel="stylesheet" type="text/css" href="../css/base.css" />
      <link rel="stylesheet" type="text/css" href="../css/xproc.css" />
      <link rel="stylesheet" type="text/css" href="../css/base.css" />
      <link href="../css/all.css" rel="stylesheet" type="text/css" />
      <link href="../css/testsuite.css" rel="stylesheet" type="text/css" />
      <script type="text/javascript" src="../js/dbmodnizr.js"></script>
    </head>
    <body>
      <nav>
        <xsl:choose>
          <xsl:when test="$prev eq ''">
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$prev}.html"><i class="fas fa-chevron-circle-left"></i></a>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:choose>
          <xsl:when test="$next eq ''">
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$next}.html"><i class="fas fa-chevron-circle-right"></i></a>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <a href="../"><i class="fa fa-chevron-circle-up"></i></a>
      </nav>

      <h1><xsl:value-of select="(t:info/t:title|t:title)[1]"/></h1>

      <xsl:apply-templates select="t:description"/>

      <xsl:if test="t:info/t:specref">
        <p class="seealso">
          <xsl:text>See also </xsl:text>
          <xsl:apply-templates select="t:info/t:specref"/>
          <xsl:text>.</xsl:text>
        </p>
      </xsl:if>

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
              <code>
                <xsl:sequence select="t:error-code($codes)"/>
              </code>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text> with one of the following error codes: </xsl:text>
              <xsl:choose>
                <xsl:when test="count($codes) = 2">
                  <code>
                    <xsl:sequence select="t:error-code($codes[1])"/>
                  </code>
                  <xsl:text> or </xsl:text>
                  <code>
                    <xsl:sequence select="t:error-code($codes[2])"/>
                  </code>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="$codes">
                    <xsl:if test="position() gt 1">, </xsl:if>
                    <code>
                      <xsl:sequence select="t:error-code(.)"/>
                    </code>
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

      <script src="../js/prism.js"></script>
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

<xsl:template match="h:code">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="@*"/>

    <xsl:choose>
      <xsl:when test="not(contains(., ' ')) and starts-with(., 'err:')">
        <xsl:sequence select="t:error-code(.)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:element>
</xsl:template>

<xsl:template match="h:*">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="@*,node()"/>
  </xsl:element>
</xsl:template>

<xsl:template match="t:specref">
  <xsl:if test="preceding-sibling::t:specref">
    <xsl:if test="count(../t:specref) gt 2">, </xsl:if>
    <xsl:if test="empty(following-sibling::t:specref)"> and </xsl:if>
  </xsl:if>

  <xsl:variable name="tocref" as="node()*">
    <xsl:choose>
      <xsl:when test="@spec = 'steps'">
        <xsl:sequence select="key('href', concat('#', @linkend), $specs)[ancestor::h:div[@class='toc']]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="key('href', concat('#', @linkend), $specs)[ancestor::h:div[@class='toc']]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="ref" as="node()*">
    <xsl:choose>
      <xsl:when test="@spec = 'steps'">
        <xsl:sequence select="key('id', @linkend, $specs)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="key('id', @linkend, $specs)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="base" as="xs:string">
    <xsl:choose>
      <xsl:when test="@spec = 'steps'">
        <xsl:value-of select="'XXX'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'XXX'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <span class="specref">
    <xsl:choose>
      <xsl:when test="$tocref">
        <a href="{$base}#{@linkend}"><xsl:value-of select="$tocref"/></a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>[[</xsl:text>
        <xsl:value-of select="@linkend"/>
        <xsl:text>]]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <sup class="specid">
      <xsl:choose>
        <xsl:when test="@spec = 'steps'">[XS]</xsl:when>
        <xsl:otherwise>[XP]</xsl:otherwise>
      </xsl:choose>
    </sup>
  </span>
</xsl:template>

<xsl:template match="t:pipeline">
  <div class="pipeline">
    <h2>The pipeline</h2>

    <xsl:call-template name="insert-content"/>

    <xsl:variable name="basename" select="substring-after(base-uri(/*), '/test-suite/tests/')"/>
    <xsl:variable name="i1" select="($calabash/testcase[@name=$basename])[1]"/>
    <xsl:variable name="i2" select="($morganaxproc/testcase[@name=$basename])[1]"/>
    <xsl:if test="$i1 or $i2">
      <div class="implbanners">
        <xsl:if test="$i2">
          <span class="morganaxproc">
            <a href="../implementation.html#{substring-before($basename, '.xml')}">
              <xsl:choose>
                <xsl:when test="$i2/failure">
                  <img src="../img/mx-fail.svg" alt="MorganaXProc failing"/>
                </xsl:when>
                <xsl:otherwise>
                  <img src="../img/mx-pass.svg" alt="MorganaXProc passing"/>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </span>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="$i1">
          <span class="xmlcalabash">
            <a href="../implementation.html#{substring-before($basename, '.xml')}">
              <xsl:choose>
                <xsl:when test="$i1/failure">
                  <img src="../img/xc-fail.svg" alt="XML Calabash failing"/>
                </xsl:when>
                <xsl:when test="$i1/failure">
                  <img src="../img/xc-fail.svg" alt="XML Calabash failing"/>
                </xsl:when>
                <xsl:otherwise>
                  <img src="../img/xc-pass.svg" alt="XML Calabash passing"/>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </span>
        </xsl:if>
      </div>
    </xsl:if>
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
  <pre class="programlisting line-numbers language-markup" data-language="Markup">
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
            <xsl:sequence select="t:gi(.)"/>
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
            <xsl:sequence select="t:gi(.)"/>
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
    <xsl:when test="$ancestors[last()][namespace::*[local-name(.) = local-name($namespace)
                                                    and string(.) = string($namespace)]]">
      <xsl:sequence select="true()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="rest" select="subsequence($ancestors, 1, count($ancestors) - 1)"/>
      <xsl:sequence select="t:ancestor-namespace($rest, $namespace)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

</xsl:stylesheet>
