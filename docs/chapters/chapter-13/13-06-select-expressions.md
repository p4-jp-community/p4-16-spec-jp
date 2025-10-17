A `select` expression evaluates to a state. The syntax for a `select`
expression is as follows:

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:selectExpression\]

\[INCLUDE=grammar.mdk:selectCaseList\]

  - \[INCLUDE=grammar.mdk:selectCase\]  
    End P4Grammar

Each expression in the `expressionList` must have a type of `bit<W>`,
`int<W>`, `bool`, `enum`, serializable `enum`, or a `tuple` type with
fields of one of the above types.

In a `select` expression, if the `expressionList` has type `tuple<T>`,
then each `keysetExpression` must have type `set<tuple<T>>`. In
particular, if a set is specified as a range or mask expression, the
endpoints of the range and mask expression are implicitly cast to type
`T` using the standard rules for casts.

  - In terms of the `ParserModel`, the meaning of a select expression:  
    Begin P4Example select(e) { ks\[0\]: s\[0\]; ks\[1\]: s\[1\]; /\*
    more labels omitted \*/ ks\[n-2\]: s\[n-1\]; \_ : sd; // ks\[n-1\]
    is default }
    
    End P4Example

  - is defined in pseudo-code as:  
    Begin P4Pseudo key = eval(e); for (int i=0; i \< n; i++) { keyset =
    eval(ks\[i\]); if (keyset.contains(key)) return s\[i\]; }
    verify(false, error.NoMatch);
    
    End P4Pseudo

Some targets may require that all keyset expressions in a select
expression be compile-time known values. Keysets are evaluated in order,
from top to bottom as implied by the pseudo-code above; the first keyset
that includes the value in the `select` argument provides the result
state. If no label matches, the execution triggers a runtime error with
the standard error code `error.NoMatch`.

Note that this implies that all cases after a `default` or `_` label are
unreachable; the compiler should emit a warning if it detects
unreachable cases. This constitutes an important difference between
`select` expressions and the `switch` statements found in many
programming languages since the keysets of a `select` expression may
“overlap”.

The typical way to use a `select` expression is to compare the value of
a recently-extracted header field against a set of values, as in the
following example:

\~ Begin P4Example header IPv4\_h { bit\<8\> protocol; /\* more fields
omitted */ } struct P { IPv4\_h ipv4; /* more fields omitted \*/ } P
headers; select (headers.ipv4.protocol) { 8w6 : parse\_tcp; 8w17 :
parse\_udp; \_ : accept; } \~ End P4Example

  - For example, to detect TCP reserved ports (\< 1024) one could
    write:  
    Begin P4Example select (p.tcp.port) { 16w0 &&& 16w0xFC00:
    well\_known\_port; \_: other\_port; }
    
    End P4Example

The expression `16w0 &&& 16w0xFC00` describes the set of 16-bit values
whose most significant six bits are zero.

Some targets may support parser value sets; see Section
\[\#sec-value-set\]. Given a type `T` for the type parameter of the
value set, the type of the value set is `set<T>`. The type of the value
set must match to the type of all other `keysetExpression`s in the same
`select` expression. If there is a mismatch, the compiler must raise an
error. The type of the values in the set must be either bit\<\>,
int\<\>, tuple, struct, or serializable `enum`.

For example, to allow the control plane API to specify TCP reserved
ports at runtime, one could write:

\~ Begin P4Example struct vsk\_t { @match(ternary) bit\<16\> port; }
value\_set<vsk_t>(4) pvs; select (p.tcp.port) { pvs:
runtime\_defined\_port; \_: other\_port; } \~ End P4Example

The above example allows the runtime API to populate up to 4 different
`keysetExpression`s in the `value_set`. If the `value_set` takes a
struct as type parameter, the runtime API can use the struct field names
to name the objects in the value set. The match type of the struct field
is specified with the `@match` annotation. If the `@match` annotation is
not specified on a struct field, by default it is assumed to be
`@match(exact)`. A single non-exact field must be placed into a struct
by itself, with the desired `@match` annotation.
