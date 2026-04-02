<p:library version="3.0" 
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:ex="http://extension-step.org">
    
    <p:declare-step type="ex:no-body">
        <p:input port="source" />
        <p:output port="result" />
    </p:declare-step>
    
    <p:declare-step type="ex:not-visible" visibility="private">
        <p:input port="source" />
        <p:output port="result" />
        
        <p:identity />
    </p:declare-step>
    
    <p:declare-step type="ex:visible">
        <p:input port="source" />
        <p:output port="result" />
        
        <p:identity />
    </p:declare-step>
    
    <p:declare-step type="ex:tester1">
        <p:output port="result" />
        
        <p:identity>
            <p:with-input>
                <result>
                    <no-body>{p:step-available('ex:no-body')}</no-body>
                    <not-visible>{p:step-available('ex:not-visible')}</not-visible>
                    <visible>{p:step-available('ex:visible')}</visible>
                </result>
            </p:with-input>
        </p:identity>
    </p:declare-step>
</p:library>
    