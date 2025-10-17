# 12 Statements


Every statement in P4 except block statements must end with a semicolon.
Statements can appear in several places:

  - Within `parser` states
  - Within a `control` block
  - Within an `action`

There are restrictions for the kinds of statements that can appear in
each of these places. For example, `return`s are not supported in
parsers, and `switch` statements are only supported in control blocks.
We present here the most general case, for control blocks.

\~ Begin P4Grammar statement : assignmentOrMethodCallStatement |
conditionalStatement | emptyStatement | blockStatement | exitStatement |
returnStatement | switchStatement ;

  - \[INCLUDE=grammar.mdk:assignmentOrMethodCallStatement\]  
    End P4Grammar

In addition, parsers support a `transition` statement (Section
\[\#sec-transition\]).

--8<-- "chapters/chapter-12/12-01-assignment-statement.md"
--8<-- "chapters/chapter-12/12-02-empty-statement.md"
--8<-- "chapters/chapter-12/12-03-block-statement.md"
--8<-- "chapters/chapter-12/12-04-return-statement.md"
--8<-- "chapters/chapter-12/12-05-exit-statement.md"
--8<-- "chapters/chapter-12/12-06-conditional-statement.md"
--8<-- "chapters/chapter-12/12-07-switch-statement.md"
