A variable declared with a union type is initially invalid. For example:

\~Begin P4Example header H1 { bit\<8\> f; } header H2 { bit\<16\> g; }
header\_union U { H1 h1; H2 h2; }

U u; // u invalid \~End P4Example

This also implies that each of the headers `h1` through `hn` contained
in a header union are also initially invalid. Unlike headers, a union
cannot be initialized. However, the validity of a header union can be
updated by assigning a valid header to one of its elements:

\~Begin P4Example U u; H1 my\_h1 = { 8w0 }; // my\_h1 is valid u.h1 =
my\_h1; // u and u.h1 are both valid \~End P4Example

We can also assign a tuple to an element of a header union,

\~Begin P4Example U u; u.h2 = { 16w1 }; // u and u.h2 are both valid
\~End P4Example

or set their validity bits directly.

\~Begin P4Example U u; u.h1.setValid(); // u and u.h1 are both valid H1
my\_h1 = u.h1; // my\_h1 is now valid, but contains an undefined value
\~End P4Example

Note that reading an uninitialized header produces an undefined value,
even if the header is itself valid.

If `u` is an expression whose type is a header union `U` with fields
ranged over by `hi`, then the expression `u.hi` evaluates to a header,
and thus it can be used wherever a header expression is allowed. If `u`
is a left-value, then `u.hi` is also a left-value.

The following operations:

  - `u.hi.setValid():` sets the valid bit for header `hi` to `true` and
    sets the valid bit for all other headers to `false`, which implies
    that it is unspecified what value reading any member header of `u`
    will return.

  - `u.hi.setInvalid()`: if the valid bit for any member header of `u`
    is `true` then sets it to `false`, which implies that it is
    unspecified what value reading any member header of `u` will return.

The assignment to a union field:

\~Begin P4Example u.hi = e; \~End P4Example

has the following meaning:

  - if `e` is valid, then it is equivalent to:

\~Begin P4Example u.hi.setValid(); u.hi = e; \~End P4Example

  - if `e` is invalid, then it is equivalent to:

\~Begin P4Example u.hi.setInvalid(); \~End P4Example

Assignments between variables of the same type of header union are
permitted. The assignment `u1 = u2` copies the full state of header
union `u2` to `u1`. If `u2` is valid, then there is some header `u2.hi`
that is valid. The assignment behaves the same as `u1.hi = u2.hi`. If
`u2` is not valid, then `u1` becomes invalid (i.e. if any header of `u1`
was valid, it becomes invalid).

`u.isValid()` returns true if any member of the header union `u` is
valid, otherwise it returns false. `setValid()` and `setInvalid()`
methods are not defined for header unions.

Supplying an expression with a union type to `emit` simply emits the
single header that is valid, if any.

The following example shows how we can use header unions to represent
IPv4 and IPv6 headers uniformly:

\~Begin P4Example header\_union IP { IPv4 ipv4; IPv6 ipv6; }

struct Parsed\_packet { Ethernet ethernet; IP ip; }

parser top(packet\_in b, out Parsed\_packet p) { state start {
b.extract(p.ethernet); transition select(p.ethernet.etherType) {
16w0x0800 : parse\_ipv4; 16w0x86DD : parse\_ipv6; } } state parse\_ipv4
{ b.extract(p.ip.ipv4); transition accept; } state parse\_ipv6 {
b.extract(p.ip.ipv6); transition accept; } } \~End P4Example

As another example, we can also use unions to parse (selected) TCP
options: \~Begin P4Example header Tcp\_option\_end\_h { bit\<8\> kind; }
header Tcp\_option\_nop\_h { bit\<8\> kind; } header Tcp\_option\_ss\_h
{ bit\<8\> kind; bit\<32\> maxSegmentSize; } header Tcp\_option\_s\_h {
bit\<8\> kind; bit\<24\> scale; } header Tcp\_option\_sack\_h { bit\<8\>
kind; bit\<8\> length; varbit\<256\> sack; } header\_union
Tcp\_option\_h { Tcp\_option\_end\_h end; Tcp\_option\_nop\_h nop;
Tcp\_option\_ss\_h ss; Tcp\_option\_s\_h s; Tcp\_option\_sack\_h sack; }

typedef Tcp\_option\_h\[10\] Tcp\_option\_stack;

struct Tcp\_option\_sack\_top { bit\<8\> kind; bit\<8\> length; }

parser Tcp\_option\_parser(packet\_in b, out Tcp\_option\_stack vec) {
state start { transition select(b.lookahead\<bit\<8\>\>()) { 8w0x0 :
parse\_tcp\_option\_end; 8w0x1 : parse\_tcp\_option\_nop; 8w0x2 :
parse\_tcp\_option\_ss; 8w0x3 : parse\_tcp\_option\_s; 8w0x5 :
parse\_tcp\_option\_sack; } } state parse\_tcp\_option\_end {
b.extract(vec.next.end); transition accept; } state
parse\_tcp\_option\_nop { b.extract(vec.next.nop); transition start; }
state parse\_tcp\_option\_ss { b.extract(vec.next.ss); transition start;
} state parse\_tcp\_option\_s { b.extract(vec.next.s); transition start;
} state parse\_tcp\_option\_sack { bit\<8\> n =
b.lookahead<Tcp_option_sack_top>().length; // n is the total length of
the TCP SACK option in bytes. // The length of the varbit field ‘sack’
of the // Tcp\_option\_sack\_h header is thus n-2 bytes.
b.extract(vec.next.sack, (bit\<32\>) (8 \* n - 16)); transition start; }
} \~End P4Example

Similar to headers, the size of a header union is a local compile-time
known value (Section \[\#sec-minsizeinbits\]).

The expression `{#}` represents an invalid header union of some type,
but it can be any header or header union type. A P4 compiler may require
an explicit cast on this expression in cases where it cannot determine
the particular header or header union type from the context.

\~ Begin P4Example header\_union HU { … } HU h = (HU){\#}; // invalid
header union; same as an uninitialized header union. \~ End P4Example

Two header unions can be compared for equality (`==`) or inequality
(`!=`) if they have the same type. The unions are equal if and only if
all their corresponding fields are equal (i.e., either all fields are
invalid in both unions, or in both unions the same field is valid, and
the values of the valid fields are equal as headers).
