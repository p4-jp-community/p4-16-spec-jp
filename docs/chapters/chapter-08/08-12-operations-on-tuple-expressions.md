Tuples can be assigned to other tuples with the same type, passed as
arguments and returned from functions, and can be initialized with tuple
expressions.

\~ Begin P4Example tuple\<bit\<32\>, bool\> x = { 10, false }; \~ End
P4Example

The fields of a tuple can be accessed using array index syntax `x[0]`,
`x[1]`. The indexes *must* be local compile-time known values, to enable
the type-checker to identify the field types statically.

Tuples can be compared for equality using `==` and `!=`; two tuples are
equal if and only if all their fields are respectively equal.

Currently tuple fields are not left-values, even if the tuple itself is.
(I.e. a tuple can only be assigned monolithically, and the field values
cannot be changed individually.) This restriction may be lifted in a
future version of the language.

A tuple expression is written using curly braces, with each element
separated by a comma:

\~ Begin P4Grammar expression … | ‘{’ expressionList ‘}’

  - \[INCLUDE=grammar.mdk:expressionList\]  
    End P4Grammar

The type of a tuple expression is a tuple type (Section
\[\#sec-tuple-types\]). Tuple expressions can be assigned to expressions
of type `tuple`, `struct` or `header`, and can also be passed as
arguments to methods. Tuples may be nested. However, tuple expressions
are not l-values.

For example, the following program fragment uses a tuple expression to
pass several header fields simultaneously to a learning provider:

\~ Begin P4Example extern LearningProvider<T> { LearningProvider(); void
learn(in T data); }

LearningProvider\<tuple\<bit\<48\>, bit\<32\>\>\>() lp;

  - lp.learn( { hdr.ethernet.srcAddr, hdr.ipv4.src } );  
    End P4Example

A tuple may be used to initialize a structure if the tuple has the same
number of elements as fields in the structure. The effect of such an
initializer is to assign the n<sup>th</sup> element of the tuple to the
n<sup>th</sup> field in the structure:

\~ Begin P4Example struct S { bit\<32\> a; bit\<32\> b; } const S x = {
10, 20 }; //a = 10, b = 20 \~ End P4Example

A tuple expression can have an explicit structure or header type
specified, and then it is converted automatically to a structure-valued
expression (see \[\#sec-structure-expressions\]):

\~ Begin P4Example struct S { bit\<32\> a; bit\<32\> b; }

extern void f<T>(in T data);

  - f((S){ 10, 20 }); // automatically converted to f((S){a = 10, b =
    20});  
    End P4Example

Tuple expressions can also be used to initialize variables whose type is
a `tuple` type.

\~ Begin P4Example tuple\<bit\<32\>, bool\> x = { 10, false }; \~ End
P4Example

The empty tuple expression has type `tuple<>` - a tuple with no
components.
