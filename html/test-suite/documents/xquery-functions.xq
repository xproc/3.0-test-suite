xquery version "3.1";
declare namespace test="http://xproc.org/ns/testsuite/3.0/function-test";
declare namespace test1="http://xproc.org/ns/testsuite/3.0/function-test1";

declare function test:function1() as item(){
  element{"function-result"}{}
};
declare function test:function2($par as xs:string) as item(){
    element{"function-result"}{$par}
};
declare %private function test:private-function() as item(){
    element{"function-result"}{}
};
declare function test1:function1() as item(){
  element{"namespaced-function"}{}
};

(:main expr:)
42