A `typedef` declaration can be used to give an alternative name to a
type.

```bison
typedefDeclaration
    : optAnnotations TYPEDEF typeRef name ';'
    | optAnnotations TYPEDEF derivedTypeDeclaration name ';'
    ;
```

```p4
typedef bit<32> u32;
typedef struct Point { int<32> x; int<32> y; } Pt;
typedef Empty_h[32] HeaderStack;
```

The two types are treated as synonyms, and all operations that can be
executed using the original type can be also executed using the newly
created type.

If `typedef` is used with a generic type the type must be specialized
with the suitable number of type arguments:

```p4
struct S<T> {
   T field;
}

// typedef S X;  -- illegal: S does not have type arguments
typedef S<bit<32>> X;  // -- legal
```
