# 8. Expressions


This section describes all expressions that can be used in P4, grouped
by the type of value they produce.

  - The grammar production rule for general expressions is as follows:  
    Begin P4Grammar expression : INTEGER | DOTS // DOTS is … |
    STRING\_LITERAL | TRUE | FALSE | prefixedNonTypeName | expression
    ‘\[’ expression ’\]’ | expression ‘\[’ expression ’:’ expression
    ’\]’ | ‘{’ expressionList optTrailingComma ‘}’ | “{\#}” | ‘{’
    kvList optTrailingComma ‘}’ | “{” kvList “,” DOTS optTrailingComma
    “}” | ‘(’ expression ‘)’ | ‘\!’ expression | ‘\~’ expression | ‘-’
    expression | ‘+’ expression | typeName ‘.’ member | ERROR ‘.’ member
    | expression ‘.’ member | expression ’\*’ expression | expression
    ‘/’ expression | expression ‘%’ expression | expression ‘+’
    expression | expression ‘-’ expression | expression ‘|+|’ expression
    | expression ‘|-|’ expression | expression SHL expression // SHL is
    \<\< | expression ‘\>’‘\>’ expression // check that \>\> are
    contiguous | expression LE expression // LE is \<= | expression GE
    expression // GE is \>= | expression ‘\<’ expression | expression
    ‘\>’ expression | expression NE expression // NE is \!= |
    expression EQ expression // EQ is == | expression ‘&’ expression |
    expression ‘^’ expression | expression ‘|’ expression | expression
    PP expression // PP is ++ | expression AND expression // AND is && |
    expression OR expression // OR is || | expression ‘?’ expression ‘:’
    expression | expression ‘\<’ realTypeArgumentList ‘\>’ ‘(’
    argumentList ‘)’ | expression ‘(’ argumentList ‘)’ | namedType ‘(’
    argumentList ‘)’ | ‘(’ typeRef ‘)’ expression ;

\[INCLUDE=grammar.mdk:expressionList\]

\[INCLUDE=grammar.mdk:member\]

\[INCLUDE=grammar.mdk:argumentList\]

\[INCLUDE=grammar.mdk:nonEmptyArgList\]

argument : expression ;

\[INCLUDE=grammar.mdk:typeArg\]

  - \[INCLUDE=grammar.mdk:typeArgumentList\]  
    End P4Grammar

See Appendix \[\#sec-grammar\] for the complete P4 grammar.

This grammar does not indicate the precedence of the various operators.
The precedence mostly follows the C precedence rules, with one change
and some additions. The precedence of the bitwise operators `&` `|` and
`^` is higher than the precedence of relation operators `<`, `<=`, `>`,
`>=`. This is more natural given the addition of a true boolean type in
the type system, as bitwise operators cannot be applied to boolean
types. Concatenation (`++`) has the same precedence as infix addition.
Bit-slicing `a[m:l]` has the same precedence as array indexing (`a[i]`).

In addition to these expressions, P4 also supports `select` expressions
(described in Section \[\#sec-select\]), which may be used only in
parsers.

--8<-- "chapters/chapter-08/08-01-expression-evaluation-order.md"
--8<-- "chapters/chapter-08/08-02-operations-on-error-types.md"
--8<-- "chapters/chapter-08/08-03-operations-on-enum-types.md"
--8<-- "chapters/chapter-08/08-04-operations-on-match-kind-types.md"
--8<-- "chapters/chapter-08/08-05-expressions-on-booleans.md"
--8<-- "chapters/chapter-08/08-06-operations-on-fixed-width-bit-types-unsigned-integers.md"
--8<-- "chapters/chapter-08/08-07-operations-on-fixed-width-signed-integers.md"
--8<-- "chapters/chapter-08/08-08-operations-on-arbitrary-precision-integers.md"
--8<-- "chapters/chapter-08/08-09-concatenation-and-shifts.md"
--8<-- "chapters/chapter-08/08-10-operations-on-variable-size-bit-types.md"
--8<-- "chapters/chapter-08/08-11-casts.md"
--8<-- "chapters/chapter-08/08-12-operations-on-tuple-expressions.md"
--8<-- "chapters/chapter-08/08-13-operations-on-structure-valued-expressions.md"
--8<-- "chapters/chapter-08/08-14-operations-on-lists.md"
--8<-- "chapters/chapter-08/08-15-operations-on-sets.md"
--8<-- "chapters/chapter-08/08-16-operations-on-struct-types.md"
--8<-- "chapters/chapter-08/08-17-operations-on-headers.md"
--8<-- "chapters/chapter-08/08-18-operations-on-header-stacks.md"
--8<-- "chapters/chapter-08/08-19-operations-on-header-unions.md"
--8<-- "chapters/chapter-08/08-20-method-invocations-and-function-calls.md"
--8<-- "chapters/chapter-08/08-21-constructor-invocations.md"
--8<-- "chapters/chapter-08/08-22-operations-on-extern-objects.md"
--8<-- "chapters/chapter-08/08-23-operations-on-types-introduced-by-type.md"
--8<-- "chapters/chapter-08/08-24-operations-on-types-that-are-type-variables.md"
--8<-- "chapters/chapter-08/08-25-reading-uninitialized-values-and-writing-fields-of-invalid-headers.md"
--8<-- "chapters/chapter-08/08-26-initializing-with-default-values.md"
