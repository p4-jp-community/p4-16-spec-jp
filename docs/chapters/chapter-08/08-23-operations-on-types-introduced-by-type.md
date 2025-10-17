Values with a type introduced by the `type` keyword provide only a few
operations:

  - assignment to left-values of the same type
  - comparisons for equality and inequality if the original type
    supported such comparisons
  - casts to and from the original type

\~ Begin P4Example type bit\<32\> U32; U32 x = (U32)0; // cast needed
U32 y = (U32) ((bit\<32\>)x + 1); // casts needed for arithmetic
bit\<32\> z = 1; bool b0 = x == (U32)z; // cast needed bool b1 =
(bit\<32\>)x == z; // cast needed bool b2 = x == y; // no cast needed \~
End P4Example
