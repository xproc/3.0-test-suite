xquery version "3.1";
module namespace test="http://xproc.org/ns/testsuite/3.0/function-test";

declare function test:function1($par as xs:string) as item(){
    element{"function-result"}{$par}
};
