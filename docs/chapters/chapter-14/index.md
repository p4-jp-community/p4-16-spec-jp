# 14 Control blocks


P4 parsers are responsible for extracting bits from a packet into
headers. These headers (and other metadata) can be manipulated and
transformed within `control` blocks. The body of a control block
resembles a traditional imperative program. Within the body of a control
block, match-action units can be invoked to perform data
transformations. Match-action units are represented in P4 by constructs
called `tables`.

Syntactically, a `control` block is declared with a name, parameters,
optional type parameters, and a sequence of declarations of constants,
variables, `action`s, `table`s, and other instantiations:

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:controlDeclaration\]

\[INCLUDE=grammar.mdk:controlLocalDeclarations\]

\[INCLUDE=grammar.mdk:controlLocalDeclaration\]

  - \[INCLUDE=grammar.mdk:controlBody\]  
    End P4Grammar

It is illegal to instantiate a `parser` within a `control` block. For a
description of the `optConstructorParameters`, which can be used to
build parameterized control blocks, see Section
\[\#sec-parameterization\].

Unlike control type declarations, control declarations may not be
generic—e.g., the following declaration is illegal:

\~ Begin P4Example control C<H>(inout H data) { /\* Body omitted \*/ }
\~ End P4Example

P4 does not support exceptional control-flow within a `control` block.
The only statement which has a non-local effect on control flow is
`exit`, which causes execution of the enclosing control block to
immediately terminate. That is, there is no equivalent of the `verify`
statement or the `reject` state from parsers. Hence, all error handling
must be performed explicitly by the programmer.

The rest of this section describes the core components of a `control`
block, starting with actions.

--8<-- "chapters/chapter-14/14-01-actions.md"
--8<-- "chapters/chapter-14/14-02-tables.md"
--8<-- "chapters/chapter-14/14-03-the-match-action-pipeline-abstract-machine.md"
--8<-- "chapters/chapter-14/14-04-invoking-controls.md"
