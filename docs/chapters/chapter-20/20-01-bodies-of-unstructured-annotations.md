The flexibility of P4 unstructured annotations comes from the minimal
structure mandated by the P4 grammar: unstructured annotation bodies may
contain any sequence of terminals, so long as parentheses are balanced.
In the following grammar fragment, the `annotationToken` non-terminal
represents any terminal produced by the lexer, including keywords,
identifiers, string and integer literals, and symbols, but excluding
parentheses.

```bison
annotationBody
    : /* empty */
    | annotationBody "(" annotationBody ")"
    | annotationBody annotationToken
    ;
```

Unstructured annotations may impose additional structure on their
bodies, and are not confined to the P4 language. For example, the
P4Runtime specification\[8\] defines a `@pkginfo` annotation that
expects key-value pairs.
