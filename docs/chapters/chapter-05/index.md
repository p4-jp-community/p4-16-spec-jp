# 5 Example: A very simple switch


As an example to illustrate the features of architectures, consider
implementing a very simple switch in P4. We will first describe the
architecture of the switch and then write a complete P4 program that
specifies the data plane behavior of the switch. This example
demonstrates many important features of the P4 programming language.

\~ Figure { \#fig-vssarch; caption: “The Very Simple Switch (VSS)
architecture.” } \[vssarch\] \~ \[vssarch\]: figs/vssarch.png { width:
100%; page-align: here }

\[\]{tex-cmd: “”} We call our architecture the “Very Simple Switch”
(VSS). Figure \[\#fig-vssarch\] is a diagram of this architecture. There
is nothing inherently special about VSS—it is just a pedagogical example
that illustrates how programmable switches can be described and
programmed in P4. VSS has a number of fixed-function blocks (shown in
cyan in our example), whose behavior is described in Section
\[\#sec\_vssarch\]. The white blocks are programmable using P4.

VSS receives packets through one of 8 input Ethernet ports, through a
recirculation channel, or from a port connected directly to the CPU. VSS
has one single parser, feeding into a single match-action pipeline,
which feeds into a single deparser. After exiting the deparser, packets
are emitted through one of 8 output Ethernet ports or one of 3 “special”
ports:

  - Packets sent to the “CPU port” are sent to the control plane
  - Packets sent to the “Drop port” are discarded
  - Packets sent to the “Recirculate port” are re-injected in the switch
    through a special input port

The white blocks in the figure are programmable, and the user must
provide a corresponding P4 program to specify the behavior of each such
block. The red arrows indicate the flow of user-defined data. The cyan
blocks are fixed-function components. The green arrows are data plane
interfaces used to convey information between the fixed-function blocks
and the programmable blocks—exposed in the P4 program as intrinsic
metadata.

--8<-- "chapters/chapter-05/05-01-very-simple-switch-architecture.md"
--8<-- "chapters/chapter-05/05-02-very-simple-switch-architecture-description.md"
--8<-- "chapters/chapter-05/05-03-a-complete-very-simple-switch-program.md"
