This section discusses all operations that can be performed on
expressions of type `int<W>` for some `W`. Recall that the `int<W>`
denotes signed `W`-bit integers, represented using two’s complement.

In general, P4 arithmetic operations do not detect “underflow” or
“overflow”: operations simply “wrap around”, similar to C operations
on unsigned values. Hence, attempting to represent large values using
`W` bits will only keep the least-significant `W` bits of the value.

P4 supports saturating arithmetic (addition and subtraction) for signed
integers. Targets may optionally reject programs using saturating
arithmetic. For a signed integer with bit-width of `W`, the minimum
value is `-2^(W-1)` and the maximum value is `2^(W-1)-1`.

P4 also does not support arithmetic exceptions. The runtime result of an
arithmetic operation is defined for all combinations of input arguments.

All binary operations except shifts and concatenation require both
operands to have the same exact type (signedness) and width and
supplying operands with different widths or signedness produces a
compile-time error. No implicit casts are inserted by the compiler to
equalize the types. Except for shifts and concatenation, P4 does not
have any binary operations that operate simultaneously on signed and
unsigned values.

Note that bitwise operations on signed integers are well-defined, since
the representation is mandated to be two’s complement.

The `int<W>` datatype supports the following operations; all binary
operations require both operands to have the exact same type. The result
always has the same width as the left operand.

  - Negation, denoted by unary `-`.
  - Unary plus, denoted by `+`. This operation behaves like a no-op.
  - Addition, denoted by `+`.
  - Subtraction, denoted by `-`.
  - Comparison for equality and inequality, denoted `==` and `!=`
    respectively. These operations produce a Boolean result.
  - Numeric comparisons, denoted by `<,<=,>,` and `>=`. These operations
    produce a Boolean result.
  - Multiplication, denoted by `*`. Result has the same width as the
    operands. P4 architectures may impose additional restrictions—e.g.,
    they may only allow multiplication by a power of two.
  - Bitwise “and” between two bit-strings of the same width, denoted by
    `&`.
  - Bitwise “or” between two bit-strings of the same width, denoted by
    `|`.
  - Bitwise “complement” of a single bit-string, denoted by `~`.
  - Bitwise “xor” of two bit-strings of the same width, denoted by `^`.
  - Saturating addition, denoted by `|+|`.
  - Saturating subtraction, denoted by `|-|`.

The `int<W>` datatype also support the following operations:

  - Arithmetic shift left and right denoted by `<<` and `>>`. The left
    operand is signed and the right operand must be either an unsigned
    number of type `bit<S>` or a compile-time known value that is a
    non-negative integer. The result has the same type as the left
    operand. Shifting left produces the exact same bit pattern as a
    shift left of an unsigned value. Shift left can thus overflow, when
    it leads to a change of the sign bit. Shifting by an amount greater
    than the width of the input produces a “correct” result:
      - all result bits are zero when shifting left
      - all result bits are zero when shifting a non-negative value
        right
      - all result bits are one when shifting a negative value right
  - Extraction of a set of contiguous bits, also known as a slice,
    denoted by `[H:L]`, where `H` and `L` must be expressions that
    evaluate to non-negative, local compile-time known values, and `H >=
    L` must be true. The types of `H` and `L` (which do not need to be
    identical) must be numeric (Section \[\#sec-numeric-values\]). The
    result is an unsigned bit-string of width `H - L + 1`, including the
    bits numbered from `L` (which becomes the least significant bit of
    the result) to `H` (the most significant bit of the result) from the
    source operand. The conditions `0 <= L <= H < W` are checked
    statically (where `W` is the length of the source bit-string). Note
    that both endpoints of the extraction are inclusive. The bounds are
    required to be values that are known at compile time so that the
    width of the result can be computed at compile time. Slices are also
    l-values, which means that P4 supports assigning to a slice: `e[H:L]
    = x`. The effect of this statement is to set bits `H` through `L` of
    `e` to the bit-pattern represented by `x`, and leaves all other bits
    of `e` unchanged. A slice of a signed integer is treated as an
    unsigned integer.
  - Concatenation of bit-strings and/or fixed-width signed integers,
    denoted by `++`. The two operands must be either `bit<W>` or
    `int<W>`, and they can be of different signedness and width. The
    result has the same signedness as the left operand and the width
    equal to the sum of the two operands’ width. In concatenation, the
    left operand is placed as the most significant bits.

Additionally, the size of a fixed-width signed integer can be determined
at compile-time (Section \[\#sec-minsizeinbits\]).
