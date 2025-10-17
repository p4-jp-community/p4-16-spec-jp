All P4 keywords use only ASCII characters. All P4 identifiers must use
only ASCII characters. P4 compilers should handle correctly strings
containing 8-bit characters in comments and string literals. P4 is
case-sensitive. Whitespace characters, including newlines are treated as
token separators. Indentation is free-form; however, P4 has C-like block
constructs, and all our examples use C-style indentation. Tab characters
are treated as spaces.

The lexer recognizes the following kinds of terminals:

  - `IDENTIFIER`: start with a letter or underscore, and contain
    letters, digits and underscores
  - `TYPE_IDENTIFIER`: identifier that denotes a type name
  - `INTEGER`: integer literals
  - `DONTCARE`: a single underscore
  - Keywords such as `RETURN`. By convention, each keyword terminal
    corresponds to a language keyword with the same spelling but using
    lowercase. For example, the `RETURN` terminal corresponds to the
    `return` keyword.

### Identifiers

P4 identifiers may contain only letters, numbers, and the underscore
character `_`, and must start with a letter or underscore. The special
identifier consisting of a single underscore `_` is reserved to indicate
a “don’t care” value; its type may vary depending on the context.
Certain keywords (e.g., `apply`) can be used as identifiers if the
context makes it unambiguous.

\~ Begin P4Grammar \[INCLUDE=grammar.mdk:nonTypeName\]

name : nonTypeName | TYPE\_IDENTIFIER ; \~ End P4Grammar

### Comments

P4 supports several kinds of comments:

  - Single-line comments, introduced by `//` and spanning to the end of
    line,
  - Multi-line comments, enclosed between `/*` and `*/`
  - Nested multi-line comments are not supported.
  - Javadoc-style comments, starting with `/**` and ending with `*/`

Use of Javadoc-style comments is strongly encouraged for the tables and
actions that are used to synthesize the interface with the
control-plane.

P4 treats comments as token separators and no comments are allowed
within a token—e.g. `bi/**/t` is parsed as two tokens, `bi` and `t`, and
not as a single token `bit`.

### Literal constants

#### Boolean literals

There are two Boolean literal constants: `true` and `false`.

#### Integer literals

Integer literals are non-negative arbitrary-precision integers. By
default, literals are represented in base 10. The following prefixes
must be employed to specify the base explicitly:

  - `0x` or `0X` indicates base 16 (hexadecimal)
  - `0o` or `0O` indicates base 8 (octal)
  - `0d` or `0D` indicates base 10 (decimal)
  - `0b` or `0B` indicates base 2

The width of a numeric literal in bits can be specified by an unsigned
number prefix consisting of a number of bits and a signedness indicator:

  - `w` indicates unsigned numbers
  - `s` indicates signed numbers

Note that a leading zero by itself does not indicate an octal (base 8)
constant. The underscore character is considered a digit within number
literals but is ignored when computing the value of the parsed number.
This allows long constant numbers to be more easily read by grouping
digits together. The underscore cannot be used in the width
specification or as the first character of an integer literal. No
comments or whitespaces are allowed within a literal. Here are some
examples of numeric literals:

\~ Begin P4Example 32w255 // a 32-bit unsigned number with value 255
32w0d255 // same value as above 32w0xFF // same value as above 32s0xFF
// a 32-bit signed number with value 255 8w0b10101010 // an 8-bit
unsigned number with value 0xAA 8w0b\_1010\_1010 // same value as above
8w170 // same value as above 8s0b1010\_1010 // an 8-bit signed number
with value -86 16w0377 // 16-bit unsigned number with value 377 (not
255\!) 16w0o377 // 16-bit unsigned number with value 255 (base 8) \~ End
P4Example

#### String literals

String literals are specified as an arbitrary sequence of 8-bit
characters, enclosed within double quote characters `"` (ASCII code 34).
Strings start with a double quote character and extend to the first
double quote sign which is not immediately preceded by an odd number of
backslash characters (ASCII code 92). P4 does not make any validity
checks on strings (i.e., it does not check that strings represent legal
UTF-8 encodings).

Since P4 does not provide any operations on strings, string literals are
generally passed unchanged through the P4 compiler to other third-party
tools or compiler-backends, including the terminating quotes. These
tools can define their own handling of escape sequences (e.g., how to
specify Unicode characters, or handle unprintable ASCII characters).

  - Here are 3 examples of string literals:  
    Begin P4Example “simple string” “string " with " embedded " quotes”
    “string with embedded line terminator”
    End P4Example

### Optional trailing commas

The P4 grammar allows several kinds of comma-separated lists to end in
an optional comma.

\~Begin P4Grammar \[INCLUDE=grammar.mdk:optTrailingComma\] \~End
P4Grammar

For example, the following declarations are both legal, and have the
same meaning:

\~Begin P4Example enum E { a, b, c }

enum E { a, b, c, } \~End P4Example

This is particularly useful in combination with preprocessor directives:

\~Begin P4Example enum E { \#if SUPPORT\_A a, \#endif b, c, } \~End
P4Example
