xquery version "3.1";
module namespace test="http://xproc.org/ns/testsuite/3.0/function-test";

declare function test:function() as item(){
  element{"function-result"}{}
};

declare function test:function1() as item(){
  element{"function-result"}{}
};
declare function test:function2($par as xs:string) as item(){
    element{"function-result"}{$par}
};
declare %private function test:private-function() as item(){
    element{"function-result"}{}
};
declare function test:function3() as item(){
  element{"namespaced-function"}{}
};
