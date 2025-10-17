A `typedef` declaration can be used to give an alternative name to a
type.

\~ Begin P4Grammar typedefDeclaration : optAnnotations TYPEDEF typeRef
name ‘;’ | optAnnotations TYPEDEF derivedTypeDeclaration name ‘;’ ; \~
End P4Grammar

\~ Begin P4Example typedef bit\<32\> u32; typedef struct Point {
int\<32\> x; int\<32\> y; } Pt; typedef Empty\_h\[32\] HeaderStack; \~
End P4Example

The two types are treated as synonyms, and all operations that can be
executed using the original type can be also executed using the newly
created type.

If `typedef` is used with a generic type the type must be specialized
with the suitable number of type arguments:

\~ Begin P4Example struct S<T> { T field; }

// typedef S X; – illegal: S does not have type arguments typedef
S\<bit\<32\>\> X; // – legal \~ End P4Example
