# XProc 3.0 test-suite

The [XProc 3.0 Test Suite](https://xproc.github.io/3.0-test-suite/)
provides the conformance tests for
[XProc 3.0](https://github.com/xproc/3.0-specification).

## Quick start

If you just want to write a test, start with this template
from [examples/passing.xml](blob/master/examples/passing.xml):

```xml
<t:test xmlns:t="http://xproc.org/ns/testsuite/3.0" expected="pass">

<t:info>
  <t:title>YOUR TITLE HERE</t:title>
  <t:revision-history>
    <t:revision>
      <t:date>TODAY’S DATE HERE</t:date>
      <t:author>
        <t:name>YOUR NAME</t:name>
      </t:author>
      <t:description xmlns="http://www.w3.org/1999/xhtml">
        <p>DESCRIBE THIS REVISION.</p>
      </t:description>
    </t:revision>
  </t:revision-history>
</t:info>

<t:description xmlns="http://www.w3.org/1999/xhtml">
  <p>DESCRIBE YOUR TEST HERE.</p>
</t:description>

<t:pipeline>
  <!-- YOUR PIPELINE GOES HERE -->
  <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="3.0">
    <p:output port="result"/>
    <p:identity>
      <p:with-input>
        <doc/>
      </p:with-input>
    </p:identity>
  </p:declare-step>
</t:pipeline>

<t:schematron>
  <!-- PROVIDE AT LEAST ONE SCHEMATRON TEST FOR VALIDITY -->
  <s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron"
            xmlns:p="http://www.w3.org/ns/xproc"
            xmlns:rng="http://relaxng.org/ns/structure/1.0">
     <s:ns prefix="p" uri="http://www.w3.org/ns/xproc"/>

     <s:pattern>
       <s:rule context="/*">
         <s:assert test="self::doc">The pipeline root is not doc.</s:assert>
       </s:rule>
     </s:pattern>
  </s:schema>
</t:schematron>
</t:test>
```

All test pipelines must produce a single result document on
the `result` port. (This limitation may complicate some tests, but
it reduces the complexity of the test harness greatly.)

You’ll find a slightly longer example demonstrating a few more features
in from [examples/passing2.xml](examples/passing2.xml).

To write a test that’s expected to fail, use this template
from [examples/fail.xml](examples/fail.xml]).

```xml
<t:test xmlns:t="http://xproc.org/ns/testsuite/3.0"
        xmlns:err="http://www.w3.org/ns/xproc-error"
        expected="fail" code="err:XD0007">

<t:info>
  <t:title>YOUR TITLE HERE</t:title>
  <t:revision-history>
    <t:revision>
      <t:date>TODAY’S DATE HERE</t:date>
      <t:author>
        <t:name>YOUR NAME</t:name>
      </t:author>
      <t:description xmlns="http://www.w3.org/1999/xhtml">
        <p>DESCRIBE THIS REVISION.</p>
      </t:description>
    </t:revision>
  </t:revision-history>
</t:info>

<t:description xmlns="http://www.w3.org/1999/xhtml">
  <p>DESCRIBE YOUR TEST HERE.</p>
</t:description>

<t:pipeline>
  <!-- YOUR PIPELINE GOES HERE -->
  <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="3.0">
    <p:output port="result" primary="false"/>
      
    <p:identity>
      <p:with-input port="source">
        <doc/>
      </p:with-input>
    </p:identity>
  </p:declare-step>
</t:pipeline>
<!-- THERE ARE NO SCHEMATRON TESTS FOR FAILED PIPELINES -->
</t:test>
```

## Continuous integration

![Build Status](https://travis-ci.org/xproc/3.0-test-suite.svg?branch=master)

The [test suite](https://xproc.github.io/3.0-test-suite/) is published
automatically by [Travis CI](https://travis-ci.org). All submissions 
are made through pull requests. Pull requests are automatically
tested for conformance to the schemas and a few other ad hoc rules (all
test titles must be unique, for example).

If you have a modern development system, you should be able to run
the tests locally with [Gradle](https://gradle.org/). Simply run
the `gradlew` script in the repository’s root directory with an
appropriate target.

Some useful targets:

* `validate_all_tests` confirms that all the tests conform to the rules.
* `transform_all_tests` transforms all of the tests into HTML.
* `test_indexes` builds the index pages for the website.
* `website` builds the website; this is the default target.

## Test format

Scheams for the test XML format can be found in 
`src/main/test-suite.rnc` and `src/main/test-suite.sch`. These may
allow you to configure syntax directed editing in your favorite
XML editing tool.

Most of the constraints are in the RELAX NG grammar but a few
co-constraints are enforced in the Schematron.

## The structure of tests

There are two kinds of tests: passing tests and failing tests.
A passing test is one where the pipeline is expected to run successfully.
A failing test is one where the pipeline is expected to fail (because
of errors in the pipeline or the runtime configuration).

Both passing and failing tests begin with a metadata section,
`t:info`:

```xml
<t:info>
  <t:title>Test Title</t:title>
  <t:revision-history>
    <t:revision>
      <t:date>2018-02-02T17:42:37+01:00</t:date>
      <t:author>
        <t:name>Author Name</t:name>
        <t:email>you@example.com</t:email>
        <t:uri>https://example.com/</t:uri>
      </t:author>
      <t:description>
        <p>Some description of this revision.</p>
      </t:description>
    </t:revision>
  </t:revision-history>
</t:info>
```

If there are multiple revisions, place newer revisions above
older ones. It isn’t mandatory to provide an email address or URI,
but it will make it easier to identify you if there are follow up
questions about the test.

(See below for a few syntactic shortcuts for revisions.)

The metadata section is followed by a description of the test:

```xml
<t:description xmlns="http://www.w3.org/1999/xhtml">
  <p>DESCRIBE YOUR TEST HERE.</p>
</t:description>
```

Descriptions must be provided in HTML. Use `<code>` to identify
errors and element names (e.g. `<code>err:XD0007</code>`
and `<code>p:identity</code>`).

Ideally, the description provides a brief synopsis of what is being
tested. It should not recapitulate the test, but it should focus the reader’s
attention to what’s important.

### Passing tests

The basic structure of a passing test is:

```xml
<t:test xmlns:t="http://xproc.org/ns/testsuite/3.0"
        expected="pass">
```

A passing test must assert that the expected result is a pass.

Following the metadata and description is the test pipeline:

```xml
<t:pipeline>
  <p:declare-step xmlns="http://xproc.org/ns/testsuite/3.0" version="3.0">
    <!-- … -->
  </p:declare-step>
</t:pipeline>
```

The test ends with at least one Schematron assertion about the
output.

```xml
<t:schematron>
  <s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron"
            xmlns:p="http://www.w3.org/ns/xproc">
     <s:ns prefix="p" uri="http://www.w3.org/ns/xproc"/>
     <!-- … some patterns -->
  </s:schema>
</t:schematron>
```

A failing test is much the same, except that it must assert that the
expected result is a failure and provide a (list of) error codes that
may be reported by a conformant processor.


```xml
<t:test xmlns:t="http://xproc.org/ns/testsuite/3.0"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:err="http://www.w3.org/ns/xproc-error"
        expected="fail"
        code="err:XS0038">
```

A failing test may not include a schematron schema to validate the
test results.

### Other test elements

Tests can also include inputs and options:

```xml
<t:test xmlns:t='http://xproc.org/ns/testsuite/3.0' expected="pass">
  <t:info>…</t:info>
  <t:description>…</t:description>
  
  <t:input port='source'>…</t:input>
  <t:option name='optname' select='3'/>
  
  <t:pipeline>…</t:pipeline>
  <t:schematron>…</t:schematron>
</test>
```

The `test`, `input`, `pipeline`, and `schematron` elements may each
_either_ include their content inline _or_ point to it with a `src`
attribute. Test elements may further point to a specific step (if the
`src` URI points to a library, for example) with a `step` attribute.

In this way, if a complicated pipeline is reused in several tests
(perhaps with different options), the pipeline can be authored once
and reused:

```xml
  <t:pipeline src="../pipelines/a-complex-pipeline.xpl"/>
```

## Revision history shortcuts

Often the same author makes several revisions to a test. In this case,
it is somewhat inconvenient to have to repeat the author information
over and over again. If the same author is responsible for multiple
revisions, a syntactic shortcut is possible:

1. The first time you add an `t:author`, specify the author initials.
2. On a subsequent revision by that author, you can use the
   `initials` attribute on `t:revision` as a shortcut for
   the author.

For example:

```xml
<t:revision-history>

  <t:revision initials="fa">
    <t:date>2018-03-14</t:date>
    <t:description>
      <p>Some description of this revision.</p>
    </t:description>
  </t:revision>

  <t:revision>
    <t:date>2018-02-02</t:date>
    <t:author initials="fa">
      <t:name>First Author</t:name>
      <t:email>fa@example.com</t:email>
    </t:author>
    <t:description>
      <p>Some description of this revision.</p>
    </t:description>
  </t:revision>

</t:revision-history>
```

## Executing tests

The program that runs tests should accept a list of file or directory
names and evaluate all of the tests given. For directories, it should
recursively evaluate all of the tests in or below the specified
directory.

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

## Test results

All tests must produce a single result document on the `result` port.
The correctness of the result is determined by checking it with the
supplied [Schematron](http://schematron.com/) schema.

There’s no direct way to check non-XML results with Schematron, so
some XML abstract (properties, counts, `base64` or `hexBinary`
encodings, etc.) will have to be produced and tested.

## Test report format

Tests should output the JUnit XML test result format.

## Repository layout

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

## Docker configuration

Some tests require access to a configured server. For example, the
HTTP tests require access to an HTTP server running scripts that
respond in the expected way to requests.

This used to be accomplished by running the services on
`tests.xproc.org`. However, that site runs on shared infrastructure
and changes to that infrastructure caused a number of tests to fail.
It also had the disadvantage that only Norm had access to the scripts
and the server configuration.

Starting in April, 2021, the services required for running tests are
provided by a Docker container. To run the tests, you will need to
have [Docker](https://docker.com/) and `docker-compose`.

Before running the tests, you must start the container. You can do
this by running `./gradlew start`. Or, if you prefer, by running
`docker-compose` directly in the `docker` directory. The container is
downloaded from GitHub automatically, but the build script for the
container is in `docker/xproctest`. When the tests finish, you can
stop the container by running `./gradlew stop` or, again, with
`docker-compose` directly.

At the time of this writing, the container only supports the HTTP
tests. Over time, additional services such as SMTP mocking may be
added to the container to facilitate testing more steps.

### A note about port numbers

Access to the tests in the running container is provided through port
mapping. At the moment, the mapping for HTTP is hard-coded to port
`8246`. In other words, `http://localhost:8246` is mapped to port 80
in the container.

It’s possible to make this configurable, but it would require some
effort and it isn’t clear if it’s necessary. If you are running the
tests and you find that using port `8246` on `localhost` is
problematic, please open an issue.
