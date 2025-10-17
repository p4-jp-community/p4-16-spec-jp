The following P4 program provides a declaration of VSS in P4, as it
would be provided by the VSS manufacturer. The declaration contains
several type declarations, constants, and finally declarations for the
three programmable blocks; the code uses syntax highlighting. The
programmable blocks are described by their types; the implementation of
these blocks has to be provided by the switch programmer.

\~ Begin P4Example // File “very\_simple\_switch\_model.p4” // Very
Simple Switch P4 declaration // core library needed for packet\_in and
packet\_out definitions \# include \<core.p4\> /\* Various constants and
structure declarations */ /* ports are represented using 4-bit values */
typedef bit\<4\> PortId; /* only 8 ports are “real” */ const PortId
REAL\_PORT\_COUNT = 4w8; // 4w8 is the number 8 in 4 bits /* metadata
accompanying an input packet */ struct InControl { PortId inputPort; }
/* special input port values */ const PortId RECIRCULATE\_IN\_PORT =
0xD; const PortId CPU\_IN\_PORT = 0xE; /* metadata that must be computed
for outgoing packets */ struct OutControl { PortId outputPort; } /*
special output port values for outgoing packet */ const PortId
DROP\_PORT = 0xF; const PortId CPU\_OUT\_PORT = 0xE; const PortId
RECIRCULATE\_OUT\_PORT = 0xD; /* Prototypes for all programmable blocks
\*/ /\*\* \* Programmable parser. \* @param <H> type of headers; defined
by user \* @param b input packet \* @param parsedHeaders headers
constructed by parser \*/ parser Parser<H>(packet\_in b, out H
parsedHeaders); /\*\* \* Match-action pipeline \* @param <H> type of
input and output headers \* @param headers headers received from the
parser and sent to the deparser \* @param parseError error that may have
surfaced during parsing \* @param inCtrl information from architecture,
accompanying input packet \* @param outCtrl information for
architecture, accompanying output packet \*/ control Pipe<H>(inout H
headers, in error parseError,// parser error in InControl inCtrl,//
input port out OutControl outCtrl); // output port /\*\* \* VSS
deparser. \* @param <H> type of headers; defined by user \* @param b
output packet \* @param outputHeaders headers for output packet \*/
control Deparser<H>(inout H outputHeaders, packet\_out b); /\*\* \*
Top-level package declaration - must be instantiated by user. \* The
arguments to the package indicate blocks that \* must be instantiated by
the user. \* @param <H> user-defined type of the headers processed. \*/
package VSS<H>(Parser<H> p, Pipe<H> map, Deparser<H> d); //
Architecture-specific objects that can be instantiated // Checksum unit
extern Checksum16 { Checksum16(); // constructor void clear(); //
prepare unit for computation void update<T>(in T data); // add data to
checksum void remove<T>(in T data); // remove data from existing
checksum bit\<16\> get(); // get the checksum for the data added since
last clear } \~ End P4Example Let us describe some of these elements:

  - The included file `core.p4` is described in more detail in Appendix
    \[\#sec-p4-core-lib\]. It defines some standard data-types and error
    codes.

  - `bit<4>` is the type of bit-strings with 4 bits.

  - The syntax `4w0xF` indicates the value 15 represented using 4 bits.
    An alternative notation is `4w15`. In many circumstances the width
    modifier can be omitted, writing just `15`.

  - `error` is a built-in P4 type for holding error codes

  -   - Next follows the declaration of a parser:  
        Begin P4Example parser Parser<H>(packet\_in b, out H
        parsedHeaders);
        End P4Example  
        This declaration describes the interface for a parser, but not
        yet its implementation, which will be provided by the
        programmer. The parser reads its input from a `packet_in`, which
        is a pre-defined P4 extern object that represents an incoming
        packet, declared in the `core.p4` library. The parser writes its
        output (the `out` keyword) into the `parsedHeaders` argument.
        The type of this argument is `H`, yet unknown—it will also be
        provided by the programmer.

  -   - The declaration  
        Begin P4Example control Pipe<H>(inout H headers, in error
        parseError, in InControl inCtrl, out OutControl outCtrl);
        End P4Example  
        describes the interface of a Match-Action pipeline named `Pipe`.

The pipeline receives three inputs: the headers `headers`, a parser
error `parseError`, and the `inCtrl` control data. Figure
\[\#fig-vssarch\] indicates the different sources of these pieces of
information. The pipeline writes its outputs into `outCtrl`, and it must
update in place the headers to be consumed by the deparser.

  - The top-level package is called `VSS`; in order to program a VSS,
    the user will have to instantiate a package of this type (shown in
    the next section). The top-level package declaration also depends on
    a type variable H: \~ Begin P4Example package VSS<H> \~ End
    P4Example

A type variable indicates a type yet unknown that must be provided by
the user at a later time. In this case `H` is the type of the set of
headers that the user program will be processing; the parser will
produce the parsed representation of these headers, and the match-action
pipeline will update the input headers in place to produce the output
headers.

  - The `package VSS` declaration has three complex parameters, of types
    `Parser`, `Pipe`, and `Deparser` respectively; which are exactly the
    declarations we have just described. In order to program the target
    one has to supply values for these parameters.
  - In this program the `inCtrl` and `outCtrl` structures represent
    control registers. The content of the headers structure is stored in
    general-purpose registers.
  - The `extern Checksum16` declaration describes an extern object whose
    services can be invoked to compute checksums.
