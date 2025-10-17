The dynamic evaluation of a P4 program is orchestrated by the
architecture model. Each architecture model needs to specify the order
and the conditions under which the various P4 component programs are
dynamically executed. For example, in the Simple Switch example from
Section \[\#sec-vss-arch\] the execution flow goes
`Parser->Pipe->Deparser`.

Once a P4 execution block is invoked its execution proceeds until
termination according to the semantics defined in this document.

### Concurrency model

A typical packet processing system needs to execute multiple
simultaneous logical “threads.” At the very least there is a thread
executing the control plane, which can modify the contents of the
tables. Architecture specifications should describe in detail the
interactions between the control-plane and the data-plane. The data
plane can exchange information with the control plane through `extern`
function and method calls. Moreover, high-throughput packet-processing
systems may be processing multiple packets simultaneously, e.g., in a
pipelined fashion, or concurrently parsing a first packet while
performing match-action operations on a second packet. This section
specifies the semantics of P4 programs with respect to such concurrent
executions.

Each top-level `parser` or `control` block is executed as a separate
thread when invoked by the architecture. All the parameters of the block
and all local variables are thread-local—i.e., each thread has a private
copy of these resources. This applies to the `packet_in` and
`packet_out` parameters of parsers and deparsers.

As long as a P4 block uses only thread-local storage (e.g., metadata,
packet headers, local variables), its behavior in the presence of
concurrency is identical with the behavior in isolation, since any
interleaving of statements from different threads must produce the same
output.

In contrast, `extern` blocks instantiated by a P4 program are global,
shared across all threads. If `extern` blocks mediate access to state
(e.g., counters, registers)—i.e., the methods of the `extern` block read
and write state, these stateful operations are subject to data races. P4
mandates that execution of a method call on an extern instance is
atomic.

To allow users to express atomic execution of larger code blocks, P4
provides an `@atomic` annotation, which can be applied to block
statements, parser states, control blocks, or whole parsers.

  - Consider the following example:  
    Begin P4Example extern Register { /\* body omitted */ } control
    Ingress() { Register() r; table flowlet { /* read state of r in an
    action */ } table new\_flowlet { /* write state of r in an action
    \*/ } apply { @atomic { flowlet.apply(); if
    (ingress\_metadata.flow\_ipg \> FLOWLET\_INACTIVE\_TIMEOUT)
    new\_flowlet.apply(); }}}
    
    End P4Example

This program accesses an extern object `r` of type `Register` in actions
invoked from tables `flowlet` (reading) and `new_flowlet` (writing).
Without the `@atomic` annotation these two operations would not execute
atomically: a second packet may read the state of `r` before the first
packet had a chance to update it.

Note that even within an `action` definition, if the action does
something like reading a register, modifying it, and writing it back, in
a way that only the modified value should be visible to the next packet,
then, to guarantee correct execution in all cases, that portion of the
action definition should be enclosed within a block annotated with
`@atomic`.

A compiler backend must reject a program containing `@atomic` blocks if
it cannot implement the atomic execution of the instruction sequence. In
such cases, the compiler should provide reasonable diagnostics.
