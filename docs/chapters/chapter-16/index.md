# 16 Deparsing


The inverse of parsing is deparsing, or packet construction. P4 does not
provide a separate language for packet deparsing; deparsing is done in a
`control` block that has at least one parameter of type `packet_out`.

For example, the following code sequence writes first an Ethernet header
and then an IPv4 header into a `packet_out`:

\~ Begin P4Example control TopDeparser(inout Parsed\_packet p,
packet\_out b) { apply { b.emit(p.ethernet); b.emit(p.ip); } } \~ End
P4Example

Emitting a header appends the header to the `packet_out` only if the
header is valid. Emitting a header stack will emit all elements of the
stack in order of increasing indices.

--8<-- "chapters/chapter-16/16-01-data-insertion-into-packets.md"
