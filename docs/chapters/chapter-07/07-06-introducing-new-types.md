Similarly to `typedef`, the keyword `type` can be used to introduce a
new type.

\~ Begin P4Grammar | optAnnotations TYPE typeRef name \~ End P4Grammar

\~ Begin P4Example type bit\<32\> U32; U32 x = (U32)0; \~ End P4Example

While similar to `typedef`, the `type` keyword introduces a new type
which is not a synonym with the original type: values of the original
type and the newly introduced type cannot be mixed in expressions.

Currently the types that can be created by the `type` keyword are
restricted to one of: `bit<>`, `int<>`, `bool`, or types defined using
`type` from such types.

One important use of such types is in describing P4 values that need to
be exchanged with the control plane through communication channels
(e.g., through the control-plane API or through network packets sent to
the control plane). For example, a P4 architecture may define a type for
the switch ports:

\~Begin P4Example type bit\<9\> PortId\_t; \~End P4Example

This declaration will prevent `PortId_t` values from being used in
arithmetic expressions without casts. Moreover, this declaration may
enable special manipulation or such values by software that lies outside
of the datapath (e.g., a target-specific toolchain could include
software that automatically converts values of type `PortId_t` to a
different representation when exchanged with the control-plane
software).
