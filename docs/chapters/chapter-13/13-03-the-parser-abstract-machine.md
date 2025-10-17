The semantics of a P4 parser can be formulated in terms of an abstract
machine that manipulates a `ParserModel` data structure. This section
describes this abstract machine in pseudo-code.

A parser starts execution in the `start` state and ends execution when
one of the `reject` or `accept` states has been reached.

\~ Begin P4Pseudo ParserModel { error parseError; onPacketArrival(packet
p) { ParserModel.parseError = error.NoError; goto start; } } \~ End
P4Pseudo

An architecture must specify the behavior when the `accept` and `reject`
states are reached. For example, an architecture may specify that all
packets reaching the `reject` state are dropped without further
processing. Alternatively, it may specify that such packets are passed
to the next block after the parser, with intrinsic metadata indicating
that the parser reached the `reject` state, along with the error
recorded.
