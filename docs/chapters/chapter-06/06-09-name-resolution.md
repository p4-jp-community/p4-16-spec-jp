P4 objects that introduce namespaces are organized in a hierarchical
fashion. There is a top-level unnamed namespace containing all top-level
declarations.

Identifiers prefixed with a dot are always resolved in the top-level
namespace.

```p4
const bit<32> x = 2;
control c() {
   int<32> x = 0;
   apply {
       x = x + (int<32>).x;  // x is the int<32> local variable,
                             // .x is the top-level bit<32> variable
   }
}
```

References to resolve an identifier are attempted inside-out, starting
with the current scope and proceeding to all lexically enclosing scopes.
The compiler may provide a warning if multiple resolutions are possible
for the same name (name shadowing).

```p4
const bit<4> x = 1;
control p() {
    const bit<8> x = 8;    // x declaration shadows global x
    const bit<4> y = .x;   // reference to top-level x
    const bit<8> z = x;    // reference to p's local x
    apply {}
}
```
