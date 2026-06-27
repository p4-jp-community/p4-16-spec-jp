  - Added support for accessing tuple fields (Section
    [Operations on tuple expressions](../chapter-08/08-12-operations-on-tuple-expressions.md#sec-tuple-exprs)).
  - Added support for generic structures (Section [Type specialization](../chapter-07/07-02-derived-types.md#sec-type-spec)).
  - Added support for integers, `enum`s, and `error`s in `switch`
    statements (Section [Switch statement](../chapter-12/12-07-switch-statement.md#sec-switch-stmt)).
  - Added support for additional enumeration types (Section
    [Enumeration types](../chapter-07/07-02-derived-types.md#sec-enum-types)).
  - Added support for abstract methods (Section
    [Abstract methods](../chapter-07/07-02-derived-types.md#sec-abstract-methods)).
  - Added support for conditional statements and empty statements in
    parsers (Section [Parser states](../chapter-13/13-04-parser-states-2.md#sec-parser-state-stmt)).
  - Added support for casts from `int` to `bool` (Section
    [Casts](../chapter-08/08-11-casts.md#sec-casts)).
  - Added support for 0-width bitstrings and varbits (Section
    [Reading uninitialized values and writing fields of invalid headers](../chapter-08/08-25-reading-uninitialized-values-and-writing-fields-of-invalid-headers.md#sec-uninitialized-values-and-writing-invalid-headers)).
  - Clarified that `default_action` is `NoAction` if otherwise
    unspecified (Section [Tables](../chapter-14/14-02-tables.md#sec-tables)).
  - Clarified the types of expressions that may be used as indexes for
    header stacks (Section [Operations on header stacks](../chapter-08/08-18-operations-on-header-stacks.md#sec-expr-hs)).
  - Clarified representation of Booleans in headers (Section
    [Header types](../chapter-07/07-02-derived-types.md#sec-header-types)).
  - Clarified representation of empty types (Section
    [Reading uninitialized values and writing fields of invalid headers](../chapter-08/08-25-reading-uninitialized-values-and-writing-fields-of-invalid-headers.md#sec-uninitialized-values-and-writing-invalid-headers)).
  - Clarified that action data can be specified by the control plane,
    `default_action` table property, or `const entries` table property
    (Section [Actions](../chapter-14/14-01-actions.md#sec-actions)).
  - Fixed several typos and inconsistencies in grammar (Section
    [P4 grammar](../appendix-G/index.md#sec-grammar)).
  - Eliminated annotations on `const` entries in grammar (Section
    [P4 grammar](../appendix-G/index.md#sec-grammar)).
