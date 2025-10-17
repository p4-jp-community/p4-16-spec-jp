To describe a functional block that can be programmed in P4, the
architecture includes a type declaration that specifies the interfaces
between the block and the other components in the architecture. For
example, the architecture might contain a declaration such as the
following:

\~ Begin P4Example control MatchActionPipe<H>(in bit\<4\> inputPort,
inout H parsedHeaders, out bit\<4\> outputPort); \~ End P4Example

This type declaration describes a block named `MatchActionPipe` that can
be programmed using a data-dependent sequence of match-action unit
invocations and other imperative constructs (indicated by the `control`
keyword). The interface between the `MatchActionPipe` block and the
other components of the architecture can be read off from this
declaration:

  - The first parameter is a 4-bit value named `inputPort.` The
    direction `in` indicates that this parameter is an input that cannot
    be modified.
  - The second parameter is an object of type `H` named `parsedHeaders`,
    where `H` is a type variable representing the headers that will be
    defined later by the P4 programmer. The direction `inout` indicates
    that this parameter is both an input and an output.
  - The third parameter is a 4-bit value named `outputPort`. The
    direction `out` indicates that this parameter is an output whose
    value is undefined initially but can be modified.
