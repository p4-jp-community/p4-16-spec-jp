<a id="sec-instantiating-abstract-methods"></a>
<a id="sec-instantiations"></a>
Instantiations are similar to variable declarations, but are reserved
for the types with constructors (`extern` objects, `control` blocks,
`parser`s, and `package`s):

```bison
instantiation
    : typeRef '(' argumentList ')' name ';'
    | annotations typeRef '(' argumentList ')' name ';'
    ;
```

An instantiation is written as a constructor invocation followed by a
name. Instantiations are always executed at compilation time (Section
[Compile-time known and local compile-time known values](../chapter-18/18-01-compile-time-known-and-local-compile-time-known-values.md#sec-compile-time-known)). The effect is to allocate an object with
the specified name, and to bind it to the result of the constructor
invocation. Note that instantiation arguments can be specified by name.

For example, a hypothetical bank of counter objects can be instantiated
as follows:

```p4
// from target library
enum CounterType {
   Packets,
   Bytes,
   Both
}
extern Counter {
    Counter(bit<32> size, CounterType type);
    void increment(in bit<32> index);
}
// user program
control c(/* parameters omitted */) {
    Counter(32w1024, CounterType.Both) ctr;  // instantiation
    apply { /* body omitted */ }
}
```

### Instantiating objects with abstract methods

When instantiating an extern type that has `abstract` methods users have
to supply implementations for all such methods. This is done using
object initializers:

```bison
lvalue:
    ...
    | THIS

expression:
    ...
    | THIS

instantiation:
      ...
      | annotations typeRef "(" argumentList ")" name "=" objInitializer ";"
      | typeRef "(" argumentList ")" name "=" objInitializer ";"

objInitializer
    : "{" objDeclarations "}"
    ;

objDeclarations
    : /* empty */
    | objDeclarations objDeclaration
    ;

objDeclaration
    : functionDeclaration
    | instantiation
    ;
```

The abstract methods can only use the supplied arguments or refer to
values that are in the top-level scope. When calling another method of
the same instance the `this` keyword is used to indicate the current
object instance:

```p4
// Instantiate a balancer
Balancer() b = {  // provide an implementation for the abstract methods
    bit<4> on_new_flow(in bit<32> address) {
        // uses the address and the number of flows to balance the load
        bit<32> count = this.getFlowCount();  // call method of the same instance
        return (address + count)[3:0];
    }
}
```

Abstract methods may be invoked by users explicitly, or they may be
invoked by the target architecture. The architectural description has to
specify when the abstract methods are invoked and what the meaning of
their arguments and return values is; target architectures may impose
additional constraints on abstract methods.

### Restrictions on top-level instantiations

A P4 program may not instantiate controls and parsers in the top-level
package. This restriction is designed to ensure that most state resides
in the architecture itself, or is local to a `parser` or `control`. For
example, the following program is not valid:

```p4
// Program
control c(/* parameters omitted */) { /* body omitted */ }
c() c1;  // illegal top-level instantiation
```

because control `c1` is instantiated at the top-level. Note that
top-level declarations of constants and instantiations of extern objects
are permitted.
