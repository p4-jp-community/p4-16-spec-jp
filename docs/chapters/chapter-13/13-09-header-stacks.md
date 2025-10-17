A header stack has two properties, `next` and `last`, which can be used
in parsing. Consider the following declaration, which defines a stack
for representing the headers of a packet with at most ten MPLS headers:

\~ Begin P4Example header Mpls\_h { bit\<20\> label; bit\<3\> tc; bit
bos; bit\<8\> ttl; } Mpls\_h\[10\] mpls; \~ End P4Example

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

  - The following example shows a simplified parser for MPLS
    processing:  
    Begin P4Example struct Pkthdr { Ethernet\_h ethernet; Mpls\_h\[3\]
    mpls; // other headers omitted }

parser P(packet\_in b, out Pkthdr p) { state start {
b.extract(p.ethernet); transition select(p.ethernet.etherType) { 0x8847:
parse\_mpls; 0x0800: parse\_ipv4; } } state parse\_mpls {
b.extract(p.mpls.next); transition select(p.mpls.last.bos) { 0:
parse\_mpls; // This creates a loop 1: parse\_ipv4; } } // other states
omitted } \~ End P4Example
