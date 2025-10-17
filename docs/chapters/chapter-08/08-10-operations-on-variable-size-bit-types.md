To support parsing headers with variable-length fields, P4 offers a type
`varbit`. Each occurrence of the type `varbit` has a statically-declared
maximum width, as well as a dynamic width, which must not exceed the
static bound. Prior to initialization a variable-size bit-string has an
unknown dynamic width.

Variable-length bit-strings support a limited set of operations:

  - Assignment to another variable-sized bit-string. The target of the
    assignment must have the same static width as the source. When
    executed, the assignment sets the dynamic width of the target to the
    dynamic width of the source.
  - Comparison for equality or inequality with another `varbit` field.
    Two `varbit` fields can be compared only if they have the same type.
    Two varbits are equal if they have the same dynamic width and all
    the bits up to the dynamic width are the same.

The following operations are *not* supported directly on a value of type
`varbit`, but instead on any type for which `extract` and `emit`
operations are supported (e.g. a value with type header) that may
contain a field of type `varbit`. They are mentioned here only to ease
finding this information in a section dedicated to type `varbit`.

  - Parser extraction into a header containing a variable-sized
    bit-string using the two-argument `extract` method of a `packet_in`
    extern object (see Section \[\#sec-packet-extract-two\]). This
    operation sets the dynamic width of the field.
  - The `emit` method of a `packet_out` extern object can be performed
    on a header and a few other types (see Section \[\#sec-deparse\])
    that contain a field with type `varbit`. Such an `emit` method call
    inserts a variable-sized bit-string with a known dynamic width into
    the packet being constructed.

Additionally, the maximum size of a variable-length bit-string can be
determined at compile-time (Section \[\#sec-minsizeinbits\]).
