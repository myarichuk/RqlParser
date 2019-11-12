parser grammar RqlCommonParser;
//common parse rules like 'where' or 'order by' clause handling should be declared here

expressionList:
		expression ( 
					(
						(
							COMMA | 
							{ NotifyErrorListeners(_input.Lt(-1),"Missing ','", null); }
						) 
						expression 
					)
					|
					(
						COMMA
						{ NotifyErrorListeners(_input.Lt(-1),"Missing expression", null); }
					)
				)*
	|	COMMA { NotifyErrorListeners(_input.Lt(-1),"Missing expression at the start of the list (before the first ',')", null); } expression ((COMMA | { NotifyErrorListeners(_input.Lt(-1),"Missing ','", null); }) expression)*
	;
	 
expression
		:
			literal #LiteralExpression
		|   parameter #ParemeterExpression
		|   identifier #IdentifierExpression
		|   instance = 				
				IDENTIFIER 
				( OPEN_BRACKET CLOSE_BRACKET |
				  OPEN_BRACKET { NotifyErrorListeners(_input.Lt(-1),"Missing ']'", null);} |
				  CLOSE_BRACKET { NotifyErrorListeners(_input.Lt(-1),"Missing '['", null);} 
				)
				#CollectionReferenceExpression
		|   instance = IDENTIFIER 
						(
						OPEN_BRACKET
							(literal | parameter | identifier | { NotifyErrorListeners(_input.Lt(-1),"RQL supports only literals, paremeters or identifiers as indexer values", null);})
						CLOSE_BRACKET
						|
						OPEN_BRACKET
							(literal | parameter | identifier | { NotifyErrorListeners(_input.Lt(-1),"RQL supports only literals, paremeters or identifiers as indexer values", null);})
						{ NotifyErrorListeners(_input.Lt(-1),"Missing ']'", null);}
						|
						{ NotifyErrorListeners(_input.Lt(-1),"Missing '['", null);}
							(literal | parameter | identifier | { NotifyErrorListeners(_input.Lt(-1),"RQL supports only literals, paremeters or identifiers as indexer values", null);})
						CLOSE_BRACKET
						) #CollectionIndexerExpression		
		|   instance = expression DOT field = expression #MemberExpression
		|   functionName = IDENTIFIER OPEN_PAREN expressionList? CLOSE_PAREN #MethodExpression
		;

literalList: 
		literal ( 
					(
						(
							COMMA | 
							{ NotifyErrorListeners(_input.Lt(-1),"Missing ','", null); }
						) 
						literal 
					)
					|
					(
						COMMA
						{ NotifyErrorListeners(_input.Lt(-1),"Missing a value", null); }
					)
				)*
	|	COMMA { NotifyErrorListeners(_input.Lt(-1),"Missing a value at the start of the list (before the first ',')", null); } literal ((COMMA | { NotifyErrorListeners(_input.Lt(-1),"Missing ','", null); }) literal)*
	;

parameter: PARAMETER;
identifier: IDENTIFIER;

literal:
		BOOLEAN_LITERAL #Boolean
	|	DOUBLE_LITERAL	#Double
	|	LONG_LITERAL    #Long
	|	STRING_LITERAL  #String
	|	NULL_LITERAL	#Null
	;