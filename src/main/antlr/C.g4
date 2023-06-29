grammar C;

compilationUnit
   : translationUnit? EOF
   ;

primaryExpression
   : Identifier
   | Constant
   | StringLiteral+
   | '(' expression ')'
   ;

postfixExpression
   : (primaryExpression | '(' typeName ')' '{' initializerList ','? '}') ('[' expression ']' | '(' argumentExpressionList? ')' | ('.' | '->') Identifier | '++' | '--')*
   ;

argumentExpressionList
   : assignmentExpression (',' assignmentExpression)*
   ;

unaryExpression
   : ('++' | '--' | 'sizeof')* (postfixExpression | unaryOperator castExpression | 'sizeof' '(' typeName ')')
   ;

unaryOperator
   : '&'
   | '*'
   | '+'
   | '-'
   | '~'
   | '!'
   ;

castExpression
   : '(' typeName ')' castExpression
   | unaryExpression
   | DigitSequence // for
   
   ;

multiplicativeExpression
   : castExpression (('*' | '/' | '%') castExpression)*
   ;

additiveExpression
   : multiplicativeExpression (('+' | '-') multiplicativeExpression)*
   ;

shiftExpression
   : additiveExpression (('<<' | '>>') additiveExpression)*
   ;

relationalExpression
   : shiftExpression (('<' | '>' | '<=' | '>=') shiftExpression)*
   ;

equalityExpression
   : relationalExpression (('==' | '!=') relationalExpression)*
   ;

andExpression
   : equalityExpression ('&' equalityExpression)*
   ;

exclusiveOrExpression
   : andExpression ('^' andExpression)*
   ;

inclusiveOrExpression
   : exclusiveOrExpression ('|' exclusiveOrExpression)*
   ;

logicalAndExpression
   : inclusiveOrExpression ('&&' inclusiveOrExpression)*
   ;

logicalOrExpression
   : logicalAndExpression ('||' logicalAndExpression)*
   ;

conditionalExpression
   : logicalOrExpression ('?' expression ':' conditionalExpression)?
   ;

assignmentExpression
   : conditionalExpression
   | unaryExpression assignmentOperator assignmentExpression
   | DigitSequence // for
   
   ;

assignmentOperator
   : '='
   | '*='
   | '/='
   | '%='
   | '+='
   | '-='
   | '<<='
   | '>>='
   | '&='
   | '^='
   | '|='
   ;

expression
   : assignmentExpression (',' assignmentExpression)*
   ;

constantExpression
   : conditionalExpression
   ;

declaration
   : declarationSpecifiers initDeclaratorList? ';'
   | staticAssertDeclaration
   ;

declarationSpecifiers
   : declarationSpecifier+
   ;

declarationSpecifiers2
   : declarationSpecifier+
   ;

declarationSpecifier
   : storageClassSpecifier
   | typeSpecifier
   | functionSpecifier
   ;

initDeclaratorList
   : initDeclarator (',' initDeclarator)*
   ;

initDeclarator
   : declarator ('=' initializer)?
   ;

storageClassSpecifier
   : 'typedef'
   ;

typeSpecifier
   : 'void'
   | 'char'
   | 'short'
   | 'int'
   | 'long'
   | 'float'
   | 'double'
   | 'signed'
   | 'unsigned'
   | structOrUnionSpecifier
   | enumSpecifier
   | typedefName
   ;

structOrUnionSpecifier
   : structOrUnion Identifier? '{' structDeclarationList '}'
   | structOrUnion Identifier
   ;

structOrUnion
   : 'struct'
   | 'union'
   ;

structDeclarationList
   : structDeclaration+
   ;

structDeclaration // The first two rules have priority order and cannot be simplified to one expression.
   : specifierQualifierList structDeclaratorList ';'
   | specifierQualifierList ';'
   | staticAssertDeclaration
   ;

specifierQualifierList
   : typeSpecifier specifierQualifierList?
   ;

structDeclaratorList
   : structDeclarator (',' structDeclarator)*
   ;

structDeclarator
   : declarator
   | declarator? ':' constantExpression
   ;

enumSpecifier
   : 'enum' Identifier? '{' enumeratorList ','? '}'
   | 'enum' Identifier
   ;

enumeratorList
   : enumerator (',' enumerator)*
   ;

enumerator
   : enumerationConstant ('=' constantExpression)?
   ;

