Controls and parsers are often instantiated exactly once. As a light
syntactic sugar, control and parser declarations with no constructor
parameters may be applied directly, as if they were an instance. This
has the effect of creating and applying a local instance of that type.

\~ Begin P4Example control Callee(/\* parameters omitted */) { /* body
omitted \*/ }

control Caller(/\* parameters omitted */)(/* parameters omitted */) {
apply { Callee.apply(/* arguments omitted \*/); // Callee is treated as
an instance } } \~ End P4Example

  - The definition of `Caller` is equivalent to the following.  
    Begin P4Example control Caller(/\* parameters omitted */)(/*
    parameters omitted */) { @name(“Callee”) Callee() Callee\_inst; //
    local instance of Callee apply { Callee\_inst.apply(/* arguments
    omitted \*/); // Callee\_inst is applied } }
    
    End P4Example
    
    Begin P4Grammar \[INCLUDE=grammar.mdk:directApplication\]
    
    End P4Grammar

This feature is intended to streamline the common case where a type is
instantiated exactly once.

The second production in the grammar allows direct calls for generic
controls or parsers:

\~ Begin P4Example control Callee<T>(/\* parameters omitted */) { /*
body omitted \*/ }

control Caller(/\* parameters omitted */)(/* parameters omitted */) {
apply { // Callee\<bit\<32\>\> is treated as an instance
Callee\<bit\<32\>\>.apply(/* arguments omitted \*/); } } \~ End
P4Example

For completeness, the behavior of directly invoking the same type more
than once is defined as follows.

  - Direct type invocation in different scopes will result in different
    local instances with different fully-qualified control names.
  - In the same scope, direct type invocation will result in a different
    local instance per invocation—however, instances of the same type
    will share the same global name, via the `@name` annotation. If the
    type contains controllable entities, then invoking it directly more
    than once in the same scope is illegal, because it will produce
    multiple controllable entities with the same fully-qualified control
    name.

See Section \[\#sec-name-annotations\] for details of `@name`
annotations.

No direct invocation is possible for controls or parsers that require
constructor arguments. These need to be instantiated before they are
invoked.
