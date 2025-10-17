Several P4 constructs denote resources that are allocated at compilation
time:

  - `extern` objects
  - `parser`s
  - `control` blocks
  - `package`s

Allocation of such objects can be performed in two ways:

  - Using constructor invocations, which are expressions that return an
    object of the corresponding type.
  - Using instantiations, described in Section \[\#sec-instantiations\].

The syntax for a constructor invocation is similar to a function call;
constructors can also be called using named arguments. Constructors are
evaluated entirely at compilation time (see Section
\[\#sec-p4-abstract-mach\]). In consequence, all constructor arguments
must also be expressions that can be evaluated at compilation time. When
performing type inference and overload resolution, constructor
invocations are treated similar to methods or functions.

The following example shows a constructor invocation for setting the
target-dependent implementation property of a table:

\~ Begin P4Example extern ActionProfile { ActionProfile(bit\<32\> size);
// constructor } table tbl { actions = { /\* body omitted \*/ }
implementation = ActionProfile(1024); // constructor invocation } \~ End
P4Example