enumerationConstant
   : Identifier
   ;

functionSpecifier
   : 'inline'
   | '_Noreturn'
   | '__stdcall'
   | '__declspec' '(' Identifier ')'
   ;

declarator
   : pointer? directDeclarator
   ;

directDeclarator
   : Identifier
   | '(' declarator ')'
   | directDeclarator '[' assignmentExpression? ']'
   | directDeclarator '[' 'static' assignmentExpression ']'
   | directDeclarator '[' 'static' assignmentExpression ']'
   | directDeclarator '[' '*' ']'
   | directDeclarator '(' parameterTypeList ')'
   | directDeclarator '(' identifierList? ')'
   | Identifier ':' DigitSequence // bit field
   
   ;

nestedParenthesesBlock
   : (~ ('(' | ')') | '(' nestedParenthesesBlock ')')*
   ;

pointer
   : '*'+
   ;

parameterTypeList
   : parameterList (',' '...')?
   ;

parameterList
   : parameterDeclaration (',' parameterDeclaration)*
   ;

parameterDeclaration
   : declarationSpecifiers declarator
   | declarationSpecifiers2 abstractDeclarator?
   ;

identifierList
   : Identifier (',' Identifier)*
   ;

typeName
   : specifierQualifierList abstractDeclarator?
   ;

abstractDeclarator
   : pointer
   | pointer? directAbstractDeclarator
   ;

directAbstractDeclarator
   : '(' abstractDeclarator ')'
   | '[' assignmentExpression? ']'
   | '[' 'static' assignmentExpression ']'
   | '[' '*' ']'
   | '(' parameterTypeList? ')'
   | directAbstractDeclarator '[' assignmentExpression? ']'
   | directAbstractDeclarator '[' 'static' assignmentExpression ']'
   | directAbstractDeclarator '[' '*' ']'
   | directAbstractDeclarator '(' parameterTypeList? ')'
   ;

typedefName
   : Identifier
   ;

initializer
   : assignmentExpression
   | '{' initializerList ','? '}'
   ;

initializerList
   : designation? initializer (',' designation? initializer)*
   ;

designation
   : designatorList '='
   ;

designatorList
   : designator+
   ;

designator
   : '[' constantExpression ']'
   | '.' Identifier
   ;

staticAssertDeclaration
   : '_Static_assert' '(' constantExpression ',' StringLiteral+ ')' ';'
   ;

statement
   : labeledStatement
   | compoundStatement
   | expressionStatement
   | selectionStatement
   | iterationStatement
   | jumpStatement
   | '(' (logicalOrExpression (',' logicalOrExpression)*)? (':' (logicalOrExpression (',' logicalOrExpression)*)?)* ')' ';'
   ;

labeledStatement
   : Identifier ':' statement
   | 'case' constantExpression ':' statement
   | 'default' ':' statement
   ;

compoundStatement
   : '{' blockItemList? '}'
   ;

blockItemList
   : blockItem+
   ;

blockItem
   : statement
   | declaration
   ;

expressionStatement
   : expression? ';'
   ;

selectionStatement
   : 'if' '(' expression ')' statement ('else' statement)?
   | 'switch' '(' expression ')' statement
   ;

iterationStatement
   : While '(' expression ')' statement
   | Do statement While '(' expression ')' ';'
   | For '(' forCondition ')' statement
   ;

forCondition
   : (forDeclaration | expression?) ';' forExpression? ';' forExpression?
   ;

forDeclaration
   : declarationSpecifiers initDeclaratorList?
   ;

forExpression
   : assignmentExpression (',' assignmentExpression)*
   ;

jumpStatement
   : ('goto' Identifier | 'continue' | 'break' | 'return' expression?) ';'
   ;

translationUnit
   : externalDeclaration+
   ;

externalDeclaration
   : functionDefinition
   | declaration
   | ';' // stray ;
   
   ;

functionDefinition
   : declarationSpecifiers? declarator declarationList? compoundStatement
   ;

declarationList
   : declaration+
   ;

Auto
   : 'auto'
   ;

Break
   : 'break'
   ;

Case
   : 'case'
   ;

Char
   : 'char'
   ;

Const
   : 'const'
   ;

Continue
   : 'continue'
   ;

Default
   : 'default'
   ;

Do
   : 'do'
   ;

