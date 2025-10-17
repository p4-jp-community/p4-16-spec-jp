Because functions, methods, control, and parsers can be generic, they
offer the possibility of declaring values with types that are type
variables:

\~ Begin P4Example control C<T>() { apply { T x; // the type of x is T,
a type variable } } \~ End P4Example

The type of such objects is not known until the control is instantiated
with specific type arguments.

Currently the only operations that are available for such values are
assignment (explicit through `=`, or implicit, through argument
passing). This behavior is similar to languages such as Java, and
different from languages such as C++.

A future version of P4 may introduce a notion of *type constraints*
which would enable more operations on such values. Because of this
limitation, such values are currently of limited utility.
