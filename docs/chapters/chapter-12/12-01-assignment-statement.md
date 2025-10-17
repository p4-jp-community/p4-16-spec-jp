An assignment, written with the `=` sign, first evaluates its left
sub-expression to an l-value, then evaluates its right sub-expression to
a value, and finally copies the value into the l-value. Derived types
(e.g. `structs`) are copied recursively, and all components of `header`s
are copied, including “validity” bits. Assignment is not defined for
`extern` values.
