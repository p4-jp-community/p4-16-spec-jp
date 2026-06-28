<a id="sec-lvalues"></a>
L-values are expressions that may appear on the left side of an
assignment operation or as arguments corresponding to `out` and `inout`
function parameters. An l-value represents a storage reference. The
following expressions are legal l-values:

```bison
prefixedNonTypeName
    : nonTypeName
    | dotPrefix nonTypeName
    ;

lvalue
    : prefixedNonTypeName
    | THIS
    | lvalue "." member
    | lvalue "[" expression "]"
    | lvalue "[" expression ":" expression "]"
    | lvalue "[" expression "+" ":" expression "]"
    | "(" lvalue ")"
    ;
```

<!-- end list -->

  - Identifiers of a base or derived type.
  - Structure, header, and header union field member access operations
    (using the dot notation).
  - References to elements within header stacks (see Section
    [Operations on header stacks](../chapter-08/08-18-operations-on-header-stacks.md#sec-expr-hs)): indexing, and references to `last` and `next`.
  - The result of a bit-slice operator `[m:l]`.

The following is a legal l-value: `headers.stack[4].field`. Note that
method and function calls cannot return l-values.
