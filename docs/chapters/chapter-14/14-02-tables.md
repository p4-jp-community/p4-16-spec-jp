\~ Figure { \#fig-maudataflow; caption: “Match-Action Unit Dataflow.” }
\[maudataflow\] \~ \[maudataflow\]: figs/maudataflow.png { width: 80%;
page-align: here }

A `table` describes a match-action unit. The structure of a match-action
unit is shown in Figure \[\#fig-maudataflow\]. Processing a packet using
a match-action table executes the following steps:

  - Key construction.
  - Key lookup in a lookup table (the “match” step). The result of key
    lookup is an “action”.
  - Action execution (the “action step”) over the input data, resulting
    in mutations of the data.

A `table` declaration introduces a table instance. To obtain multiple
instances of a table, it must be declared within a control block that is
itself instantiated multiple times.

The look-up table is a finite map whose contents are manipulated
asynchronously (read/write) by the target control plane, through a
separate control-plane API (see Figure \[\#fig-maudataflow\]). Note that
the term “table” is overloaded: it can refer to the P4 `table` objects
that appear in P4 programs, as well as the internal look-up tables used
in targets. We will use the term “match-action unit” when necessary to
disambiguate.

Syntactically a table is defined in terms of a set of key-value
properties. Some of these properties are “standard” properties, but the
set of properties can be extended by target-specific compilers as
needed. Note duplicated properties are invalid and the compiler should
reject them.

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:tableDeclaration\]

\[INCLUDE=grammar.mdk:tablePropertyList\]

tableProperty : KEY ‘=’ ‘{’ keyElementList ‘}’ | ACTIONS ‘=’ ‘{’
actionList ‘}’ | optAnnotations optCONST ENTRIES ‘=’ ‘{’ entriesList ‘}’
| optAnnotations optCONST nonTableKwName ‘=’ initializer ‘;’ ;

  - \[INCLUDE=grammar.mdk:nonTableKwName\]  
    End P4Grammar

The standard table properties include:

  - `key`: An expression that describes how the key used for look-up is
    computed.
  - `actions`: A list of all actions that may be found in the table.

In addition, the tables may optionally define the following properties,

  - `default_action`: an action to execute when the lookup in the lookup
    table fails to find a match for the key used.
  - `size`: an integer specifying the desired size of the table.
  - `entries`: entries that are initially added to a table when the P4
    program is loaded, some or all of which may be unchangeable by the
    control plane software.
  - `largest_priority_wins` - Only useful for some tables with the
    `entries` property. See section \[\#sec-entries\] for details.
  - `priority_delta` - Only useful for some tables with the `entries`
    property. See section \[\#sec-entries\] for details.

The compiler must set the `default_action` to `NoAction` (and also
insert it into the list of `actions`) for tables that do not define the
`default_action` property. Hence, all tables can be thought of as having
a `default_action` property, either implicitly or explicitly.

In addition, tables may contain architecture-specific properties (see
Section \[\#sec-additional-table-properties\]).

A property marked as `const` cannot be changed dynamically by the
control plane. The `key`, `actions`, and `size` properties cannot be
modified so the `const` keyword is not needed for these.

### Table properties

#### Keys

The `key` is a table property which specifies the data-plane values that
should be used to look up an entry. A key is a list of pairs of the form
`(e : m)`, where `e` is an expression that describes the data to be
matched in the table, and `m` is a `match_kind` that describes the
algorithm used to perform the lookup (see Section
\[\#sec-match-kind-type\]).

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:keyElementList\]

  - \[INCLUDE=grammar.mdk:keyElement\]  
    End P4Grammar

  - For example, consider the following program fragment:  
    Begin P4Example table Fwd { key = { ipv4header.dstAddress : ternary;
    ipv4header.version : exact; } // more fields omitted }
    
    End P4Example

Here the key comprises two fields from the `ipv4header` header:
`dstAddress` and `version`. The `match_kind` elements serve three
purposes:

  - They specify the algorithm used to match data-plane values against
    the entries in the table at runtime.
  - They are used to synthesize the control-plane API that is used to
    populate the table.
  - They are used by the compiler back-end to allocate resources for the
    implementation of the table.

<!-- end list -->

  - The P4 core library contains three predefined `match_kind`
    identifiers:  
    Begin P4Example match\_kind { exact, ternary, lpm }
    
    End P4Example

These identifiers correspond to the P4<sub>14</sub> match kinds with the
same names. The semantics of these match kinds is actually not needed to
describe the behavior of the P4 abstract machine; how they are used
influences only the control-plane API and the implementation of the
look-up table. From the point of view of the P4 program, a look-up table
is an abstract finite map that is given a key and produces as a result
either an action or a “miss” indication, as described in Section
\[\#sec-mau-semantics\].

The expected meaning of these values is as follows:

  - an `exact` match kind on a key field means that the value of the
    field in the table specifies exactly the value the lookup key field
    must have in order to match. This is applicable for all legal key
    fields whose types support equality comparisons.

  - a `ternary` match kind on a key field means that the field in the
    table specifies a set of values for the key field using a value and
    a mask. The meaning of the `(value, mask)` pair is similar to the P4
    mask expressions, as described in Section \[\#sec-cubes\]: a key
    field `k` matches the table entry when `k & mask == value & mask`.

  - a `lpm` (longest prefix match) match kind on a key field is a
    specific type of `ternary` match where the mask is required to have
    a form in binary that is a contiguous set of 1 bits followed by a
    contiguous set of 0 bits. Masks with more 1 bits have automatically
    higher priorities. A mask with all bits 0 is legal.

Some table entries, in particular the ones with at least one `ternary`
field, also require a priority value. A priority is a numeric value
which is used to break ties when a particular key belongs to multiple
sets. When table entries are specified in the P4 program the priorities
are generated by the compiler; when entries are specified by the
control-plane, the priority may need to be explicitly specified. Entries
with higher priority are matched first. This specification does not
mandate whether “higher” priorities are represented by higher or lower
numeric values; this choice is left to the target implementation.

An example specifying entries for a table is given in Section
\[\#sec-entries\].

If a table has no `key` property, or if the value of its `key` property
is the empty tuple, i.e. `key = {}`, then it contains no look-up table,
just a default action—i.e., the associated lookup table is always the
empty map.

Each key element can have an optional `@name` annotation which is used
to synthesize the control-plane-visible name for the key field.

Note some implementations might only support a limited number of keys or
a limited combinations of match\_kind for the keys. The implementation
should reject those cases with an error message in this case.

#### Actions

A table must declare all possible actions that may appear within the
associated lookup table or in the default action. This is done with the
`actions` property; the value of this property is always an
`actionList`:

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:actionList\]

  - \[INCLUDE=grammar.mdk:actionRef\]  
    End P4Grammar

To illustrate, recall the example Very Simple Switch program in Section
\[\#sec-vss-all\]:

\~ Begin P4Example action Drop\_action() { outCtrl.outputPort =
DROP\_PORT; }

action Rewrite\_smac(EthernetAddress sourceMac) {
headers.ethernet.srcAddr = sourceMac; }

table smac { key = { outCtrl.outputPort : exact; } actions = {
Drop\_action; Rewrite\_smac; } } \~ End P4Example

  - The entries in the `smac` `table` may contain two different actions:
    `Drop_action` and `Rewrite_mac`.
  - The `Rewrite_smac` action has one parameter, `sourceMac`, which in
    this case will be provided by the control plane.

Each action in the list of actions for a table must have a distinct
name—e.g., the following program fragment is illegal:

\~ Begin P4Example action a() {} control c() { action a() {} // Illegal
table: two actions with the same name table t { actions = { a; .a; } } }
\~ End P4Example

Each action parameter that has a direction (`in`, `inout`, or `out`)
must be bound in the `actions` list specification; conversely, no
directionless parameters may be bound in the list. The expressions
supplied as arguments to an `action` are not evaluated until the action
is invoked. Applying tables, whether directly via an expression like
`table1.apply().hit`, or indirectly, are forbidden in the expressions
supplied as action arguments.

\~ Begin P4Example action a(in bit\<32\> x) { /\* body omitted */ }
bit\<32\> z; action b(inout bit\<32\> x, bit\<8\> data) { /* body
omitted \*/ } table t { actions = { // a; – illegal, x parameter must be
bound a(5); // binding a’s parameter x to 5 b(z); // binding b’s
parameter x to z // b(z, 3); – illegal, cannot bind directionless data
parameter // b(); – illegal, x parameter must be bound //
a(table2.apply().hit ? 5 : 3); – illegal, cannot apply a table here } }
\~ End P4Example

#### Default action

The default action for a table is an action that is invoked
automatically by the match-action unit whenever the lookup table does
not find a match for the supplied key.

If present, the `default_action` property *must* appear after the
`action` property. It may be declared as `const`, indicating that it
cannot be changed dynamically by the control-plane. The `default action`
*must* be one of the actions that appear in the actions list. In
particular, the expressions passed as `in`, `out`, or `inout` parameters
must be syntactically identical to the expressions used in one of the
elements of the `actions` list.

For example, in the above `table` we could set the default action as
follows (marking it also as constant):

\~ Begin P4Example const default\_action =
Rewrite\_smac(48w0xAA\_BB\_CC\_DD\_EE\_FF); \~ End P4Example

Note that the specified default action must supply arguments for the
control-plane-bound parameters (i.e., the directionless parameters),
since the action is synthesized at compilation time. The expressions
supplied as arguments for parameters with a direction (`in`, `inout`, or
`out`) are evaluated when the action is invoked while the expressions
supplied as arguments for directionless parameters are evaluated at
compile time.

Continuing the example from the previous section, the following are
several legal and illegal specifications of default actions for the
`table t`:

\~ Begin P4Example default\_action = a(5); // OK - no control-plane
parameters // default\_action = a(z); – illegal, a’s x parameter is
already bound to 5 default\_action = b(z,8w8); // OK - bind b’s data
parameter to 8w8 // default\_action = b(z); – illegal, b’s data
parameter is not bound // default\_action = b(x, 3); – illegal: x
parameter of b bound to x instead of z \~ End P4Example

#### Entries

While table entries are typically installed by the control plane, tables
may also be initialized at compile time with a set of entries.

Declaring these entries with `const entries` is useful in situations
where tables are used to implement fixed algorithms—defining table
entries statically enables expressing these algorithms directly in P4,
which allows the compiler to infer how the table is actually used and
potentially make better allocation decisions for targets with limited
resources.

Declaring entries with `entries` (without the `const` qualifier) enables
one to specify a mix of some immutable entries that are always in the
table, and some mutable entries that the control plane is allowed to
later change or remove.

Entries declared in the P4 source are installed in the table when the
program is loaded onto the target. Entries cannot be specified for a
table with no key (see Sec. \[\#sec-table-keys\]).

  - Table entries are defined using the following syntax:  
    Begin P4Grammar tableProperty
    
    optAnnotations optCONST ENTRIES ‘=’ ‘{’ entriesList ‘}’ ;

\[INCLUDE=grammar.mdk:entriesList\]

\[INCLUDE=grammar.mdk:optCONST\]

\[INCLUDE=grammar.mdk:entryPriority\]

  - \[INCLUDE=grammar.mdk:entry\]  
    End P4Grammar

Table entries defined using `const entries` are immutable—i.e., they can
only be read by the control plane. The control plane is not allowed to
remove or modify any entries defined within `const entries`, nor is it
allowed to add entries to such a table. It is allowed for individual
entries to have the `const` keyword before them, but this is redundant
when the entries are declared using `const entries`.

Table entries defined using `entries` (without a `const` qualifier
before it) may have `const` before them, or not, independently for each
entry. Entries with `const` before them may not be modified or removed
by the control plane. Entries without `const` may be modified or removed
by the control plane. It is permitted for the control plane to add
entries to such a table (subject to table capacity limitations), unlike
tables declared with `const entries`.

Whether the control plane is allowed to modify a table’s default action
at run time is determined by the table’s `default_action` table property
(see Section \[\#sec-default-action\]), independently of whether the
control plane is allowed to modify the entries of the table.

The `keysetExpression` component of an entry is a tuple that must
provide a field for each key in the table keys (see Sec.
\[\#sec-table-props\]). The table key type must match the type of the
element of the set. The `actionRef` component must be an action which
appears in the table actions list (and must not have the `@defaultonly`
annotation), with all its arguments bound.

If no entry priorities are specified in the source code, and if the
runtime API requires a priority for the entries of a table—e.g. when
using the P4 Runtime API, tables with at least one `ternary` search key
field—then the entries are matched in program order, stopping at the
first matching entry. Architectures should define the significance of
entry order (if any) for other kinds of tables.

Depending on the `match_kind` of the keys, key set expressions may
define one or multiple entries. The compiler will synthesize the correct
number of entries to be installed in the table. Target constraints may
further restrict the ability of synthesizing entries. For example, if
the number of synthesized entries exceeds the table size, the compiler
implementation may choose to issue a warning or an error, depending on
target capabilities.

  - To illustrate, consider the following example:  
    Begin P4Example header hdr { bit\<8\> e; bit\<16\> t; bit\<8\> l;
    bit\<8\> r; bit\<1\> v; }

struct Header\_t { hdr h; } struct Meta\_t {}

control ingress(inout Header\_t h, inout Meta\_t m, inout
standard\_metadata\_t standard\_meta) {

    action a() { standard_meta.egress_spec = 0; }
    action a_params(bit<9> x) { standard_meta.egress_spec = x; }
    
    table t_exact_ternary {
    
    key = {
            h.h.e : exact;
            h.h.t : ternary;
        }
    
    actions = {
            a;
            a_params;
        }
    
    default_action = a;
    
        const entries = {
            (0x01, 0x1111 &&& 0xF   ) : a_params(1);
            (0x02, 0x1181           ) : a_params(2);
            (0x03, 0x1111 &&& 0xF000) : a_params(3);
            (0x04, 0x1211 &&& 0x02F0) : a_params(4);
            (0x04, 0x1311 &&& 0x02F0) : a_params(5);
            (0x06, _                ) : a_params(6);
            _                         : a;
        }
    }

  - }  
    End P4Example

In this example we define a set of 7 entries, all of which invoke action
`a_params` except for the final entry which invokes action `a`. Once the
program is loaded, these entries are installed in the table in the order
they are enumerated in the program.

##### Entry priorities

If a table has fields where their `match_kind`s are all `exact` or
`lpm`, there is no reason to assign numeric priorities to its entries.
If they are all `exact`, duplicate keys are not allowed, and thus every
lookup key can match at most one entry, so there is no need for a
tiebreaker. If there is an `lpm` field, the priority of the entry
corresponds to the length of the prefix, i.e. if a lookup key matches
multiple prefixes, the longest prefix is always the winner.

For tables with other `match_kind` values, e.g. at least one `ternary`
field, in general it is possible to install multiple entries such that
the same lookup key can match the key of multiple entries installed into
the table at the same time. Control plane APIs such as P4Runtime
API\[5\] and TDI\[6\] require control plane software to provide a
numeric priority with each entry added to such a table. This enables the
data plane to determine which of several matching entries is the
“winner”, i.e. the one entry whose action is invoked.

Unfortunately there are two commonly used, but different, ways of
interpreting numeric priority values.

The P4Runtime API requires numeric priorities to be positive integers,
i.e. 1 or larger, and defines that entries with larger priorities must
win over entries with smaller priorities. We will call this convention
`largest_priority_wins`.

TDI requires numeric priorities to be non-negative integers, i.e. 0 or
larger, and defines that entries with smaller priorities must win over
entries with larger priorities. We will call this convention
`smallest_priority_wins`.

We wish to support either of these conventions when developers specify
priorities for initial table entries in the program. Thus there is a
table property `largest_priority_wins`. If explicitly specified for a
table, its value must be boolean. If `true`, then the priority values
use the `largest_priority_wins` convention. If `false`, then the
priority values use the `smallest_priority_wins` convention. If the
table property is not present at all, then the default convention is
`true`, corresponding to `largest_priority_wins`.

We also wish to support developers that want the convenience of
predictable entry priority values automatically selected by the
compiler, without having to write them in the program, plus the ability
to specify entry priorities explicitly, if they wish.

In some cases, developers may wish the initial priority values to have
“gaps” between their values, to leave room for possible later
insertion of new entries between two initial entries. They can achieve
this by explicitly specifying all priority values, of course, but as a
convenience we define the table property `priority_delta` to be a
positive integer value, with a default value of 1 if not specified for a
table, to use as a default difference between the priorities of
consecutive entries.

There are two steps that occur at compile time for a table with the
`entries` property involving entry priorities:

  - Determine the value of the priority of every entry in the `entries`
    list.
  - Issue any errors or warnings that are appropriate for these priority
    values. Warnings may be suppressed via an appropriate `@noWarn`
    annotation.

These steps are performed independently for each table with the
`entries` property, and each is described in more detail below.

In general, if the developer specifies a priority value for an entry,
that is the value that will be used.

If the developer does not specify priority values for any entry, then
the compiler calculates priority values for every entry as follows:

\~ Begin P4Pseudo // For this pseudocode, table entries in the `entries`
list are // numbered 0 through n-1, 0 being the first to appear in order
in the // source code. Their priority values are named prio\[0\] through
// prio\[n-1\]. int p = 1; if (largest\_priority\_wins == true) { for
(int j = n-1; j \>= 0; j -= 1) { prio\[j\] = p; p += priority\_delta; }
} else { for (int j = 0; j \< n; j += 1) { prio\[j\] = p; p +=
priority\_delta; } } \~ End P4Pseudo

If the developer specifies priority values for at least one entry, then
in order to simplify the rules for determining priorities of entries
without one in the source code, the first entry *must* have a priority
value explicitly provided. The priorities of entries that do not have
one in the source code (if any) are determined as follows:

\~ Begin P4Pseudo // Same conventions here as in the previous block of
pseudocode above. // If entry j has a priority value specified in the
source code, // prio\_specified\[j\] is true, otherwise it is false.
assert(prio\_specified\[0\]); // compile time error if
prio\_specified\[0\] is false p = prio\[0\]; for (int j = 1; j \< n; j
+= 1) { if (prio\_specified\[j\]) { p = prio\[j\]; } else { if
(largest\_priority\_wins == true) { p -= priority\_delta; } else { p +=
priority\_delta; } prio\[j\] = p; } } \~ End P4Pseudo

This is the end of the first step: determining entry priorities.

The priorities determined in this way are the values used when the P4
program is first loaded into a device. Afterwards, the priorities may
only change by means provided by the control plane API in use.

In the second step, the compiler issues errors for out of range priority
values, and/or warnings for certain combinations of entry priorities
that might be unintended by the developer, unless the developer
explicitly disables those warnings.

If any priority values are negative, or larger than the maximum
supported value, that is a compile time error.

If the annotation `@noWarn("duplicate_priorities")` is *not* used on the
`entries` table property, then the compiler issues a warning if any two
entries for the same table have equal priority values. Both P4Runtime
and TDI leave it unspecified which entry is the winner if a lookup key
matches multiple keys that all have the same priority, hence a warning
is useful to less experienced developers that are unfamiliar with this
unspecified behavior.

If the annotation `@noWarn("duplicate_priorities")` is used on the
`entries` table property, then no warnings of this type are ever issued
by the compiler. Using equal priority values for multiple entries in the
same table is sometimes useful in reducing the number of hardware
updates required when adding entries to such a table.

If the annotation `@noWarn("entries_out_of_priority_order")` is *not*
used on the `entries` table property, then the compiler issues a warning
if:

  - If `largest_priority_wins` is `true` for the table, and there is any
    pair of consecutive entries where `prio[j] < prio[j+1]`, then a
    warning is issued for that pair of entries.
  - If `largest_priority_wins` is `false` for the table, and there is
    any pair of consecutive entries where `prio[j] > prio[j+1]`, then a
    warning is issued for that pair of entries.

This warning is useful to developers that want the order that entries
appear in the source code to match the relative priority of entries in
the target device.

If the annotation `@noWarn("entries_out_of_priority_order")` is used on
the `entries` table property, then no warnings of this type are ever
issued by the compiler for this table. This option is provided for
developers who explicitly choose to specify entries in an order that
does not match their relative priority order.

The following example is the same as the first example in section
\[\#sec-entries\], except for the definition of table `t_exact_ternary`
shown below.

\~ Begin P4Example table t\_exact\_ternary { key = { h.h.e : exact;
h.h.t : ternary; }

    actions = {
        a;
        a_params;
    }
    
    default_action = a;
    
    largest_priority_wins = false;
    priority_delta = 10;
    @noWarn("duplicate_priorities")
    entries = {
        const priority=10: (0x01, 0x1111 &&& 0xF   ) : a_params(1);
                           (0x02, 0x1181           ) : a_params(2); // priority=20
                           (0x03, 0x1000 &&& 0xF000) : a_params(3); // priority=30
        const              (0x04, 0x0210 &&& 0x02F0) : a_params(4); // priority=40
              priority=40: (0x04, 0x0010 &&& 0x02F0) : a_params(5);
                           (0x06, _                ) : a_params(6); // priority=50
    }

  - }  
    End P4Example

The entries that do not have an explicit priority specified will be
assigned the priority values shown in the comments, because
`priority_delta` is 10, and because of those entries that do have
priority values specified.

Normally this program would cause a warning about multiple entries with
the same priority of 40, but those warnings will be suppressed because
of the `@noWarn("duplicate_priorities")` annotation.

#### Size

The `size` is an optional property of a table. When present, its value
must always be a compile-time known value that is an integer. The `size`
property is specified in units of number of table entries.

If a table is specified with a `size` property of value `N`, it is
recommended that a compiler should choose a data plane implementation
that is capable of storing `N` table entries. This does not guarantee
that an *arbitrary* set of `N` entries can always be inserted in such a
table, only that there is *some* set of `N` entries that can be
inserted. For example, attempts to add some combinations of `N` entries
may fail because the compiler selected a hash table with `O(1)`
guaranteed search time. See “Size property of P4 tables and parser value
sets”
[P4SizeProperty](https://github.com/p4lang/p4-spec/blob/master/p4-16/spec/docs/p4-table-and-parser-value-set-sizes.md)
for further discussion on some P4 table implementations and what they
are able to guarantee.

If a P4 implementation must dimension table resources at compile time,
they may treat it as an error if they encounter a table with no `size`
property.

Some P4 implementations may be able to dynamically dimension table
resources at run time. If a `size` value is specified in the P4 program,
it is recommended that such an implementation uses the `size` value as
the initial capacity of the table.

#### Additional properties

A `table` declaration defines its essential control and data plane
interfaces—i.e., keys and actions. However, the best way to implement a
table may actually depend on the nature of the entries that will be
installed at runtime (for example, tables could be dense or sparse,
could be implemented as hash-tables, associative memories, tries, etc.)
In addition, some architectures may support extra table properties whose
semantics lies outside the scope of this specification. For example, in
architectures where table resources are statically allocated,
programmers may be required to define a `size` table property, which can
be used by the compiler back-end to allocate storage resources. However,
these architecture-specific properties may not change the semantics of
table lookups, which always produce either a `hit` and an action or a
`miss`—they can only change how those results are interpreted on the
state of the data plane. This restriction is needed to ensure that it is
possible to reason about the behavior of tables during compilation.

As another example, an `implementation` property could be used to pass
additional information to the compiler back-end. The value of this
property could be an instance of an `extern` block chosen from a
suitable library of components. For example, the core functionality of
the P4<sub>14</sub> table `action_profile` constructs could be
implemented on architectures that support this feature using a construct
such as the following:

\~ Begin P4Example extern ActionProfile { ActionProfile(bit\<32\> size);
// number of distinct actions expected } table t { key = { /\* body
omitted \*/ } size = 1024; implementation = ActionProfile(32); //
constructor invocation } \~ End P4Example

Here the action profile might be used to optimize for the case where the
table has a large number of entries, but the actions associated with
those entries are expected to range over a small number of distinct
values. Introducing a layer of indirection enables sharing identical
entries, which can significantly reduce the table’s storage
requirements.

### Match-action unit invocation

A `table` can be invoked by calling its `apply` method. Calling an apply
method on a table instance returns a value with a `struct` type with
three fields. This structure is synthesized by the compiler
automatically. For each `table T`, the compiler synthesizes an `enum`
and a `struct`, shown in pseudo-P4:

\~ Begin P4Pseudo enum action\_list(T) { // one field for each action in
the actions list of table T } struct apply\_result(T) { bool hit; bool
miss; action\_list(T) action\_run; } \~ End P4Pseudo

The evaluation of the `apply` method sets the `hit` field to `true` and
the field `miss` to `false` if a match is found in the lookup-table; if
a match is not found `hit` is set to `false` and `miss` to `true`. These
bits can be used to drive the execution of the control-flow in the
control block that invoked the table:

\~ Begin P4Example if (ipv4\_match.apply().hit) { // there was a hit }
else { // there was a miss }

if (ipv4\_host.apply().miss) { ipv4\_lpm.apply(); // Look up the route
only if host table missed } \~ End P4Example

The `action_run` field indicates which kind of action was executed
(irrespective of whether it was a hit or a miss). It can be used in a
switch statement:

\~ Begin P4Example switch (dmac.apply().action\_run) { Drop\_action: {
return; } } \~ End P4Example

### Match-action unit execution semantics

  - The semantics of a table invocation statement:  
    Begin P4Example m.apply();
    
    End P4Example

is given by the following pseudocode (see also Figure
\[\#fig-maudataflow\]):

\~ Begin P4Pseudo apply\_result(m) m.apply() { apply\_result(m) result;

    var lookupKey = m.buildKey(m.key); // using key block
    action RA = m.table.lookup(lookupKey);
    if (RA == null) {      // miss in lookup table
       result.hit = false;
       RA = m.default_action;  // use default action
    }
    else {
       result.hit = true;
    }
    result.miss = !result.hit;
    result.action_run = action_type(RA);
    evaluate_and_copy_in_RA_args(RA);
    execute(RA);
    copy_out_RA_args(RA);
    return result;

  - }  
    End P4Pseudo

The behavior of the `buildKey` call in the pseudocode above is to
evaluate each key expression in the order they appear in the table key
definition. The behavior must be the same as if the result of evaluating
each key expression is assigned to a fresh temporary variable, before
starting the evaluation of the following key expression. For example,
this P4 table definition and apply call:

\~ Begin P4Example bit\<8\> f1 (in bit\<8\> a, inout bit\<8\> b) { b = a
+ 5; return a \>\> 1; } bit\<8\> x; bit\<8\> y; table t1 { key = { y &
0x7 : exact @name(“masked\_y”); f1(x, y) : exact @name(“f1”); y : exact;
} // … rest of table properties defined here, not relevant to example }
apply { // assign values to x and y here, not relevant to example
t1.apply(); } \~ End P4Example

is equivalent in behavior to the following table definition and apply
call:

\~ Begin P4Example // same definition of f1, x, and y as before, so they
are not repeated here bit\<8\> tmp\_1; bit\<8\> tmp\_2; bit\<8\> tmp\_3;
table t1 { key = { tmp\_1 : exact @name(“masked\_y”); tmp\_2 : exact
@name(“f1”); tmp\_3 : exact @name(“y”); } // … rest of table properties
defined here, not relevant to example } apply { // assign values to x
and y here, not relevant to example tmp\_1 = y & 0x7; tmp\_2 = f1(x, y);
tmp\_3 = y; t1.apply(); } \~ End P4Example

Note that the second code example above is given in order to specify the
behavior of the first one. An implementation is free to choose any
technique that achieves this behavior\[7\].
