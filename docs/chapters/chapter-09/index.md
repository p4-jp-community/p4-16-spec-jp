# 9. Compile-time size determination


The method calls `minSizeInBits`, `minSizeInBytes`, `maxSizeInBits`, and
`maxSizeInBytes` can be applied to certain expressions. These method
calls return the minimum (or maximum) size in bits (or bytes) required
to store the expression. Thus, the result type of these methods has type
`int`. Except in certain situations involving type variables, discussed
below, these method calls produce local compile-time known values;
otherwise they produce compile-time known values. None of these methods
evaluate the expression that is the receiver of the method call, so it
may be invalid (e.g., an out-of-bounds header stack access).

The method `minSizeInBytes` returns the result of `minSizeInBits`
rounded up to the next whole number of bytes. In other words, for any
expression `e`, `e.minSizeInBytes()` is equal to `(e.minSizeInBits()
+ 7) >> 3`.

The method `maxSizeInBytes` always returns the result of `maxSizeInBits`
rounded up to the next whole number of bytes. In other words, for any
expression `e`, `e.maxSizeInBytes()` is equal to `(e.maxSizeInBits()
+ 7) >> 3`.

The definition of `e.minSizeInBits()` and `e.maxSizeInBits()` is given
recursively on the type of `e` as described in the following table:

|—–|—————|—————| |Type | minSizeInBits | maxSizeInBits |
+—–+:————-:+:————-:+ | `bit<N>` | N | N |
+—–+—————+—————+ | `int<N>` | N | N |
+—–+—————+—————+ | `bool` | 1 | 1 |
+—–+—————+—————+ | `enum bit<N>` | N | N |
+—–+—————+—————+ | `enum int<N>` | N | N |
+—–+—————+—————+ | `tuple` | foreach
field(tuple) sum of | foreach field(tuple) sum of | | |
`field.minSizeInBits()` | `field.maxSizeInBits()` | +—–+—————+—————+ |
`varbit<N>` | 0 | N | +—–+—————+—————+ | `struct` | foreach
field(struct) sum of | foreach field(struct) sum of | | |
`field.minSizeInBits()` | `field.maxSizeInBits()` | +—–+—————+—————+ |
`header` | foreach field(header) sum of | foreach field(header) sum of |
| | `field.minSizeInBits()` | `field.maxSizeInBits()` | +—–+—————+—————+
| `H[N]` | `N * H.minSizeInBits()` | `N * H.maxSizeInBits()` |
+—–+—————+—————+ | `header_union` | max(foreach
field(header\_union) | max(foreach field(header\_union) | | |
`field.minSizeInBits()`) | `field.maxSizeInBits()`) | |—–|—————|—————|

The methods can also be applied to type name expressions `e`:

  - if the type of `e` is a type introduced by `type`, the result is the
    application of the method to the underlying type
  - if `e` is the name of a type (e.g., introduced by a `typedef`
    declaration), where the type given a name is one of the above, then
    the result is obtained by applying the method to the underlying
    type.

These methods are defined for:

  - all serializable types
  - for a type that does not contain `varbit` fields, both methods
    return the same result
  - for a type that does contain `varbit` fields, `maxSizeInBits` is the
    worst-case size of the serialized representation of the data and
    `minSizeInBits` is the “best” case.

Every other case is undefined and will produce a compile-time error. In
particular, cases involving type variables produce a compile-time error.

