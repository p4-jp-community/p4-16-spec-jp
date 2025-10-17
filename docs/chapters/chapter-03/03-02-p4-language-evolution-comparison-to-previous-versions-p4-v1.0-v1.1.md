\~ Figure { \#fig-p4transition; caption: “Evolution of the language
between versions P4<sub>14</sub> (versions 1.0 and 1.1) and
P4<sub>16</sub>.” } \[p4transition\] \~ \[p4transition\]:
figs/p4transition.png { width: 100%; page-align: forcehere }

Compared to P4<sub>14</sub>, the earlier version of the language,
P4<sub>16</sub> makes a number of significant, backwards-incompatible
changes to the syntax and semantics of the language. The evolution from
the previous version (P4<sub>14</sub>) to the current one
(P4<sub>16</sub>) is depicted in Figure \[\#fig-p4transition\]. In
particular, a large number of language features have been eliminated
from the language and moved into libraries including counters, checksum
units, meters, etc.

Hence, the language has been transformed from a complex language (more
than 70 keywords) into a relatively small core language (less than 40
keywords, shown in Section \[\#sec-p4-keywords\]) accompanied by a
library of fundamental constructs that are needed for writing most P4.

The v1.1 version of P4 introduced a language construct called `extern`
that can be used to describe library elements. Many constructs defined
in the v1.1 language specification will thus be transformed into such
library elements (including constructs that have been eliminated from
the language, such as counters and meters). Some of these `extern`
objects are expected to be standardized, and they will be in the scope
of a future document describing a standard library of P4 elements. In
this document we provide several examples of `extern` constructs.
P4<sub>16</sub> also introduces and repurposes some v1.1 language
constructs for describing the programmable parts of an architecture.
These language constructs are: `parser`, `state`, `control`, and
`package`.

One important goal of the P4<sub>16</sub> language revision is to
provide a *stable* language definition. In other words, we strive to
ensure that all programs written in P4<sub>16</sub> will remain
syntactically correct and behave identically when treated as programs
for future versions of the language. Moreover, if some future version of
the language requires breaking backwards compatibility, we will seek to
provide an easy path for migrating P4<sub>16</sub> programs to the new
version.
