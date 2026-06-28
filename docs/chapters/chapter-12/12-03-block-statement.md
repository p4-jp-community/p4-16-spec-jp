A block statement is denoted by curly braces. It contains a sequence of
statements and declarations, which are executed sequentially. The
declarations (e.g., variables and constants) within a block statement
are only visible within the block.

```bison
blockStatement
    : optAnnotations "{" statOrDeclList "}"
    ;

statOrDeclList
    : /* empty */
    | statOrDeclList statementOrDeclaration
    ;

statementOrDeclaration
    : variableDeclaration
    | constantDeclaration
    | statement
    ;
```
