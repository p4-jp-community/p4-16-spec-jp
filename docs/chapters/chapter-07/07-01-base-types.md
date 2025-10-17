P4 supports the following built-in base types:

  - The `void` type, which has no values and can be used only in a few
    restricted circumstances.
  - The `error` type, which is used to convey errors in a
    target-independent, compiler-managed way.
  - The `string` type, which can be used with compile-time known values
    of type string.
  - The `match_kind` type, which is used for describing the
    implementation of table lookups,
  - `bool`, which represents Boolean values
  - `int`, which represents arbitrary-sized integer values
  - Bit-strings of fixed width, denoted by `bit<>`
  - Fixed-width signed integers represented using two’s complement
    `int<>`
  - Bit-strings of dynamically-computed width with a fixed maximum width
    `varbit<>`

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:baseType\] \~ End P4Grammar

### The void type

The void type is written `void`. It contains no values. It is not
included in the production rule `baseType` as it can only appear in few
restricted places in P4 programs.

### The error type

The error type contains opaque distinct values that can be used to
signal errors. It is written as `error`. New elements of the error type
are defined with the syntax:

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:errorDeclaration\] \~ End
P4Grammar

All elements of the `error` type are inserted into the `error`
namespace, irrespective of the place where an error is defined. `error`
is similar to an enumeration (`enum`) type in other languages. A program
can contain multiple `error` declarations, which the compiler will merge
together. It is an error to declare the same identifier multiple times.
Expressions of type `error` are described in Section
\[\#sec-error-exprs\].

For example, the following declaration creates two elements of the
`error` type (these errors are declared in the P4 core library):

\~ Begin P4Example error { ParseError, PacketTooShort } \~ End P4Example

The underlying representation of errors is target-dependent.

### The match kind type

The `match_kind` type is very similar to the `error` type and is used to
declare a set of distinct names that may be used in a table’s key
property (described in Section \[\#sec-table-props\]). All identifiers
are inserted into the top-level namespace. It is an error to declare the
same `match_kind` identifier multiple times.

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:matchKindDeclaration\] \~ End
P4Grammar

  - The P4 core library contains the following match\_kind
    declaration:  
    Begin P4Example match\_kind { exact, ternary, lpm }
    
    End P4Example

Architectures may support additional `match_kind`s. The declaration of
new `match_kind`s can only occur within model description files; P4
programmers cannot declare new match kinds.

Operations on values of type `match_kind` are described in Section
\[\#sec-match-kind-exprs\].

### The Boolean type

The Boolean type `bool` contains just two values, `false` and `true`.
Boolean values are not integers or bit-strings.

### Strings

The type `string` represents strings. There are no operations on string
values; one cannot declare variables with a `string` type. Parameters
with type `string` can be only directionless (see Section
\[\#sec-calling-convention\]). P4 does not support string manipulation
in the dataplane; the `string` type is only allowed for describing
compile-time known values (i.e., string literals, as discussed in
Section \[\#sec-string-literals\]). Even so, the string type is useful,
for example, in giving the type signature for extern functions such as
the following:

\~ Begin P4Example extern void log(string message); \~ End P4Example

As another example, the following annotation indicates that the
specified name should be used for a given table in the generated
control-plane API:

\~ Begin P4Example @name(“acl”) table t1 { /\* body omitted \*/ } \~ End
P4Example

### Integers (signed and unsigned)

P4 supports arbitrary-size integer values. The typing rules for the
integer types are chosen according to the following principles:

  - **Inspired by C**: Typing of integers is modeled after the
    well-defined parts of C, expanded to cope with arbitrary fixed-width
    integers. In particular, the type of the result of an expression
    only depends on the expression operands, and not on how the result
    of the expression is consumed.
  - **No undefined behaviors**: P4 attempts to avoid many of C’s
    behaviors, which include the size of an integer (int), the results
    produced on overflow, and the results produced for some input
    combinations (e.g., shifts with negative amounts, overflows on
    signed numbers, etc.). P4 computations on integer types have no
    undefined behaviors.
  - **Least surprise**: The P4 typing rules are chosen to behave as
    closely as possible to traditional well-behaved C programs.
  - **Forbid rather than surprise**: Rather than provide surprising or
    undefined results (e.g., in C comparisons between signed and
    unsigned integers), we have chosen to forbid expressions with
    ambiguous interpretations. For example, P4 does not allow binary
    operations that combine signed and unsigned integers.

The priority of arithmetic operations is identical to C—e.g.,
multiplication binds tighter than addition.

#### Portability

No P4 target can support all possible types and operations. For example,
the type `bit<23132312>` is legal in P4, but it is highly unlikely to be
supported on any target in practice. Hence, each target can impose
restrictions on the types it can support. Such restrictions may include:

  - The maximum width supported
  - Alignment and padding constraints (e.g., arithmetic may only be
    supported on widths which are an integral number of bytes).
  - Constraints on some operands (e.g., some architectures may only
    support multiplications by small values, or shifts with small
    values).

The documentation supplied with a target should clearly specify
restrictions, and target-specific compilers should provide clear error
messages when such restrictions are encountered. An architecture may
reject a well-typed P4 program and still be conformant to the P4 spec.
However, if an architecture accepts a P4 program as valid, the runtime
program behavior should match this specification.

#### Unsigned integers (bit-strings)

An unsigned integer (which we also call a “bit-string”) has an arbitrary
width, expressed in bits. A bit-string of width `W` is declared as:
`bit<W>`. `W` must be an expression that evaluates to a local
compile-time known value (see Section \[\#sec-compile-time-known\]) that
is a non-negative integer. When using an expression for the size, the
expression must be parenthesized. Bitstrings with width 0 are allowed;
they have no actual bits, and can only have the value 0. See
\[\#sec-uninitialized-values-and-writing-invalid-headers\] for
additional details. Note that `bit<W>` type refers to both cases of
`bit<W>` and `bit<(expression)>` where the width is a compile-time known
value.

\~ Begin P4Example const bit\<32\> x = 10; // 32-bit constant with value
10. const bit\<(x + 2)\> y = 15; // 12-bit constant with value 15. //
expression for width must use () \~ End P4Example

Bits within a bit-string are numbered from `0` to `W-1`. Bit `0` is the
least significant, and bit `W-1` is the most significant.

For example, the type `bit<128>` denotes the type of bit-string values
with 128 bits numbered from 0 to 127, where bit 127 is the most
significant.

The type `bit` is a shorthand for `bit<1>`.

P4 architectures may impose additional constraints on bit types: for
example, they may limit the maximum size, or they may only support some
arithmetic operations on certain sizes (e.g., 16-, 32-, and 64- bit
values).

All operations that can be performed on unsigned integers are described
in Section \[\#sec-bit-ops\].

#### Signed Integers

Signed integers are represented using two’s complement. An integer with
`W` bits is declared as: `int<W>`. `W` must be an expression that
evaluates to a local compile-time known (see Section
\[\#sec-compile-time-known\]) value that is a non-negative integer. Note
that `int<W>` type refers to both cases of `int<W>` and
`int<(expression)>` where the width is a local compile-time known value.

Bits within an integer are numbered from `0` to `W-1`. Bit `0` is the
least significant, and bit `W-1` is the sign bit.

For example, the type `int<64>` describes the type of integers
represented using exactly 64 bits with bits numbered from 0 to 63, where
bit 63 is the most significant (sign) bit.

P4 architectures may impose additional constraints on signed types: for
example, they may limit the maximum size, or they may only support some
arithmetic operations on certain sizes (e.g., 16-, 32-, and 64- bit
values).

All operations that can be performed on signed integers are described in
Section \[\#sec-int-ops\].

A signed integer with width 1 can only have two legal values: 0 and -1.

#### Dynamically-sized bit-strings

Some network protocols use fields whose size is only known at runtime
(e.g., IPv4 options). To support restricted manipulations of such
values, P4 provides a special bit-string type whose size is set at
runtime, called a `varbit`.

The type `varbit<W>` denotes a bit-string with a width of at most `W`
bits, where `W` is a local compile-time known value (see Section
\[\#sec-compile-time-known\]) that is a non-negative integer. For
example, the type `varbit<120>` denotes the type of bit-string values
that may have between 0 and 120 bits. Most operations that are
applicable to fixed-size bit-strings (unsigned numbers) *cannot* be
performed on dynamically sized bit-strings. Note that `varbit<W>` type
refers to both cases of `varbit<W>` and `varbit<(expression)>` where the
width is a compile-time known value.

P4 architectures may impose additional constraints on varbit types: for
example, they may limit the maximum size, or they may require `varbit`
values to always contain an integer number of bytes at runtime.

All operations that can be performed on varbits are described in Section
\[\#sec-varbit-string\].

#### Arbitrary-precision integers

The arbitrary-precision data type describes integers with an unlimited
precision. This type is written as `int`.

This type is reserved for integer literals and expressions that involve
only literals. No P4 runtime value can have an `int` type; at compile
time the compiler will convert all int values that have a runtime
component to fixed-width types, according to the rules described below.

All operations that can be performed on arbitrary-precision integers are
described in Section \[\#sec-varint-ops\]. The following example shows
three constant definitions whose values are arbitrary-precision
integers.

\~ Begin P4Example const int a = 5; const int b = 2 \* a; const int c =
b - a + 3; \~ End P4Example

Parameters with type `int` are not supported for actions. Parameters
with type `int` for other callable entities of a program, e.g. controls,
parsers, or functions, must be directionless, indicating that all calls
must provide a compile-time known value as an argument for such a
parameter. See Section \[\#sec-calling-convention\] for more details on
directionless parameters.

#### Integer literal types

The types of integer literals are as follows:

  - An integer with no type prefix has type `int`.
  - A non-negative integer prefixed with an integer width `W` and the
    character `w` has type `bit<W>`.
  - An integer prefixed with an integer width `W` and the character `s`
    has type `int<W>`.

The table below shows several examples of integer literals and their
types. For additional examples of literals see Section
\[\#sec-literals\].

<table style="width:38%;">
<colgroup>
<col style="width: 13%" />
<col style="width: 23%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: right;"><h2 id="literal">Literal</h2>
<code>10</code> <code>8w10</code> <code>8s10</code> <code>2s3</code> <code>1w10</code> <code>1s1</code> ———</td>
<td><h2 id="interpretation">Interpretation</h2>
Type is <code>int</code>, value is 10 Type is <code>bit&lt;8&gt;</code>, value is 10 Type is <code>int&lt;8&gt;</code>, value is 10 Type is <code>int&lt;2&gt;</code>, value is -1 (last 2 bits), overflow warning Type is <code>bit&lt;1&gt;</code>, value is 0 (last bit), overflow warning Type is <code>int&lt;1&gt;</code>, value is -1, overflow warning ——————–</td>
</tr>
</tbody>
</table>
