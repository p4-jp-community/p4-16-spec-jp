As mentioned in Section \[\#sec-expr-hs\], any reference to an element
of a header stack `hs[index]` where `index` is a compile-time known
value must give an error at compile time if the value of the index is
out of range. That section also defines the run time behavior of the
expressions `hs.next` and `hs.last`, and the behaviors specified there
take precedence over anything in this section for those expressions.

All mentions of header stack elements in this section only apply for
expressions `hs[index]` where `index` is not a compile-time known value.
A P4 implementation may elect not to support expressions of the form
`hs[index]` where `index` is not a compile-time known value. However, it
does support such expressions, the implementation should conform to the
behaviors specified in this section.

The result of reading a value in any of the situations below is that
some unspecified value will be used for that field.

  - reading a field from a header that is currently invalid.
  - reading a field from a header that is currently valid, but the field
    has not been initialized since the header was last made valid.
  - reading any other value that has not been initialized, e.g. a field
    from a `struct`, any uninitialized variable inside of an `action` or
    `control`, or an `out` parameter of a `control` or `action` you have
    called, which was not assigned a value during the execution of that
    `control` or `action` (this list of examples is not intended to be
    exhaustive).
  - reading a field of a header that is an element of a header stack,
    where the index is out of range for the header stack.

Calling the `isValid()` method on an element of a header stack, where
the index is out of range, returns an undefined boolean value, i.e., it
is either `true` or `false`, but the specification does not require one
or the other, nor that a consistent value is returned across multiple
such calls. Assigning an out-of-range header stack element to another
header variable `h` leads to a state where `h` is undefined in all of
its field values, and its validity is also undefined.

Where a header is mentioned, it may be a member of a `header_union`, an
element in a header stack, or a normal header. This unspecified value
could differ from one such read to another.

For an uninitialized field or variable with a type of `enum` or `error`,
the unspecified value that is read might not be equal to any of the
values defined for that type. Such an unspecified value should still
lead to predictable behavior in cases where any legal value would match,
e.g. it should match in any of these situations:

  - If used in a `select` expression, it should match `default` or `_`
    in a key set expression.
  - If used as a key with `match_kind` `ternary` in a table, it should
    match a table entry where the field has all bit positions “don’t
    care”.
  - If used as a key with `match_kind` `lpm` in a table, it should match
    a table entry where the field has a prefix length of 0.

Consider a situation where a `header_union` `u1` has member headers
`u1.h1` and `u1.h2`, and at a given point in the program’s execution
`u1.h1` is valid and `u1.h2` is invalid. If a write is attempted to a
field of the invalid member header `u1.h2`, then any or all of the
fields of the valid member header `u1.h1` may change as a result. Such a
write must not change the validity of any member headers of `u1`, nor
any other state that is currently defined in the system, whether it is
defined state in header fields or anywhere else.

If any of these kinds of writes are performed:

  - a write to a field in a currently invalid header, either a regular
    header or an element of a header stack with an index that is in
    range, and that header is not part of a `header_union`
  - a write to a field in an element of a header stack, where the index
    is out of range
  - a method call of `setValid()` or `setInvalid()` on an element of a
    header stack, where the index is out of range

then that write must not change any state that is currently defined in
the system, neither in header fields nor anywhere else. In particular,
if an invalid header is involved in the write, it must remain invalid.

Any writes to fields in a currently invalid header, or to header stack
elements where the index is out of range, are allowed to modify state
whose values are not defined, e.g. the values of fields in headers that
are currently invalid.

For a top level `parser` or `control` in an architecture, it is up to
that architecture to specify whether parameters with direction `in` or
`inout` are initialized when the control is called, and under what
conditions they are initialized, and if so, what their values will be.

Since P4 allows empty tuples and structs, one can construct types whose
values carry no “useful” information, e.g.:

\~Begin P4Example struct Empty { tuple\<\> t; } \~End P4Example

We call the following “empty” types:

  - bitstrings with 0 width
  - varbits with 0 width
  - empty tuples (`tuple<>`)
  - stacks with 0 size
  - structs with no fields
  - a tuple having all fields of an empty type
  - a struct having all fields of an empty type

Values with empty types carry no useful information. In particular, they
do not have to be explicitly initialized to have a legal value.

(Header types with no fields always have a validity bit.)
