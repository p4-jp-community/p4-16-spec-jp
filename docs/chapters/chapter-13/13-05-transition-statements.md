<a id="sec-transition"></a>
The last statement in a parser state is an optional `transition`
statement, which transfers control to another state, possibly `accept`
or `reject`. A `transition` statements is written using the following
syntax:

```bison
transitionStatement
    : /* empty */
    | TRANSITION stateExpression
    ;

stateExpression
    : name ";"
    | selectExpression
    ;
```

The execution of the transition statement causes `stateExpression` to be
evaluated, and transfers control to the resulting state.

In terms of the `ParserModel`, the semantics of a `transition` statement
can be formalized as follows:

```p4
goto eval(stateExpression)
```

  - For example, this statement:  
    ```p4
transition accept;
```

terminates execution of the current parser and transitions immediately
to the `accept` state.

If the body of a state block does not end with a `transition` statement,
the implied statement is

```p4
transition reject;
```
