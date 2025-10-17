A header stack is a fixed-size array of headers with the same type. The
valid elements of a header stack need not be contiguous. P4 provides a
set of computations for manipulating header stacks. A header stack `hs`
of type `h[n]` can be understood in terms of the following pseudocode:

\~ Begin P4Pseudo // type declaration struct hs\_t { bit\<32\>
nextIndex; bit\<32\> size; h\[n\] data; // Ordinary array }

// instance declaration and initialization hs\_t hs; hs.nextIndex = 0;
hs.size = n; \~ End P4Pseudo

Intuitively, a header stack can be thought of as a struct containing an
ordinary array of headers `hs` and a counter `nextIndex` that can be
used to simplify the construction of parsers for header stacks, as
discussed below. The `nextIndex` counter is initialized to `0`.

Given a header stack value `hs` of size `n`, the following expressions
are legal:

  - `hs[index]`: produces a reference to the header at the specified
    position within the stack; if `hs` is an l-value, the result is also
    an l-value. The header may be invalid. Some implementations may
    impose the constraint that the index expression must be a
    compile-time known value. A P4 compiler must give an error if an
    index that is a compile-time known value is out of range.
    
    Accessing a header stack `hs` with an index less than `0` or greater
    than or equal to `hs.size` results in an undefined value. See
    Section \[\#sec-uninitialized-values-and-writing-invalid-headers\]
    for more details.
    
    The `index` is an expression that must be of numeric types (Section
    \[\#sec-numeric-values\]).

  - `hs.size`: produces a 32-bit unsigned integer that returns the size
    of the header stack (a local compile-time known value).

  - assignment from a header stack `hs` into another stack requires the
    stacks to have the same types and sizes. All components of `hs` are
    copied, including its elements and their validity bits, as well as
    `nextIndex`.

To help programmers write parsers for header stacks, P4 also offers
computations that automatically advance through the stack as elements
are parsed:

  - `hs.next`: produces a reference to the element with index
    `hs.nextIndex` in the stack. May only be used in a `parser`. If the
    stack’s `nextIndex` counter is greater than or equal to `size`, then
    evaluating this expression results in a transition to `reject` and
    sets the error to `error.StackOutOfBounds`. If `hs` is an l-value,
    then `hs.next` is also an l-value.

  - `hs.last`: produces a reference to the element with index
    `hs.nextIndex - 1` in the stack, if such an element exists. May only
    be used in a `parser`. If the `nextIndex` counter is less than `1`,
    or greater than `size`, then evaluating this expression results in a
    transition to `reject` and sets the error to
    `error.StackOutOfBounds`. Unlike `hs.next`, the resulting reference
    is never an l-value.

  - `hs.lastIndex`: produces a 32-bit unsigned integer that encodes the
    index `hs.nextIndex - 1`. May only be used in a `parser`. If the
    `nextIndex` counter is `0`, then evaluating this expression produces
    an undefined value.

Finally, P4 offers the following computations that can be used to
manipulate the elements at the front and back of the stack:

  - `hs.push_front(int count)`: shifts `hs` “right” by `count`. The
    first `count` elements become invalid. The last `count` elements in
    the stack are discarded. The `hs.nextIndex` counter is incremented
    by `count`. The `count` argument must be a compile-time known value
    that is a positive integer. The return type is `void`.

  - `hs.pop_front(int count)`: shifts `hs` “left” by `count` (i.e.,
    element with index `count` is copied in stack at index `0`). The
    last `count` elements become invalid. The `hs.nextIndex` counter is
    decremented by `count`. The `count` argument must be a compile-time
    known value that is a positive integer. The return type is `void`.

<!-- end list -->

  - The following pseudocode defines the behavior of `push_front` and
    `pop_front`:  
    Begin P4Pseudo void push\_front(int count) { for (int i =
    this.size-1; i \>= 0; i -= 1) { if (i \>= count) { this\[i\] =
    this\[i-count\]; } else { this\[i\].setInvalid(); } } this.nextIndex
    = this.nextIndex + count; if (this.nextIndex \> this.size)
    this.nextIndex = this.size; // Note: this.last, this.next, and
    this.lastIndex adjust with this.nextIndex }

void pop\_front(int count) { for (int i = 0; i \< this.size; i++) { if
(i+count \< this.size) { this\[i\] = this\[i+count\]; } else {
this\[i\].setInvalid(); } } if (this.nextIndex \>= count) {
this.nextIndex = this.nextIndex - count; } else { this.nextIndex = 0; }
// Note: this.last, this.next, and this.lastIndex adjust with
this.nextIndex } \~ End P4Pseudo

Similar to structs and headers, the size of a header stack is a
compile-time known value (Section \[\#sec-minsizeinbits\]).

Two header stacks can be compared for equality (`==`) or inequality
(`!=`) only if they have the same element type and the same length. Two
stacks are equal if and only if all their corresponding elements are
equal. Note that the `nextIndex` value is not used in the equality
comparison.

### Header stack expressions

One can write expressions that evaluate to a header stack. The syntax of
these expressions is given by:

\~ Begin P4Grammar expression … | ‘{’ expressionList ‘}’ | ‘(’ typeRef
‘)’ expression ; \~ End P4Grammar

The `typeRef` is a header stack type. The `typeRef` can be omitted if it
can be inferred from context, e.g., when initializing a variable with a
header stack type. Each expression in the list must evaluate to a header
of the same type as the other stack elements.

  - Here is an example:  
    Begin P4Example header H<T> { bit\<32\> b; T t; }
    H\<bit\<32\>\>\[3\] s = (H\<bit\<32\>\>\[3\]){ {0, 1}, {2, 3},
    (H\<bit\<32\>\>){\#} }; // without an explicit cast
    H\<bit\<32\>\>\[3\] s1 = { {0, 1}, {2, 3}, (H\<bit\<32\>\>){\#} };
    // using the default initializer H\<bit\<32\>\>\[3\] s2 = { {0, 1},
    {2, 3}, … }; \~End P4Example

The values of `s`, `s1`, and `s2` in the above example are identical.
