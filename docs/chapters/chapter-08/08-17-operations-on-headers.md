Headers provide the same operations as `struct`s. Assignment between
headers also copies the “validity” header bit.

In addition, headers support the following methods:

  - The method `isValid()` returns the value of the “validity” bit of
    the header.
  - The method `setValid()` sets the header’s validity bit to “true”. It
    can only be applied to an l-value.
  - The method `setInvalid()` sets the header’s validity bit to “false”.
    It can only be applied to an l-value.

Similar to a `struct`, a header object can be initialized with a tuple
expression (see Section \[\#sec-tuple-exprs\]) — the tuple fields are
assigned to the header fields in the order they appear — or with a
structure-valued expression (see Section \[\#sec-ops-on-structs\]). When
initialized the header automatically becomes valid:

\~ Begin P4Example header H { bit\<32\> x; bit\<32\> y; } H h; h = { 10,
12 }; // This also makes the header h valid h = { y = 12, x = 10 }; //
Same effect as above \~ End P4Example

Two headers can be compared for equality (`==`) or inequality (`!=`)
only if they have the same type. Two headers are equal if and only if
they are both invalid, or they are both valid and all their
corresponding fields are equal. Furthermore, the size of a header can be
determined at compile-time (Section \[\#sec-minsizeinbits\]).

The expression `{#}` represents an invalid header of some type, but it
can be any header or header union type. A P4 compiler may require an
explicit cast on this expression in cases where it cannot determine the
particular header or header union type from the context.

\~ Begin P4Grammar expression … | “{\#}” \~ End P4Grammar

  - For example:  
    Begin P4Example header H { bit\<32\> x; bit\<32\> y; } H h; h =
    {\#}; // This make the header h become invalid if (h == {\#}) { //
    This is equivalent to the condition \!h.isValid() // … }
    
    End P4Example

Note that the `#` character cannot be misinterpreted as a preprocessor
directive, since it cannot be the first character on a line when it
occurs in the single lexical token `{#}`, which may not have whitespace
or any other characters between those shown.

See Section \[\#sec-uninitialized-values-and-writing-invalid-headers\]
for a description of the behavior if header fields are read without
being initialized, or header fields are written to a currently invalid
header.
