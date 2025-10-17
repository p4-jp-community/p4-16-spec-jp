A parser declaration comprises a name, a list of parameters, an optional
list of constructor parameters, local elements, and parser states (as
well as optional annotations).

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:parserTypeDeclaration\]

\[INCLUDE=grammar.mdk:parserDeclaration\]

\[INCLUDE=grammar.mdk:parserLocalElements\]

  - \[INCLUDE=grammar.mdk:parserStates\]  
    End P4Grammar

For a description of `optConstructorParameters`, which are useful for
building parameterized parsers, see Section \[\#sec-parameterization\].

Unlike parser type declarations, parser declarations may not be
generic—e.g., the following declaration is illegal:

\~ Begin P4Example parser P<H>(inout H data) { /\* body omitted \*/ } \~
End P4Example

Hence, used in the context of a `parserDeclaration` the production rule
`parserTypeDeclaration` should not yield type parameters.

At least one state, named `start`, must be present in any `parser`. A
parser may not define two states with the same name. It is also illegal
for a parser to give explicit definitions for the `accept` and `reject`
states—those states are logically distinct from the states defined by
the programmer.

State declarations are described below. Preceding the parser states, a
`parser` may also contain a list of local elements. These can be
constants, variables, or instantiations of objects that may be used
within the parser. Such objects may be instantiations of `extern`
objects, or other `parser`s that may be invoked as subroutines. However,
it is illegal to instantiate a `control` block within a `parser`.

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:parserLocalElement\] \~ End
P4Grammar

The states and local elements are all in the same namespace, thus the
following example will produce an error:

\~ Begin P4Example // erroneous example parser p() { bit\<4\> t; state
start { t = 1; transition t; } state t { // error: name t is duplicated
transition accept; } } \~ End P4Example

For an example containing a complete declaration of a parser see Section
\[\#sec-vss-all\].
