To construct a program for the architecture, the P4 program must
instantiate a top-level `package` by passing values for all its
arguments creating a variable called `main` in the top-level namespace.
The types of the arguments must match the types of the parameters—after
a suitable substitution of the type variables. The type substitution can
be expressed directly, using type specialization, or can be inferred by
a compiler, using a unification algorithm like Hindley-Milner.

  - For example, given the following type declarations:  
    Begin P4Example parser Prs<T>(packet\_in b, out T result); control
    Pipe<T>(in T data); package Switch<T>(Prs<T> p, Pipe<T> map);
    
    End P4Example

  - and the following declarations:  
    Begin P4Example parser P(packet\_in b, out bit\<32\> index) { /\*
    body omitted */ } control Pipe1(in bit\<32\> data) { /* body omitted
    */ } control Pipe2(in bit\<8\> data) { /* body omitted \*/ }
    
    End P4Example

  - The following is a legal declaration for the top-level target:  
    Begin P4Example Switch(P(), Pipe1()) main;
    
    End P4Example

  - And the following is illegal:  
    Begin P4Example Switch(P(), Pipe2()) main;
    
    End P4Example

The latter declaration is incorrect because the parser `P` requires `T`
to be `bit<32>`, while `Pipe2` requires `T` to be `bit<8>`.

The user can also explicitly specify values for the type variables
(otherwise the compiler has to infer values for these type variables):

\~ Begin P4Example Switch\<bit\<32\>\>(P(), Pipe1()) main; \~ End
P4Example
