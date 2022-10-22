xquery version "3.1";
declare namespace test="http://xproc.org/ns/testsuite/3.0/function-test";

declare function test:function1() as item(){
element{"function-result1"}{}
};

(:main expr:)
42