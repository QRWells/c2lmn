grammar C;

program
   : decl
   | def
   ;

decl
   : func_sig ';'
   | type ID ';'
   ;

def
   : func_sig block
   | type ID ('=' expr)? ';'
   ;

block
   : '{' stmt* '}'
   ;

stmt
   : block
   | 'if' '(' expr ')' stmt ('else' stmt)?
   | 'while' '(' expr ')' stmt
   | 'return' expr? ';'
   | expr ';'
   ;

expr
   : '(' expr ')'
   | ID '(' expr (',' expr)* ')'
   | ID
   | INT
   | FLOAT
   ;

type
   : 'int'
   | 'float'
   | 'void'
   ;

func_sig
   : type ID '(' arg_list? ')'
   ;

arg_list
   : arg (',' arg)*
   ;

arg
   : type ID
   ;

COMMENT
   : '/*' .*? '*/' -> channel (HIDDEN)
   ;

WS
   : [ \t\r\n]+ -> skip
   ;

ID
   : [a-zA-Z_]+ [a-zA-Z_0-9]*
   ;

INT
   : [0-9]+
   ;

FLOAT
   : [0-9]+ '.' [0-9]*
   ;

