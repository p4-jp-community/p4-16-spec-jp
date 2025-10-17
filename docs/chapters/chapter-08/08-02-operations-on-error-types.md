Symbolic names declared by an `error` declaration belong to the `error`
namespace. The `error` type only supports equality (`==`) and inequality
(`!=`) comparisons. The result of such a comparison is a Boolean value.

For example, the following operation tests for the occurrence of an
error: \~ Begin P4Example error errorFromParser;

  - if (errorFromParser \!= error.NoError) { /\* code omitted \*/ }  
    End P4Example
