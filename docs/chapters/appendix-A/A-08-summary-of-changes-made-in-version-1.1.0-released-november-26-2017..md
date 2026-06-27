  - Top-level functions (Section [Function declarations](../chapter-10/index.md#sec-functions))
      - Functions may be declared at the top-level of a P4 program.
  - Optional and named parameters (Section [Calling convention: call by copy in/copy out](../chapter-06/06-08-calling-convention-call-by-copy-in-copy-out.md#sec-calling-convention))
      - Parameters may be specified by name, with a default value, or
        designated as optional.
  - `enum` representations (Section [Operations on `enum` types](../chapter-08/08-03-operations-on-enum-types.md#sec-enum-exprs))
      - `enum` values to be specified with a concrete representation.
  - Parser values sets (Section [Parser Value Sets](../chapter-13/13-11-parser-value-sets.md#sec-value-set))
      - `value_set` objects for control-plane programmable `select`
        labels.
  - Type definitions (Section [Introducing new types](../chapter-07/07-06-introducing-new-types.md#sec-newtype))
      - New types may be introduced in programs.
  - Saturating arithmetic (Section [Operations on fixed-width bit types (unsigned integers)](../chapter-08/08-06-operations-on-fixed-width-bit-types-unsigned-integers.md#sec-bit-ops))
      - Saturating arithmetic is supported on some targets.
  - Structured annotations (Section [Annotations](../chapter-20/index.md#sec-annotations))
      - Annotations may be specified as lists of key-value pairs
  - Globalname (Section [Annotations controlling naming](../chapter-18/18-03-control-plane-names.md#sec-name-annotations))
      - The reserved `globalname` annotation has been removed.
  - Table `size` property (Section [Size](../chapter-14/14-02-tables.md#sec-size-table-property))
      - Meaning of optional `size` property for tables has been defined.
  - Invalid headers (Section [Operations on headers](../chapter-08/08-17-operations-on-headers.md#sec-ops-on-hdrs))
      - Clarified semantics of operations on invalid headers.
  - Calling restrictions (Section [Restrictions on compile time and run time calls](../appendix-F/index.md#sec-calling-restrictions))
      - Added restrictions on kinds of values that may be passed as
        arguments to calls.
  - Bitwise operator precedence (Section [P4 grammar](../appendix-G/index.md#sec-grammar))
      - Modified precedence conventions so that bitwise operators `&`
        `|` and `^` have higher precedence than relation operators `<`
        `>` `<=` `>=`.
  - Computed bitwidths (Section [Base types](../chapter-07/07-01-base-types.md#sec-base-types))
      - Added support for specifying widths using expressions in `bit`
        and `varbit` types.
