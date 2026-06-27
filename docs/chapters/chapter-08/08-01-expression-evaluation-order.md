<a id="sec-expr-eval-order"></a>
Given a compound expression, the order in which sub-expressions are
evaluated is important when the sub-expressions have side-effects. P4
expressions are evaluated as follows:

  - Boolean operators `&&` and `||` use short-circuit evaluation—i.e.,
    the second operand is only evaluated if necessary.
  - The conditional operator `e1 ? e2 : e3` evaluates `e1`, and then
    either evaluates `e2` or `e3`.
  - All other expressions are evaluated left-to-right as they appear in
    the source program.
  - Method and function calls are evaluated as described in Section
    [Calling convention: call by copy in/copy out](../chapter-06/06-08-calling-convention-call-by-copy-in-copy-out.md#sec-calling-convention).
