The `verify` statement provides a simple form of error handling.
`verify` can only be invoked within a parser; it is used syntactically
as if it were a function with the following signature:

\~ Begin P4Example extern void verify(in bool condition, in error err);
\~ End P4Example

If the first argument is `true`, then executing the statement has no
side-effect. However, if the first argument is `false`, it causes an
immediate transition to `reject`, which causes immediate parsing
termination; at the same time, the `parserError` associated with the
parser is set to the value of the second argument.

In terms of the `ParserModel` the semantics of a `verify` statement is
given by:

\~ Begin P4Pseudo ParserModel.verify(bool condition, error err) { if
(condition == false) { ParserModel.parserError = err; goto reject; } }
\~ End P4Pseudo
