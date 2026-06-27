  - Added structure-value expressions (Section
    [Operations on structure-valued expressions](../chapter-08/08-13-operations-on-structure-valued-expressions.md#sec-structure-expressions)).
  - Added support for default values (Section [Default values](../chapter-07/07-03-default-values.md#sec-default-values)).
  - Added support for concatenating signed strings (Section
    [Concatenation](../chapter-08/08-09-concatenation-and-shifts.md#sec-concatenation)).
  - Added key-value and list-structured annotations (Section
    [Annotations](../chapter-20/index.md#sec-annotations)).
  - Added `@pure` and `@noSideEffects` annotations (Section
    [Extern function/method annotations](../chapter-20/20-03-predefined-annotations.md#sec-extern-annotations)).
  - Added `@noWarn` annotation (Section [No warnings annotation](../chapter-20/20-03-predefined-annotations.md#sec-nowarn-anno)).
  - Generalized typing for masks to allow serializable `enum`s (Section
    [Masks](../chapter-08/08-15-operations-on-sets.md#sec-cubes)).
  - Restricted the right operands of bit shifts involving
    arbitrary-precision integers to be constant and positive (Section
    [Operations on arbitrary-precision integers](../chapter-08/08-08-operations-on-arbitrary-precision-integers.md#sec-varint-ops)).
  - Clarified copy-out behavior for `return` (Section
    [Return statement](../chapter-12/12-04-return-statement.md#sec-return-stmt)) and `exit` (Section [Exit statement](../chapter-12/12-05-exit-statement.md#sec-exit-stmt))
    statements.
  - Clarified semantics of invalid header stacks (Section
    [Reading uninitialized values and writing fields of invalid headers](../chapter-08/08-25-reading-uninitialized-values-and-writing-fields-of-invalid-headers.md#sec-uninitialized-values-and-writing-invalid-headers)).
  - Clarified initialization semantics (Section [L-values](../chapter-06/06-07-l-values.md#sec-lvalues) and
    [Calling convention: call by copy in/copy out](../chapter-06/06-08-calling-convention-call-by-copy-in-copy-out.md#sec-calling-convention)), especially for headers and local
    variables.
  - Clarified evaluation order for table keys (Section
    [Match-action unit execution semantics](../chapter-14/14-02-tables.md#sec-mau-semantics)).
  - Fixed grammar to clarify parsing of right shift operator (`>>`),
    allow empty statements in parser (Section
    [Parser states](../chapter-13/13-04-parser-states-2.md#sec-parser-state-stmt)), and eliminate annotations on const
    entries (Section [Entries](../chapter-14/14-02-tables.md#sec-entries)).
