<s:schema queryBinding="xslt2"
    xmlns:s="http://purl.oclc.org/dsdl/schematron"
    xmlns="http://www.w3.org/1999/xhtml">
    
    <s:ns uri="http://xproc.org/ns/testsuite/3.0/book" prefix="book" />
    <s:pattern>
        <s:rule context="/">
            <s:assert test="book:Book">The document root is not "book".</s:assert>
        </s:rule>
    </s:pattern>
</s:schema>