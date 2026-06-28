The conditional statement uses standard syntax and semantics familiar
from many programming languages.

However, the condition expression in P4 is required to be a Boolean (and
not an integer).

```bison
conditionalStatement
    : IF "(" expression ")" statement
    | IF "(" expression ")" statement ELSE statement
    ;
```

When several `if` statements are nested, the `else` applies to the
innermost `if` statement that does not have an `else` statement.
