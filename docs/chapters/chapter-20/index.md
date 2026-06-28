<a id="sec-annotations"></a>
# 20. Annotations


Annotations are a simple mechanism for extending the P4 language to some
limited degree without changing the grammar. Annotations are attached to
types, fields, variables, etc. using the `@` syntax (as shown explicitly
in the P4 grammar). Unstructured annotations, or just “annotations,”
have an optional body; structured annotations have a mandatory body,
containing at least a pair of square brackets `[]`.

```bison
optAnnotations
    : /* empty */
    | annotations
    ;

annotations
    : annotation
    | annotations annotation
    ;

annotation
    : "@" name
    | "@" name "(" annotationBody ")"
    | "@" name "[" structuredAnnotationBody "]"
    ;
```

Structured annotations and unstructured annotations on any one element
must not use the same `name`. Thus, a given `name` can only be applied
to one type of annotation or the other for any one element. An
annotation used on one element does not affect the annotation on another
because they have different scope.

This is legal:

```p4
@my_anno(1) table T { /* body omitted */ }
@my_anno[2] table U { /* body omitted */ } // OK - different scope than previous
                                           // use of my_anno
```

This is illegal:

```p4
@my_anno(1)
@my_anno[2] table U { /* body omitted */ } // Error - changed type of anno
                                           // on an element
```

Multiple unstructured annotations using the same `name` can appear on a
given element; they are cumulative. Each one will be bound to that
element. In contrast, only one structured annotation using a given
`name` may appear on an element; multiple uses of the same `name` will
produce an error.

This is legal:

```p4
@my_anno(1)
@my_anno(2) table U { /* body omitted */ }  // OK - unstructured annos accumulate
```

This is illegal:

```p4
@my_anno[1]
@my_anno[2] table U { /* body omitted */ } // Error - reused the same structured
                                           // anno on an element
```

--8<-- "chapters/chapter-20/20-01-bodies-of-unstructured-annotations.md"
--8<-- "chapters/chapter-20/20-02-bodies-of-structured-annotations.md"
--8<-- "chapters/chapter-20/20-03-predefined-annotations.md"
--8<-- "chapters/chapter-20/20-04-target-specific-annotations.md"
