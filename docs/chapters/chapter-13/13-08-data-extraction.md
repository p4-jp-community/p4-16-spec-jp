The P4 core library contains the following declaration of a built-in
`extern` type called `packet_in` that represents incoming network
packets. The `packet_in` extern is special: it cannot be instantiated by
the user explicitly. Instead, the architecture supplies a separate
instance for each `packet_in` argument to a `parser` instantiation.

\~ Begin P4Example extern packet\_in { void extract<T>(out T
headerLvalue); void extract<T>(out T variableSizeHeader, in bit\<32\>
varFieldSizeBits); T lookahead<T>(); bit\<32\> length(); // This method
may be unavailable in some architectures void advance(bit\<32\> bits); }
\~ End P4Example

To extract data from a packet represented by an argument `b` with type
`packet_in`, a parser invokes the `extract` methods of `b`. There are
two variants of the `extract` method: a one-argument variant for
extracting fixed-size headers, and a two-argument variant for extracting
variable-sized headers. Because these operations can cause runtime
verification failures (see below), these methods can only be executed
within parsers.

When extracting data into a bit-string or integer, the first packet bit
is extracted to the most significant bit of the integer.

Some targets may perform cut-through packet processing, i.e., they may
start processing a packet before its length is known (i.e., before all
bytes have been received). On such a target calls to the
`packet_in.length()` method cannot be implemented. Attempts to call this
method should be flagged as errors (either at compilation time by the
compiler back-end, or when attempting to load the compiled P4 program
onto a target that does not support this method).

In terms of the `ParserModel`, the semantics of `packet_in` can be
captured using the following abstract model of packets:

\~ Begin P4Pseudo packet\_in { unsigned nextBitIndex; byte\[\] data;
unsigned lengthInBits; void initialize(byte\[\] data) { this.data =
data; this.nextBitIndex = 0; this.lengthInBits = data.sizeInBytes \* 8;
} bit\<32\> length() { return this.lengthInBits / 8; } } \~ End P4Pseudo

### Fixed-width extraction

The single-argument `extract` method handles fixed-width headers, and is
declared in P4 as follows:

\~ Begin P4Example void extract<T>(out T headerLeftValue); \~ End
P4Example

