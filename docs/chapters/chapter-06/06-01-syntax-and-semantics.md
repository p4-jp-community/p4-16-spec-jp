### Grammar

The complete grammar of P4<sub>16</sub> is given in Appendix
\[\#sec-grammar\], using Yacc/Bison grammar description language. This
text is based on the same grammar. We adopt several standard conventions
when we provide excerpts from the grammar:

  - `UPPERCASE` symbols denote terminals in the grammar.

  -   - Excerpts from the grammar are given in BNF notation as
        follows:  
        Begin P4Grammar \[INCLUDE=grammar.mdk:p4program\]
        End P4Grammar

Pseudo-code (mostly used for describing the semantics of various P4
constructs) are shown with fixed-size fonts as in the following example:

\~ Begin P4Pseudo ParserModel.verify(bool condition, error err) { if
(condition == false) { ParserModel.parserError = err; goto reject; } }
\~ End P4Pseudo

### Semantics and the P4 abstract machines

We describe the semantics of P4 in terms of abstract machines executing
traditional imperative code. There is an abstract machine for each P4
sub-language (parser, control). The abstract machines are described in
this text in pseudo-code and English.

P4 compilers are free to reorganize the code they generate in any way as
long as the externally visible behaviors of the P4 programs are
preserved as described by this specification where externally visible
behavior is defined as:

  - The input/output behavior of all P4 blocks, and
  - The state maintained by extern blocks.
