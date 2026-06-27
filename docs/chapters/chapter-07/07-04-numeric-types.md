<a id="sec-numeric-values"></a>
Many P4 operations are restrained to expressions that evaluate to
numeric values. Such expressions must have one of the following numeric
types:

  - `int` - an arbitrary-precision integer (section
    [Arbitrary-precision integers](07-01-base-types.md#sec-arbitrary-precision-integers))
  - `bit<W>` - a `W`-bit unsigned integer where `W >= 0` (section
    [Unsigned integers (bit-strings)](07-01-base-types.md#sec-unsigned-integers))
  - `int<W>` - a `W`-bit signed integer where `W >= 1` (section
    [Signed Integers](07-01-base-types.md#sec-signed-integers))
  - a serializable `enum` with an underlying type that is `bit<W>` or
    `int<W>` (section [Enumeration types](07-02-derived-types.md#sec-enum-types)).
