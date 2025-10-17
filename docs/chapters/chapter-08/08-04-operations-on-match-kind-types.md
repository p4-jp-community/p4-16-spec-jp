Values of type `match_kind` are similar to `enum` values. They support
only assignment and comparisons for equality and inequality.

\~ Begin P4Example match\_kind { fuzzy } const bool same = exact ==
fuzzy; // always ‘false’ \~ End P4Example
