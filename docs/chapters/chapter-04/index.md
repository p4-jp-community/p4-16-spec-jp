# 4 Architecture Model


\~ Figure { \#fig-p4interface; caption: “P4 program interfaces.” }
\[p4interface\] \~ \[p4interface\]: figs/p4interface.png { width: 100%;
page-align: here }

The *P4 architecture* identifies the P4-programmable blocks (e.g.,
parser, ingress control flow, egress control flow, deparser, etc.) and
their data plane interfaces.

The P4 architecture can be thought of as a contract between the program
and the target. Each manufacturer must therefore provide both a P4
compiler as well as an accompanying architecture definition for their
target. (We expect that P4 compilers can share a common front-end that
handles all architectures). The architecture definition does not have to
expose the entire programmable surface of the data plane—a manufacturer
may even choose to provide multiple definitions for the same hardware
device, each with different capabilities (e.g., with or without
multicast support).

Figure \[\#fig-p4interface\] illustrates the data plane interfaces
between P4-programmable blocks. It shows a target that has two
programmable blocks (\#1 and \#2). Each block is programmed through a
separate fragment of P4 code. The target interfaces with the P4 program
through a set of control registers or signals. Input controls provide
information to P4 programs (e.g., the input port that a packet was
received from), while output controls can be written to by P4 programs
to influence the target behavior (e.g., the output port where a packet
has to be directed). Control registers/signals are represented in P4 as
*intrinsic metadata*. P4 programs can also store and manipulate data
pertaining to each packet as *user-defined metadata*.

The behavior of a P4 program can be fully described in terms of
transformations that map vectors of bits to vectors of bits. To actually
process a packet, the architecture model interprets the bits that the P4
program writes to intrinsic metadata. For example, to cause a packet to
be forwarded on a specific output port, a P4 program may need to write
the index of an output port into a dedicated control register.
Similarly, to cause a packet to be dropped, a P4 program may need to set
a “drop” bit into another dedicated control register. Note that the
details of how intrinsic metadata are interpreted is
architecture-specific.

\~ Figure { \#fig-p4checksum; caption: “P4 program invoking the services
of a fixed-function object.” } \[p4checksum\] \~ \[p4checksum\]:
figs/p4checksum.png { width: 50%; page-align: here }

\[\]{tex-cmd: “”} P4 programs can invoke services implemented by extern
objects and functions provided by the architecture. Figure
\[\#fig-p4checksum\] depicts a P4 program invoking the services of a
built-in checksum computation unit on a target. The implementation of
the checksum unit is not specified in P4, but its interface is. In
general, the interface for an extern object describes each operation it
provides, as well as their parameter and return types.

In general, P4 programs are not expected to be portable across different
architectures. For example, executing a P4 program that broadcasts
packets by writing into a custom control register will not function
correctly on a target that does not have the control register. However,
P4 programs written for a given architecture should be portable across
all targets that faithfully implement the corresponding model, provided
there are sufficient resources.

--8<-- "chapters/chapter-04/04-01-standard-architectures.md"
--8<-- "chapters/chapter-04/04-02-data-plane-interfaces.md"
--8<-- "chapters/chapter-04/04-03-extern-objects-and-functions.md"
