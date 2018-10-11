# XProc 3.0 test-suite

The XProc 3.0 test suite contains conformance tests for
[XProc 3.0](https://github.com/xproc/3.0-specification).

This repository is organized in the following way:

```
├── README.md
├── src/main/schema
│            └── …               # Schemas for the test suite itself
├── src/main/resources
│            └── …               # Site index, CSS, etc.
└── test-suite
    ├── documents
    │   └── …                    # Ancillary documents used by tests
    ├── pipelines
    │   └── …                    # Pipeline documents
    ├── schematron
    │   └── …                    # Schematron schemas for checking test results
    └── tests
        └── …                    # Individual tests
```

## Test format

Tests must conform to the `src/main/test-suite.rnc` and
`src/main/test-suite.sch` schemas. Most of the constraints are in the
RELAX NG grammar but a few co-constraints are enforced in the
Schematron.

Note that the build process copies/converts them to
`build/test-suite.rng` and `build/test-suite.sch`. It’s probably
better to rely on those versions for testing because the sources may
be converted in more interesting ways in the future.

The basic structure of a passing test is:

```
<t:test xmlns:t="http://xproc.org/ns/testsuite/3.0"
        xmlns="http://www.w3.org/1999/xhtml"
        expected="pass">
```

A passing test must assert that the expected result is a pass. Failing
tests are described below.

The first element in the `test` must be an `info` that includes metadata
about the test.

```
  <t:info>
    <t:title>Test Title</t:title>
    <t:revision-history>
      <t:revision>
        <t:date>2018-02-02T17:42:37+01:00</t:date>
        <t:author>
          <t:name>Author Name</t:name>
        </t:author>
        <t:description>
          <p>Some description of this revision.</p>
        </t:description>
      </t:revision>
    </t:revision-history>
   </t:info>
```

If there are multiple revisions, they should be in date order.

Followed by a description of the test.

```
   <t:description>
      <p>Some description of the test.</p>
   </t:description>
```

Note that the `description` element must contain some fragment(s) of HTML.

Following the metadata and description is the test pipeline followed,
optionally, by a Schematron schema to validate the test results.

```
   <t:pipeline>
      <p:declare-step xmlns="http://xproc.org/ns/testsuite/3.0" version="3.0">
         <p:output port="result">
            <p:pipe step="producer" port="result"/>
         </p:output>
      
         <p:identity name="producer">
            <p:with-input port="source">
               <doc xmlns=""/>
            </p:with-input>
         </p:identity>
      </p:declare-step>
   </t:pipeline>
   <t:schematron src="../schematron/some-schema.sch"/>
</t:test>
```

A failing test is much the same, except that it must assert that the
expected result is a fail and provide a (list of) error codes that may
be reported by a conformant processor.


```
<t:test xmlns:t="http://xproc.org/ns/testsuite/3.0"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:err="http://www.w3.org/ns/xproc-error"
        expected="fail"
        code="err:XS0038">
  …
</t:test>  
```

A failing test may not include a schematron schema to validate the
test results.

Tests can also include inputs and options:

```
<t:test xmlns:t='http://xproc.org/ns/testsuite/3.0' expected="pass">
  <t:info>…</t:info>
  <t:input port='source'>…</t:input>
  <t:option name='optname' select='3'/>
  <t:pipeline>…</t:pipeline>
  <t:schematron>…</t:schematron>
</test>
```

The `test`, `input`, `pipeline`, and `schematron` elements may each _either_
include their content inline _or_ point to it with a `src` attribute. Test elements
may further point to a specific step (if the `src` URI points to a library, for example)
with a `step` attribute.

All tests must produce a single result document on the `result` port. The correctness
of the result is determined by checking it with the supplied
[Schematron](http://schematron.com/) schema.

There’s no direct way to check non-XML results with Schematron, so some XML abstract
(properties, counts, `base64` or `hexBinary` encodings, etc.) will have to be produced
and tested.

A group of tests can be combined into a `test-suite` and tests may be divided into
sections using `div`s.

### Revision histories

In the case of revisions, it is somewhat inconvenient to have to
repeat the same author information over and over again. If the same
author is responsible for multiple revisions, a syntacit shortcut is
possible:

1. On the first `t:author`, specify the author initials.
2. On a subsequent revision by that author, you can use the
   `initials` attribute on the `t:revision` as a shortcut for
   the author.

For example:

```
<t:revision-history>

<t:revision>
    <t:date>2018-02-02</t:date>
    <t:author initials="fa">
      <t:name>First Author</t:name>
    </t:author>
    <t:description>
      <p>Some description of this revision.</p>
    </t:description>
  </t:revision>

  <t:revision initials=”fa”>
    <t:date>2018-03-14</t:date>
    <t:description>
      <p>Some description of this revision.</p>
    </t:description>
  </t:revision>

</t:revision-history>
```

## Executing tests

The program that runs tests should accept a list of file or directory names
and evaluate all of the tests given. For directories, it should recursively
evaluate all of the tests in or below the specified directory.

All test files should have the extension `.xml`. Files that are not
tests: pipelines, schemas, ancillary documents, etc. should be stored
in other directories. Nevertheless, if a test runner finds a non-test
document, it should simply skip it.

### Controlling execution of tests

Tests and test suites can identify which features they cover with a
`features` attribute. (We don’t have a vocabulary of feature names
yet, but…). It would be reasonable for a test runner to allow the user
to specify which features they wanted to test.

In addition, tests and test suites have a `when` attribute. The `when`
attribute, if present, must contain an XPath expression. If the
effective boolean value of that expression is true, then the test or
test suite will run. Otherwise, it will be skipped.

The context item for the `when` expression is undefined. It is an
error if the expression refers to the context.

## Test report format

Tests should output the JUnit XML test result format.
