# 10. Function declarations


Functions can only be declared at the top level and all parameters must
have a direction. P4 functions are modeled after functions as found in
most other programming languages, but the language does not permit
recursive functions.

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:functionDeclaration\]

  - \[INCLUDE=grammar.mdk:functionPrototype\]  
    End P4Grammar

  - Here is an example of a function that returns the maximum of two
    32-bit values:  
    Begin P4Example bit\<32\> max(in bit\<32\> left, in bit\<32\> right)
    { return (left \> right) ? left : right; }
    
    End P4Example

A function returns a value using the `return` statement. A function with
a return type of `void` can simply use the `return` statement with no
arguments. A function with a non-void return type must return a value of
the suitable type on all possible execution paths.

