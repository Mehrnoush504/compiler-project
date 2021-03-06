grammar myCompiler;

program: moduleDeclarations otherModules driverModule otherModules;
moduleDeclarations: moduleDeclaration moduleDeclarations | /* epsilon */ ;
moduleDeclaration: DECLARE MODULE ID SEMICOL;
otherModules: module otherModules | /* epsilon */ ;
driverModule: DEF DRIVER PROGRAM ENDDEF moduleDef;
module: DEF MODULE ID ENDDEF TAKES INPUT SQBO input_plist SQBC SEMICOL ret moduleDef;
ret: RETURNS SQBO output_plist SQBC SEMICOL | /* epsilon */ ;
input_plist: input_plist COMMA ID COLON dataType | ID COLON dataType;
output_plist: output_plist COMMA ID COLON type | ID COLON type;
type: INTEGER | REAL | BOOLEAN;
dataType: type | ARRAY SQBO range SQBC OF type;
moduleDef: START statements END;
statements: statement statements | /* epsilon */ ;
statement: ioStmt | simpleStmt | declareStmt | condionalStmt | iterativeStmt /*| SEMICOL*/;
ioStmt: GET_VALUE BO ID BC SEMICOL | PRINT BO var BC SEMICOL;
var: ID whichId | NUM | RNUM;
whichId: SQBO ID SQBC | /* epsilon */ ;
simpleStmt: assignmentStmt | moduleReuseStmt;
assignmentStmt: ID whichStmt;
whichStmt: lvalueIDStmt | lvalueARRStmt;
lvalueIDStmt: ASSIGNOP expression SEMICOL;
lvalueARRStmt: SQBO index SQBC ASSIGNOP expression SEMICOL;
index: NUM | ID;
moduleReuseStmt: optional USE MODULE ID WITH PARAMETERS idList SEMICOL;
optional: SQBO idList SQBC ASSIGNOP | /* epsilon */ ;
idList: idList COMMA ID | ID;
expression: arithmeticExpr | booleanExpr;
arithmeticExpr: arithmeticExpr op term | term;
term: term op factor | factor;
factor: BO arithmeticExpr BC | var;
op: PLUS | MINUS | MUL | DIV;
booleanExpr: booleanExpr logicalOp booleanExpr | arithmeticExpr relationalOp arithmeticExpr | BO booleanExpr BC;
logicalOp: AND | OR;
relationalOp: LT | LE | GT | GE | EQ | NE;
declareStmt: DECLARE idList COLON dataType SEMICOL;
condionalStmt: SWITCH BO ID BC START caseStmt default END;
caseStmt: CASE value COLON statements BREAK SEMICOL caseStmt;
value: NUM | TRUE | FALSE;
default: DEFAULT COLON statements BREAK SEMICOL | /* epsilon */ ;
iterativeStmt: FOR BO ID IN range BC START statements END | WHILE BO booleanExpr BC START statements END;
range: NUM RANGEOP NUM;

//Keywords
INTEGER: 'integer';
REAL: 'real';
BOOLEAN: 'boolean';
OF: 'of';
ARRAY: 'array';
START : 'start';
END: 'end';
DECLARE : 'declare';
MODULE: 'module';
DRIVER: 'driver';
PROGRAM: 'program';
GET_VALUE: 'get_value';
PRINT: 'print';
USE: 'use';
WITH: 'with';
PARAMETERS : 'parameters';
TRUE: 'true';
FALSE: 'false';
//
TAKES: 'takes';
INPUT: 'input';
RETURNS: 'returns';
AND : 'AND';
OR: 'OR';
FOR: 'for';
IN: 'in';
SWITCH: 'switch';
CASE: 'case';
BREAK: 'break';
DEFAULT: 'default';
WHILE: 'while';
//symbols
PLUS: '+';
MINUS: '-';
MUL: '*';
DIV: '/';
LT: '<';
LE: '<=';
GE: '>=';
GT: '>';
EQ: '==';
NE: '!=';
DEF: '<<';
ENDDEF: '>>';
COLON: ':';
RANGEOP: '..';
SEMICOL: ';';
COMMA: ',';
ASSIGNOP: ':=';
SQBO: '[';
SQBC: ']';
BO: '(';
BC: ')';
COMMENTMA: '**';

// Identifiers
ID : ('_'|LETTER)+ ('_'|LETTER|DIGIT)*;
NUM : DIGIT+;
RNUM : ( (NUM? '.' NUM) | (NUM '.') ) EXP?;
WS : [\t\n ]+ -> skip;
fragment LETTER: [a-zA-Z];
fragment DIGIT : [0-9];
fragment EXP: '^'[-+]?NUM;
