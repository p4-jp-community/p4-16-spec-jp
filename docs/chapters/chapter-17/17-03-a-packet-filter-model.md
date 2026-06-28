<figure id="fig-packetfilter">
  <img src="https://p4-jp-community.github.io/p4-16-spec-jp/assets/figs/packetfilter.png" alt="A packet filter target model." style="width: 5cm;">
  <figcaption>
  A packet filter target model. The parser computes a Boolean value, which is used to decide whether the
  packet is dropped.</figcaption>
</figure>

To illustrate the versatility of the P4 architecture description
language, we give an example of another architecture: one which models a
packet filter that makes a drop/no drop decision based only on the
computation in a P4 parser, as shown in Figure \[\#fig-packetfilter\].

This model could be used to program packet filters running in the Linux
kernel. For example, we could replace the `tcpdump` language with the
much more powerful P4 language; P4 can seamlessly support new protocols,
while providing complete “type safety” during packet processing. For
such a target, the P4 compiler could generate an eBPF (Extended Berkeley
Packet Filter) program, which is injected by the `tcpdump` utility into
the Linux kernel, and executed by the eBPF kernel JIT compiler/runtime.

In this case the target is the Linux kernel, and the architecture model
is a packet filter.

The declaration for this architecture is as follows:

```p4
parser Parser<H>(packet_in packet, out H headers);
control Filter<H>(inout H headers, out bool accept);

package Program<H>(Parser<H> p, Filter<H> f);
```
