<p:library xmlns:p="http://www.w3.org/ns/xproc" version="3.0">

  <p:import href="ab-library-001.xpl"/>
  
  <p:declare-step type="Q{http://test}three"
                  xmlns:t="http://test">
    <p:output port="result" />
    <t:one/>
    <p:rename match="/one" new-name="three"/>
  </p:declare-step>
    
</p:library>

