This section discusses all operations that can be performed on
expressions of type `bit<W>` for some width `W`, also known as
bit-strings.

Arithmetic operations “wrap around”, similar to C operations on unsigned
values (i.e., representing a large value on W bits will only keep the
least-significant W bits of the value). In particular, P4 does not have
arithmetic exceptions—the result of an arithmetic operation is defined
for all possible inputs.

P4 target architectures may optionally support saturating arithmetic.
All saturating operations are limited to a fixed range between a minimum
and maximum value. Saturating arithmetic has advantages, in particular
when used as counters. The result of a saturating counter max-ing out is
much closer to the real result than a counter that overflows and wraps
around. According to Wikipedia [Saturating
Arithmetic](https://en.wikipedia.org/wiki/Saturation_arithmetic)
saturating arithmetic is as numerically close to the true answer as
possible; for 8-bit binary signed arithmetic, when the correct answer is
130, it is considerably less surprising to get an answer of 127 from
saturating arithmetic than to get an answer of −126 from modular
arithmetic. Likewise, for 8-bit binary unsigned arithmetic, when the
correct answer is 258, it is less surprising to get an answer of 255
from saturating arithmetic than to get an answer of 2 from modular
arithmetic. At this time, P4 defines saturating operations only for
addition and subtraction. For an unsigned integer with bit-width of `W`,
the minimum value is `0` and the maximum value is `2^W-1`. The
precedence of saturating addition and subtraction operations is the same
as for modular arithmetic addition and subtraction.

All binary operations except shifts and concatenation require both
operands to have the same exact type and width; supplying operands with
different widths produces an error at compile time. No implicit casts
are inserted by the compiler to equalize the widths. There are no other
binary operations that accept signed and unsigned values simultaneously
besides shifts and concatenation. The following operations are provided
on bit-string expressions:

  - Test for equality between bit-strings of the same width, designated
    by `==`. The result is a Boolean value.
  - Test for inequality between bit-strings of the same width,
    designated by `!=`. The result is a Boolean value.
  - Unsigned comparisons `<,>,<=,>=`. Both operands must have the same
    width and the result is a Boolean value.

Each of the following operations produces a bit-string result when
applied to bit-strings of the same width:

  - Negation, denoted by unary `-`. The result is computed by
    subtracting the value from 2<sup>W</sup>. The result is unsigned and
    has the same width as the input. The semantics is the same as the C
    negation of unsigned numbers.
  - Unary plus, denoted by `+`. This operation behaves like a no-op.
  - Addition, denoted by `+`. This operation is associative. The result
    is computed by truncating the result of the addition to the width of
    the output (similar to C).
  - Subtraction, denoted by `-`. The result is unsigned, and has the
    same type as the operands. It is computed by adding the negation of
    the second operand (similar to C).
  - Multiplication, denoted by `*`. The result has the same width as the
    operands and is computed by truncating the result to the output’s
    width. P4 architectures may impose additional restrictions — e.g.,
    they may only allow multiplication by a non-negative integer power
    of two.
  - Bitwise “and” between two bit-strings of the same width, denoted by
    `&`.
  - Bitwise “or” between two bit-strings of the same width, denoted by
    `|`.
  - Bitwise “complement” of a single bit-string, denoted by `~`.
  - Bitwise “xor” of two bit-strings of the same width, denoted by `^`.
  - Saturating addition, denoted by `|+|`.
  - Saturating subtraction, denoted by `|-|`.

Bit-strings also support the following operations:

  - Logical shift left and right by a non-negative integer value (which
    need not be a compile-time known value), denoted by `<<` and `>>`
    respectively. In a shift, the left operand is unsigned, and right
    operand must be either an expression of type `bit<S>` or a
    non-negative integer value that is known at compile time. The result
    has the same type as the left operand. Shifting by an amount greater
    than or equal to the width of the input produces a result where all
    bits are zero.
  - Extraction of a set of contiguous bits, also known as a slice,
    denoted by `[H:L]`, where `H` and `L` must be expressions that
    evaluate to non-negative, local compile-time known values, and `H >=
    L`. The types of `H` and `L` (which do not need to be identical)
    must be numeric (Section \[\#sec-numeric-values\]). The result is a
    bit-string of width `H - L + 1`, including the bits numbered from
    `L` (which becomes the least significant bit of the result) to `H`
    (the most significant bit of the result) from the source operand.
    The conditions `0 <= L <= H < W` are checked statically (where `W`
    is the length of the source bit-string). Note that both endpoints of
    the extraction are inclusive. The bounds are required to be local
    compile-time known values so that the width of the result can be
    computed at compile time. Slices are also l-values, which means that
    P4 supports assigning to a slice: `e[H:L] = x`. The effect of this
    statement is to set bits `H` through `L` (inclusive of both) of `e`
    to the bit-pattern represented by `x`, and leaves all other bits of
    `e` unchanged. A slice of an unsigned integer is an unsigned
    integer.
  - Concatenation of bit-strings and/or fixed-width signed integers,
    denoted by `++`. The two operands must be either `bit<W>` or
    `int<W>`, and they can be of different signedness and width. The
    result has the same signedness as the left operand and the width
    equal to the sum of the two operands’ width. In concatenation, the
    left operand is placed as the most significant bits.

Additionally, the size of a bit-string can be determined at compile-time
(Section \[\#sec-minsizeinbits\]).
