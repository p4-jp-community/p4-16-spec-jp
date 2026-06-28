Unlike unstructured annotations, structured annotations use square
brackets `[...]` and have a restricted format. They are commonly used to
declare custom metadata, consisting of expression lists or key-value
lists but not both. An `expressionList` may be empty or contain a
comma-separated list of member `expression`s. A `kvList` consists of one
or more `kvPair`s, each consisting of a key and a value `expression`.
Note the syntax for `expression` is rich, see Appendix [P4 grammar](../appendix-G/index.md#sec-grammar)
for details.

All `expression`s within a `structuredAnnotationBody` must be
compile-time known values with a result type that is either: `string`,
`int`, or `bool`. In particular, structured `expression`s (e.g. an
`expression` containing an `expressionList`, a `kvList`, etc.) are not
allowed. Note that P4Runtime information (P4Info) may stipulate
additional restrictions. For example, an integer expression might be
limited to 64-bit values.

It is illegal to duplicate a `key` within the `kvList` of a structured
annotation.

```bison
structuredAnnotationBody
    : expressionList optTrailingComma
    | kvList optTrailingComma
    ;
...
expressionList
    : /* empty */
    | expression
    | expressionList "," expression
    ;
...
kvList
    : kvPair
    | kvList "," kvPair
    ;

kvPair
    : name "=" expression
    ;
```

### Structured Annotation Examples

**Empty Expression List**

  - The following example produces an empty annotation:  
    ```p4
@Empty[]
table t {
    /* body omitted */
}
```

**Mixed Expression List**

The following example will produce an effective expression list as
follows:

    [1,"hello",true, false, 11]

```p4
#define TEXT_CONST "hello"
#define NUM_CONST 6
@MixedExprList[1,TEXT_CONST,true,1==2,5+NUM_CONST]
table t {
    /* body omitted */
}
```

  - **kvList of Strings**  
    ```p4
@Labels[short="Short Label", hover="My Longer Table Label to appear in hover-help"]
table t {
    /* body omitted */
}
```

**kvList of Mixed Expressions**

The following example will produce an effective kvList as follows.

    [label="text", my_bool=true, int_val=6]

```p4
@MixedKV[label="text", my_bool=true, int_val=2*3]
table t {
    /* body omitted */
}
```

**Illegal Mixing of `kvPair` and `expressionList`**

The following example is invalid because the body contains both a
`kvPair` and an `expression`:

```p4
@IllegalMixing[key=4, 5] // illegal mixing
table t {
    /* body omitted */
}
```

**Illegal Duplicate Key**

  - The following example is invalid because the same key occurs more
    than once:  
    ```p4
@DupKey[k1=4,k1=5] // illegal duplicate key
table t {
    /* body omitted */
}
```

**Illegal Duplicate Structured Annotation**

The following example is invalid because the annotation `name` occurs
more than once on the same element, e.g. `table t`:

```p4
@DupAnno[k1=4]
@DupAnno[k2=5] // illegal duplicate name
table t {
    /* body omitted */
}
```

**Illegal Simultaneous Use of Both Structured and Unstructured
Annotation**

The following example is invalid because the annotation `name` is used
by both an unstructured and structured annotation on the same element
`table t`:

```p4
@MixAnno("Anything")
@MixAnno[k2=5] // illegal use in both annotation types
table t {
    /* body omitted */
}
```
