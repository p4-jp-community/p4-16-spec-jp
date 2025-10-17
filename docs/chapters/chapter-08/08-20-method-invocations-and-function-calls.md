Method invocations and function calls can be invoked using the following
syntax:

\~ Begin P4Grammar expression : … | expression ‘\<’ realTypeArgumentList
‘\>’ ‘(’ argumentList ‘)’ | expression ‘(’ argumentList ‘)’

\[INCLUDE=grammar.mdk:argumentList\]

\[INCLUDE=grammar.mdk:nonEmptyArgList\]

\[INCLUDE=grammar.mdk:argument\]

\[INCLUDE=grammar.mdk:realTypeArgumentList\]

  - \[INCLUDE=grammar.mdk:realTypeArg\]  
    End P4Grammar

A function call or method invocation can optionally specify for each
argument the corresponding parameter name. It is illegal to use names
only for some arguments: either all or no arguments must specify the
parameter name. Function arguments are evaluated in the order they
appear, left to right, before the function invocation takes place.

\~ Begin P4Example extern void f(in bit\<32\> x, out bit\<16\> y);
bit\<32\> xa = 0; bit\<16\> ya; f(xa, ya); // match arguments by
position f(x = xa, y = ya); // match arguments by name f(y = ya, x =
xa); // match arguments by name in any order //f(x = xa); – error:
enough arguments //f(x = xa, x = ya); – error: argument specified twice
//f(x = xa, ya); – error: some arguments specified by name //f(z = xa, w
= yz); – error: no parameter named z or w //f(x = xa, y = 0); – error: y
must be a left-value \~ End P4Example

The calling convention is copy-in/copy-out (Section
\[\#sec-calling-convention\]). For generic functions the type arguments
can be explicitly specified in the function call. The compiler only
inserts implicit casts for direction `in` arguments to methods or
functions as described in Section \[\#sec-casts\]. The types for all
other arguments must match the parameter types exactly.

The result returned by a function call is discarded when the function
call is used as a statement.

The “don’t care” identifier (`_`) can only be used for an `out`
function/method argument, when the value of returned in that argument is
ignored by subsequent computations. When used in generic functions or
methods, the compiler may reject the program if it is unable to infer a
type for the don’t care argument.
