xquery version "3.1";
module namespace test="http://xproc.org/ns/testsuite/3.0/function-test";

declare function test:function() as item(){
element{"function-result"}{}
};

declare function test:function1() as item(){
element{"function-result1"}{}
};
