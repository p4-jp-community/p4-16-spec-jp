P4 allows controls to invoke the services of other controls, similar to
subroutines. To invoke the services of another control, it must be first
instantiated; the services of an instance are invoked by calling it
using its `apply` method.

  - The following example shows a control invocation:  
    Begin P4Example control Callee(inout IPv4 ipv4) { /\* body omitted
    \*/ } control Caller(inout Headers h) { Callee() instance; //
    instance of callee apply { instance.apply(h.ipv4); // invoke control
    } }
    
    End P4Example

As with parsers, when a control is instantiated, local instantiations of
stateful objects are evaluated recursively. That is, each instantiation
of a control has a unique set of local tables, extern objects, inner
control instances, etc. Thus, in general, invoking a control instance
twice is not the same as invoking two copies of the same control
instance. Note however, that local variables do not persist across
invocations of the control. This semantics also applies to direct
invocation (see Section \[\#sec-direct-invocation\]).

When a control is instantiated, all its local declarations of stateful
instantiations are evaluated recursively. Each instantiation of a
control will have a unique set of local tables, extern objects, and
inner control instances. Thus, invoking a control instance twice is
different from invoking two control instances each once, where the
former accesses the same local stateful constructs while the latter
access two different copies.

The exactly-once evaluation only applies to local stateful
instantiations. For local variable declarations, whether in the `apply`
block or out, and whether with initializers or not, they are always
evaluated when a control instance is invoked. That is, local variables
in a control never persist across invocations. For variables declared
outside the `apply` block, they are evaluated at the beginning of
execution.

All the behavior above also applies to direct invocation (see Section
\[\#sec-direct-invocation\]).
