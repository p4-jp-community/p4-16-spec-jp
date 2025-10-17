A left-value can be initialized automatically with a default value of
the suitable type using the syntax `...` (see Section
\[\#sec-default-values\]). A value of type `struct`, `header`, or
`tuple` can also be initialized using a mix of explicit values and
default values by using the notation `...` in a tuple expression
initializer; in this case all fields not explicitly initialized are
initialized with default values. When initializing a `struct`, `header`,
and `tuple` with a value containing partially default values using the
`...` notation the three dots must appear last in the initializer.

\~ Begin P4Example struct S { bit\<32\> b32; bool b; }

enum int\<8\> N0 { one = 1, zero = 0, two = 2 }

enum N1 { A, B, C, F }

struct T { S s; N0 n0; N1 n1; }

header H { bit\<16\> f1; bit\<8\> f2; }

N0 n0 = …; // initialize n0 with the default value 0 N1 n1 = …; //
initialize n1 with the default value N1.A S s0 = …; // initialize s0
with the default value { 0, false } S s1 = { 1, … }; // initialize s1
with the value { 1, false } S s2 = { b = true, … }; // initialize s2
with the value { 0, true } T t0 = …; // initialize t0 with the value { {
0, false }, 0, N1.A } T t1 = { s = …, … }; // initialize t1 with the
value { { 0, false }, 0, N1.A } T t2 = { s = … }; // error: no
initializer specified for fields n0 and n1 tuple\<N0, N1\> p = { … }; //
initialize p with default value { 0, N1.A } T t3 = { …, n0 = 2}; //
error: … must be last H h1 = …; // initialize h1 with a header that is
invalid H h2 = { f2=5, … }; // initialize h2 with a header that is
valid, field f1 0, // field f2 5 H h3 = { … }; // initialize h3 with a
header that is valid, field f1 0, field f2 0 \~ End P4Example
