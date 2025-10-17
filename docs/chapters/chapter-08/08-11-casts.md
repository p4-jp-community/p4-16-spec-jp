P4 provides a limited set of casts between types. A cast is written `(t)
e`, where `t` is a type and `e` is an expression. Casts are only
permitted on base types and derived types introduced by `typedef`,
`type`, and `enum`. While this design is arguably more onerous for
programmers, it has several benefits:

  - It makes user intent unambiguous.
  - It makes the costs associated with converting numeric values
    explicit. Implementing certain casts involves sign extensions, and
    thus can require significant computational resources on some
    targets.
  - It reduces the number of cases that have to be considered in the P4
    specification. Some targets may not support all casts.

### Explicit casts

The following casts are legal in P4:

  - `bit<1>` ↔ `bool`: converts the value `0` to `false`, the value `1`
    to `true`, and vice versa.
  - `int` → `bool`: only if the `int` value is `0` (converted to
    `false`) or `1` (converted to `true`)
  - `int<W>` → `bit<W>`: preserves all bits unchanged and reinterprets
    negative values as positive values
  - `bit<W>` → `int<W>`: preserves all bits unchanged and reinterprets
    values whose most-significant bit is `1` as negative values
  - `bit<W>` → `bit<X>`: truncates the value if `W > X`, and otherwise
    (i.e., if `W <= X`) pads the value with zero bits.
  - `int<W>` → `int<X>`: truncates the value if `W > X`, and otherwise
    (i.e., if `W < X`) extends it with the sign bit.
  - `bit<W>` → `int`: preserves the value unchanged but converts it to
    an unlimited-precision integer; the result is always non-negative
  - `int<W>` → `int`: preserves the value unchanged but converts it to
    an unlimited-precision integer; the result may be negative
  - `int` → `bit<W>`: converts the integer value into a sufficiently
    large two’s complement bit string to avoid information loss, and
    then truncates the result to `W` bits. The compiler should emit a
    warning on overflow or on conversion of negative value.
  - `int` → `int<W>`: converts the integer value into a
    sufficiently-large two’s complement bit string to avoid information
    loss, and then truncates the result to `W` bits. The compiler should
    emit a warning on overflow.
  - casts between two types that are introduced by `typedef` and are
    equivalent to one of the above combinations.
  - casts between a typedef and the original type.
  - casts between a type introduced by `type` and the original type.
  - casts between an `enum` with an explicit type and its underlying
    type
  - casts of a key-value list to a struct type or a header type (see
    Section \[\#sec-structure-expressions\])
  - casts of a tuple expression to a header stack type
  - casts of an invalid expression `{#}` to a header or a header union
    type
  - casts where the destination type is the same as the source type if
    the destination type appears in this list (this excludes e.g.,
    parsers or externs).

### Implicit casts { sec-implicit-casts }

To keep the language simple and avoid introducing hidden costs, P4 only
implicitly casts from `int` to fixed-width types and from enums with an
underlying type to the underlying type. In particular, applying a binary
operation (except shifts and concatenation) to an expression of type
`int` and an expression with a fixed-width type will implicitly cast the
`int` expression to the type of the other expression. For enums with an
underlying type, it can be implicitly cast to its underlying type
whenever appropriate, including but not limited to in shifts,
concatenation, bit slicing indexes, header stack indexes as well as
other unary and binary operations.

  - For example, given the following declarations,  
    Begin P4Example enum bit\<8\> E { a = 5 }

bit\<8\> x; bit\<16\> y; int\<8\> z; \~ End P4Example

the compiler will add implicit casts as follows:

  - `x + 1` becomes `x + (bit<8>)1`
  - `z < 0` becomes `z < (int<8>)0`
  - `x | 0xFFF` becomes `x | (bit<8>)0xFFF`; overflow warning
  - `x + E.a` becomes `x + (bit<8>)E.a`
  - `x &&& 8` becomes `x &&& (bit<8>)8`
  - `x << 256` remains unchanged; `256` not implicitly cast to `8w0` in
    a shift; overflow warning
  - `16w11 << E.a` becomes `16w11 << (bit<8>)E.a`
  - `x[E.a:0]` becomes `x[(bit<8>)E.a:0]`
  - `E.a ++ 8w0` becomes `(bit<8>)E.a ++ 8w0`

The compiler also adds implicit casts when types of different
expressions need to `match`; for example, as described in Section
\[\#sec-select\], since select labels are compared against the selected
expression, the compiler will insert implicit casts for the select
labels when they have `int` types. Similarly, when assigning a
structure-valued expression to a structure or header, the compiler will
add implicit casts for `int` fields.

### Illegal arithmetic expressions

Many arithmetic expressions that would be allowed in other languages are
illegal in P4. To illustrate, consider the following declarations:

\~ Begin P4Example bit\<8\> x; bit\<16\> y; int\<8\> z; \~ End P4Example

The table below shows several expressions which are illegal because they
do not obey the P4 typing rules. For each expression we provide several
ways that the expression could be manually rewritten into a legal
expression. Note that for some expression there are several legal
alternatives, which may produce different results\! The compiler cannot
guess the user intent, so P4 requires the user to disambiguate.

|—–|—–|—–| | Expression | Why it is illegal | Alternatives |
+—————-:+:———————+:—————–+ | `x + y` | Different widths |
`(bit<16>)x + y`| | | | `x + (bit<8>)y` | | `x + z` | Different
signedness | `(int<8>)x + z` | | | | `x + (bit<8>)z` | | `(int<8>)y` |
Cannot change both sign and width | `(int<8>)(bit<8>)y` | | | |
`(int<8>)(int<16>)y` | | `y + z` | Different widths and signs |
`(int<8>)(bit<8>)y + z` | | | | `y + (bit<16>)(bit<8>)z` | | | |
`(bit<8>)y + (bit<8>)z` | | | | `(int<16>)y + (int<16>)z` | | `x << z` |
RHS of shift cannot be signed | `x << (bit<8>)z` | | `x < z` | Different
signs | `x < (bit<8>)z` | | | | `(int<8>)x < z` | | `1 << x` | Either
LHS should have a fixed width (bit shift), | `32w1 << x` | | | Or RHS
must be compile-time known (int shift) | None | | `~1` | Bitwise
operation on int | `~32w1` | | `5 & -3` | Bitwise operation on int |
`32w5 & -3` | |—–|—–|—–|
