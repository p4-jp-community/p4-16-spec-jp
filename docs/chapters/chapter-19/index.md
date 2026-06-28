<a id="sec-static-assert"></a>
# 19. Static assertions


The P4 core library contains two overloaded declarations for a
`static_assert` function, as follows:

```p4
/// Static assert evaluates a boolean expression
/// at compilation time.  If the expression evaluates to
/// false, compilation is stopped and the corresponding message is printed.
extern bool static_assert(bool check, string message);

/// Like the above but using a default message.
extern bool static_assert(bool check);
```

These functions both return boolean values. Since the parameters are
directionless, these functions require compile-time known values as
arguments, thus they can be used to enforce compile-time invariants.
Since P4 does not allow statements at the program top-level (outside of
apply blocks), these functions can be used at the top-level by assigning
their result to a dummy constant, e.g.:

```p4
const bool _check = static_assert(V1MODEL_VERSION > 20180000,
                                  "Expected a v1 model version >= 20180000");
```

As the comment indicates, if `static_assert` returns `false`, it causes
the program compilation to be terminated immediately with an error.

