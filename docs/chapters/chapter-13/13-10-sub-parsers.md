P4 allows parsers to invoke the services of other parsers, similar to
subroutines. To invoke the services of another parser, the sub-parser
must be first instantiated; the services of an instance are invoked by
calling it using its `apply` method.

  - The following example shows a sub-parser invocation:  
    Begin P4Example parser callee(packet\_in packet, out IPv4 ipv4) {
    /\* body omitted \*/ } parser caller(packet\_in packet, out Headers
    h) { callee() subparser; // instance of callee state subroutine {
    subparser.apply(packet, h.ipv4); // invoke sub-parser transition
    accept; // accept if sub-parser ends in accept state } }
    
    End P4Example

The semantics of a sub-parser invocation can be described as follows:

  - The state invoking the sub-parser is split into two half-states at
    the parser invocation statement.
  - The top half includes a transition to the sub-parser `start` state.
  - The sub-parser’s `accept` state is identified with the bottom half
    of the current state
  - The sub-parser’s `reject` state is identified with the reject state
    of the current parser.

\~ Figure { \#fig-subparser; caption: “Semantics of invoking a
sub-parser: top: original program, bottom: equivalent program.” }
\[subparser\] \~ \[subparser\]: figs/subparser.png { width: 60%;
page-align: here }

\[\]{tex-cmd: “”} Figure \[\#fig-subparser\] shows a diagram of this
process.

Note that since P4 requires definitions to precede uses, it is
impossible to create recursive (or mutually recursive) parsers.

When a parser is instantiated, local instantiations of stateful objects
are evaluated recursively. That is, each instantiation of a parser has a
unique set of local parser value sets, extern objects, inner parser
instances, etc. Thus, in general, invoking a parser instance twice is
not the same as invoking two copies of the same parser instance. Note
however that local variables do not persist across invocations of the
parser. This semantics also applies to direct invocation (see Section
\[\#sec-direct-invocation\]).

Architectures may impose (static or dynamic) constraints on the number
of parser states that can be traversed for processing each packet. For
example, a compiler for a specific target may reject parsers containing
loops that cannot be unrolled at compilation time or that may contain
cycles that do not advance the cursor. If a parser aborts execution
dynamically because it exceeded the time budget allocated for parsing,
the parser should transition to `reject` and set the standard error
`error.ParserTimeout`.
