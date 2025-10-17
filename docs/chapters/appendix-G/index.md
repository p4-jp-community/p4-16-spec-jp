# Appendix G P4 grammar


This is the grammar of P4<sub>16</sub> written using the YACC/bison
language. Absent from this grammar is the precedence of various
operations.

The grammar is actually ambiguous, so the lexer and the parser must
collaborate for parsing the language. In particular, the lexer must be
able to distinguish two kinds of identifiers:

  - Type names previously introduced (`TYPE_IDENTIFIER` tokens)
  - Regular identifiers (`IDENTIFIER` token)

The parser has to use a symbol table to indicate to the lexer how to
parse subsequent appearances of identifiers. For example, given the
following program fragment:

\~ Begin P4Example typedef bit\<4\> t; struct s { /\* body omitted */} t
x; parser p(bit\<8\> b) { /* body omitted \*/ } \~ End P4Example The
lexer has to return the following terminal kinds: \~ Begin P4Example t -
TYPE\_IDENTIFIER s - TYPE\_IDENTIFIER x - IDENTIFIER p -
TYPE\_IDENTIFIER b - IDENTIFIER \~ End P4Example

This grammar has been heavily influenced by limitations of the Bison
parser generator tool.

The `STRING_LITERAL` token corresponds to a string literal enclosed
within double quotes, as described in Section \[\#sec-string-literals\].

All other terminals are uppercase spellings of the corresponding
keywords. For example, `RETURN` is the terminal returned by the lexer
when parsing the keyword return.

\~ Begin P4Grammar \[INCLUDE=“grammar.trimmed.mdk”\] \~ End P4Grammar

1.  an `enum` type used as a field in a `header` must specify a
    underlying type and representation for `enum` elements.

2.  a `struct` or nested `struct` type that has the same properties,
    used as a field in a `header` must contain only `bit<W>`, `int<W>`,
    a serializable `enum`, or a `bool`.

3.  `type B <name>` is allowed for a type name `B` defined via `typedef
    X B` if `type X <name>` is allowed.

4.  The P4Runtime API is defined as a Google Protocol Buffer `.proto`
    file and an accompanying English specification document here:
    <https://github.com/p4lang/p4runtime>

5.  The P4Runtime API is defined as a Google Protocol Buffer `.proto`
    file and an accompanying English specification document here:
    <https://github.com/p4lang/p4runtime>

6.  TDI is the Table Driven Interface. More information can be found
    here: https://github.com/p4lang/tdi

7.  Most existing P4<sub>16</sub> programs today do not use function or
    method calls in table key expressions, and the order of evaluation
    of these key expressions makes no difference in the resulting lookup
    key value. In this overwhelmingly common case, if an implementation
    chooses to insert extra assignment statements to implement
    side-effecting key expressions, but does not insert them when there
    are no side-effecting key expressions, then in typical programs they
    will almost never be inserted.

8.  The P4Runtime API is defined as a Google Protocol Buffer `.proto`
    file and an accompanying English specification document here:
    <https://github.com/p4lang/p4runtime>

