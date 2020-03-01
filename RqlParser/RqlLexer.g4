lexer grammar RqlLexer;
channels { ERROR }

//operators
ARROW_RIGHT: '->';
ARROW_LEFT: '<-';
COLON: ':';
DOT : '.';
OPEN_CURLY: '{';
CLOSE_CURLY: '}';
OPEN_PAREN : '(';
CLOSE_PAREN : ')';
OPEN_BRACKET: '[';
CLOSE_BRACKET: ']';
COMMA : ',';
ASSIGN : '=';
STAR : '*';
PLUS : '+';
MINUS : '-';
TILDE : '~';
DIV : '/';
MOD : '%';
AMP : '&';
PIPE : '|';
LT : '<';
LT_EQ : '<=';
GT : '>';
GT_EQ : '>=';
EQ : '=' | '==';
NOT_EQ : '!=' | '<>';
BETWEEN: B E T W E E N;
AND: A N D;
OR: O R;
NOT: N O T;

DASH: '-';
AT: '@';


//keywords
ALL_DOCS: AT A L L '_' D O C S;
DECLARE: D E C L A R E;
FROM: F R O M;
GROUP_BY: G R O U P ' ' B Y;
WHERE: W H E R E;
ORDER_BY: O R D E R ' ' B Y;
ASCENDING: A S C | A S C E N D I N G;
DESCENDING: D E S C | D E S C E N D I N G;
AS: A S;
LOAD: L O A D;
SELECT: S E L E C T;
DISTINCT: D I S T I N C T;
UPDATE: U P D A T E;
INCLUDE: I N C L U D E;
WITH: W I T H;
MATCH: M A T C H;
IN: I N;
ALL_IN: A L L ' ' IN;
EDGES: E D G E S;
PARAMETER: '$' IDENTIFIER;

IDENTIFIER
 : [a-zA-Z_] [a-zA-Z_0-9]* // TODO: make sure the definition fits RQL rules
 ;

BOOLEAN_LITERAL: T R U E | F A L S E;
NULL_LITERAL: N U L L;

DOUBLE_LITERAL: DIGIT+ '.' DIGIT+;
LONG_LITERAL: DIGIT+;

STRING_LITERAL: D_STRING | S_STRING;
fragment D_STRING: '"' ( '\\'. | '""' | ~('"'| '\\') )*? '"';
fragment S_STRING: '\'' ('\\'. | '\'\'' | ~('\'' | '\\'))*? '\'';

SINGLE_LINE_COMMENT
 : '//' ~[\r\n]* -> channel(HIDDEN)
 ;

MULTILINE_COMMENT
 : '/*' .*? ( '*/' | EOF ) -> channel(HIDDEN)
 ;

SPACES
 : [ \u000B\t\r\n] -> channel(HIDDEN)
 ;

UNEXPECTED_CHAR
: .
;

fragment DIGIT : [0-9];
 
fragment A : [aA]; // match either an 'a' or 'A'
fragment B : [bB];
fragment C : [cC];
fragment D : [dD];
fragment E : [eE];
fragment F : [fF];
fragment G : [gG];
fragment H : [hH];
fragment I : [iI]; 
fragment J : [jJ];
fragment K : [kK];
fragment L : [lL];
fragment M : [mM];
fragment N : [nN];
fragment O : [oO];
fragment P : [pP];
fragment Q : [qQ];
fragment R : [rR];
fragment S : [sS];
fragment T : [tT];
fragment U : [uU];
fragment V : [vV];
fragment W : [wW];
fragment X : [xX];
fragment Y : [yY];
fragment Z : [zZ];