In some cases, the values that determine the transition from one parser
state to another need to be determined at run time. MPLS is one example
where the value of the MPLS label field is used to determine what
headers follow the MPLS tag and this mapping may change dynamically at
run time. To support this functionality, P4 supports the notion of a
Parser Value Set. This is a named set of values with a run time API to
add and remove values from the set.

Value sets are declared locally within a parser. They should be declared
before being referenced in parser `keysetExpression` and can be used as
a label in a select expression.

  - The syntax for declaring value sets is:  
    Begin P4Grammar \[INCLUDE=grammar.mdk:valueSetDeclaration\]
    
    End P4Grammar

Parser Value Sets support a `size` argument to provide hints to the
compiler to reserve hardware resources to implement the value set. For
example, this parser value set:

\~ Begin P4Example value\_set\<bit\<16\>\>(4) pvs; \~ End P4Example

creates a value\_set of size 4 with entries of type `bit<16>`.

The semantics of the `size` argument is similar to the `size` property
of a table. If a value set has a `size` argument with value `N`, it is
recommended that a compiler should choose a data plane implementation
that is capable of storing `N` value set entries. See “Size property of
P4 tables and parser value sets”
[P4SizeProperty](https://github.com/p4lang/p4-spec/blob/master/p4-16/spec/docs/p4-table-and-parser-value-set-sizes.md)
for further discussion on the implementation of parser value set size.

The value set is populated by the control plane by methods specified in
the P4Runtime specification\[4\].
