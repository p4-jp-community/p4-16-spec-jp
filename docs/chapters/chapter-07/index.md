# 7 P4 data types


P4<sub>16</sub> is a statically-typed language. Programs that do not
pass the type checker are considered invalid and rejected by the
compiler. P4 provides a number of base types as well as type operators
that construct derived types. Some values can be converted to a
different type using casts. However, to make user intents clear,
implicit casts are only allowed in a few circumstances and the range of
casts available is intentionally restricted.

--8<-- "chapters/chapter-07/07-01-base-types.md"
--8<-- "chapters/chapter-07/07-02-derived-types.md"
--8<-- "chapters/chapter-07/07-03-default-values.md"
--8<-- "chapters/chapter-07/07-04-numeric-types.md"
--8<-- "chapters/chapter-07/07-05-typedef.md"
--8<-- "chapters/chapter-07/07-06-introducing-new-types.md"
