<p:declare-step version="3.0" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:p="http://www.w3.org/ns/xproc">
    <p:option name="static" as="xs:boolean" static="true" />
    <p:output port="result" />
    <p:identity >
        <p:with-input use-when="$static"><correct /></p:with-input>
        <p:with-input use-when="not($static)"><failed /></p:with-input>
    </p:identity>
</p:declare-step>