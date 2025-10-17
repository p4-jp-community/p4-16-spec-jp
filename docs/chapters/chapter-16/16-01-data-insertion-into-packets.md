The `packet_out` datatype is defined in the P4 core library, and
reproduced below. It provides a method for appending data to an output
packet called `emit`:

\~ Begin P4Example extern packet\_out { void emit<T>(in T data); } \~
End P4Example

The `emit` method supports appending the data contained in a header,
header stack, `struct`, or header union to the output packet.

  - When applied to a header, `emit` appends the data in the header to
    the packet if it is valid and otherwise behaves like a no-op.
  - When applied to a header stack, `emit` recursively invokes itself to
    each element of the stack.
  - When applied to a `struct` or header union, `emit` recursively
    invokes itself to each field. Note, a `struct` must not contain a
    field of type `error` or `enum` because these types cannot be
    serialized.

It is illegal to invoke `emit` on an expression whose type is a base
type, `enum`, or `error`.

We can define the meaning of the `emit` method in pseudocode as follows:

\~ Begin P4Pseudo packet\_out { byte\[\] data; unsigned lengthInBits;
void initializeForWriting() { this.data.clear(); this.lengthInBits = 0;
} /// Append data to the packet. Type T must be a header, header ///
stack, header union, or struct formed recursively from those types void
emit<T>(T data) { if (isHeader(T))
if(data.valid\() {  this.data.append(data);  this.lengthInBits += data.lengthInBits;  }  else if (isHeaderStack(T))  for (e : data)  emit(e);  else if (isHeaderUnion(T) || isStruct(T))  for (f : data.fields\))
emit(e.f) // Other cases for T are illegal } \~ End P4Pseudo

Here we use the special `valid$` identifier to indicate the hidden valid
bit of headers and `fields$` to indicate the list of fields for a struct
or header union. We also use standard `for-each` notation to iterate
through the elements of a stack `(e : data)` and list of fields for
header unions and structs `(f : data.fields$)`. The iteration order for
a struct is the order those fields appear in the type declaration.
