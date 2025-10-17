  - Added structure-value expressions (Section
    \[\#sec-structure-expressions\]).
  - Added support for default values (Section \[\#sec-default-values\]).
  - Added support for concatenating signed strings (Section
    \[\#sec-concatenation\]).
  - Added key-value and list-structured annotations (Section
    \[\#sec-annotations\]).
  - Added `@pure` and `@noSideEffects` annotations (Section
    \[\#sec-extern-annotations\]).
  - Added `@noWarn` annotation (Section \[\#sec-nowarn-anno\]).
  - Generalized typing for masks to allow serializable `enum`s (Section
    \[\#sec-cubes\]).
  - Restricted the right operands of bit shifts involving
    arbitrary-precision integers to be constant and positive (Section
    \[\#sec-varint-ops\]).
  - Clarified copy-out behavior for `return` (Section
    \[\#sec-return-stmt\]) and `exit` (Section \[\#sec-exit-stmt\])
    statements.
  - Clarified semantics of invalid header stacks (Section
    \[\#sec-uninitialized-values-and-writing-invalid-headers\]).
  - Clarified initialization semantics (Section \[\#sec-lvalues\] and
    \[\#sec-calling-convention\]), especially for headers and local
    variables.
  - Clarified evaluation order for table keys (Section
    \[\#sec-mau-semantics\]).
  - Fixed grammar to clarify parsing of right shift operator (`>>`),
    allow empty statements in parser (Section
    \[\#sec-parser-state-stmt\]), and eliminate annotations on const
    entries (Section \[\#sec-entries\]).
