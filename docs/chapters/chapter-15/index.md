# 15. Parameterization


In order to support libraries of useful P4 components, both `parser`s
and `control` blocks can be additionally parameterized through the use
of constructor parameters.

  - Consider again the parser declaration syntax:  
    Begin P4Grammar \[INCLUDE=grammar.mdk:parserDeclaration\]

  - \[INCLUDE=grammar.mdk:optConstructorParameters\]  
    End P4Grammar

From this grammar fragment we infer that a `parser` declaration may have
two sets of parameters:

  - The runtime parser parameters (`parameterList`)
  - Optional parser constructor parameters (`optConstructorParameters`)

Constructor parameters must be directionless (i.e., they cannot be `in`,
`out`, or `inout`) and where the parser is instantiated, it must be
possible to fully evaluate the expressions supplied for these parameters
at compilation time.

  - Consider the following example:  
    Begin P4Example parser GenericParser(packet\_in b, out
    Packet\_header p) (bool udpSupport) { // constructor parameters
    state start { b.extract(p.ethernet); transition
    select(p.ethernet.etherType) { 16w0x0800: ipv4; } } state ipv4 {
    b.extract(p.ipv4); transition select(p.ipv4.protocol) { 6: tcp; 17:
    tryudp; } } state tryudp { transition select(udpSupport) { false:
    accept; true : udp; } } state udp { // body omitted } }
    
    End P4Example

When instantiating the `GenericParser` it is necessary to supply a value
for the `udpSupport` parameter, as in the following example:

\~ Begin P4Example // topParser is a GenericParser where udpSupport =
false GenericParser(false) topParser; \~ End P4Example

--8<-- "chapters/chapter-15/15-01-direct-type-invocation.md"
