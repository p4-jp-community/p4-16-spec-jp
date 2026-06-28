<a id="sec-parser-state-stmt"></a>
A parser state is declared with the following syntax:

```bison
parserState
: optAnnotations STATE name
  "{" parserStatements transitionStatement "}"
;
```

Each state has a name and a body. The body consists of a sequence of
statements that describe the processing performed when the parser
transitions to that state, including:

  - Local variable declarations,
  - Assignment statements,
  - Method calls, which serve several purposes:
      - Invoking functions (e.g., using `verify` to check the validity
        of data already parsed), and
      - Invoking methods (e.g., extracting data out of packets or
        computing checksums) and other parsers (see Section
        [Sub-parsers](13-10-sub-parsers.md#sec-invoke-subparser)), and
  - Conditional statements,
  - Transitions to other states (discussed in Section
    [Transition statements](13-05-transition-statements.md#sec-transition)).

<!-- end list -->

The syntax for parser statements is given by the following grammar rules:

```bison
parserStatements
: /* empty */
| parserStatements parserStatement
;

parserStatement
: assignmentOrMethodCallStatement
| directApplication
| emptyStatement
| variableDeclaration
| constantDeclaration
| parserBlockStatement
| conditionalStatement
;

parserBlockStatement
: optAnnotations "{" parserStatements "}"
;
```

Architectures may place restrictions on the expressions and statements
that can be used in a parser—e.g., they may forbid the use of operations
such as multiplication or place restrictions on the number of local
variables that may be used.

In terms of the `ParserModel`, the sequence of statements in a state are
executed sequentially.
