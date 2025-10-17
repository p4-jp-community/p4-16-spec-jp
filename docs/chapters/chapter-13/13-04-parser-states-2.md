  - A parser state is declared with the following syntax:  
    Begin P4Grammar \[INCLUDE=grammar.mdk:parserState\]
    End P4Grammar

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
        \[\#sec-invoke-subparser\]), and
  - Conditional statements,
  - Transitions to other states (discussed in Section
    \[\#sec-transition\]).

<!-- end list -->

  - The syntax for parser statements is given by the following grammar
    rules:  
    Begin P4Grammar \[INCLUDE=grammar.mdk:parserStatements\]

\[INCLUDE=grammar.mdk:parserStatement\]

  - \[INCLUDE=grammar.mdk:parserBlockStatement\]  
    End P4Grammar

Architectures may place restrictions on the expressions and statements
that can be used in a parser—e.g., they may forbid the use of operations
such as multiplication or place restrictions on the number of local
variables that may be used.

In terms of the `ParserModel`, the sequence of statements in a state are
executed sequentially.
