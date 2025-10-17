In order to fully understand VSS’s behavior and write meaningful P4
programs for it, and for implementing a control plane, we also need a
full behavioral description of the fixed-function blocks. This section
can be seen as a simple example illustrating all the details that have
to be handled when writing an architecture description. The P4 language
is not intended to cover the description of all such functional
blocks—the language can only describe the interfaces between
programmable blocks and the architecture. For the current program, this
interface is given by the `Parser`, `Pipe`, and `Deparser` declarations.
In practice we expect that the complete description of the architecture
will be provided as an executable program and/or diagrams and text; in
this document we will provide informal descriptions in English.

### Arbiter block

The input arbiter block performs the following functions:

  - It receives packets from one of the physical input Ethernet ports,
    from the control plane, or from the input recirculation port.
  - For packets received from Ethernet ports, the block computes the
    Ethernet trailer checksum and verifies it. If the checksum does not
    match, the packet is discarded. If the checksum does match, it is
    removed from the packet payload.
  - Receiving a packet involves running an arbitration algorithm if
    multiple packets are available.
  - If the arbiter block is busy processing a previous packet and no
    queue space is available, input ports may drop arriving packets,
    without indicating the fact that the packets were dropped in any
    way.
  - After receiving a packet, the arbiter block sets the
    `inCtrl.inputPort` value that is an input to the match-action
    pipeline with the identity of the input port where the packet
    originated. Physical Ethernet ports are numbered 0 to 7, while the
    input recirculation port has a number 13 and the CPU port has the
    number 14.

### Parser runtime block

The parser runtime block works in concert with the parser. It provides
an error code to the match-action pipeline, based on the parser actions,
and it provides information about the packet payload (e.g., the size of
the remaining payload data) to the demux block. As soon as a packet’s
processing is completed by the parser, the match-action pipeline is
invoked with the associated metadata as inputs (packet headers and
user-defined metadata).

### Demux block

The core functionality of the demux block is to receive the headers for
the outgoing packet from the deparser and the packet payload from the
parser, to assemble them into a new packet and to send the result to the
correct output port. The output port is specified by the value of
`outCtrl.ouputPort`, which is set by the match-action pipeline.

  - Sending the packet to the drop port causes the packet to disappear.
  - Sending the packet to an output Ethernet port numbered between 0 and
    7 causes it to be emitted on the corresponding physical interface.
    The packet may be placed in a queue if the output interface is
    already busy emitting another packet. When the packet is emitted,
    the physical interface computes a correct Ethernet checksum trailer
    and appends it to the packet.
  - Sending a packet to the output CPU port causes the packet to be
    transferred to the control plane. In this case, the packet that is
    sent to the CPU is the **original input packet**, and not the packet
    received from the deparser—the latter packet is discarded.
  - Sending the packet to the output recirculation port causes it to
    appear at the input recirculation port. Recirculation is useful when
    packet processing cannot be completed in a single pass.
  - If the `outputPort` has an illegal value (e.g., 9), the packet is
    dropped.
  - Finally, if the demux unit is busy processing a previous packet and
    there is no capacity to queue the packet coming from the deparser,
    **the demux unit may drop the packet**, irrespective of the output
    port indicated.

Please note that some of the behaviors of the demux block may be
unexpected—we have highlighted them in bold. We are not specifying here
several important behaviors related to queue size, arbitration, and
timing, which also influence the packet processing.

The arrow shown from the parser runtime to the demux block represents an
additional information flow from the parser to the demux: the packet
being processed as well as the offset within the packet where parsing
ended (i.e., the start of the packet payload).

### Available extern blocks

The VSS architecture provides an incremental checksum extern block,
called `Checksum16`. The checksum unit has a constructor and four
methods:

  - `clear()`: prepares the unit for a new computation
  - `update<T>(in T data)`: add some data to be checksummed. The data
    must be either a bit-string, a header-typed value, or a `struct`
    containing such values. The fields in the header/struct are
    concatenated in the order they appear in the type declaration.
  - `get()`: returns the 16-bit one’s complement checksum. When this
    function is invoked the checksum must have received an integral
    number of bytes of data.
  - `remove<T>(in T data)`: assuming that `data` was used for computing
    the current checksum, `data` is removed from the checksum.
