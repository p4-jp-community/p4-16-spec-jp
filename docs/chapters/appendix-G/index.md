<a id="sec-grammar"></a>
# Appendix G P4 grammar


This is the grammar of P4<sub>16</sub> written using the YACC/bison
language. Absent from this grammar is the precedence of various
operations.

The grammar is actually ambiguous, so the lexer and the parser must
collaborate for parsing the language. In particular, the lexer must be
able to distinguish two kinds of identifiers:

  - Type names previously introduced (`TYPE_IDENTIFIER` tokens)
  - Regular identifiers (`IDENTIFIER` token)

The parser has to use a symbol table to indicate to the lexer how to
parse subsequent appearances of identifiers. For example, given the
following program fragment:

```p4
typedef bit<4> t;
struct s { /* body omitted */}
t x;
parser p(bit<8> b) { /* body omitted */ }
```

The lexer has to return the following terminal kinds:

```p4
t - TYPE_IDENTIFIER
s - TYPE_IDENTIFIER
x - IDENTIFIER
p - TYPE_IDENTIFIER
b - IDENTIFIER
```

This grammar has been heavily influenced by limitations of the Bison
parser generator tool.

The `STRING_LITERAL` token corresponds to a string literal enclosed
within double quotes, as described in Section [String literals](../chapter-06/06-04-lexical-constructs.md#sec-string-literals).

All other terminals are uppercase spellings of the corresponding
keywords. For example, `RETURN` is the terminal returned by the lexer
when parsing the keyword return.

```bison
p4program
    : /* empty */
    | p4program declaration
    | p4program ";"  /* empty declaration */
    ;

declaration
    : constantDeclaration
    | externDeclaration
    | actionDeclaration
    | parserDeclaration
    | typeDeclaration
    | controlDeclaration
    | instantiation
    | errorDeclaration
    | matchKindDeclaration
    | functionDeclaration
    ;

nonTypeName
    : IDENTIFIER
    | APPLY
    | KEY
    | ACTIONS
    | STATE
    | ENTRIES
    | TYPE
    | PRIORITY
    ;

name
    : nonTypeName
    | LIST
    | TYPE_IDENTIFIER
    ;

nonTableKwName
   : IDENTIFIER
   | TYPE_IDENTIFIER
   | APPLY
   | STATE
   | TYPE
   | PRIORITY
   ;

optCONST
    : /* empty */
    | CONST
    ;

optAnnotations
    : /* empty */
    | annotations
    ;

annotations
    : annotation
    | annotations annotation
    ;

annotation
    : "@" name
    | "@" name "(" annotationBody ")"
    | "@" name "[" structuredAnnotationBody "]"
    ;

annotationBody
    : /* empty */
    | annotationBody "(" annotationBody ")"
    | annotationBody annotationToken
    ;

annotationToken
    : UNEXPECTED_TOKEN
    | ABSTRACT
    | ACTION
    | ACTIONS
    | APPLY
    | BOOL
    | BIT
    | CONST
    | CONTROL
    | DEFAULT
    | ELSE
    | ENTRIES
    | ENUM
    | ERROR
    | EXIT
    | EXTERN
    | FALSE
    | HEADER
    | HEADER_UNION
    | IF
    | IN
    | INOUT
    | INT
    | KEY
    | MATCH_KIND
    | TYPE
    | OUT
    | PARSER
    | PACKAGE
    | PRAGMA
    | RETURN
    | SELECT
    | STATE
    | STRING
    | STRUCT
    | SWITCH
    | TABLE
    | THIS
    | TRANSITION
    | TRUE
    | TUPLE
    | TYPEDEF
    | VARBIT
    | VALUESET
    | LIST
    | VOID
    | "_"
    | IDENTIFIER
    | TYPE_IDENTIFIER
    | STRING_LITERAL
    | INTEGER
    | "&&&"
    | ".."
    | "<<"
    | "&&"
    | "||"
    | "=="
    | "!="
    | ">="
    | "<="
    | "++"
    | "+"
    | "|+|"
    | "-"
    | "|-|"
    | "*"
    | "/"
    | "%"
    | "|"
    | "&"
    | "^"
    | "~"
    | "["
    | "]"
    | "{"
    | "}"
    | "<"
    | ">"
    | "!"
    | ":"
    | ","
    | "?"
    | "."
    | "="
    | ";"
    | "@"
    ;

kvList
    : kvPair
    | kvList "," kvPair
    ;

kvPair
    : name "=" expression
    ;

parameterList
    : /* empty */
    | nonEmptyParameterList
    ;

nonEmptyParameterList
    : parameter
    | nonEmptyParameterList "," parameter
    ;

parameter
    : optAnnotations direction typeRef name
    | optAnnotations direction typeRef name "=" expression
    ;

direction
    : IN
    | OUT
    | INOUT
    | /* empty */
    ;

packageTypeDeclaration
    : optAnnotations PACKAGE name optTypeParameters
      "(" parameterList ")"
    ;

instantiation
    : annotations typeRef "(" argumentList ")" name ";"
    | typeRef "(" argumentList ")" name ";"
    | annotations typeRef "(" argumentList ")" name "=" objInitializer ";"
    | typeRef "(" argumentList ")" name "=" objInitializer ";"
    ;

objInitializer
    : "{" objDeclarations "}"
    ;

objDeclarations
    : /* empty */
    | objDeclarations objDeclaration
    ;

objDeclaration
    : functionDeclaration
    | instantiation
    ;

optConstructorParameters
    : /* empty */
    | "(" parameterList ")"
    ;

dotPrefix
    : "."
    ;

/**************************** PARSER ******************************/

parserDeclaration
    : parserTypeDeclaration optConstructorParameters
      "{" parserLocalElements parserStates "}"
    ;

parserLocalElements
    : /* empty */
    | parserLocalElements parserLocalElement
    ;

parserLocalElement
    : constantDeclaration
    | instantiation
    | variableDeclaration
    | valueSetDeclaration
    ;

parserTypeDeclaration
    : optAnnotations PARSER name optTypeParameters
      "(" parameterList ")"
    ;

parserStates
    : parserState
    | parserStates parserState
    ;

parserState
    : optAnnotations STATE name
      "{" parserStatements transitionStatement "}"
    ;

parserStatements
    : /* empty */
    | parserStatements parserStatement
    ;

parserStatement
    : assignmentOrMethodCallStatement
    | directApplication
    | emptyStatement
    | variableDeclaration
    | constantDeclaration
    | parserBlockStatement
    | conditionalStatement
    ;

parserBlockStatement
    : optAnnotations "{" parserStatements "}"
    ;

transitionStatement
    : /* empty */
    | TRANSITION stateExpression
    ;

stateExpression
    : name ";"
    | selectExpression
    ;

selectExpression
    : SELECT "(" expressionList ")" "{" selectCaseList "}"
    ;

selectCaseList
    : /* empty */
    | selectCaseList selectCase
    ;

selectCase
    : keysetExpression ":" name ";"
    ;

keysetExpression
    : tupleKeysetExpression
    | simpleKeysetExpression
    ;

tupleKeysetExpression
    : "(" simpleKeysetExpression "," simpleExpressionList ")"
    | "(" reducedSimpleKeysetExpression ")"
    ;

optTrailingComma
    : /* empty */
    | ","
    ;

simpleExpressionList
    : simpleKeysetExpression
    | simpleExpressionList "," simpleKeysetExpression
    ;

reducedSimpleKeysetExpression
    : expression "&&&" expression
    | expression ".." expression
    | DEFAULT
    | "_"
    ;

simpleKeysetExpression
    : expression
    | expression "&&&" expression
    | expression ".." expression
    | DEFAULT
    | "_"
    ;

valueSetDeclaration
  : optAnnotations
      VALUESET "<" baseType ">" "(" expression ")" name ";"
  | optAnnotations
      VALUESET "<" tupleType ">" "(" expression ")" name ";"
  | optAnnotations
      VALUESET "<" typeName ">" "(" expression ")" name ";"
  ;

/*************************** CONTROL ************************/

controlDeclaration
    : controlTypeDeclaration optConstructorParameters
      /* controlTypeDeclaration cannot contain type parameters */
      "{" controlLocalDeclarations APPLY controlBody "}"
    ;

controlTypeDeclaration
    : optAnnotations CONTROL name optTypeParameters
      "(" parameterList ")"
    ;

controlLocalDeclarations
    : /* empty */
    | controlLocalDeclarations controlLocalDeclaration
    ;

controlLocalDeclaration
    : constantDeclaration
    | actionDeclaration
    | tableDeclaration
    | instantiation
    | variableDeclaration
    ;

controlBody
    : blockStatement
    ;

/*************************** EXTERN *************************/

externDeclaration
    : optAnnotations EXTERN nonTypeName optTypeParameters "{" methodPrototypes "}"
    | optAnnotations EXTERN functionPrototype ";"
    ;

methodPrototypes
    : /* empty */
    | methodPrototypes methodPrototype
    ;

functionPrototype
    : typeOrVoid name optTypeParameters "(" parameterList ")"
    ;

methodPrototype
    : optAnnotations functionPrototype ";"
    | optAnnotations TYPE_IDENTIFIER "(" parameterList ")" ";"
    ;

/************************** TYPES ****************************/

typeRef
    : baseType
    | typeName
    | specializedType
    | headerStackType
    | p4listType
    | tupleType
    ;

namedType
    : typeName
    | specializedType
    ;

prefixedType
    : TYPE_IDENTIFIER
    | dotPrefix TYPE_IDENTIFIER
    ;

typeName
    : prefixedType
    ;

p4listType
    : LIST "<" typeArg ">"
    ;

tupleType
    : TUPLE "<" typeArgumentList ">"
    ;

headerStackType
    : typeName "[" expression "]"
    | specializedType "[" expression "]"
    ;

specializedType
    : typeName "<" typeArgumentList ">"
    ;

baseType
    : BOOL
    | MATCH_KIND
    | ERROR
    | BIT
    | STRING
    | INT
    | BIT "<" INTEGER ">"
    | INT "<" INTEGER ">"
    | VARBIT "<" INTEGER ">"
    | BIT "<" "(" expression ")" ">"
    | INT "<" "(" expression ")" ">"
    | VARBIT "<" "(" expression ")" ">"
    ;

typeOrVoid
    : typeRef
    | VOID
    | IDENTIFIER     // may be a type variable
    ;

optTypeParameters
    : /* empty */
    | typeParameters
    ;

typeParameters
    : "<" typeParameterList ">"
    ;

typeParameterList
    : name
    | typeParameterList "," name
    ;

typeArg
    : typeRef
    | nonTypeName
    | VOID
    | "_"
    ;

typeArgumentList
    : /* empty */
    | typeArg
    | typeArgumentList "," typeArg
    ;

realTypeArg
    : typeRef
    | VOID
    | "_"
    ;

realTypeArgumentList
    : realTypeArg
    | realTypeArgumentList "," typeArg
    ;

typeDeclaration
    : derivedTypeDeclaration
    | typedefDeclaration ";"
    | parserTypeDeclaration ";"
    | controlTypeDeclaration ";"
    | packageTypeDeclaration ";"
    ;

derivedTypeDeclaration
    : headerTypeDeclaration
    | headerUnionDeclaration
    | structTypeDeclaration
    | enumDeclaration
    ;

headerTypeDeclaration
    : optAnnotations HEADER name optTypeParameters "{" structFieldList "}"
    ;

structTypeDeclaration
    : optAnnotations STRUCT name optTypeParameters "{" structFieldList "}"
    ;

headerUnionDeclaration
    : optAnnotations HEADER_UNION name optTypeParameters "{" structFieldList "}"
    ;

structFieldList
    : /* empty */
    | structFieldList structField
    ;

structField
    : optAnnotations typeRef name ";"
    ;

enumDeclaration
    : optAnnotations ENUM name "{" identifierList optTrailingComma "}"
    | optAnnotations ENUM typeRef name "{"
      specifiedIdentifierList optTrailingComma "}"
    ;

specifiedIdentifierList
    : specifiedIdentifier
    | specifiedIdentifierList "," specifiedIdentifier
    ;

specifiedIdentifier
    : name "=" initializer
    ;

errorDeclaration
    : ERROR "{" identifierList "}"
    ;

matchKindDeclaration
    : MATCH_KIND "{" identifierList optTrailingComma "}"
    ;

identifierList
    : name
    | identifierList "," name
    ;

typedefDeclaration
    : optAnnotations TYPEDEF typeRef name
    | optAnnotations TYPEDEF derivedTypeDeclaration name
    | optAnnotations TYPE typeRef name
    ;

/*************************** STATEMENTS *************************/

assignmentOrMethodCallStatement
    : lvalue "(" argumentList ")" ";"
    | lvalue "<" typeArgumentList ">" "(" argumentList ")" ";"
    | lvalue "="  expression ";"
    ;

emptyStatement
    : ";"
    ;

exitStatement
    : EXIT ";"
    ;

returnStatement
    : RETURN ";"
    | RETURN expression ";"
    ;

conditionalStatement
    : IF "(" expression ")" statement
    | IF "(" expression ")" statement ELSE statement
    ;

// To support direct invocation of a control or parser without instantiation
directApplication
    : typeName "." APPLY "(" argumentList ")" ";"
    | specializedType "." APPLY "(" argumentList ")" ";"
    ;

statement
    : assignmentOrMethodCallStatement
    | directApplication
    | conditionalStatement
    | emptyStatement
    | blockStatement
    | returnStatement
    | exitStatement
    | switchStatement
    ;

blockStatement
    : optAnnotations "{" statOrDeclList "}"
    ;

statOrDeclList
    : /* empty */
    | statOrDeclList statementOrDeclaration
    ;

switchStatement
    : SWITCH "(" expression ")" "{" switchCases "}"
    ;

switchCases
    : /* empty */
    | switchCases switchCase
    ;

switchCase
    : switchLabel ":" blockStatement
    | switchLabel ":"  // fall-through
    ;

switchLabel
    : DEFAULT
    | nonBraceExpression
    ;

statementOrDeclaration
    : variableDeclaration
    | constantDeclaration
    | statement
    ;

/************************* TABLE *********************************/

tableDeclaration
    : optAnnotations TABLE name "{" tablePropertyList "}"
    ;

tablePropertyList
    : tableProperty
    | tablePropertyList tableProperty
    ;

tableProperty
    : KEY "=" "{" keyElementList "}"
    | ACTIONS "=" "{" actionList "}"
    | optAnnotations optCONST ENTRIES "=" "{" entriesList "}"
    | optAnnotations optCONST nonTableKwName "=" initializer ";"
    ;

keyElementList
    : /* empty */
    | keyElementList keyElement
    ;

keyElement
    : expression ":" name optAnnotations ";"
    ;

actionList
    : /* empty */
    | actionList optAnnotations actionRef ";"
    ;

actionRef
    : prefixedNonTypeName
    | prefixedNonTypeName "(" argumentList ")"
    ;

entry
    : optCONST entryPriority keysetExpression ':' actionRef optAnnotations ';'
    | optCONST keysetExpression ':' actionRef optAnnotations ';'
    ;

entryPriority
 : PRIORITY '=' INTEGER ":"
 | PRIORITY '=' '(' expression ')' ":"
 ;

entriesList
    : /* empty */
    | entriesList entry
    ;

/************************* ACTION ********************************/

actionDeclaration
    : optAnnotations ACTION name "(" parameterList ")" blockStatement
    ;

/************************* VARIABLES *****************************/

variableDeclaration
    : annotations typeRef name optInitializer ";"
    | typeRef name optInitializer ";"
    ;

constantDeclaration
    : optAnnotations CONST typeRef name "=" initializer ";"
    ;

optInitializer
    : /* empty */
    | "=" initializer
    ;

initializer
    : expression
    ;

/**************** Expressions ****************/

functionDeclaration
    : annotations functionPrototype blockStatement
    | functionPrototype blockStatement
    ;

argumentList
    : /* empty */
    | nonEmptyArgList
    ;

nonEmptyArgList
    : argument
    | nonEmptyArgList "," argument
    ;

argument
    : expression  /* positional argument */
    | name "=" expression  /* named argument */
    | "_"
    | name "=" "_"
    ;

expressionList
    : /* empty */
    | expression
    | expressionList "," expression
    ;

structuredAnnotationBody
    : expressionList optTrailingComma
    | kvList optTrailingComma
    ;

member
    : name
    ;

prefixedNonTypeName
    : nonTypeName
    | dotPrefix nonTypeName
    ;

lvalue
    : prefixedNonTypeName
    | THIS
    | lvalue "." member
    | lvalue "[" expression "]"
    | lvalue "[" expression ":" expression "]"
    | "(" lvalue ")"
    ;

%left ","
%nonassoc "?"
%nonassoc ":"
%left "||"
%left "&&"
%left "==" "!="
%left "<" ">" "<=" ">="
%left "|"
%left "^"
%left "&"
%left "<<" ">>"
%left "++" "+" "-" "|+|" "|-|"
%left "*" "/" "%"
%right PREFIX
%nonassoc "]" "(" "["
%left "."

// Additional precedences need to be specified

expression
    : INTEGER
    | DOTS
    | STRING_LITERAL
    | TRUE
    | FALSE
    | THIS
    | prefixedNonTypeName
    | expression "[" expression "]"
    | expression "[" expression ":" expression "]"
    | "{" expressionList optTrailingComma "}"
    | "{#}"
    | "{" kvList optTrailingComma "}"
    | "{" kvList "," DOTS optTrailingComma "}"
    | "(" expression ")"
    | "!" expression %prec PREFIX
    | "~" expression %prec PREFIX
    | "-" expression %prec PREFIX
    | "+" expression %prec PREFIX
    | typeName "." member
    | ERROR "." member
    | expression "." member
    | expression "*" expression
    | expression "/" expression
    | expression "%" expression
    | expression "+" expression
    | expression "-" expression
    | expression "|+|" expression
    | expression "|-|" expression
    | expression "<<" expression
    | expression ">>" expression
    | expression "<=" expression
    | expression ">=" expression
    | expression "<" expression
    | expression ">" expression
    | expression "!=" expression
    | expression "==" expression
    | expression "&" expression
    | expression "^" expression
    | expression "|" expression
    | expression "++" expression
    | expression "&&" expression
    | expression "||" expression
    | expression "?" expression ":" expression
    | expression "<" realTypeArgumentList ">" "(" argumentList ")"
    | expression "(" argumentList ")"
    | namedType "(" argumentList ")"
    | "(" typeRef ")" expression
    ;

nonBraceExpression
    : INTEGER
    | STRING_LITERAL
    | TRUE
    | FALSE
    | THIS
    | prefixedNonTypeName
    | nonBraceExpression "[" expression "]"
    | nonBraceExpression "[" expression ":" expression "]"
    | "(" expression ")"
    | "!" expression %prec PREFIX
    | "~" expression %prec PREFIX
    | "-" expression %prec PREFIX
    | "+" expression %prec PREFIX
    | typeName "." member
    | ERROR "." member
    | nonBraceExpression "." member
    | nonBraceExpression "*" expression
    | nonBraceExpression "/" expression
    | nonBraceExpression "%" expression
    | nonBraceExpression "+" expression
    | nonBraceExpression "-" expression
    | nonBraceExpression "|+|" expression
    | nonBraceExpression "|-|" expression
    | nonBraceExpression "<<" expression
    | nonBraceExpression ">>" expression
    | nonBraceExpression "<=" expression
    | nonBraceExpression ">=" expression
    | nonBraceExpression "<" expression
    | nonBraceExpression ">" expression
    | nonBraceExpression "!=" expression
    | nonBraceExpression "==" expression
    | nonBraceExpression "&" expression
    | nonBraceExpression "^" expression
    | nonBraceExpression "|" expression
    | nonBraceExpression "++" expression
    | nonBraceExpression "&&" expression
    | nonBraceExpression "||" expression
    | nonBraceExpression "?" expression ":" expression
    | nonBraceExpression "<" realTypeArgumentList ">" "(" argumentList ")"
    | nonBraceExpression "(" argumentList ")"
    | namedType "(" argumentList ")"
    | "(" typeRef ")" expression
    ;
```

1.  an `enum` type used as a field in a `header` must specify a
    underlying type and representation for `enum` elements.

2.  a `struct` or nested `struct` type that has the same properties,
    used as a field in a `header` must contain only `bit<W>`, `int<W>`,
    a serializable `enum`, or a `bool`.

3.  `type B <name>` is allowed for a type name `B` defined via `typedef
    X B` if `type X <name>` is allowed.

4.  The P4Runtime API is defined as a Google Protocol Buffer `.proto`
    file and an accompanying English specification document here:
    <https://github.com/p4lang/p4runtime>

5.  The P4Runtime API is defined as a Google Protocol Buffer `.proto`
    file and an accompanying English specification document here:
    <https://github.com/p4lang/p4runtime>

6.  TDI is the Table Driven Interface. More information can be found
    here: https://github.com/p4lang/tdi

7.  Most existing P4<sub>16</sub> programs today do not use function or
    method calls in table key expressions, and the order of evaluation
    of these key expressions makes no difference in the resulting lookup
    key value. In this overwhelmingly common case, if an implementation
    chooses to insert extra assignment statements to implement
    side-effecting key expressions, but does not insert them when there
    are no side-effecting key expressions, then in typical programs they
    will almost never be inserted.

8.  The P4Runtime API is defined as a Google Protocol Buffer `.proto`
    file and an accompanying English specification document here:
    <https://github.com/p4lang/p4runtime>

