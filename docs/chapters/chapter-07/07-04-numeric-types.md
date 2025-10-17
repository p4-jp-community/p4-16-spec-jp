Many P4 operations are restrained to expressions that evaluate to
numeric values. Such expressions must have one of the following numeric
types:

  - `int` - an arbitrary-precision integer (section
    \[\#sec-arbitrary-precision-integers\])
  - `bit<W>` - a `W`-bit unsigned integer where `W >= 0` (section
    \[\#sec-unsigned-integers\])
  - `int<W>` - a `W`-bit signed integer where `W >= 1` (section
    \[\#sec-signed-integers\])
  - a serializable `enum` with an underlying type that is `bit<W>` or
    `int<W>` (section \[\#sec-enum-types\]).
