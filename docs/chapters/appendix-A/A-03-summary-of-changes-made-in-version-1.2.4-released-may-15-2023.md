  - Added header stack expressions (Section [Header stack expressions](../chapter-08/08-18-operations-on-header-stacks.md#sec-hs-init)).
  - Allow casts from a type to itself (Section [Casts](../chapter-08/08-11-casts.md#sec-casts)).
  - Added an invalid header or header union expression `{#}` (Sections
    [Operations on headers](../chapter-08/08-17-operations-on-headers.md#sec-ops-on-hdrs) and [Operations on header unions](../chapter-08/08-19-operations-on-header-unions.md#sec-expr-hu)).
  - Added a concept of numeric values (Section
    [Numeric types](../chapter-07/07-04-numeric-types.md#sec-numeric-values)).
  - Added a section on operations on extern objects (Section
    [Operations on `extern` objects](../chapter-08/08-22-operations-on-extern-objects.md#sec-extern-operations)).
  - Added note in sections operations on types for types that support
    compile-time size determination.
  - Clarified that header stacks are arrays of headers or header unions.
  - Added distinctness of fields for types that have fields including
    error, match kind, struct, header, and header union.
  - Clarified types `bit<W>`, `int<W>`, and `varbit<W>` encompass the
    case where the width is a compile-time known expression evaluating
    to an appropriate integer (Section [Unsigned integers (bit-strings)](../chapter-07/07-01-base-types.md#sec-unsigned-integers),
    Section [Signed Integers](../chapter-07/07-01-base-types.md#sec-signed-integers), Section
    [Dynamically-sized bit-strings](../chapter-07/07-01-base-types.md#sec-dynamically-sized-integers)).
  - Clarified restrictions for parameters with default values (Section
    [Justification](../chapter-06/06-08-calling-convention-call-by-copy-in-copy-out.md#sec-calling-convention-justification)).
  - Added optional trailing commas (Section [Optional trailing commas](../chapter-06/06-04-lexical-constructs.md#sec-trailing-commas)).
  - Clarified the scope of parser namespaces (Section
    [Parser declarations](../chapter-13/13-02-parser-declarations.md#sec-parser-decl)).
  - Specified that algorithm for generating control-plane names for keys
    is optional (Section [Keys](../chapter-18/18-03-control-plane-names.md#sec-cp-keys)).
  - Clarified types of expressions that may appear in `select` (Section
    [Select expressions](../chapter-13/13-06-select-expressions.md#sec-select)).
  - Added description of semantics of the core.p4 match kinds (Section
    [Keys](../chapter-14/14-02-tables.md#sec-table-keys)).
  - Explicitly disallow overloading of parsers, controls, and packages
    (Section [Extern objects](../chapter-07/07-02-derived-types.md#sec-extern-objects)).
  - Clarified implicit casts present in select expressions (Section
    [Select expressions](../chapter-13/13-06-select-expressions.md#sec-select)).
  - Clarified that slices can be applied to arbitrary-precision integers
    (Section [Operations on arbitrary-precision integers](../chapter-08/08-08-operations-on-arbitrary-precision-integers.md#sec-varint-ops)).
  - Clarified that direct invocation is not possible for objects that
    have constructor arguments (Section [Direct type invocation](../chapter-15/15-01-direct-type-invocation.md#sec-direct-invocation)).
  - Added comparison for tuples as a legal operation (Section
    [Operations on tuple expressions](../chapter-08/08-12-operations-on-tuple-expressions.md#sec-tuple-exprs)).
  - Clarified the behavior of `lookahead` on header-typed values
    (Section [Lookahead](../chapter-13/13-08-data-extraction.md#sec-packet-lookahead)).
  - Added `static_assert` function (Section [Static assertions](../chapter-19/index.md#sec-static-assert)).
  - Clarified semantics of ranges where the start is bigger than the end
    (Section [Ranges](../chapter-08/08-15-operations-on-sets.md#sec-ranges)).
  - Allow ranges to be specified by serializable enums (Section
    [Ranges](../chapter-08/08-15-operations-on-sets.md#sec-ranges)).
  - Specified type produced by the `*sizeInB*` methods (Section
    [Compile-time size determination](../chapter-09/index.md#sec-minsizeinbits)).
  - Added section with operations on `match_kind` values (Section
    [Operations on `match_kind` types](../chapter-08/08-04-operations-on-match-kind-types.md#sec-match-kind-exprs)).
  - Renamed infinite-precision integers to arbitrary-precision integers
    (Section [Arbitrary-precision integers](../chapter-07/07-01-base-types.md#sec-arbitrary-precision-integers)).
  - compiler-inserted `default_action` is not `const` (Section
    [Tables](../chapter-14/14-02-tables.md#sec-tables)).
  - Clarified the restrictions on run time for tables with `const
    entries` (Section [Entries](../chapter-14/14-02-tables.md#sec-entries)).
  - renamed list expressions to tuple expressions
  - Added `list` type (Section [List types](../chapter-07/07-02-derived-types.md#sec-list-types)).
  - Defined `entries` table property without `const`, for entries
    installed when the P4 program is loaded, but the control plane can
    later change them or add to them (Section [Entries](../chapter-14/14-02-tables.md#sec-entries)).
  - Clarified behavior of table with no `key` property, or if its list
    of keys is empty (Section [Keys](../chapter-14/14-02-tables.md#sec-table-keys)).
