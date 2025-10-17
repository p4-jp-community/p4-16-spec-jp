P4 provides a number of type constructors that can be used to derive
additional types including:

  - `enum`
  - `header`
  - header stacks
  - `struct`
  - `header_union`
  - `tuple`
  - type specialization
  - `extern`
  - `parser`
  - `control`
  - `package`

The types `header`, `header_union`, `enum`, `struct`, `extern`,
`parser`, `control`, and `package` can only be used in type
declarations, where they introduce a new name for the type. The type can
subsequently be referred to using this identifier.

Other types cannot be declared, but are synthesized by the compiler
internally to represent the type of certain language constructs. These
types are described in Section \[\#sec-synth-types\]: set types and
function types. For example, the programmer cannot declare a variable
with type “set”, but she can write an expression whose value evaluates
to a `set` type. These types are used during type-checking.

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:typeDeclaration\]

\[INCLUDE=grammar.mdk:derivedTypeDeclaration\]

\[INCLUDE=grammar.mdk:typeRef\]

\[INCLUDE=grammar.mdk:namedType\]

\[INCLUDE=grammar.mdk:prefixedType\]

  - \[INCLUDE=grammar.mdk:typeName\]  
    End P4Grammar

### Enumeration types

  - An enumeration type is defined using the following syntax:  
    Begin P4Grammar \[INCLUDE=grammar.mdk:enumDeclaration\]

\[INCLUDE=grammar.mdk:identifierList\]

\[INCLUDE=grammar.mdk:specifiedIdentifierList\]

  - \[INCLUDE=grammar.mdk:specifiedIdentifier\]  
    End P4Grammar

  - For example, the declaration  
    Begin P4Example enum Suits { Clubs, Diamonds, Hearths, Spades }
    
    End P4Example

introduces a new enumeration type, which contains four elements—e.g.,
`Suits.Clubs`. An `enum` declaration introduces a new identifier in the
current scope for naming the created type along with its distinct
elements. The underlying representation of the `Suits` enum is not
specified, so their “size” in bits is not specified (it is
target-specific).

It is also possible to specify an `enum` with an underlying
representation. These are sometimes called serializable `enum`s, because
headers are allowed to have fields with such `enum` types. This requires
the programmer provide both the fixed-width unsigned (or signed) integer
type and an associated integer value for each symbolic entry in the
enumeration. The symbol `typeRef` in the grammar above must be one of
the following types:

  - an unsigned integer, i.e. `bit<W>` for some local compile-time known
    value `W`.
  - a signed integer, i.e. `int<W>` for some local compile-time known
    value `W`.
  - a type name declared via `typedef`, where the base type of that type
    is either one of the types listed above, or another `typedef` name
    that meets these conditions. For example, the declaration

\~ Begin P4Example enum bit\<16\> EtherType { VLAN = 0x8100, QINQ =
0x9100, MPLS = 0x8847, IPV4 = 0x0800, IPV6 = 0x86dd } \~ End P4Example

introduces a new enumeration type, which contains five elements—e.g.,
`EtherType.IPV4`. This `enum` declaration specifies the fixed-width
unsigned integer representation for each entry in the `enum` and
provides an underlying type: `bit<16>`. This kind of `enum` declaration
can be thought of as declaring a new `bit<16>` type, where variables or
fields of this type are expected to be unsigned 16-bit integer values,
and the mapping of symbolic to numeric values defined by the `enum` are
also defined as a part of this declaration. In this way, an `enum` with
an underlying type can be thought of as being a type derived from the
underlying type carrying equality, assignment, and casts to/from the
underlying type.

Compiler implementations are expected to raise an error if the
fixed-width integer representation for an enumeration entry falls
outside the representation range of the underlying type.

  - For example, the declaration  
    Begin P4Example enum bit\<8\> FailingExample { first = 1, second =
    2, third = 3, unrepresentable = 300 }
    
    End P4Example