Double
   : 'double'
   ;

Else
   : 'else'
   ;

Enum
   : 'enum'
   ;

Extern
   : 'extern'
   ;

Float
   : 'float'
   ;

For
   : 'for'
   ;

Goto
   : 'goto'
   ;

If
   : 'if'
   ;

Inline
   : 'inline'
   ;

Int
   : 'int'
   ;

Long
   : 'long'
   ;

Register
   : 'register'
   ;

Restrict
   : 'restrict'
   ;

Return
   : 'return'
   ;

Short
   : 'short'
   ;

Signed
   : 'signed'
   ;

Sizeof
   : 'sizeof'
   ;

Static
   : 'static'
   ;

Struct
   : 'struct'
   ;

Switch
   : 'switch'
   ;

Typedef
   : 'typedef'
   ;

Union
   : 'union'
   ;

Unsigned
   : 'unsigned'
   ;

Void
   : 'void'
   ;

Volatile
   : 'volatile'
   ;

While
   : 'while'
   ;

LeftParen
   : '('
   ;

RightParen
   : ')'
   ;

LeftBracket
   : '['
   ;

RightBracket
   : ']'
   ;

LeftBrace
   : '{'
   ;

RightBrace
   : '}'
   ;

Less
   : '<'
   ;

LessEqual
   : '<='
   ;

Greater
   : '>'
   ;

GreaterEqual
   : '>='
   ;

LeftShift
   : '<<'
   ;

RightShift
   : '>>'
   ;

Plus
   : '+'
   ;

PlusPlus
   : '++'
   ;

Minus
   : '-'
   ;

MinusMinus
   : '--'
   ;

Star
   : '*'
   ;

Div
   : '/'
   ;

Mod
   : '%'
   ;

And
   : '&'
   ;

Or
   : '|'
   ;

AndAnd
   : '&&'
   ;

OrOr
   : '||'
   ;

Caret
   : '^'
   ;

Not
   : '!'
   ;

Tilde
   : '~'
   ;

Question
   : '?'
   ;

Colon
   : ':'
   ;

Semi
   : ';'
   ;

Comma
   : ','
   ;

Assign
   : '='
   ;
   // '*=' | '/=' | '%=' | '+=' | '-=' | '<<=' | '>>=' | '&=' | '^=' | '|='
   
StarAssign
   : '*='
   ;

DivAssign
   : '/='
   ;

ModAssign
   : '%='
   ;

PlusAssign
   : '+='
   ;

MinusAssign
   : '-='
   ;

LeftShiftAssign
   : '<<='
   ;

RightShiftAssign
   : '>>='
   ;

AndAssign
   : '&='
   ;

XorAssign
   : '^='
   ;

OrAssign
   : '|='
   ;

Equal
   : '=='
   ;

NotEqual
   : '!='
   ;

Arrow
   : '->'
   ;

Dot
   : '.'
   ;

Ellipsis
   : '...'
   ;

Identifier
   : IdentifierNondigit (IdentifierNondigit | Digit)*
   ;

fragment IdentifierNondigit
   : Nondigit
   | UniversalCharacterName
   //|   // other implementation-defined characters...
   
   ;

fragment Nondigit
   : [a-zA-Z_]
   ;

fragment Digit
   : [0-9]
   ;

fragment UniversalCharacterName
   : '\\u' HexQuad
   | '\\U' HexQuad HexQuad
   ;

fragment HexQuad
   : HexadecimalDigit HexadecimalDigit HexadecimalDigit HexadecimalDigit
   ;

Constant
   : IntegerConstant
   | FloatingConstant
   //|   EnumerationConstant
   | CharacterConstant
   ;

fragment IntegerConstant
   : DecimalConstant IntegerSuffix?
   | OctalConstant IntegerSuffix?
   | HexadecimalConstant IntegerSuffix?
   | BinaryConstant
   ;

fragment BinaryConstant
   : '0' [bB] [0-1]+
   ;

fragment DecimalConstant
   : NonzeroDigit Digit*
   ;

fragment OctalConstant
   : '0' OctalDigit*
   ;

fragment HexadecimalConstant
   : HexadecimalPrefix HexadecimalDigit+
   ;

fragment HexadecimalPrefix
   : '0' [xX]
   ;

fragment NonzeroDigit
   : [1-9]
   ;

