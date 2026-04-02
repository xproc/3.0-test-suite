<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:test="http://xproc.org/ns/testsuite/3.0/function-test">
    
    <xsl:function name="test:function1" as="item()" visibility="public">
        <xsl:param name="par" as="xs:string" />
        <function-result >
            <xsl:value-of select="$par" />
        </function-result>
    </xsl:function>
    
</xsl:stylesheet>