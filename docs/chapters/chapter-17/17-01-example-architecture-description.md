\~ Figure { \#fig-switcharch; caption: “Fragment of example switch
architecture.” } \[switcharch\] \~ \[switcharch\]: figs/switcharch.png {
width: 75%; page-align: here }

The following example describes a switch by using two packages, each
containing a parser, a match-action pipeline, and a deparser:

\~ Begin P4Example parser Parser<IH>(packet\_in b, out IH
parsedHeaders); // ingress match-action pipeline control IPipe\<T, IH,
OH\>(in IH inputHeaders, in InControl inCtrl, out OH outputHeaders, out
T toEgress, out OutControl outCtrl); // egress match-action pipeline
control EPipe\<T, IH, OH\>(in IH inputHeaders, in InControl inCtrl, in T
fromIngress, out OH outputHeaders, out OutControl outCtrl); control
Deparser<OH>(in OH outputHeaders, packet\_out b); package Ingress\<T,
IH, OH\>(Parser<IH> p, IPipe\<T, IH, OH\> map, Deparser<OH> d); package
Egress\<T, IH, OH\>(Parser<IH> p, EPipe\<T, IH, OH\> map, Deparser<OH>
d); package Switch<T>(Ingress\<T, *, *\> ingress, Egress\<T, *, *\>
egress); \~ End P4Example

Just from these declarations, even without reading a precise description
of the target, the programmer can infer some useful information about
the architecture of the described switch, as shown in Figure
\[\#fig-switcharch\]:

  - The switch contains two separate `package`s `Ingress` and `Egress`.
  - The `Parser`, `IPipe`, and `Deparser` in the `Ingress` package are
    chained together in order. In addition, the `Ingress.IPipe` block
    has an input of type `Ingress.IH`, which is an output of the
    `Ingress.Parser`.
  - Similarly, the `Parser`, `EPipe`, and `Deparser` are chained in the
    `Egress` package.
  - The `Ingress.IPipe` is connected to the `Egress.EPipe`, because the
    first outputs a value of type `T`, which is an input to the second.
    Note that the occurrences of the type variable `T` are instantiated
    with the same type in `Switch`. In contrast, the `Ingress` type `IH`
    and the `Egress` type `IH` may be different. To force them to be the
    same, we could instead declare `IH` and `OH` at the switch level:
    `package Switch<T,IH,OH>(Ingress<T, IH, OH> ingress, Egress<T, IH,
    OH> egress)`.

Hence, this architecture models a target switch that contains two
separate channels between the ingress and egress pipeline:

  - A channel that can pass data directly via its argument of type `T`.
    On a software target with shared memory between ingress and egress
    this could be implemented by passing directly a pointer; on an
    architecture without shared memory presumably the compiler will need
    to automatically synthesize serialization code.
  - A channel that can pass data indirectly using a parser and deparser
    that serializes data into a packet and back.
