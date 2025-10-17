The type `int` denotes arbitrary-precision integers. In P4, all
expressions of type `int` must be compile-time known values. The type
`int` supports the following operations:

  - Negation, denoted by unary `-`

  - Unary plus, denoted by `+`. This operation behaves like a no-op.

  - Addition, denoted by `+`.

  - Subtraction, denoted by `-`.

  - Comparison for equality and inequality, denoted by `==` and `!=`
    respectively. These operations produce a Boolean result.

  - Numeric comparisons `<,<=,>`, and `>=`. These operations produce a
    Boolean result.

  - Multiplication, denoted by `*`.

  - Truncating integer division between positive values, denoted by `/`.

  - Modulo between positive values, denoted by `%`.

  - Arithmetic shift left and right denoted by `<<` and `>>`. These
    operations produce an `int` result. The right operand must be either
    an unsigned value of type `bit<S>` or a compile-time known value
    that is a non-negative integer. The expression `a << b` is equal to
    \(a \times 2^b\) while `a >> b` is equal to
    \(\lfloor{a / 2^b}\rfloor\).

  - Bit slices, denoted by `[H:L]`, where `H` and `L` must be
    expressions that evaluate to non-negative, local compile-time known
    values, and `H >= L` must be true. The types of `H` and `L` (which
    do not need to be identical) must be one of the following:
    
      - `int` - an arbitrary-precision integer (section
        \[\#sec-arbitrary-precision-integers\])
      - `bit<W>` - a `W`-bit unsigned integer where `W >= 0` (section
        \[\#sec-unsigned-integers\])
      - `int<W>` - a `W`-bit signed integer where `W >= 1` (section
        \[\#sec-signed-integers\])
      - a serializable `enum` with an underlying type that is `bit<W>`
        or `int<W>` (section \[\#sec-enum-types\]).
    
    The result is an unsigned bit-string of width `H - L + 1`, including
    the bits numbered from `L` (which becomes the least significant bit
    of the result) to `H` (the most significant bit of the result) from
    the source operand. The conditions `0 <= L <= H` are checked
    statically. If necessary, the source integer value that is sliced is
    automatically extended to have a width with `H` bits. Note that both
    endpoints of the extraction are inclusive. The bounds are required
    to be values that are known at compile time so that the width of the
    result can be computed at compile time. A slice of a negative or
    positive value is always a positive value.

Each operand that participates in any of these operation must have type
`int` (except shifts). Binary operations cannot be used to combine
values of type `int` with values of a fixed-width type (except shifts).
However, the compiler automatically inserts casts from `int` to
fixed-width types in certain situations—see Section \[\#sec-casts\].

All computations on `int` values are carried out without loss of
information. For example, multiplying two 1024-bit values may produce a
2048-bit value (note that concrete representation of `int` values is not
specified). `int` values can be cast to `bit<w>` and `int<w>` values.
Casting an `int` value to a fixed-width type will preserve the
least-significant bits. If truncation causes significant bits to be
lost, the compiler should emit a warning.

Note: bitwise-operations (`|`,`&`,`^`,`~`) are not defined on
expressions of type `int`. In addition, it is illegal to apply division
and modulo to negative values.

Note: saturating arithmetic is not supported for arbitrary-precision
integers.
