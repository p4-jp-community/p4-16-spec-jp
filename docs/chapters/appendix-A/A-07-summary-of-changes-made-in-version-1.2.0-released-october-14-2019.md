  - Added `table.apply().miss` (Section [Match-action unit invocation](../chapter-14/14-02-tables.md#sec-invoke-mau)).
  - Added `string` type (Section [Strings](../chapter-07/07-01-base-types.md#sec-string-type)).
  - Added implicit casts from enum values (Section
    [Operations on `enum` types](../chapter-08/08-03-operations-on-enum-types.md#sec-enum-exprs)).
  - Allow 1-bit signed values
  - Define the type of bit slices from signed and unsigned values to be
    unsigned.
  - Constrain `default` label position for `switch` statements.
  - Allow empty tuples.
  - Added `@deprecated` annotation.
  - Relaxed the structure of annotation bodies.
  - Removed the `@pkginfo` annotation, which is now defined by the
    P4Runtime specification.
  - Added `int` type (Section [Arbitrary-precision integers](../chapter-07/07-01-base-types.md#sec-arbitrary-precision-integers)).
  - Added error `ParserInvalidArgument` (Sections
    [Variable-width extraction](../chapter-13/13-08-data-extraction.md#sec-packet-extract-two), [Skipping bits](../chapter-13/13-08-data-extraction.md#sec-skip-bits)).
  - Clarified the significance of order of entries in `const entries`
    (Section [Entries](../chapter-14/14-02-tables.md#sec-entries)).
  - Added methods to calculate header size (Section
    [Operations on headers](../chapter-08/08-17-operations-on-headers.md#sec-ops-on-hdrs)).
