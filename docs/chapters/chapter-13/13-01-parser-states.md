<figure id="fig-parserstatemachine">
  <img src="https://p4-jp-community.github.io/p4-16-spec-jp/assets/figs/parserstatemachine.png" alt="Parser FSM structure." style="height: 5cm;">
  <figcaption>
  Parser FSM structure.</figcaption>
</figure>

A P4 parser describes a state machine with one start
state and two final states. The start state is always named `start`. The
two final states are named `accept` (indicating successful parsing) and
`reject` (indicating a parsing failure). The `start` state is part of
the parser, while the `accept` and `reject` states are distinct from the
states provided by the programmer and are logically outside of the
parser. Figure \[\#fig-parserstatemachine\] illustrates the general
structure of a parser state machine.
