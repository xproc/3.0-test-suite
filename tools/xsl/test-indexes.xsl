<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:t="http://xproc.org/ns/testsuite/3.0"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="c h p t xs"
                version="2.0">

<xsl:import href="functions.xsl"/>

<xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes"/>

<xsl:variable name="Z" select="xs:dayTimeDuration('PT0H')"/>

<xsl:template match="/">
  <xsl:for-each select="/c:directory/t:test">
    <xsl:variable name="title" select="string(t:info/t:title)"/>
    <xsl:variable name="tests" select="/c:directory/t:test[t:info/t:title = $title]"/>
    <xsl:if test="count($tests) gt 1 and . is $tests[1]">
      <xsl:message terminate="yes">
        <xsl:text>There are </xsl:text>
        <xsl:value-of select="count ($tests)"/>
        <xsl:text> tests with the title: </xsl:text>
        <xsl:value-of select="$title"/>
      </xsl:message>
      <xsl:for-each select="$tests">
        <xsl:message>
          <xsl:text>   …/test-suite/</xsl:text>
          <xsl:value-of select="substring-after(@xml:base, '/test-suite/')"/>
        </xsl:message>
      </xsl:for-each>
    </xsl:if>
  </xsl:for-each>

  <xsl:apply-templates mode="alphabetical"/>
  <xsl:apply-templates mode="expected"/>
  <xsl:apply-templates mode="element"/>
  <xsl:apply-templates mode="implementation"/>
  <xsl:apply-templates mode="bydate"/>
  <xsl:apply-templates mode="byerror"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="c:directory" mode="alphabetical">
  <xsl:result-document href="/fakeroot/alphabetical.html">
    <html>
      <head>
        <xsl:sequence select="t:head('Alphabetical index')"/>
     </head>
      <body>
        <nav>
          <a href="index.html"><i class="fa fa-chevron-circle-up"></i></a>
        </nav>
        <h1>Alphabetical index</h1>
        <ul>
          <xsl:for-each select="t:test">
            <xsl:variable name="href" select="substring-after(@xml:base, '/tests/')"/>
            <li>
              <xsl:sequence select="t:test-link($href)"/>
              <xsl:text>: </xsl:text>
              <xsl:value-of select="t:info/t:title"/>
            </li>
          </xsl:for-each>
        </ul>
        <script src="js/prism.js"></script>
      </body>
    </html>
  </xsl:result-document>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="c:directory" mode="expected">
  <xsl:result-document href="/fakeroot/expected.html">
    <html>
      <head>
        <xsl:sequence select="t:head('Expectation index')"/>
      </head>
      <body>
        <nav>
          <a href="index.html"><i class="fa fa-chevron-circle-up"></i></a>
        </nav>
        <h1>Expectation index</h1>
        <h2>Expected to pass</h2>
        <ul>
          <xsl:for-each select="t:test[@expected='pass']">
            <xsl:variable name="href" select="substring-after(@xml:base, '/tests/')"/>
            <li>
              <xsl:sequence select="t:test-link($href)"/>
            </li>
          </xsl:for-each>
        </ul>
        <h2>Expected to fail</h2>
        <ul>
          <xsl:for-each select="t:test[@expected='fail']">
            <xsl:variable name="href" select="substring-after(@xml:base, '/tests/')"/>
            <li>
              <xsl:sequence select="t:test-link($href)"/>
            </li>
          </xsl:for-each>
        </ul>
        <script src="js/prism.js"></script>
      </body>
    </html>
  </xsl:result-document>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="c:directory" mode="element">
  <xsl:result-document href="/fakeroot/element.html">
    <html>
      <head>
        <xsl:sequence select="t:head('Element index')"/>
      </head>
      <body>
        <nav>
          <a href="index.html"><i class="fa fa-chevron-circle-up"></i></a>
        </nav>
        <h1>Element index</h1>

        <xsl:variable name="tests" select="."/>

        <xsl:variable name="all-elements" as="xs:QName*">
          <xsl:for-each select="t:test/t:pipeline//*">
            <xsl:sequence select="node-name(.)"/>
          </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="elements" as="xs:QName*">
          <xsl:for-each select="distinct-values($all-elements)">
            <xsl:sort select="concat(namespace-uri-from-QName(.),local-name-from-QName(.))"/>
            <xsl:sequence select="."/>
          </xsl:for-each>
        </xsl:variable>

        <ul>
          <xsl:for-each select="$elements[namespace-uri-from-QName(.)='http://www.w3.org/ns/xproc']">
            <xsl:variable name="name" select="."/>
            <li>
              <span class="index-item"><xsl:sequence select="t:gi-from-QName($name)"/></span>

              <ul>
                <xsl:for-each select="$tests/t:test[t:pipeline//*[node-name(.) = $name]]">
                  <xsl:variable name="href" select="substring-after(@xml:base, '/tests/')"/>
                  <li>
                    <xsl:sequence select="t:test-link($href)"/>
                  </li>
                </xsl:for-each>
              </ul>
            </li>
          </xsl:for-each>

          <xsl:for-each select="$elements[namespace-uri-from-QName(.)!='http://www.w3.org/ns/xproc']">
            <xsl:variable name="name" select="."/>
            <li>
              <xsl:if test="namespace-uri-from-QName(.) != ''">
                <xsl:text>{</xsl:text>
                <xsl:value-of select="namespace-uri-from-QName(.)"/>
                <xsl:text>}</xsl:text>
              </xsl:if>
              <xsl:value-of select="local-name-from-QName(.)"/>

              <ul>
                <xsl:for-each select="$tests/t:test[t:pipeline//*[node-name(.) = $name]]">
                  <xsl:variable name="href" select="substring-after(@xml:base, '/tests/')"/>
                  <li>
                    <xsl:sequence select="t:test-link($href)"/>
                  </li>
                </xsl:for-each>
              </ul>
            </li>
          </xsl:for-each>
        </ul>
        <script src="js/prism.js"></script>
      </body>
    </html>
  </xsl:result-document>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="c:directory" mode="byerror">
  <xsl:result-document href="/fakeroot/errors.html">
    <html>
      <head>
        <xsl:sequence select="t:head('Error index')"/>
      </head>
      <body>
        <nav>
          <a href="index.html"><i class="fa fa-chevron-circle-up"></i></a>
        </nav>
        <h1>Error index</h1>

        <xsl:variable name="tests" select="."/>

        <xsl:variable name="all-test-errors" as="xs:string*">
          <xsl:for-each select="t:test[@code]">
            <xsl:sequence select="tokenize(@code, '\s+')"/>
          </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="test-errors" as="xs:string*">
          <xsl:for-each select="distinct-values($all-test-errors)">
            <xsl:sort select="."/>
            <xsl:sequence select="."/>
          </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="all-spec-errors" as="xs:string*">
          <xsl:sequence select="$xproc//*/@id[starts-with(., 'err.S') or starts-with(., 'err.D')
                                              or starts-with(., 'err.C')]"/>
          <xsl:sequence select="$steps//*/@id[starts-with(., 'err.S') or starts-with(., 'err.D')
                                              or starts-with(., 'err.C')]"/>
        </xsl:variable>

        <xsl:variable name="spec-errors" as="xs:string*">
          <xsl:for-each select="distinct-values($all-spec-errors)">
            <xsl:sort select="."/>
            <xsl:value-of select="concat('err:X', substring-after(., 'err.'))"/>
          </xsl:for-each>
        </xsl:variable>

        <xsl:for-each select="('err:XS', 'err:XD', 'err:XC')">
          <xsl:choose>
            <xsl:when test=". = 'err:XS'"><h2>Static errors</h2></xsl:when>
            <xsl:when test=". = 'err:XD'"><h2>Dynamic errors</h2></xsl:when>
            <xsl:when test=". = 'err:XC'"><h2>Step errors</h2></xsl:when>
          </xsl:choose>

          <xsl:variable name="errtype" select="."/>

          <ul>
            <xsl:for-each select="$spec-errors[starts-with(., $errtype)]">
              <xsl:variable name="name" select="."/>
              <li>
                <code class="index-item"><xsl:sequence select="t:error-code($name)"/></code>
                <xsl:variable name="etests" select="$tests/t:test[contains(@code, $name)]"/>
                <ul>
                  <xsl:for-each select="$etests">
                    <xsl:sort select="@xml:base"/>
                    <xsl:variable name="href" select="substring-after(@xml:base, '/tests/')"/>
                    <li>
                      <xsl:sequence select="t:test-link($href)"/>
                    </li>
                  </xsl:for-each>
                </ul>
              </li>
            </xsl:for-each>

            <xsl:for-each select="$test-errors[starts-with(., $errtype)]">
              <xsl:variable name="name" select="."/>
              <xsl:if test="empty($spec-errors[. = $name])">
                <li>
                  <code class="index-item"><xsl:sequence select="t:error-code($name)"/></code>
                  <xsl:text> (This error is not defined in the specs.)</xsl:text>
                  <xsl:variable name="etests" select="$tests/t:test[contains(@code, $name)]"/>
                  <ul>
                    <xsl:for-each select="$etests">
                      <xsl:sort select="@xml:base"/>
                      <xsl:variable name="href" select="substring-after(@xml:base, '/tests/')"/>
                      <li>
                        <xsl:sequence select="t:test-link($href)"/>
                      </li>
                    </xsl:for-each>
                  </ul>
                </li>
              </xsl:if>
            </xsl:for-each>
          </ul>
        </xsl:for-each>
        <script src="js/prism.js"></script>
      </body>
    </html>
  </xsl:result-document>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="c:directory" mode="implementation">
  <xsl:variable name="impl" select="(doc('../../reports/xml-calabash.xml')/*)"/>

  <xsl:result-document href="/fakeroot/implementation.html">
    <html>
      <head>
        <xsl:sequence select="t:head('Implementation index')"/>
      </head>
      <body>
        <nav>
          <a href="index.html"><i class="fa fa-chevron-circle-up"></i></a>
        </nav>
        <h1>Implementation index</h1>

        <p>
          <xsl:variable name="time" select="adjust-dateTime-to-timezone(current-dateTime(), $Z)"/>
          <xsl:text>Report formatted on </xsl:text>
          <time datetime="{$time}" title="{$time}">
            <xsl:value-of select='format-dateTime($time, "[D01] [MNn,*-3] [Y0001] at [H01]:[m01] GMT")'/>
          </time>.</p>

        <table cellspacing="0" cellpadding="5">
          <thead>
            <tr>
              <th>Implementation</th>
              <xsl:for-each select="$impl">
                <td>
                  <xsl:value-of select="$impl/properties/property[@name='processor']/@value"/>
                </td>
              </xsl:for-each>
            </tr>
            <tr>
              <th>Version</th>
              <xsl:for-each select="$impl">
                <td>
                  <xsl:value-of select="$impl/properties/property[@name='version']/@value"/>
                </td>
              </xsl:for-each>
            </tr>
            <tr>
              <th>Date</th>
              <xsl:for-each select="$impl">
                <xsl:variable name="time"
                              select="adjust-dateTime-to-timezone(xs:dateTime($impl/@timestamp), $Z)"/>
                <td>
                  <time datetime="{$time}" title="{$time}">
                    <xsl:value-of
                        select='format-dateTime($time, "[D01] [MNn,*-3] [Y0001] at [H01]:[m01] GMT")'/>
                  </time>
                </td>
              </xsl:for-each>
            </tr>              
            <tr>
              <th>Status</th>
              <xsl:for-each select="$impl">
                <td>Passing <xsl:value-of select="$impl/@tests - $impl/@errors"/>
                of <xsl:value-of select="$impl/@tests"/>
                (<xsl:value-of select="format-number(($impl/@tests - $impl/@errors)
                                                      div $impl/@tests * 100.0, '#.00')"/>%)
                </td>
              </xsl:for-each>
            </tr>              
          </thead>
          <tbody>
            <xsl:for-each select="t:test">
              <xsl:variable name="href" select="substring-after(@xml:base, '/tests/')"/>
              <tr>
                <td>
                  <xsl:sequence select="t:test-link($href)"/>
                </td>
                <xsl:for-each select="$impl">
                  <xsl:variable name="report" select="$impl/testcase[@name=$href]"/>
                  <xsl:choose>
                    <xsl:when test="$report/failure">
                      <td class="fail" align="center">fail</td>
                    </xsl:when>
                    <xsl:when test="exists($report)">
                      <td class="pass" align="center">pass</td>
                    </xsl:when>
                    <xsl:otherwise>
                      <td align="center">???</td>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
        <script src="js/prism.js"></script>
      </body>
    </html>
  </xsl:result-document>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="c:directory" mode="bydate">
  <xsl:result-document href="/fakeroot/date.html">
    <html>
      <head>
        <xsl:sequence select="t:head('Date index')"/>
      </head>
      <body>
        <nav>
          <a href="index.html"><i class="fa fa-chevron-circle-up"></i></a>
        </nav>
        <h1>Date index</h1>
        <dl>
          <xsl:for-each-group select="t:test" group-by="@log-date">
            <xsl:sort select="@log-date" order="descending"/>
            <dt>
              <xsl:value-of select="current-grouping-key()"/>
            </dt>
            <dd>
              <ul>
                <xsl:for-each select="current-group()">
                  <xsl:sort select="@xml:base"/>
                  <xsl:variable name="href" select="substring-after(@xml:base, '/tests/')"/>
                  <li>
                    <xsl:sequence select="t:test-link($href)"/>

                    <!-- there was a massive refactor on 2018-10-09 and 2018-10-10 -->
                    <!-- there was another massive refactor on 2018-10-14 -->
                    <xsl:variable name="cutoff" select="xs:date('2018-10-14')"/>
                    <xsl:variable name="fuzz" select="xs:dayTimeDuration('P1D')"/>
                    <xsl:variable name="log-date" select="xs:date(current-grouping-key())"/>
                    <xsl:variable name="rev-date"
                                  select="xs:date(substring(
                                             t:info/t:revision-history/t:revision[1]/t:date, 1, 10))"/>

                    <xsl:if test="$cutoff lt $log-date
                                  and ($log-date - $rev-date) gt $fuzz">
                      <xsl:text> (Last posted revision date seems too old: </xsl:text>
                      <xsl:value-of select="$log-date - $rev-date"/>
                      <xsl:text>)</xsl:text>
                    </xsl:if>
                  </li>
                </xsl:for-each>
              </ul>
            </dd>
          </xsl:for-each-group>
        </dl>
        <script src="js/prism.js"></script>
      </body>
    </html>
  </xsl:result-document>
</xsl:template>

<!-- ============================================================ -->

<xsl:function name="t:test-link">
  <xsl:param name="xml"/>
  <xsl:variable name="name" select="substring-before($xml, '.xml')"/>

  <a href="tests/{$name}.html" id="#{$name}">
    <xsl:value-of select="$name"/>
  </a>
</xsl:function>

<xsl:function name="t:head">
  <xsl:param name="title" required="true"/>
  
  <meta charset="utf-8"/>
  <title><xsl:value-of select="$title"/></title>
  <link href="css/prism.css" rel="stylesheet" type="text/css" />
  <link href="css/db-prism.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="css/base.css" />
  <link rel="stylesheet" type="text/css" href="css/xproc.css" />
  <link rel="stylesheet" type="text/css" href="css/base.css" />
  <link href="css/all.css" rel="stylesheet" type="text/css" />
  <link href="css/testsuite.css" rel="stylesheet" type="text/css" />
  <script type="text/javascript" src="js/dbmodnizr.js"></script>
</xsl:function>

</xsl:stylesheet>
