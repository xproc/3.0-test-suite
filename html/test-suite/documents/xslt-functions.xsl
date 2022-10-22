<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:test="http://xproc.org/ns/testsuite/3.0/function-test"
    xmlns:test1="http://xproc.org/ns/testsuite/3.0/function-test1">
    
    <xsl:function name="test:function1" as="item()" visibility="public">
        <function-result />
    </xsl:function>
    
    <xsl:function name="test:function2" as="item()" visibility="public">
        <xsl:param name="par" as="xs:string" />
        <function-result >
            <xsl:value-of select="$par"/>
        </function-result>
    </xsl:function>
    
    <xsl:function name="test:private-function" as="item()" visibility="private">
        <function-result />
    </xsl:function>

    <xsl:function name="test1:function1" as="item()" visibility="public">
        <namespaced-function />
    </xsl:function>
</xsl:stylesheet>