fragment OctalDigit
   : [0-7]
   ;

fragment HexadecimalDigit
   : [0-9a-fA-F]
   ;

fragment IntegerSuffix
   : UnsignedSuffix LongSuffix?
   | UnsignedSuffix LongLongSuffix
   | LongSuffix UnsignedSuffix?
   | LongLongSuffix UnsignedSuffix?
   ;

fragment UnsignedSuffix
   : [uU]
   ;

fragment LongSuffix
   : [lL]
   ;

fragment LongLongSuffix
   : 'll'
   | 'LL'
   ;

fragment FloatingConstant
   : DecimalFloatingConstant
   | HexadecimalFloatingConstant
   ;

fragment DecimalFloatingConstant
   : FractionalConstant ExponentPart? FloatingSuffix?
   | DigitSequence ExponentPart FloatingSuffix?
   ;

fragment HexadecimalFloatingConstant
   : HexadecimalPrefix (HexadecimalFractionalConstant | HexadecimalDigitSequence) BinaryExponentPart FloatingSuffix?
   ;

fragment FractionalConstant
   : DigitSequence? '.' DigitSequence
   | DigitSequence '.'
   ;

fragment ExponentPart
   : [eE] Sign? DigitSequence
   ;

fragment Sign
   : [+-]
   ;

DigitSequence
   : Digit+
   ;

fragment HexadecimalFractionalConstant
   : HexadecimalDigitSequence? '.' HexadecimalDigitSequence
   | HexadecimalDigitSequence '.'
   ;

fragment BinaryExponentPart
   : [pP] Sign? DigitSequence
   ;

fragment HexadecimalDigitSequence
   : HexadecimalDigit+
   ;

fragment FloatingSuffix
   : [flFL]
   ;

fragment CharacterConstant
   : '\'' CCharSequence '\''
   | 'L\'' CCharSequence '\''
   | 'u\'' CCharSequence '\''
   | 'U\'' CCharSequence '\''
   ;

fragment CCharSequence
   : CChar+
   ;

fragment CChar
   : ~ ['\\\r\n]
   | EscapeSequence
   ;

fragment EscapeSequence
   : SimpleEscapeSequence
   | OctalEscapeSequence
   | HexadecimalEscapeSequence
   | UniversalCharacterName
   ;

fragment SimpleEscapeSequence
   : '\\' ['"?abfnrtv\\]
   ;

fragment OctalEscapeSequence
   : '\\' OctalDigit OctalDigit? OctalDigit?
   ;

fragment HexadecimalEscapeSequence
   : '\\x' HexadecimalDigit+
   ;

StringLiteral
   : EncodingPrefix? '"' SCharSequence? '"'
   ;

fragment EncodingPrefix
   : 'u8'
   | 'u'
   | 'U'
   | 'L'
   ;

fragment SCharSequence
   : SChar+
   ;

fragment SChar
   : ~ ["\\\r\n]
   | EscapeSequence
   | '\\\n' // Added line
   | '\\\r\n' // Added line
   
   ;

ComplexDefine
   : '#' Whitespace? 'define' ~ [#\r\n]* -> skip
   ;

IncludeDirective
   : '#' Whitespace? 'include' Whitespace? ('"' ~ [\r\n]* '"' | '<' ~ [\r\n]* '>') Whitespace? Newline -> skip
   ;
   // ignore the following asm blocks:
   
/*
    asm
    {
        mfspr x, 286;
    }
 */
   
   
AsmBlock
   : 'asm' ~ '{'* '{' ~ '}'* '}' -> skip
   ;
   // ignore the lines generated by c preprocessor
   
   // sample line : '#line 1 "/home/dm/files/dk1.h" 1'
   
LineAfterPreprocessing
   : '#line' Whitespace* ~ [\r\n]* -> skip
   ;

LineDirective
   : '#' Whitespace? DecimalConstant Whitespace? StringLiteral ~ [\r\n]* -> skip
   ;

PragmaDirective
   : '#' Whitespace? 'pragma' Whitespace ~ [\r\n]* -> skip
   ;

Whitespace
   : [ \t]+ -> skip
   ;

Newline
   : ('\r' '\n'? | '\n') -> skip
   ;

BlockComment
   : '/*' .*? '*/' -> skip
   ;

LineComment
   : '//' ~ [\r\n]* -> skip
   ;

