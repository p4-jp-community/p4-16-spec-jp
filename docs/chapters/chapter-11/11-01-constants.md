  - Constant values are defined with the syntax:  
    Begin P4Grammar \[INCLUDE=grammar.mdk:constantDeclaration\]

  - \[INCLUDE=grammar.mdk:initializer\]  
    End P4Grammar

Such a declaration introduces a constant whose value has the specified
type. The following are all legal constant declarations:

\~ Begin P4Example const bit\<32\> COUNTER = 32w0x0; struct Version {
bit\<32\> major; bit\<32\> minor; } const Version version = { 32w0, 32w0
}; \~ End P4Example

The `initializer` expression must be a local compile-time known value.
