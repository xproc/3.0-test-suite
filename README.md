# XProc 3.0 test-suite

The XProc 3.0 test suite contains conformance tests for
[XProc 3.0](https://github.com/xproc/3.0-specification).

This repository is organized in the following way:

```
├── README.md
├── schema
│   └── …                        # Schemas for the test suite itself
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

Tests must indicate whether they are expected to pass or fail. The
simplest structure for a passing test is:

```
<test xmlns='http://xproc.org/ns/testsuite/3.0' expected="pass">
  <pipeline>…</pipeline>
  <schematron>…</schematron>
</test>
```

The simplest structure for a failing test is:

```
<test xmlns='http://xproc.org/ns/testsuite/3.0'
      xmlns:err='http://www.w3.org/ns/xproc-error’
      expected="fail" code=”err:code>
  <pipeline>…</pipeline>
</test>
```

Tests can also include inputs and options:

```
<test xmlns='http://xproc.org/ns/testsuite/3.0' expected="pass">
  <input port='source'>…</input>
  <option name='optname' select='3'/>
  <pipeline>…</pipeline>
  <schematron>…</schematron>
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

