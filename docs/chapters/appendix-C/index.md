# Appendix C P4 reserved annotations


The following table shows all P4 reserved annotations.

|—————|—————————————————-|————————–| | Annotation | Purpose | See
Section | +—————+:—————————————————+:————————-+ | `atomic` | specify
atomic execution | \[\#sec-concurrency\] | | `defaultonly` | action can
only appear in the default action | \[\#sec-table-action-anno\] | |
`hidden` | hides a controllable entity from the control plane |
\[\#sec-name-annotations\] | | `match` | specify `match_kind` of a field
in a `value_set` | \[\#sec-value-set-annotations\] | | `name` | assign
local control-plane name | \[\#sec-name-annotations\] | | `optional` |
parameter is optional | \[\#sec-optional-parameter-annotations\] | |
`tableonly` | action cannot be a default\_action |
\[\#sec-table-action-anno\] | | `deprecated` | Construct has been
deprecated | \[\#sec-deprecated-anno\] | | `pure` | pure function |
\[\#sec-extern-annotations\] | | `noSideEffects` | function with no side
effects | \[\#sec-extern-annotations\] | | `noWarn` | Has a string
argument; inhibits compiler warnings | \[\#sec-nowarn-anno\] |
|—————|—————————————————-|————————–|

