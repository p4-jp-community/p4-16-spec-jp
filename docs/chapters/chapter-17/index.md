# 17. Architecture description


The architecture description must be provided by the target manufacturer
in the form of a library P4 source file that contains at least one
declaration for a `package`; this `package` must be instantiated by the
user to construct a program for a target. For an example see the Very
Simple Switch declaration from Section \[\#sec-vss-arch\].

The architecture description file may pre-define data types, constants,
helper package implementations, and errors. It must also declare the
types of all the programmable blocks that will appear in the final
target: `parser`s and `control` blocks. The programmable blocks may
optionally be grouped together in packages, which can be nested.

Since some of the target components may manipulate user-defined types,
which are unknown at the target declaration time, these are described
using type variables, which must be used parametrically in the
program—i.e., type variables are checked similar to Java generics, not
C++ templates.

--8<-- "chapters/chapter-17/17-01-example-architecture-description.md"
--8<-- "chapters/chapter-17/17-02-example-architecture-program.md"
--8<-- "chapters/chapter-17/17-03-a-packet-filter-model.md"
