The last statement in a parser state is an optional `transition`
statement, which transfers control to another state, possibly `accept`
or `reject`. A `transition` statements is written using the following
syntax:

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:transitionStatement\]

  - \[INCLUDE=grammar.mdk:stateExpression\]  
    End P4Grammar

The execution of the transition statement causes `stateExpression` to be
evaluated, and transfers control to the resulting state.

In terms of the `ParserModel`, the semantics of a `transition` statement
can be formalized as follows:

\~ Begin P4Example goto eval(stateExpression) \~ End P4Example

  - For example, this statement:  
    Begin P4Example transition accept;
    
    End P4Example

terminates execution of the current parser and transitions immediately
to the `accept` state.

If the body of a state block does not end with a `transition` statement,
the implied statement is

\~ Begin P4Example transition reject; \~ End P4Example
