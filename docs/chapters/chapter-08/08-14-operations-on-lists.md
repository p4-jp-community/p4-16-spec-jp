<a id="sec-list-exprs"></a>
The value of a list is written using curly braces, with each element
separated by a comma. The left curly brace is preceded by a `(list<T>)`
where `T` is the list element type. Such a value can be passed as an
argument, e.g. to extern constructor functions.

\~ Begin P4Example struct pair\_t { bit\<16\> a; bit\<32\> b; }

extern E { E(list<pair_t> data); void run(); }

control c() { E((list<pair_t>) {{2, 3}, {4, 5}}) e; apply { e.run(); } }
\~ End P4Example

Additionally, the size of a list can be determined at compile-time
(Section [Compile-time size determination](../chapter-09/index.md#sec-minsizeinbits)).
