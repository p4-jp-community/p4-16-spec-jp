<a id="sec-p4-reserved-annotations"></a>
# Appendix C P4 reserved annotations


The following table shows all P4 reserved annotations.

|—————|—————————————————-|————————–| | Annotation | Purpose | See
Section | +—————+:—————————————————+:————————-+ | `atomic` | specify
atomic execution | [Concurrency model](../chapter-18/18-04-dynamic-evaluation.md#sec-concurrency) | | `defaultonly` | action can
only appear in the default action | [Annotations on the table action list](../chapter-20/20-03-predefined-annotations.md#sec-table-action-anno) | |
`hidden` | hides a controllable entity from the control plane |
[Annotations controlling naming](../chapter-18/18-03-control-plane-names.md#sec-name-annotations) | | `match` | specify `match_kind` of a field
in a `value_set` | [Value set annotations](../chapter-20/20-03-predefined-annotations.md#sec-value-set-annotations) | | `name` | assign
local control-plane name | [Annotations controlling naming](../chapter-18/18-03-control-plane-names.md#sec-name-annotations) | | `optional` |
parameter is optional | [Optional parameter annotations](../chapter-20/20-03-predefined-annotations.md#sec-optional-parameter-annotations) | |
`tableonly` | action cannot be a default\_action |
[Annotations on the table action list](../chapter-20/20-03-predefined-annotations.md#sec-table-action-anno) | | `deprecated` | Construct has been
deprecated | [Deprecated annotation](../chapter-20/20-03-predefined-annotations.md#sec-deprecated-anno) | | `pure` | pure function |
[Extern function/method annotations](../chapter-20/20-03-predefined-annotations.md#sec-extern-annotations) | | `noSideEffects` | function with no side
effects | [Extern function/method annotations](../chapter-20/20-03-predefined-annotations.md#sec-extern-annotations) | | `noWarn` | Has a string
argument; inhibits compiler warnings | [No warnings annotation](../chapter-20/20-03-predefined-annotations.md#sec-nowarn-anno) |
|—————|—————————————————-|————————–|

