Constant values are defined with the syntax:

```bison
constantDeclaration
: optAnnotations CONST typeRef name "=" initializer ";"
;

initializer
: expression
;
```

Such a declaration introduces a constant whose value has the specified
type. The following are all legal constant declarations:

```p4
const bit<32> COUNTER = 32w0x0;
struct Version {
    bit<32> major;
    bit<32> minor;
}
const Version version = { 32w0, 32w0 };
```

The `initializer` expression must be a local compile-time known value.
