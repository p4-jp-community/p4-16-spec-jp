  - The `switch` statement can only be used within `control` blocks.  
    Begin P4Grammar \[INCLUDE=grammar.mdk:switchStatement\]

\[INCLUDE=grammar.mdk:switchCases\]

\[INCLUDE=grammar.mdk:switchCase\]

\[INCLUDE=grammar.mdk:switchLabel\]

  - \[INCLUDE=grammar.mdk:nonBraceExpression\]  
    End P4Grammar

The `nonBraceExpression` is the same as `expression` as defined in
Section \[\#sec-exprs\], except it does not include any cases that can
begin with a left brace `{` character, to avoid syntactic ambiguity with
a block statement.

There are two kinds of `switch` expressions allowed, described
separately in the following two subsections.

### Switch statement with `action_run` expression

For this variant of `switch` statement, the expression must be of the
form `t.apply().action_run`, where `t` is the name of a table (see
Section \[\#sec-invoke-mau\]). All switch labels must be names of
actions of the table `t`, or `default`.

\~ Begin P4Example switch (t.apply().action\_run) { action1: //
fall-through to action2: action2: { /\* body omitted */ } action3: { /*
body omitted */ } // no fall-through from action2 to action3 labels
default: { /* body omitted \*/ } } \~ End P4Example

Note that the `default` label of the `switch` statement is used to match
on the kind of action executed, no matter whether there was a table hit
or miss. The `default` label does not indicate that the table missed and
the `default_action` was executed.

### Switch statement with integer or enumerated type expression

For this variant of `switch` statement, the expression must evaluate to
a result with one of these types:

  - `bit<W>`
  - `int<W>`
  - `enum`, either with or without an underlying representation
    specified
  - `error`

All switch labels must be expressions with compile-time known values,
and must have a type that can be implicitly cast to the type of the
`switch` expression (see Section \[\#sec-implicit-casts\]). Switch
labels must not begin with a left brace character `{`, to avoid
ambiguity with a block statement.

\~ Begin P4Example // Assume the expression hdr.ethernet.etherType has
type bit\<16\> switch (hdr.ethernet.etherType) { 0x86dd: { /\* body
omitted */ } 0x0800: // fall-through to the next body 0x0802: { /* body
omitted */ } 0xcafe: { /* body omitted */ } default: { /* body omitted
\*/ } } \~ End P4Example

### Notes common to all switch statements

It is a compile-time error if two labels of a `switch` statement equal
each other. The switch label values need not include all possible values
of the switch expression. It is optional to have a `switch` case with
the `default` label, but if one is present, it must be the last one in
the `switch` statement.

If a switch label is not followed by a block statement, it falls through
to the next label. However, if a block statement is present, it does not
fall through. Note that this is different from C-style `switch`
statements, where a `break` is needed to prevent fall-through. If the
last switch label is not followed by a block statement, the behavior is
the same as if the last switch label were followed by an empty block
statement `{ }`.

When a `switch` statement is executed, first the switch expression is
evaluated, and any side effects from evaluating this expression are
visible to any `switch` case that is executed. Among switch labels that
are not `default`, at most one of them can equal the value of the switch
expression. If one is equal, that switch case is executed.

If no labels are equal to the `switch` expression, then:

  - if there is a `default` label, the case with the `default` label is
    executed.
  - if there is no `default` label, then no switch case is executed, and
    execution continues after the end of the `switch` statement, with no
    side effects (except any that were caused by evaluating the `switch`
    expression).

See “Implementing generalized P4\_16 switch statements”
[GeneralizedSwitchStatements](https://github.com/p4lang/p4-spec/blob/master/p4-16/spec/docs/implementing-generalized-switch-statements.md)
for possible techniques that one might use to implement generalized
switch statements.
