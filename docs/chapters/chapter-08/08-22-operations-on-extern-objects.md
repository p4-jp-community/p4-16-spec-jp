<a id="sec-extern-operations"></a>
The only operations that can be performed on `extern` objects are the
following:

  - Instantiating an extern object using a constructor invocation, as
    described in Section [Constructor invocations](08-21-constructor-invocations.md#sec-constructor).
  - Invoking a method of an extern object instance using a method call
    expression, as described in Section [Method invocations and function calls](08-20-method-invocations-and-function-calls.md#sec-invocations).

Controls, parsers, packages, and extern constructors can have parameters
of type `extern` only if they are directionless parameters. Extern
object instances can thus be used as arguments in the construction of
such objects.

No other operations are available on extern objects, e.g., equality
comparison is not defined.
