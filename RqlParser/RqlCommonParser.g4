parser grammar RqlCommonParser;
//common parse rules like 'where' or 'order by' clause handling should be declared here

literalList: 
		literal ((COMMA | { NotifyErrorListeners(_input.Lt(-1),"Missing ','", null); }) literal)*
	;

literal:
		BOOLEAN_LITERAL #Boolean
	|	DOUBLE_LITERAL	#Double
	|	LONG_LITERAL    #Long
	|	STRING_LITERAL  #String
	|	NULL_LITERAL	#Null
	;