The expression `headerLeftValue` must evaluate to an l-value (see
Section \[\#sec-lvalues\]) of type `header` with a fixed width. If this
method executes successfully, on completion the `headerLvalue` is filled
with data from the packet and its validity bit is set to `true`. This
method may fail in various ways—e.g., if there are not enough bits left
in the packet to fill the specified header.

  - For example, the following program fragment extracts an Ethernet
    header:  
    Begin P4Example struct Result { Ethernet\_h ethernet; /\* more
    fields omitted \*/ } parser P(packet\_in b, out Result r) { state
    start { b.extract(r.ethernet); } }
    
    End P4Example

In terms of the `ParserModel`, the semantics of the single-argument
`extract` is given in terms of the following pseudo-code method, using
data from the `packet` class defined above. We use the special `valid$`
identifier to indicate the hidden valid bit of a header, `isNext$` to
indicate that the l-value was obtained using `next`, and `nextIndex$` to
indicate the corresponding header or header union stack properties.

\~ Begin P4Pseudo void packet\_in.extract<T>(out T headerLValue) {
bitsToExtract = sizeofInBits(headerLValue); lastBitNeeded =
this.nextBitIndex + bitsToExtract; ParserModel.verify(this.lengthInBits
\>= lastBitNeeded, error.PacketTooShort); headerLValue =
this.data.extractBits(this.nextBitIndex, bitsToExtract);
headerLValue.valid$ = true; if headerLValue.isNext$ {
verify(headerLValue.nextIndex$ \< headerLValue.size,
error.StackOutOfBounds); headerLValue.nextIndex$ =
headerLValue.nextIndex$ + 1; } this.nextBitIndex += bitsToExtract; } \~
End P4Pseudo

### Variable-width extraction

  - The two-argument `extract` handles variable-width headers, and is
    declared in P4 as follows:  
    Begin P4Example void extract<T>(out T headerLvalue, in bit\<32\>
    variableFieldSize);
    
    End P4Example

The expression `headerLvalue` must be an l-value representing a header
that contains *exactly one* `varbit` field. The expression
`variableFieldSize` must evaluate to a `bit<32>` value that indicates
the number of bits to be extracted into the unique `varbit` field of the
header (i.e., this size is not the size of the complete header, just the
`varbit` field).

In terms of the `ParserModel`, the semantics of the two-argument
`extract` is captured by the following pseudo-code:

\~ Begin P4Pseudo void packet\_in.extract<T>(out T headerLvalue, in
bit\<32\> variableFieldSize) { // targets are allowed to include the
following line, but need not // verify(variableFieldSize\[2:0\] == 0,
error.ParserInvalidArgument); bitsToExtract =
sizeOfFixedPart(headerLvalue) + variableFieldSize; lastBitNeeded =
this.nextBitIndex + bitsToExtract; ParserModel.verify(this.lengthInBits
\>= lastBitNeeded, error.PacketTooShort);
ParserModel.verify(bitsToExtract \<= headerLvalue.maxSize,
error.HeaderTooShort); headerLvalue =
this.data.extractBits(this.nextBitIndex, bitsToExtract);
headerLvalue.varbitField.size = variableFieldSize; headerLvalue.valid$ =
true; if headerLValue.isNext$ { verify(headerLValue.nextIndex$ \<
headerLValue.size, error.StackOutOfBounds); headerLValue.nextIndex$ =
headerLValue.nextIndex$ + 1; } this.nextBitIndex += bitsToExtract; } \~
End P4Pseudo

The following example shows one way to parse IPv4 options—by splitting
the IPv4 header into two separate headers:

\~ Begin P4Example // IPv4 header without options header
IPv4\_no\_options\_h { bit\<4\> version; bit\<4\> ihl; bit\<8\>
diffserv; bit\<16\> totalLen; bit\<16\> identification; bit\<3\> flags;
bit\<13\> fragOffset; bit\<8\> ttl; bit\<8\> protocol; bit\<16\>
hdrChecksum; bit\<32\> srcAddr; bit\<32\> dstAddr; } header
IPv4\_options\_h { varbit\<320\> options; }

struct Parsed\_headers { // Some fields omitted IPv4\_no\_options\_h
ipv4; IPv4\_options\_h ipv4options; }

error { InvalidIPv4Header }

parser Top(packet\_in b, out Parsed\_headers headers) { // Some states
omitted

state parse\_ipv4 { b.extract(headers.ipv4); verify(headers.ipv4.ihl \>=
5, error.InvalidIPv4Header); transition select (headers.ipv4.ihl) { 5:
dispatch\_on\_protocol; \_: parse\_ipv4\_options; } }

state parse\_ipv4\_options { // use information in the ipv4 header to
compute the number of bits to extract b.extract(headers.ipv4options,
(bit\<32\>)(((bit\<16\>)headers.ipv4.ihl - 5) \* 32)); transition
dispatch\_on\_protocol; } } \~ End P4Example

### Lookahead

The `lookahead` method provided by the `packet_in` packet abstraction
evaluates to a set of bits from the input packet without advancing the
`nextBitIndex` pointer. Similar to `extract`, it will transition to
`reject` and set the error if there are not enough bits in the packet.
When `lookahead` returns a value that contains headers (e.g., a header
type, or a struct containing headers), the headers values in the
returned result are always valid (otherwise `lookahead` must have
transitioned to the `reject` state).

  - The `lookahead` method can be invoked as follows:  
    Begin P4Example b.lookahead<T>()
    
    End P4Example

where `T` must be a type with fixed width. In case of success the result
of the evaluation of `lookahead` returns a value of type `T`.

In terms of the `ParserModel`, the semantics of `lookahead` is given by
the following pseudocode:

\~ Begin P4Pseudo T packet\_in.lookahead<T>() { bitsToExtract =
sizeof(T); lastBitNeeded = this.nextBitIndex + bitsToExtract;
ParserModel.verify(this.lengthInBits \>= lastBitNeeded,
error.PacketTooShort); T tmp = this.data.extractBits(this.nextBitIndex,
bitsToExtract); return tmp; } \~ End P4Pseudo

  - The TCP options example from Section \[\#sec-expr-hu\] also
    illustrates how `lookahead` can be used:  
    Begin P4Example state start { transition
    select(b.lookahead\<bit\<8\>\>()) { 0: parse\_tcp\_option\_end; 1:
    parse\_tcp\_option\_nop; 2: parse\_tcp\_option\_ss; 3:
    parse\_tcp\_option\_s; 5: parse\_tcp\_option\_sack; } }

// Some states omitted

state parse\_tcp\_option\_sack { bit\<8\> n =
b.lookahead<Tcp_option_sack_top>().length; b.extract(vec.next.sack,
(bit\<32\>) (8 \* n - 16)); transition start; } \~ End P4Example

### Skipping bits

P4 provides two ways to skip over bits in an input packet without
assigning them to a header:

One way is to `extract` to the underscore identifier, explicitly
specifying the type of the data:

\~ Begin P4Example b.extract<T>(\_) \~ End P4Example

Another way is to use the `advance` method of the packet when the number
of bits to skip is known.

In terms of the `ParserModel`, the meaning of `advance` is given in
pseudocode as follows:

\~ Begin P4Pseudo void packet\_in.advance(bit\<32\> bits) { // targets
are allowed to include the following line, but need not //
verify(bits\[2:0\] == 0, error.ParserInvalidArgument); lastBitNeeded =
this.nextBitIndex + bits; ParserModel.verify(this.lengthInBits \>=
lastBitNeeded, error.PacketTooShort); this.nextBitIndex += bits; } \~
End P4Pseudo
