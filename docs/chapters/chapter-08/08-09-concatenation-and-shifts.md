### Concatenation

Concatenation is applied to two bit-strings (signed or unsigned). It is
denoted by the infix operator `++`. The result is a bit-string whose
length is the sum of the lengths of the inputs where the most
significant bits are taken from the left operand; the sign of the result
is taken from the left operand.

### A note about shifts

The left operand of shifts can be any one out of unsigned bit-strings,
signed bit-strings, and arbitrary-precision integers, and the right
operand of shifts must be either an expression of type `bit<S>` or a
compile-time known value that is a non-negative integer. The result has
the same type as the left operand.

Shifts on signed and unsigned bit-strings deserve a special discussion
for the following reasons:

  - Right shift behaves differently for signed and unsigned bit-strings:
    right shift for signed bit-strings is an arithmetic shift, and for
    unsigned bit-strings is a logical shift.
  - Shifting with a negative amount does not have a clear semantics: the
    P4 type system makes it illegal to shift with a negative amount.
  - Unlike C, shifting by an amount larger than or equal to the number
    of bits has a well-defined result.
  - Finally, depending on the capabilities of the target, shifting may
    require doing work which is exponential in the number of bits of the
    right-hand-side operand.

<!-- end list -->

  - Consider the following examples:  
    Begin P4Example bit\<8\> x; bit\<16\> y; bit\<16\> z = y \<\< x;
    bit\<16\> w = y \<\< 1024;
    
    End P4Example

As mentioned above, P4 gives a precise meaning shifting with an amount
larger than the size of the shifted value, unlike C.

P4 targets may impose additional restrictions on shift operations such
as forbidding shifts by non-constant expressions, or by expressions
whose width exceeds a certain bound. For example, a target may forbid
shifting an 8-bit value by a non-constant value whose width is greater
than 3 bits.
