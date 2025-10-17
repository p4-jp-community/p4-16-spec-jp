One can write expressions that evaluate to a structure or header. The
syntax of these expressions is given by:

\~ Begin P4Grammar expression … | ‘{’ kvList ‘}’ | ‘(’ typeRef ‘)’
expression ;

\[INCLUDE=grammar.mdk:kvList\]

  - \[INCLUDE=grammar.mdk:kvPair\]  
    End P4Grammar

For a structure-valued expression `typeRef` is the name of a `struct` or
`header` type. The `typeRef` can be omitted if it can be inferred from
context, e.g., when initializing a variable with a `struct` type.
Structure-valued expressions that evaluate to a value of some `header`
type are always valid.

The following example shows a structure-valued expression used in an
equality comparison expression:

\~ Begin P4Example struct S { bit\<32\> a; bit\<32\> b; }

S s;

// Compare s with a structure-valued expression bool b = s == (S) { a =
1, b = 2 }; \~ End P4Example

Structure-valued expressions can be used in the right-hand side of
assignments, in comparisons, in field selection expressions, and as
arguments to functions, method or actions. Structure-valued expressions
are not left values.

Structure-valued expressions that do not have `...` as their last
element must provide a value for every member of the struct or header
type to which it evaluates, by mentioning each field name exactly once.

Structure-valued expressions that have `...` as their last element are
allowed to give values to only a subset of the fields of the struct or
header type to which it evaluates. Any field names not given a value
explicitly will be given their default value (see Section
\[\#sec-initializing-with-default-values\]).

The order of the fields of the `struct` or `header` type does not need
to match the order of the values of the structure-valued expression.

It is a compile-time error if a field name appears more than once in the
same structure-valued expression.
