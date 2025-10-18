# 18. P4 abstract machine: Evaluation


The evaluation of a P4 program is done in two stages:

  - **static evaluation**: at compile time the P4 program is analyzed
    and all stateful blocks are instantiated.
  - **dynamic evaluation**: at runtime each P4 functional block is
    executed to completion, in isolation, when it receives control from
    the architecture

--8<-- "chapters/chapter-18/18-01-compile-time-known-and-local-compile-time-known-values.md"
--8<-- "chapters/chapter-18/18-02-compile-time-evaluation.md"
--8<-- "chapters/chapter-18/18-03-control-plane-names.md"
--8<-- "chapters/chapter-18/18-04-dynamic-evaluation.md"
