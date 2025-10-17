  - Added header stack expressions (Section \[\#sec-hs-init\]).
  - Allow casts from a type to itself (Section \[\#sec-casts\]).
  - Added an invalid header or header union expression `{#}` (Sections
    \[\#sec-ops-on-hdrs\] and \[\#sec-expr-hu\]).
  - Added a concept of numeric values (Section
    \[\#sec-numeric-values\]).
  - Added a section on operations on extern objects (Section
    \[\#sec-extern-operations\]).
  - Added note in sections operations on types for types that support
    compile-time size determination.
  - Clarified that header stacks are arrays of headers or header unions.
  - Added distinctness of fields for types that have fields including
    error, match kind, struct, header, and header union.
  - Clarified types `bit<W>`, `int<W>`, and `varbit<W>` encompass the
    case where the width is a compile-time known expression evaluating
    to an appropriate integer (Section \[\#sec-unsigned-integers\],
    Section \[\#sec-signed-integers\], Section
    \[\#sec-dynamically-sized-integers\]).
  - Clarified restrictions for parameters with default values (Section
    \[\#sec-calling-convention-justification\]).
  - Added optional trailing commas (Section \[\#sec-trailing-commas\]).
  - Clarified the scope of parser namespaces (Section
    \[\#sec-parser-decl\]).
  - Specified that algorithm for generating control-plane names for keys
    is optional (Section \[\#sec-cp-keys\]).
  - Clarified types of expressions that may appear in `select` (Section
    \[\#sec-select\]).
  - Added description of semantics of the core.p4 match kinds (Section
    \[\#sec-table-keys\]).
  - Explicitly disallow overloading of parsers, controls, and packages
    (Section \[\#sec-extern-objects\]).
  - Clarified implicit casts present in select expressions (Section
    \[\#sec-select\]).
  - Clarified that slices can be applied to arbitrary-precision integers
    (Section \[\#sec-varint-ops\]).
  - Clarified that direct invocation is not possible for objects that
    have constructor arguments (Section \[\#sec-direct-invocation\]).
  - Added comparison for tuples as a legal operation (Section
    \[\#sec-tuple-exprs\]).
  - Clarified the behavior of `lookahead` on header-typed values
    (Section \[\#sec-packet-lookahead\]).
  - Added `static_assert` function (Section \[\#sec-static-assert\]).
  - Clarified semantics of ranges where the start is bigger than the end
    (Section \[\#sec-ranges\]).
  - Allow ranges to be specified by serializable enums (Section
    \[\#sec-ranges\]).
  - Specified type produced by the `*sizeInB*` methods (Section
    \[\#sec-minsizeinbits\]).
  - Added section with operations on `match_kind` values (Section
    \[\#sec-match-kind-exprs\]).
  - Renamed infinite-precision integers to arbitrary-precision integers
    (Section \[\#sec-arbitrary-precision-integers\]).
  - compiler-inserted `default_action` is not `const` (Section
    \[\#sec-tables\]).
  - Clarified the restrictions on run time for tables with `const
    entries` (Section \[\#sec-entries\]).
  - renamed list expressions to tuple expressions
  - Added `list` type (Section \[\#sec-list-types\]).
  - Defined `entries` table property without `const`, for entries
    installed when the P4 program is loaded, but the control plane can
    later change them or add to them (Section \[\#sec-entries\]).
  - Clarified behavior of table with no `key` property, or if its list
    of keys is empty (Section \[\#sec-table-keys\]).
