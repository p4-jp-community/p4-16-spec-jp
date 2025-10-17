Local variables are declared with a type, a name, and an optional
initializer (as well as an optional annotation):

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:variableDeclaration\]

  - \[INCLUDE=grammar.mdk:optInitializer\]  
    End P4Grammar

Variable declarations without an initializer are uninitialized (except
for headers and other header-related types, which are initialized to
invalid in the same way as described for direction `out` parameters in
Section \[\#sec-calling-convention\]). The language places few
restrictions on the types of the variables: most P4 types that can be
written explicitly can be used (e.g., base types, `struct`, `header`,
header stack, `tuple`). However, it is impossible to declare variables
with type `int`, or with types that are only synthesized by the compiler
(e.g., `set`) In addition, variables of type `parser`, `control`,
`package`, or `extern` types must be declared using instantiations (see
Section \[\#sec-instantiations\]).

Reading the value of a variable that has not been initialized yields an
undefined result. The compiler should attempt to detect and emit a
warning in such situations.

Variables declarations can appear in the following locations within a P4
program:

  - In a block statement,
  - In a `parser` state,
  - In an `action` body,
  - In a `control` block’s `apply` sub-block,
  - In the list of local declarations in a `parser`, and
  - In the list of local declarations in a `control`.

Variables have local scope, and behave like stack-allocated variables in
languages such as C. The value of a variable is never preserved from one
invocation of its enclosing block to the next. In particular, variables
cannot be used to maintain state between different network packets.
