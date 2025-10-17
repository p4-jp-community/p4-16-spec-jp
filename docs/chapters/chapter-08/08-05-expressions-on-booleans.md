The following operations are provided on Boolean expressions:

  - “And”, denoted by `&&`
  - “Or”, denoted by `||`
  - Negation, denoted by `!`
  - Equality and inequality tests, denoted by `==` and `!=`
    respectively.

The precedence of these operators is similar to C and uses
short-circuited evaluation where relevant.

Additionally, the size of a boolean can be determined at compile-time
(Section \[\#sec-minsizeinbits\]).

P4 does not implicitly cast from bit-strings to Booleans or vice versa.
As a consequence, a program that is valid in a language like C such as,

\~ Begin P4Example if (x) /\* body omitted \*/ \~ End P4Example

  - (where x has an integer type) must instead be written in P4 as:  
    Begin P4Example if (x \!= 0) /\* body omitted \*/
    
    End P4Example

See the discussion on arbitrary-precision types and implicit casts in
Section \[\#sec-implicit-casts\] for details on how the `0` in this
expression is evaluated.

### Conditional operator

A conditional expression of the form `e1 ? e2 : e3` behaves the same as
in languages like C. As described above, the expression `e1` is
evaluated first, and second either `e2` or `e3` is evaluated depending
on the result.

The first sub-expression `e1` must have Boolean type and the second and
third sub-expressions must have the same type, which cannot both be
arbitrary-precision integers unless the condition itself can be
evaluated at compilation time. This restriction is designed to ensure
that the width of the result of the conditional expression can be
inferred statically at compile time.
