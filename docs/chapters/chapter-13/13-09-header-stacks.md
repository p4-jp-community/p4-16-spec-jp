A header stack has two properties, `next` and `last`, which can be used
in parsing. Consider the following declaration, which defines a stack
for representing the headers of a packet with at most ten MPLS headers:

```p4
header Mpls_h {
    bit<20> label;
    bit<3>  tc;
    bit     bos;
    bit<8>  ttl;
}
Mpls_h[10] mpls;
```

The expression `mpls.next` represents an l-value of type `Mpls_h` that
references an element in the `mpls` stack. Initially, `mpls.next` refers
to the first element of stack. It is automatically advanced on each
successful call to `extract`. The `mpls.last` property refers to the
element immediately preceding `next` if such an element exists.
Attempting to access `mpls.next` element when the stack’s `nextIndex`
counter is greater than or equal to `size` causes a transition to
`reject` and sets the error to `error.StackOutOfBounds`. Likewise,
attempting to access `mpls.last` when the `nextIndex` counter is equal
to `0` causes a transition to `reject` and sets the error to
`error.StackOutOfBounds`.

The following example shows a simplified parser for MPLS processing:

```p4
struct Pkthdr {
Ethernet_h ethernet;
Mpls_h[3] mpls;
// other headers omitted
}

parser P(packet_in b, out Pkthdr p) {
state start {
    b.extract(p.ethernet);
    transition select(p.ethernet.etherType) {
       0x8847: parse_mpls;
       0x0800: parse_ipv4;
    }
}
state parse_mpls {
     b.extract(p.mpls.next);
     transition select(p.mpls.last.bos) {
        0: parse_mpls; // This creates a loop
        1: parse_ipv4;
     }
}
// other states omitted
}
```