would raise an error because `300`, the value associated with
`FailingExample.unrepresentable` cannot be represented as a `bit<8>`
value.

The `initializer` expression must be a compile-time known value.

Annotations, represented by the non-terminal `optAnnotations`, are
described in Section \[\#sec-annotations\].

Operations on `enum` values are described in Section
\[\#sec-enum-exprs\].

### Header types

The declaration of a `header` type is given by the following syntax:

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:headerTypeDeclaration\]

\[INCLUDE=grammar.mdk:structFieldList\]

  - \[INCLUDE=grammar.mdk:structField\]  
    End P4Grammar

where each `typeRef` is restricted to a bit-string type (fixed or
variable), a fixed-width signed integer type, a boolean type, or a
struct that itself contains other struct fields, nested arbitrarily, as
long as all of the “leaf” types are `bit<W>`, `int<W>`, a serializable
`enum`, or a `bool`. If a `bool` is used inside a P4 header, all
implementations encode the `bool` as a one bit long field, with the
value `1` representing `true` and `0` representing `false`. Field names
have to be distinct.

A header declaration introduces a new identifier in the current scope;
the type can be referred to using this identifier. A header is similar
to a `struct` in C, containing all the specified fields. However, in
addition, a header also contains a hidden Boolean “validity” field. When
the “validity” bit is `true` we say that the “header is valid”. When a
local variable with a header type is declared, its “validity” bit is
automatically set to `false`. The “validity” bit can be manipulated by
using the header methods `isValid()`, `setValid()`, and `setInvalid()`,
as described in Section \[\#sec-ops-on-hdrs\].

Note, nesting of headers is not supported. One reason is that it leads
to complications in defining the behavior of arbitrary sequences of
`setValid`, `setInvalid`, and `emit` operations. Consider an example
where header `h1` contains header `h2` as a member, both currently
valid. A program executes `h2.setInvalid()` followed by
`packet.emit(h1)`. Should all fields of `h1` be emitted, but skipping
`h2`? Similarly, should `h1.setInvalid()` invalidate all headers
contained within `h1`, regardless of how deeply they are nested?

  - Header types may be empty:  
    Begin P4Example header Empty\_h { }
    
    End P4Example

Note that an empty header still contains a validity bit.

When a struct is inside of a header, the order of the fields for the
purposes of `extract` and `emit` calls is the order of the fields as
defined in the source code. An example of a header including a struct is
included below.

\~ Begin P4Example struct ipv6\_addr { bit\<32\> Addr0; bit\<32\> Addr1;
bit\<32\> Addr2; bit\<32\> Addr3; }

header ipv6\_t { bit\<4\> version; bit\<8\> trafficClass; bit\<20\>
flowLabel; bit\<16\> payloadLen; bit\<8\> nextHdr; bit\<8\> hopLimit;
ipv6\_addr src; ipv6\_addr dst; } \~ End P4Example

Headers that do not contain any `varbit` field are “fixed size.” Headers
containing `varbit` fields have “variable size.” The size (in bits) of a
fixed-size header is simply the sum of the sizes of all component fields
(without counting the validity bit). There is no padding or alignment of
the header fields. Targets may impose additional constraints on header
types—e.g., restricting headers to sizes that are an integer number of
bytes.

For example, the following declaration describes a typical Ethernet
header:

\~ Begin P4Example header Ethernet\_h { bit\<48\> dstAddr; bit\<48\>
srcAddr; bit\<16\> etherType; } \~ End P4Example

  - The following variable declaration uses the newly introduced type
    `Ethernet_h`:  
    Begin P4Example Ethernet\_h ethernetHeader;
    
    End P4Example

P4’s parser language provides an `extract` method that can be used to
“fill in” the fields of a header from a network packet, as described
in Section \[\#sec-packet-data-extraction\]. The successful execution of
an `extract` operation also sets the validity bit of the extracted
header to `true`.

  - Here is an example of an IPv4 header with variable-sized options:  
    Begin P4Example header IPv4\_h { bit\<4\> version; bit\<4\> ihl;
    bit\<8\> diffserv; bit\<16\> totalLen; bit\<16\> identification;
    bit\<3\> flags; bit\<13\> fragOffset; bit\<8\> ttl; bit\<8\>
    protocol; bit\<16\> hdrChecksum; bit\<32\> srcAddr; bit\<32\>
    dstAddr; varbit\<320\> options; }
    
    End P4Example

As demonstrated by a code example in Section
\[\#sec-packet-extract-two\], another way to support headers that
contain variable-length fields is to define two headers – one fixed
length, one containing a `varbit` field – and extract each part in
separate parsing steps.

Notice that the names `isValid`, `setValid`, `minSizeInBits`, etc. are
all valid header field names.

### Header stacks

A header stack represents an array of headers or header unions. A header
stack type is defined as:

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:headerStackType\] \~ End
P4Grammar

where `typeName` is the name of a header or header union type. For a
header stack `hs[n]`, the term `n` is the maximum defined size, and must
be a local compile-time known value that is a positive integer. Nested
header stacks are not supported. At runtime a stack contains `n` values
with type `typeName`, only some of which may be valid. Expressions on
header stacks are discussed in Section \[\#sec-expr-hs\].

  - For example, the following declarations,  
    Begin P4Example header Mpls\_h { bit\<20\> label; bit\<3\> tc; bit
    bos; bit\<8\> ttl; } Mpls\_h\[10\] mpls;
    
    End P4Example

introduce a header stack called `mpls` containing ten entries, each of
type `Mpls_h`.

Operations on header stacks are described in Section \[\#sec-expr-hs\].

### Header unions

A header union represents an alternative containing at most one of
several different headers. Header unions can be used to represent
“options” in protocols like TCP and IP. They also provide hints to P4
compilers that only one alternative will be present, allowing them to
conserve storage resources.

  - A header union is defined as:  
    Begin P4Grammar \[INCLUDE=grammar.mdk:headerUnionDeclaration\]
    
    End P4Grammar

This declaration introduces a new type with the specified name in the
current scope. Each element of the list of fields used to declare a
header union must be of header type. An empty list of fields is legal.
Field names have to be distinct.

As an example, the type `Ip_h` below represents the union of an IPv4 and
IPv6 headers:

\~ Begin P4Example header\_union IP\_h { IPv4\_h v4; IPv6\_h v6; } \~
End P4Example

A header union is not considered a type with fixed length.

Operation on header unions are described in Section \[\#sec-expr-hu\].

### Struct types

  - P4 `struct` types are defined with the following syntax:  
    Begin P4Grammar \[INCLUDE=grammar.mdk:structTypeDeclaration\]
    
    End P4Grammar

This declaration introduces a new type with the specified name in the
current scope. Field names have to be distinct. An empty struct (with no
fields) is legal. For example, the structure `Parsed_headers` below
contains the headers recognized by a simple parser:

\~ Begin P4Example header Tcp\_h { /\* fields omitted */ } header Udp\_h
{ /* fields omitted \*/ } struct Parsed\_headers { Ethernet\_h ethernet;
Ip\_h ip; Tcp\_h tcp; Udp\_h udp; } \~ End P4Example

### Tuple types

A tuple is similar to a `struct`, in that it holds multiple values. The
type of tuples with n component types `T1`,…,`Tn` is written as

\~ Begin P4Example tuple\<T1,/\* more fields omitted \*/,Tn\> \~ End
P4Example

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:tupleType\] \~ End P4Grammar

Operations that manipulate tuple types are described in Section
\[\#sec-tuple-exprs\].

The type `tuple<>` is a tuple type with no components.

### List types

A list holds zero or more values, where every element must have the same
type. The type of a list where all elements have type `T` is written as

\~ Begin P4Example list<T> \~ End P4Example

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:p4listType\] \~ End P4Grammar

Operations that manipulate list types are described in Section
\[\#sec-list-exprs\].

### Type nesting rules

The table below lists all types that may appear as members of headers,
header unions, structs, tuples, and lists. Note that `int` by itself
(i.e. not as part of an `int<N>` type expression) means an
arbitrary-precision integer, without a width specified.

|——————–|————————————————||||| | | Container kind ||||| |
|———–|————–|—————–|——|————–| | Element type |
header | header\_union | struct or tuple | list | header stack |
+:——————-+:———-+:————-+:—————-+:—–+:————-+ | `bit<W>` |
allowed | error | allowed | allowed | error | | `int<W>` | allowed |
error | allowed | allowed | error | | `varbit<W>` | allowed | error |
allowed | allowed | error | | `int` | error | error | error | allowed |
error | | `void` | error | error | error | error | error | | `string` |
error | error | error | allowed | error | | `error` | error | error |
allowed | allowed | error | | `match_kind` | error | error | error |
allowed | error | | `bool` | allowed | error | allowed | allowed | error
| | enumeration types | allowed\[1\] | error | allowed | allowed | error
| | header types | error | allowed | allowed | allowed | allowed | |
header stacks | error | error | allowed | allowed | error | | header
unions | error | error | allowed | allowed | allowed | | struct types |
allowed\[2\] | error | allowed | allowed | error | | tuple types | error
| error | allowed | allowed | error | | list types | error | error |
error | allowed | error | |——————–|———–|———|———-|———|——-|

Rationale: `int` does not have precise storage requirements, unlike
`bit<>` or `int<>` types. `match_kind` values are not useful to store in
a variable, as they are only used to specify how to match fields in
table search keys, which are all declared at compile time. `void` is not
useful as part of another data structure. Headers must have precisely
defined formats as sequences of bits in order for them to be parsed or
deparsed.

Note the two-argument `extract` method (see Section
\[\#sec-packet-extract-two\]) on packets only supports a single `varbit`
field in a header.

The table below lists all types that may appear as base types in a
`typedef` or `type` declaration.

|——————-|——————–|—————–| | Base type B | `typedef B <name>` | `type B
<name>` | +:——————+:——————-+:—————-+ | `bit<W>` | allowed | allowed | |
`int<W>` | allowed | allowed | | `varbit<W>` | allowed | error | | `int`
| allowed | error | | `void` | error | error | | `string` | allowed |
error | | `error` | allowed | error | | `match_kind` | error | error | |
`bool` | allowed | allowed | | enumeration types | allowed | error | |
header types | allowed | error | | header stacks | allowed | error | |
header unions | allowed | error | | struct types | allowed | error | |
tuple types | allowed | error | | list types | allowed | error | | a
`typedef` name | allowed | allowed\[3\] | | a `type` name | allowed |
allowed | |——————-|——————–|—————–|

Rationale: So far, no clear motivation for allowing `typedef` for `void`
and `match_kind` was presented. Therefore, to be on the safe side this
is disallowed.

### Synthesized data types

For the purposes of type-checking the P4 compiler can synthesize some
type representations which cannot be directly expressed by users. These
are described in this section: set types and function types.

#### Set types

The type `set<T>` describes *sets* of values of some type `T`. Set types
can only appear in restricted contexts in P4 programs. For example, the
range expression `8w5 .. 8w8` describes a set containing the 8-bit
numbers 5, 6, 7, and 8, so its type is `set<bit<8>>;`. This expression
can be used as a label in a `select` expression (see Section
\[\#sec-select\]), matching any value in this range. Set types cannot be
named or declared by P4 programmers, they are only synthesized by the
compiler internally and used for type-checking. Expressions with set
types are described in Section \[\#sec-set-exprs\].

#### Function types

\[\]{tex-cmd: “”} Function types are created by the P4 compiler
internally to represent the types of functions (explicit functions or
extern functions) and methods during type-checking. We also call the
type of a function its signature. Libraries can contain functions and
extern function declarations.

  - For example, consider the following declarations:  
    Begin P4Example extern void random(in bit\<5\> logRange, out
    bit\<32\> value);

bit\<32\> add(in bit\<32\> left, in bit\<32\> right) { return left +
right; } \~ End P4Example

These declarations describe two objects:

  - `random`, which has a function type, representing the following
    information:
      - the result type is `void`
      - the function has two inputs
      - the first formal parameter has direction `in`, type `bit<5>`,
        and name `logRange`
      - the second formal parameter has direction `out`, type `bit<32>`,
        and name `value`
  - `add`, also has a function type, representing the following
    information:
      - the result type is `bit<32>`
      - the function has two inputs
      - both inputs have direction `in` and type `bit<32>`

### Extern types

\[\]{tex-cmd: “”} P4 supports extern object declarations and extern
function declarations using the following syntax.

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:externDeclaration\] \~ End
P4Grammar

#### Extern functions

\[\]{tex-cmd: “”} An extern function declaration describes the name and
type signature of the function, but not its implementation.

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:functionPrototype\] \~ End
P4Grammar

For an example of an `extern` function declaration, see Section
\[\#sec-function-type\].

#### Extern objects

\[\]{tex-cmd: “”} An extern object declaration declares an object and
all methods that can be invoked to perform computations and to alter the
state of the object. Extern object declarations can also optionally
declare constructor methods; these must have the same name as the
enclosing `extern` type, no type parameters, and no return type. Extern
declarations may only appear as allowed by the architecture model and
may be specific to a target.

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:methodPrototypes\]

methodPrototype : optAnnotations functionPrototype ‘;’ | optAnnotations
TYPE\_IDENTIFIER ‘(’ parameterList ‘)’ ‘;’ //constructor |
optAnnotations ABSTRACT functionPrototype “;” ;

\[INCLUDE=grammar.mdk:typeOrVoid\]

\[INCLUDE=grammar.mdk:optTypeParameters\]

\[INCLUDE=grammar.mdk:typeParameters\]

  - \[INCLUDE=grammar.mdk:typeParameterList\]  
    End P4Grammar

For example, the P4 core library introduces two extern objects
`packet_in` and `packet_out` used for manipulating packets (see Sections
\[\#sec-packet-data-extraction\] and \[\#sec-deparse\]). Here is an
example showing how the methods of these objects can be invoked on a
packet:

\~ Begin P4Example extern packet\_out { void emit<T>(in T hdr); }
control d(packet\_out b, in Hdr h) { apply { b.emit(h.ipv4); // write
ipv4 header into output packet } // by calling emit method } \~ End
P4Example

Functions and methods are the only P4 constructs that support
overloading: there can exist multiple methods with the same name in the
same scope. When overloading is used, the compiler must be able to
disambiguate at compile-time which method or function is being called,
either by the number of arguments or by the names of the arguments, when
calls are specifying argument names. Argument type information is not
used in disambiguating calls.

  - Notice that overloading of parsers, controls, or packages is not
    allowed:  
    Begin P4Example parser p(packet\_in p, out bit\<32\> value) { … }

// The following will cause an error about a duplicate declaration
//parser p(packet\_in p, out Headers headers) { // … //} \~ End
P4Example

##### Abstract methods

Typical extern object methods are built-in, and are implemented by the
target architecture. P4 programmers can only call such methods.

However, some types of extern objects may provide methods that can be
implemented by the P4 programmers. Such methods are described with the
`abstract` keyword prior to the method definition. Here is an example:

\~ Begin P4Example extern Balancer { Balancer(); // get the number of
active flows bit\<32\> getFlowCount(); // return port index used for
load-balancing // @param address: IPv4 source address of flow abstract
bit\<4\> on\_new\_flow(in bit\<32\> address); } \~ End P4Example

When such an object is instantiated the user has to supply an
implementation of all the `abstract` methods (see
\[\#sec-instantiating-abstract-methods\]).

### Type specialization

A generic type may be specialized by specifying arguments for its type
variables. In cases where the compiler can infer type arguments type
specialization is not necessary. When a type is specialized all its type
variables must be bound.

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:specializedType\] \~ End
P4Grammar

For example, the following extern declaration describes a generic block
of registers, where the type of the elements stored in each register is
an arbitrary `T`.

\~ Begin P4Example extern Register<T> { Register(bit\<32\> size); T
read(bit\<32\> index); void write(bit\<32\> index, T value); } \~ End
P4Example

The type `T` has to be specified when instantiating a set of registers,
by specializing the Register type:

\~ Begin P4Example Register\<bit\<32\>\>(128) registerBank; \~ End
P4Example

The instantiation of `registerBank` is made using the `Register` type
specialized with the `bit<32>` bound to the `T` type argument.

`struct`, `header`, `header_union` and header stack types can be generic
as well. In order to use such a generic type it must be specialized with
appropriate type arguments. For example

\~ Begin P4Example // generic structure type struct S<T> { T field; bool
valid; }

struct G<T> { S<T> s; }

// specialize S by replacing ‘T’ with ‘bit\<32\>’ const S\<bit\<32\>\> s
= { field = 32w0, valid = false }; // Specialize G by replacing ‘T’ with
‘bit\<32\>’ const G\<bit\<32\>\> g = { s = { field = 0, valid = false }
};

// generic header type header H<T> { T field; }

// Specialize H by replacing ‘T’ with ‘bit\<8\>’ const H\<bit\<8\>\> h =
{ field = 1 }; // Header stack produced from a specialization of a
generic header type H\<bit\<8\>\>\[10\] stack;

// Generic header union header\_union HU<T> { H\<bit\<32\>\> h32;
H\<bit\<8\>\> h8; H<T> ht; }

// Header union with a type obtained by specializing a generic header
union type HU<bit> hu; \~ End P4Example

### Parser and control blocks types

Parsers and control blocks types are similar to function types: they
describe the signature of parsers and control blocks. Such functions
have no return values. Declarations of parsers and control block types
in architectures may be generic (i.e., have type parameters).

The types `parser`, `control`, and `package` cannot be used as types of
arguments for methods, parsers, controls, tables, or actions. They *can*
be used as types for the arguments passed to constructors (see Section
\[\#sec-parameterization\]).

#### Parser type declarations

A parser type declaration describes the signature of a parser. A parser
should have at least one argument of type `packet_in`, representing the
received packet that is processed.

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:parserTypeDeclaration\] \~ End
P4Grammar

For example, the following is a type declaration of a parser type named
`P` that is parameterized on a type variable `H`. That parser receives
as input a `packet_in` value `b` and produces two values:

  - A value with a user-defined type `H`
  - A value with a predefined type `Counters`

\~ Begin P4Example struct Counters { /\* Fields omitted \*/ } parser
P<H>(packet\_in b, out H packetHeaders, out Counters counters); \~ End
P4Example

#### Control type declarations

  - A control type declaration describes the signature of a control
    block.  
    Begin P4Grammar \[INCLUDE=grammar.mdk:controlTypeDeclaration\]
    
    End P4Grammar

Control type declarations are similar to parser type declarations.

### Package types

  - A package type describes the signature of a package.  
    Begin P4Grammar \[INCLUDE=grammar.mdk:packageTypeDeclaration\]
    
    End P4Grammar

All parameters of a package are evaluated at compilation time, and in
consequence they must all be directionless (they cannot be `in`, `out`,
or `inout`). Otherwise package types are very similar to parser type
declarations. Packages can only be instantiated; there are no runtime
behaviors associated with them.

### Don’t care types

A don’t care (underscore, “`_`”) can be used in some circumstances as a
type. It should be only used in a position where one could write a bound
type variable. The underscore can be used to reduce code complexity—when
it is not important what the type variable binds to (during type
unification the don’t care type can unify with any other type). An
example is given Section \[\#sec-arch-desc-example\].
