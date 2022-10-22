<?xml version="1.0" encoding="UTF-8"?>
<p:library version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
          xmlns:ex="http://extension-step.org">
    
    <p:option name="opt" static="true" select="p:step-available('ex:test1')" />
    
    <p:declare-step type="ex:test" use-when="$opt">
        <p:input port="source" />
        <p:output />
        <p:identity />
    </p:declare-step>
    
    <p:declare-step type="ex:test1" use-when="p:step-available('ex:test')">
        <p:input port="source" />
        <p:output />
        <p:identity />        
    </p:declare-step>
    
    <p:declare-step type="ex:synopsis">
        <p:output port="result" />
        <p:identity>
            <p:with-input>
                <result>
                    <test>{p:step-available('ex:test')}</test>
                    <test1>{p:step-available('ex:test1')}</test1>
                </result>
            </p:with-input>
        </p:identity>
    </p:declare-step>
</p:library>
