# 3. Overview


\~ Figure { \#fig-prgswitch; caption: “Traditional switches
vs. programmable switches.” } \[prgswitch\] \~ \[prgswitch\]:
figs/prgswitch.png { width: 100%; page-align: forcehere }

P4 is a language for expressing how packets are processed by the data
plane of a programmable forwarding element such as a hardware or
software switch, network interface card, router, or network appliance.
The name P4 comes from the original paper that introduced the language,
“Programming Protocol-independent Packet Processors,”
<https://arxiv.org/pdf/1312.1719.pdf>. While P4 was initially designed
for programming switches, its scope has been broadened to cover a large
variety of devices. In the rest of this document we use the generic term
*target* for all such devices.

Many targets implement both a control plane and a data plane. P4 is
designed to specify only the data plane functionality of the target. P4
programs also partially define the interface by which the control plane
and the data-plane communicate, but P4 cannot be used to describe the
control-plane functionality of the target. In the rest of this document,
when we talk about P4 as “programming a target”, we mean “programming
the data plane of a target”.

As a concrete example of a target, Figure \[\#fig-prgswitch\]
illustrates the difference between a traditional fixed-function switch
and a P4-programmable switch. In a traditional switch the manufacturer
defines the data-plane functionality. The control-plane controls the
data plane by managing entries in tables (e.g. routing tables),
configuring specialized objects (e.g. meters), and by processing
control-packets (e.g. routing protocol packets) or asynchronous events,
such as link state changes or learning notifications.

A P4-programmable switch differs from a traditional switch in two
essential ways:

  - The data plane functionality is not fixed in advance but is defined
    by a P4 program. The data plane is configured at initialization time
    to implement the functionality described by the P4 program (shown by
    the long red arrow) and has no built-in knowledge of existing
    network protocols.
  - The control plane communicates with the data plane using the same
    channels as in a fixed-function device, but the set of tables and
    other objects in the data plane are no longer fixed, since they are
    defined by a P4 program. The P4 compiler generates the API that the
    control plane uses to communicate with the data plane.

Hence, P4 can be said to be protocol independent, but it enables
programmers to express a rich set of protocols and other data plane
behaviors.

\~ Figure { \#fig-p4prg; caption: “Programming a target with P4.” }
\[p4prg\] \~ \[p4prg\]: figs/p4prg.png { width: 100%; page-align: here;
}

\[\]{tex-cmd: “”} The core abstractions provided by the P4 language are:

  - **Header types** describe the format (the set of fields and their
    sizes) of each header within a packet.
  - **Parsers** describe the permitted sequences of headers within
    received packets, how to identify those header sequences, and the
    headers and fields to extract from packets.
  - **Tables** associate user-defined keys with actions. P4 tables
    generalize traditional switch tables; they can be used to implement
    routing tables, flow lookup tables, access-control lists, and other
    user-defined table types, including complex multi-variable
    decisions.
  - **Actions** are code fragments that describe how packet header
    fields and metadata are manipulated. Actions can include data, which
    is supplied by the control-plane at runtime.
  - **Match-action units** perform the following sequence of operations:
      - Construct lookup keys from packet fields or computed metadata,
      - Perform table lookup using the constructed key, choosing an
        action (including the associated data) to execute, and
      - Finally, execute the selected action.
  - **Control flow** expresses an imperative program that describes
    packet-processing on a target, including the data-dependent sequence
    of match-action unit invocations. Deparsing (packet reassembly) can
    also be performed using a control flow.
  - **Extern objects** are architecture-specific constructs that can be
    manipulated by P4 programs through well-defined APIs, but whose
    internal behavior is hard-wired (e.g., checksum units) and hence not
    programmable using P4.
  - **User-defined metadata**: user-defined data structures associated
    with each packet.
  - **Intrinsic metadata**: metadata provided by the architecture
    associated with each packet—e.g., the input port where a packet has
    been received.

Figure \[\#fig-p4prg\] shows a typical tool workflow when programming a
target using P4.

Target manufacturers provide the hardware or software implementation
framework, an architecture definition, and a P4 compiler for that
target. P4 programmers write programs for a specific architecture, which
defines a set of P4-programmable components on the target as well as
their external data plane interfaces.

Compiling a set of P4 programs produces two artifacts:

  - a data plane configuration that implements the forwarding logic
    described in the input program and
  - an API for managing the state of the data plane objects from the
    control plane

P4 is a domain-specific language that is designed to be implementable on
a large variety of targets including programmable network interface
cards, FPGAs, software switches, and hardware ASICs. As such, the
language is restricted to constructs that can be efficiently implemented
on all of these platforms.

Assuming a fixed cost for table lookup operations and interactions with
extern objects, all P4 programs (i.e., parsers and controls) execute a
constant number of operations for each byte of an input packet received
and analyzed. Although parsers may contain loops, provided some header
is extracted on each cycle, the packet itself provides a bound on the
total execution of the parser. In other words, under these assumptions,
the computational complexity of a P4 program is linear in the total size
of all headers, and never depends on the size of the state accumulated
while processing data (e.g., the number of flows, or the total number of
packets processed). These guarantees are necessary (but not sufficient)
for enabling fast packet processing across a variety of targets.

*P4 conformance* of a target is defined as follows: if a specific target
T supports only a subset of the P4 programming language, say
P4<sup>T</sup>, programs written in P4<sup>T</sup> executed on the
target should provide the exact same behavior as is described in this
document. Note that P4 conformant targets can provide arbitrary P4
language extensions and `extern` elements.

--8<-- "chapters/chapter-03/03-01-benefits-of-p4.md"
--8<-- "chapters/chapter-03/03-02-p4-language-evolution-comparison-to-previous-versions-p4-v1.0-v1.1.md"
