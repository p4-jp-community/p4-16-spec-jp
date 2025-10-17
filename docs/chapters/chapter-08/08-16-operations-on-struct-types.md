The only operation defined on expressions whose type is a `struct` is
field access, written using dot (“.”) notation—e.g., `s.field`. If `s`
is an l-value, then `s.field` is also an l-value. P4 also allows copying
`struct`s using assignment when the source and target of the assignment
have the same type. Finally, `struct`s can be initialized with a tuple
expression, as discussed in Section \[\#sec-tuple-exprs\], or with a
structure-valued expression, as described in
\[\#sec-structure-expressions\]. Both of these cases must initialize all
fields of the structure. The size of a struct can be determined at
compile-time (Section \[\#sec-minsizeinbits\]).

Two structs can be compared for equality (==) or inequality (\!=) only
if they have the same type and all of their fields can be recursively
compared for equality. Two structures are equal if and only if all their
corresponding fields are equal.

The following example shows a structure initialized in several different
ways:

\~ Begin P4Example struct S { bit\<32\> a; bit\<32\> b; } const S x = {
10, 20 }; // tuple expression const S x = { a = 10, b = 20 }; //
structure-valued expression const S x = (S) { a = 10, b = 20 }; //
structure-valued expression \~ End P4Example

See Section \[\#sec-uninitialized-values-and-writing-invalid-headers\]
for a description of the behavior if `struct` fields are read without
being initialized.
