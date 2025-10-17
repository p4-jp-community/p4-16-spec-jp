  - Symbolic names declared by an enum belong to the namespace
    introduced by the enum declaration rather than the top-level
    namespace.  
    Begin P4Example enum X { v1, v2, v3 } X.v1 // reference to v1 v1 //
    error - v1 is not in the top-level namespace
    
    End P4Example

Similar to errors, `enum` expressions without a specified underlying
type only support equality (`==`) and inequality (`!=`) comparisons.
Expressions whose type is an `enum` without a specified underlying type
cannot be cast to or from any other type.

  - An `enum` may also specify an underlying type, such as the
    following:  
    Begin P4Example enum bit\<8\> E { e1 = 0, e2 = 1, e3 = 2 }
    
    End P4Example

More than one symbolic value in an `enum` may map to the same
fixed-width integer value.

\~ Begin P4Example enum bit\<8\> NonUnique { b1 = 0, b2 = 1, // Note,
both b2 and b3 map to the same value. b3 = 1, b4 = 2 } \~ End P4Example

An `enum` with an underlying type also supports explicit casts to and
from the underlying type. For instance, the following code:

\~ Begin P4Example bit\<8\> x; E a = E.e2; E b;

x = (bit\<8\>) a; // sets x to 1 b = (E) x; // sets b to E.e2 \~ End
P4Example

… casts `a` (which was initialized with `E.e2`) to a `bit<8>`, using the
specified fixed-width unsigned integer representation for `E.e2`,
i.e. `1`. The variable `b` is then set to the symbolic value `E.e2`,
which corresponds to the fixed-width unsigned integer value `1`.

Because it is always safe to cast from an `enum` to its underlying
fixed-width integer type, implicit casting from an `enum` to its
fixed-width (signed or unsigned) integer type is also supported (see
Section \[\#sec-implicit-casts\]):

\~ Begin P4Example bit\<8\> x = E.e2; // sets x to 1 (E.e2 is
automatically casted to bit\<8\>)

E a = E.e2 bit\<8\> y = a \<\< 3; // sets y to 8 (a is automatically
casted to bit\<8\> and then shifted) \~ End P4Example

  - Implicit casting from an underlying fixed-width type to an enum is
    *not* supported.  
    Begin P4Example enum bit\<8\> E1 { e1 = 0, e2 = 1, e3 = 2 }

enum bit\<8\> E2 { e1 = 10, e2 = 11, e3 = 12 } E1 a = E1.e1; E2 b =
E2.e2;

a = b; // Error: b is automatically casted to bit\<8\>, // but bit\<8\>
cannot be automatically casted to E1

a = (E1) b; // OK

a = E1.e1 + 1; // Error: E.e1 is automatically casted to bit\<8\>, //
and the right-hand expression has // the type bit\<8\>, which cannot be
casted to E automatically.

a = (E1)(E1.e1 + 1); // Final explicit casting makes the assignment
legal

a = E1.e1 + E1.e2; // Error: both arguments to the addition are
automatically // casted to bit\<8\>. Thus the addition itself is legal,
but // the assignment is not

  - a = (E1)(E2.e1 + E2.e2); // Final explicit casting makes the
    assignment legal  
    End P4Example

  - A reasonable compiler might generate a warning in cases that involve
    multiple automatic casts.  
    Begin P4Example E1 a = E1.e1; E2 b = E2.e2; bit\<8\> c;

if (a \> b) { // Potential warning: two automatic and different casts to
bit\<8\>. // code omitted }

  - c = a + b; // Legal, but a warning would be reasonable  
    End P4Example

Note that while it is always safe to cast from an `enum` to its
fixed-width unsigned integer type, and vice versa, there may be cases
where casting a fixed-width unsigned integer value to its related `enum`
type produces an unnamed value.

\~ Begin P4Example bit\<8\> x = 5; E e = (E) x; // sets e to an unnamed
value \~ End P4Example

sets `e` to an unnamed value, since there is no symbol corresponding to
the fixed-width unsigned integer value `5`.

For example, in the following code, the `else` clause of the `if/else
if/else` block can be reached even though the matches on `x` are
complete with respect to the symbols defined in `MyPartialEnum_t`:

\~ Begin P4Example enum bit\<2\> MyPartialEnum\_t { VALUE\_A = 2w0,
VALUE\_B = 2w1, VALUE\_C = 2w2 }

bit\<2\> y = \< some value \>; MyPartialEnum\_t x = (MyPartialEnum\_t)y;

if (x == MyPartialEnum\_t.VALUE\_A) { // some code here } else if (x ==
MyPartialEnum\_t.VALUE\_B) { // some code here } else if (x ==
MyPartialEnum\_t.VALUE\_C) { // some code here } else { // A P4 compiler
MUST ASSUME that this branch can be executed // some code here } \~ End
P4Example

Additionally, if an enumeration is used as a field of a header, we would
expect the `transition select` to match `default` when the parsed
integer value does not match one of the symbolic values of `EtherType`
in the following example:

\~ Begin P4Example enum bit\<16\> EtherType { VLAN = 0x8100, IPV4 =
0x0800, IPV6 = 0x86dd }

header ethernet { // Some fields omitted EtherType etherType; }

parser my\_parser(/\* parameters omitted \*/) { state parse\_ethernet {
packet.extract(hdr.ethernet); transition select(hdr.ethernet.etherType)
{ EtherType.VLAN : parse\_vlan; EtherType.IPV4 : parse\_ipv4;
EtherType.IPV6: parse\_ipv6; default: reject; } } \~ End P4Example

Any variable with an `enum` type that contains an unnamed value (whether
as the result of a cast to an `enum` with an underlying type, parse into
the field of an `enum` with an underlying type, or simply the
declaration of any `enum` without a specified initial value) will not be
equal to any of the values defined for that type. Such an unnamed value
should still lead to predictable behavior in cases where any legal value
would match, e.g. it should match in any of these situations:

  - If used in a `select` expression, it should match `default` or `_`
    in a key set expression.
  - If used as a key with `match_kind` `ternary` in a table, it should
    match a table entry where the field has all bit positions “don’t
    care”.
  - If used as a key with `match_kind` `lpm` in a table, it should match
    a table entry where the field has a prefix length of 0.

Note that if an `enum` value lacking an underlying type appears in the
control-plane API, the compiler must select a suitable serialization
data type and representation. For `enum` values with an underlying type
and representations, the compiler should use the specified underlying
type as the serialization data type and representation.

Additionally, the size of a serializable enum can be determined at
compile-time. However, the size of an enum without an underlying type
cannot be determined at compile-time (Section \[\#sec-minsizeinbits\]).
