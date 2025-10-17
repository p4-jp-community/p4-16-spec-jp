Some P4 expressions denote sets of values (`set<T>`, for some type `T`;
see Section \[\#sec-set-types\]). These expressions can appear only in a
few contexts—parsers and table entries. For example, the `select`
expression (Section \[\#sec-select\]) has the following structure:

\~ Begin P4Example select (expression) { set1: state1; set2: state2; //
More labels omitted } \~ End P4Example

Here the expressions `set1, set2`, etc. evaluate to sets of values and
the `select` expression tests whether `expression` belongs to the sets
used as labels.

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:keysetExpression\]

\[INCLUDE=grammar.mdk:tupleKeysetExpression\]

\[INCLUDE=grammar.mdk:simpleExpressionList\]

\[INCLUDE=grammar.mdk:reducedSimpleKeysetExpression\]

  - \[INCLUDE=grammar.mdk:simpleKeysetExpression\]  
    End P4Grammar

The mask (`&&&`) and range (`..`) operators have the same precedence;
the just above the `?:` operator.

### Singleton sets

In a set context, expressions denote singleton sets. For example, in the
following program fragment,

\~ Begin P4Example select (hdr.ipv4.version) { 4: continue; } \~ End
P4Example

The label `4` denotes the singleton set containing the `int` value `4`.

### The universal set

In a set context, the expressions `default` or `_` denote the universal
set, which contains all possible values of a given type:

\~ Begin P4Example select (hdr.ipv4.version) { 4: continue; \_: reject;
} \~ End P4Example

### Masks

The infix operator `&&&` takes two arguments of the same numeric type
(Section \[\#sec-numeric-values\]), and creates a value of the same
type. The right value is used as a “mask”, where each bit set to `0` in
the mask indicates a “don’t care” bit. More formally, the set denoted by
`a &&& b` is defined as follows:

\~ Begin P4Example a &&& b = { c where a & b = c & b } \~ End P4Example

  - For example:  
    Begin P4Example 8w0x0A &&& 8w0x0F
    
    End P4Example

denotes a set that contains 16 different `bit<8>` values, whose
bit-pattern is `XXXX1010`, where the value of an `X` can be any bit.
Note that there may be multiple ways to express a keyset using a mask
operator—e.g., `8w0xFA &&& 8w0x0F` denotes the same keyset as in the
example above.

Similar to other binary operations, the mask operator allows the
compiler to automatically insert casts to unify the argument types in
certain situations (section \[\#sec-implicit-casts\]).

P4 architectures may impose additional restrictions on the expressions
on the left and right-hand side of a mask operator: for example, they
may require that either or both sub-expressions be compile-time known
values.

### Ranges

The infix operator `..` takes two arguments of the same numeric type `T`
(Section \[\#sec-numeric-values\]), and creates a value of the type
`set<T>`. The set contains all values numerically between the first and
the second, inclusively. For example:

\~ Begin P4Example 4s5 .. 4s8 \~ End P4Example

denotes a set of 4 consecutive `int<4>` values `4s5, 4s6, 4s7`, and
`4s8`.

Similar to other binary operations, the range operator allows the
compiler to automatically insert casts to unify the argument types in
certain situations (section \[\#sec-implicit-casts\]).

A range where the second value is smaller than the first one represents
an empty set.

### Products

  - Multiple sets can be combined using Cartesian product:  
    Begin P4Example select(hdr.ipv4.ihl, hdr.ipv4.protocol) { (4w0x5,
    8w0x1): parse\_icmp; (4w0x5, 8w0x6): parse\_tcp; (4w0x5, 8w0x11):
    parse\_udp; (*, *): accept; }
    
    End P4Example

The type of a product of sets is a set of tuples.
