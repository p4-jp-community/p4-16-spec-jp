Every controllable entity exposed in a P4 program must be assigned a
unique, fully-qualified name, which the control plane may use to
interact with that entity. The following entities are controllable.

  - value sets
  - tables
  - keys
  - actions
  - extern instances

A fully qualified name consists of the local name of a controllable
entity prepended with the fully qualified name of its enclosing
namespace. Hence, the following program constructs, which enclose
controllable entities, must themselves have unique, fully-qualified
names.

  - control instances
  - parser instances

Evaluation may create multiple instances from one type, each of which
must have a unique, fully-qualified name.

### Computing control-plane names

The fully-qualified name of a construct is derived by concatenating the
fully-qualified name of its enclosing construct with its local name.
Constructs with no enclosing namespace, i.e. those defined at the global
scope, have the same local and fully-qualified names. The local names of
controllable entities and enclosing constructs are derived from the
syntax of a P4 program as follows.

#### Value sets

For each `value_set` construct, its syntactic name becomes the local
name of the value set. For example:

\~ Begin P4Example struct vsk\_t { @match(ternary) bit\<16\> port; }
value\_set<vsk_t>(4) pvs; \~ End P4Example

This value\_set’s local name is `pvs`.

#### Tables

For each `table` construct, its syntactic name becomes the local name of
the table. For example:

\~ Begin P4Example control c(/\* parameters omitted */)() { table t { /*
body omitted \*/ } } \~ End P4Example

This table’s local name is `t`.

#### Keys

Syntactically, table keys are expressions. For simple expressions, the
local key name can be generated from the expression itself; the
algorithm by which a compiler derives control-plane names for complex
key expressions is target-dependent.

The spec suggests, but does not mandate, the following algorithm for
generating names for some kinds of key expressions:

| Kind                    | Example           | Name                |
| ----------------------- | ----------------- | ------------------- |
| The `isValid()` method. | `h.isValid()`     | `"h.isValid()"`     |
| Array accesses.         | `header_stack[1]` | `"header_stack[1]"` |
| Constants.              | `1`               | `"1"`               |
| Field projections.      | `data.f1`         | `"data.f1"`         |
| Slices.                 | `f1[3:0]`         | `"f1[3:0]"`         |
| Masks.                  | `h.src & 0xFFFF`  | `"h.src & 0xFFFF"`  |

In the following example, the previous algorithm would derive for table
`t` two keys with names `data.f1` and `hdrs[3].f2`.

\~ Begin P4Example table t { keys = { data.f1 : exact; hdrs\[3\].f2 :
exact; } actions = { /\* body omitted \*/ } } \~ End P4Example

If a compiler cannot generate a name for a key it **requires** the key
expression to be annotated with a `@name` annotation (Section
\[\#sec-control-plane-api-annotations\]), as in the following example:

\~ Begin P4Example table t { keys = { data.f1 + 1 : exact
@name(“f1\_mask”); } actions = { /\* body omitted \*/ } } \~ End
P4Example

Here, the `@name("f1_mask")` annotation assigns the local name
`"f1_mask"` to this key.

#### Actions

For each `action` construct, its syntactic name is the local name of the
action. For example:

\~ Begin P4Example control c(/\* parameters omitted */)() { action a(…)
{ /* body omitted \*/ } } \~ End P4Example

This action’s local name is `a`.

#### Instances

The local names of `extern`, `parser`, and `control` instances are
derived based on how the instance is used. If the instance is bound to a
name, that name becomes its local control plane name. For example, if
`control` `C` is declared as,

\~ Begin P4Example control C(/\* parameters omitted */)() { /* body
omitted \*/ } \~ End P4Example

  - and instantiated as,  
    Begin P4Example C() c\_inst;
    
    End P4Example

then the local name of the instance is `c_inst`.

Alternatively, if the instance is created as an actual argument, then
its local name is the name of the formal parameter to which it will be
bound. For example, if `extern` `E` and `control` `C` are declared as,

\~ Begin P4Example extern E { /\* body omitted */ } control C( /*
parameters omitted */ )(E e\_in) { /* body omitted \*/ } \~ End
P4Example

  - and instantiated as,  
    Begin P4Example C(E()) c\_inst;
    
    End P4Example

then the local name of the extern instance is `e_in`.

If the construct being instantiated is passed as an argument to a
package, the instance name is derived from the user-supplied type
definition when possible. In the following example, the local name of
the instance of `MyC` is `c`, and the local name of the `extern` is
`e2`, not `e1`.

\~ Begin P4Example extern E { /\* body omitted \*/ } control ArchC(E
e1); package Arch(ArchC c);

control MyC(E e2)() { /\* body omitted \*/ } Arch(MyC()) main; \~ End
P4Example

Note that in this example, the architecture will supply an instance of
the extern when it applies the instance of `MyC` passed to the `Arch`
package. The fully-qualified name of that instance is `main.c.e2`.

Next, consider a larger example that demonstrates name generation when
there are multiple instances.

\~ Begin P4Example control Callee() { table t { /\* body omitted \*/ }
apply { t.apply(); } } control Caller() { Callee() c1; Callee() c2;
apply { c1.apply(); c2.apply(); } } control Simple(); package Top(Simple
s); Top(Caller()) main; \~ End P4Example

The compile-time evaluation of this program produces the structure in
Figure \[\#fig-evalmultiple\]. Notice that there are two instances of
the `table t`. These instances must both be exposed to the control
plane. To name an object in this hierarchy, one uses a path composed of
the names of containing instances. In this case, the two tables have
names `s.c1.t` and `s.c2.t`, where `s` is the name of the argument to
the package instantiation, which is derived from the name of its
corresponding formal parameter.

\~ Figure { \#fig-evalmultiple; caption: “Evaluating a program that has
several instantiations of the same component.” } \[evalmultiple\] \~
\[evalmultiple\]: figs/evalmultiple.png { width: 5cm; page-align: here }

### Annotations controlling naming

Control plane-related annotations (Section
\[\#sec-control-plane-api-annotations\]) can alter the names exposed to
the control plane in the following ways.

  - The `@hidden` annotation hides a controllable entity from the
    control plane. This is the only case in which a controllable entity
    is not required to have a unique, fully-qualified name.

  - The `@name` annotation may be used to change the local name of a
    controllable entity.

Programs that yield the same fully-qualified name for two different
controllable entities are invalid.

### Recommendations

The control plane may refer to a controllable entity by a postfix of its
fully qualified name when it is unambiguous in the context in which it
is used. Consider the following example.

\~ Begin P4Example control c( /\* parameters omitted */ )() { action a (
/* parameters omitted */ ) { /* body omitted */ } table t { keys = { /*
body omitted \*/ } actions = { a; } } } c() c\_inst; \~ End P4Example

Control plane software may refer to action `c_inst.a` as `a` when
inserting rules into table `c_inst.t`, because it is clear from the
definition of the table which action `a` refers to.

Not all unambiguous postfix shortcuts are recommended. For instance,
consider the first example in Section \[\#sec-cp-names\]. One might be
tempted to refer to `s.c1` simply as `c1`, as no other instance named
`c1` appears in the program. However, this leads to a brittle program
since future modifications can never introduce an instance named `c1`,
or include libraries of P4 code that contain instances with that name.
