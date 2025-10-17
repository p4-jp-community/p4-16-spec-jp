  - Top-level functions (Section \[\#sec-functions\])
      - Functions may be declared at the top-level of a P4 program.
  - Optional and named parameters (Section \[\#sec-calling-convention\])
      - Parameters may be specified by name, with a default value, or
        designated as optional.
  - `enum` representations (Section \[\#sec-enum-exprs\])
      - `enum` values to be specified with a concrete representation.
  - Parser values sets (Section \[\#sec-value-set\])
      - `value_set` objects for control-plane programmable `select`
        labels.
  - Type definitions (Section \[\#sec-newtype\])
      - New types may be introduced in programs.
  - Saturating arithmetic (Section \[\#sec-bit-ops\])
      - Saturating arithmetic is supported on some targets.
  - Structured annotations (Section \[\#sec-annotations\])
      - Annotations may be specified as lists of key-value pairs
  - Globalname (Section \[\#sec-name-annotations\])
      - The reserved `globalname` annotation has been removed.
  - Table `size` property (Section \[\#sec-size-table-property\])
      - Meaning of optional `size` property for tables has been defined.
  - Invalid headers (Section \[\#sec-ops-on-hdrs\])
      - Clarified semantics of operations on invalid headers.
  - Calling restrictions (Section \[\#sec-calling-restrictions\])
      - Added restrictions on kinds of values that may be passed as
        arguments to calls.
  - Bitwise operator precedence (Section \[\#sec-grammar\])
      - Modified precedence conventions so that bitwise operators `&`
        `|` and `^` have higher precedence than relation operators `<`
        `>` `<=` `>=`.
  - Computed bitwidths (Section \[\#sec-base-types\])
      - Added support for specifying widths using expressions in `bit`
        and `varbit` types.
