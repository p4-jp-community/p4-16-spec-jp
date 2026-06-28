<a id="sec-match-kind-exprs"></a>
Values of type `match_kind` are similar to `enum` values. They support
only assignment and comparisons for equality and inequality.

```p4
match_kind { fuzzy }
const bool same = exact == fuzzy;  // always 'false'
```
