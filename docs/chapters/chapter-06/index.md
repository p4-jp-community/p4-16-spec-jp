# 6 P4 language definition


The P4 language can be viewed as having several distinct components,
which we describe separately:

  - The core language, comprising of types, variables, scoping,
    declarations, statements, expressions, etc. We start by describing
    this part of the language.
  - A sub-language for expressing parsers, based on state machines
    (Section \[\#sec-packet-parsing\]).
  - A sub-language for expressing computations using match-action units,
    based on traditional imperative control-flow (Section
    \[\#sec-control\]).
  - A sub-language for describing architectures (Section
    \[\#sec-arch-desc\]).

--8<-- "chapters/chapter-06/06-01-syntax-and-semantics.md"
--8<-- "chapters/chapter-06/06-02-preprocessing.md"
--8<-- "chapters/chapter-06/06-03-p4-core-library.md"
--8<-- "chapters/chapter-06/06-04-lexical-constructs.md"
--8<-- "chapters/chapter-06/06-05-naming-conventions.md"
--8<-- "chapters/chapter-06/06-06-p4-programs.md"
--8<-- "chapters/chapter-06/06-07-l-values.md"
--8<-- "chapters/chapter-06/06-08-calling-convention-call-by-copy-in-copy-out.md"
--8<-- "chapters/chapter-06/06-09-name-resolution.md"
--8<-- "chapters/chapter-06/06-10-visibility.md"
