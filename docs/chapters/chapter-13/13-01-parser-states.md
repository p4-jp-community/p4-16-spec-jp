\~ Figure { \#fig-parserstatemachine; caption: “Parser FSM structure.” }
\[parserstatemachine\] \~ \[parserstatemachine\]:
figs/parserstatemachine.png { height: 5cm; page-align: here }

\[\]{tex-cmd: “”} A P4 parser describes a state machine with one start
state and two final states. The start state is always named `start`. The
two final states are named `accept` (indicating successful parsing) and
`reject` (indicating a parsing failure). The `start` state is part of
the parser, while the `accept` and `reject` states are distinct from the
states provided by the programmer and are logically outside of the
parser. Figure \[\#fig-parserstatemachine\] illustrates the general
structure of a parser state machine.
