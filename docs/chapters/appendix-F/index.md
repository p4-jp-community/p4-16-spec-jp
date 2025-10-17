# Appendix F Restrictions on compile time and run time calls


This appendix summarizes restrictions on compile time and run time calls
that can be made. Many of them are described earlier in this document,
but are collected here for easy reference.

The stateful types of objects in P4<sub>16</sub> are packages, parsers,
controls, externs, tables, and value-sets. P4<sub>16</sub> functions are
also considered to be in that group, even if they happen to be pure
functions of their arguments. All other types are referred to as “value
types” here.

Some guiding principles:

  - Controls are not allowed to call parsers, and vice versa, so there
    is no use in passing one type to the other in constructor parameters
    or run-time parameters.
  - At run time, after a control is called, and before that call is
    complete, there can be no recursive calls between controls, nor from
    a control to itself. Similarly for parsers. There can be loops among
    states within a single parser.
  - Externs are not allowed to call parsers or controls, so there is no
    use in passing objects of those types to them.
  - Tables are always instantiated directly in their enclosing control,
    and cannot be instantiated at the top level. There is no syntax for
    specifying parameters that are tables. Tables are only intended to
    be used from within the control where they are defined.
  - Value-sets can be instantiated in an enclosing parser or at the top
    level. There is no syntax for specifying parameters that are
    value-sets. Value-sets can be shared between the parsers as long as
    they are in the scope.

A note on recursion: It is expected that some architectures will define
capabilities for recirculating a packet to be processed again as if it
were a newly arriving packet, or to make “clones” of packets that are
then processed by parsers and/or control blocks that the original packet
has already completed. This does not change the notes above on recursion
that apply while a parser or control is executing.

The first table lists restrictions on what types can be passed as
constructor parameters to other types.

|————-|———|——–|———|——–| | | can be a constructor parameter for this type
|||| | |———|——–|———|——–| | This type | package | parser | control |
extern | +————-+:——-:+:——:+:——-:+:——:+ | package | yes | no | no | no |
| parser | yes | yes | no | no | | control | yes | no | yes | no | |
extern | yes | yes | yes | yes | | function | no | no | no | no | |
table | no | no | no | no | | value-set | no | no | no | no | | value
types | yes | yes | yes | yes | |————-|———|——–|———|——–|

The next table lists restrictions on where one may perform
instantiations (see Section \[\#sec-instantiations\]) of different
types. The answer for `package` is always “no” because there is no
“inside a package” where instantiations can be written in
P4<sub>16</sub>. One can definitely make constructor calls and use
instances of stateful types as parameters when instantiating a package,
and restrictions on those types are in the table above.

For externs, one can only specify their interface in P4<sub>16</sub>,
not their implementation. Thus there is no place to instantiate objects
within an extern.

You may declare variables and constants of any of the value types within
a parser, control, or function (see Section \[\#sec-variables\] for more
details). Declaring a variable or constant is not the same as
instantiation, hence the answer “N/A” (for not applicable) in those
table entries. Variables may not be declared at the top level of your
program, but constants may.

|————-|———–|———|———|——–|———|———-| | | can be instantiated in this place
|||||| | |———–|———|———|———|——–|———-| | This type | top level | package |
parser | control | extern | function |
+————-+:———:+:——-:+:——-:+:——-:+:——:+:——–:+
| package | yes | no | no | no | no | no | | parser | no | no | yes | no
| no | no | | control | no | no | no | yes | no | no | | extern | yes |
no | yes | yes | no | no | | function | yes | no | no | no | no | no | |
table | no | no | no | yes | no | no | | value-set | yes | no | yes | no
| no | no | | value types | N/A | N/A | N/A | N/A | N/A | N/A |
|————-|———–|———|———|———|——–|———-|

The next table lists restrictions on what types can be passed as
run-time parameters to other callable things that have run-time
parameters: parsers, controls, externs (including methods and extern
functions), actions, and functions.

|————-|———–|———|———|———|———-| | | can be a run-time parameter to this
callable thing ||||| | |———–|———|———|———|———-| | This type | parser |
control | extern | action | function |
+————-+:———:+:——-:+:——-:+:——-:+:——–:+ |
package | no | no | no | no | no | | parser | no | no | no | no | no | |
control | no | no | no | no | no | | extern | yes | yes | yes | no | no
| | table | no | no | no | no | no | | value-set | no | no | no | no |
no | | action | no | no | no | no | no | | function | no | no | no | no
| no | | value types | yes | yes | yes | yes | yes |
|————-|———–|———|———|———|———-|

Extern method and extern function calls may only return a value that is
a value type, or no value at all (specified by a return type of `void`).

The next table lists restrictions on what kinds of calls can be made
from which places in a P4 program. Calling a parser, control, or table
means invoking its `apply()` method. Calling a value-set means using it
in a select expression. The row for `extern` describes where extern
method calls can be made from.

One way that an extern can be called from the top level of a parser or
control is in an initializer expression for a declared variable,
e.g. `bit<32> x = rand.get();`.

|————-|———–|———|———–|———|——–|———-| | | can be called at run time from
this place in a P4 program |||||| | |———–|———|———–|———|——–|———-| | | |
control | parser or | | | | | | parser | apply | control | | | | | This
type | state | block | top level | action | extern | function |
+————-+:———:+:——-:+:———:+:——-:+:——:+:——–:+ | package | N/A |
N/A | N/A | N/A | N/A | N/A | | parser | yes | no | no | no | no | no |
| control | no | yes | no | no | no | no | | extern | yes | yes | yes |
yes | no | no | | table | no | yes | no | no | no | no | | value-set |
yes | no | no | no | no | no | | action | no | yes | no | yes | no | no
| | function | yes | yes | no | yes | no | yes | | value types | N/A |
N/A | N/A | N/A | N/A | N/A | |————-|———–|———|———–|———|——–|———-|

There may not be any recursion in calls, neither by a thing calling
itself directly, nor mutual recursion.

An extern can never cause any other type of P4 program object to be
called. See Section \[\#sec-calling-convention-justification\].

Actions may be called directly from a control `apply` block.

Note that while the extern row shows that extern methods can be called
from many places, particular externs may have additional restrictions
not listed in this table. Any such restrictions should be documented in
the description for each extern, as part of the documentation for the
architecture that defines the extern.

In many cases, the restriction will be “from a parser state only” or
“from a control apply block or action only”, but it may be even more
restrictive, e.g. only from a particular kind of control block
instantiated in a particular role in an architecture.

