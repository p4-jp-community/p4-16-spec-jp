  - A P4 program is a list of declarations:  
    Begin P4Grammar \[INCLUDE=grammar.mdk:p4program\]

  - \[INCLUDE=grammar.mdk:declaration\]  
    End P4Grammar

An empty declarations is indicated with a single semicolon. (Allowing
empty declarations accommodates the habits of C/C++ and Java
programmers—e.g., certain constructs, like `struct`, do not require a
terminating semicolon).

### Scopes

Some P4 constructs act as namespaces that create local scopes for names
including:

  - Derived type declarations (`struct`, `header`, `header_union`,
    `enum`), which introduce local scopes for field names,
  - Block statements, which introduce local lexically-enclosed scopes,
  - `parser`, `table`, `action`, and `control` blocks, which introduce
    local scopes
  - Declarations with type variables, which introduce a new scope for
    those variables. For example, in the following `extern` declaration,
    the scope of the type variable `H` extends to the end of the
    declaration:

\~ Begin P4Example extern E<H>(/\* parameters omitted */) { /* body
omitted \*/ } // scope of H ends here. \~ End P4Example

The order of declarations is important; with the exception of parser
states, all uses of a symbol must follow the symbol’s declaration. (This
is a departure from P4<sub>14</sub>, which allows declarations in any
order. This requirement significantly simplifies the implementation of
compilers for P4, allowing compilers to use additional information about
declared identifiers to resolve ambiguities.)

### Stateful elements

Most P4 constructs are stateless: given some inputs they produce a
result that solely depends on these inputs. There are only two stateful
constructs that may retain information across packets:

  - `table`s: Tables are read-only for the data plane, but their entries
    can be modified by the control-plane,

  - `extern` objects: many objects have state that can be read and
    written by the control plane and data plane. All constructs from the
    P4<sub>14</sub> language version that encapsulate state (e.g.,
    counters, meters, registers) are represented using `extern` objects
    in P4<sub>16</sub>.

In P4 all stateful elements must be explicitly allocated at
compilation-time through the process called “instantiation”.

In addition, `parser`s, `control` blocks, and `package`s may contain
stateful element instantiations. Thus, they are also treated as stateful
elements, even if they appear to contain no state, and must be
instantiated before they can be used. However, although they are
stateful, `table`s do not need to be instantiated explicitly—declaring a
`table` also creates an instance of it. This convention is designed to
support the common case, since most tables are used just once. To have
finer-grained control over when a `table` is instantiated, a programmer
can declare it within a `control`.

Recall the example in Section \[\#sec-vss-all\]: `TopParser`, `TopPipe`,
`TopDeparser`, `Checksum16`, and `Switch` are types. There are two
instances of `Checksum16`, one in `TopParser` and one in `TopDeparser`,
both called `ck`. The `TopParser`, `TopDeparser`, `TopPipe`, and
`Switch` are instantiated at the end of the program, in the declaration
of the `main` instance object, which is an instance of the `Switch` type
(a `package`).
