<a id="sec-expr-hu"></a>
A variable declared with a union type is initially invalid. For example:

```p4
header H1 {
  bit<8> f;
}
header H2 {
  bit<16> g;
}
header_union U {
  H1 h1;
  H2 h2;
}

U u; // u invalid
```

This also implies that each of the headers `h1` through `hn` contained
in a header union are also initially invalid. Unlike headers, a union
cannot be initialized. However, the validity of a header union can be
updated by assigning a valid header to one of its elements:

```p4
U u;
H1 my_h1 = { 8w0 }; // my_h1 is valid
u.h1 = my_h1;       // u and u.h1 are both valid
```

We can also assign a tuple to an element of a header union,

```p4
U u;
u.h2 = { 16w1 };     // u and u.h2 are both valid
```

or set their validity bits directly.

```p4
U u;
u.h1.setValid();     // u and u.h1 are both valid
H1 my_h1 = u.h1;     // my_h1 is now valid, but contains an undefined value
```

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

```p4
u.hi = e;
```

has the following meaning:

  - if `e` is valid, then it is equivalent to:

```p4
  u.hi.setValid();
  u.hi = e;
```

  - if `e` is invalid, then it is equivalent to:

```p4
  u.hi.setInvalid();
```

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

```p4
header_union IP {
    IPv4 ipv4;
    IPv6 ipv6;
}

struct Parsed_packet {
   Ethernet ethernet;
   IP ip;
}

parser top(packet_in b, out Parsed_packet p) {
    state start {
       b.extract(p.ethernet);
       transition select(p.ethernet.etherType) {
           16w0x0800 : parse_ipv4;
           16w0x86DD : parse_ipv6;
       }
   }
   state parse_ipv4 {
       b.extract(p.ip.ipv4);
       transition accept;
   }
   state parse_ipv6 {
       b.extract(p.ip.ipv6);
       transition accept;
   }
}
```

As another example, we can also use unions to parse (selected) TCP
options:

```p4
header Tcp_option_end_h {
    bit<8> kind;
}
header Tcp_option_nop_h {
    bit<8> kind;
}
header Tcp_option_ss_h {
    bit<8>  kind;
    bit<32> maxSegmentSize;
}
header Tcp_option_s_h {
    bit<8>  kind;
    bit<24> scale;
}
header Tcp_option_sack_h {
    bit<8>         kind;
    bit<8>         length;
    varbit<256>    sack;
}
header_union Tcp_option_h {
    Tcp_option_end_h  end;
    Tcp_option_nop_h  nop;
    Tcp_option_ss_h   ss;
    Tcp_option_s_h    s;
    Tcp_option_sack_h sack;
}

typedef Tcp_option_h[10] Tcp_option_stack;

struct Tcp_option_sack_top {
    bit<8> kind;
    bit<8> length;
}

parser Tcp_option_parser(packet_in b, out Tcp_option_stack vec) {
    state start {
        transition select(b.lookahead<bit<8>>()) {
            8w0x0 : parse_tcp_option_end;
            8w0x1 : parse_tcp_option_nop;
            8w0x2 : parse_tcp_option_ss;
            8w0x3 : parse_tcp_option_s;
            8w0x5 : parse_tcp_option_sack;
        }
    }
    state parse_tcp_option_end {
        b.extract(vec.next.end);
        transition accept;
    }
    state parse_tcp_option_nop {
         b.extract(vec.next.nop);
         transition start;
    }
    state parse_tcp_option_ss {
         b.extract(vec.next.ss);
         transition start;
    }
    state parse_tcp_option_s {
         b.extract(vec.next.s);
         transition start;
    }
    state parse_tcp_option_sack {
         bit<8> n = b.lookahead<Tcp_option_sack_top>().length;
         // n is the total length of the TCP SACK option in bytes.
         // The length of the varbit field 'sack' of the
         // Tcp_option_sack_h header is thus n-2 bytes.
         b.extract(vec.next.sack, (bit<32>) (8 * n - 16));
         transition start;
    }
}
```

Similar to headers, the size of a header union is a local compile-time
known value (Section [Compile-time size determination](../chapter-09/index.md#sec-minsizeinbits)).

The expression `{#}` represents an invalid header union of some type,
but it can be any header or header union type. A P4 compiler may require
an explicit cast on this expression in cases where it cannot determine
the particular header or header union type from the context.

```p4
header_union HU { ... }
HU h = (HU){#};  // invalid header union; same as an uninitialized header union.
```

Two header unions can be compared for equality (`==`) or inequality
(`!=`) if they have the same type. The unions are equal if and only if
all their corresponding fields are equal (i.e., either all fields are
invalid in both unions, or in both unions the same field is valid, and
the values of the valid fields are equal as headers).
