parser grammar RqlCommonParser;
import JavaScriptParser;
//common parse rules like 'where' or 'order by' clause handling should be declared here

selectSqlField: expression aliasClause?;
selectJsField: IDENTIFIER COLON singleExpression;
selectClause: 
	  SELECT DISTINCT? fields += selectSqlField ((COMMA | { NotifyErrorListeners(_input.Lt(-1),"Missing ','", null); }) 
					   fields+= selectSqlField)* #SqlSelectClause
	| SELECT DISTINCT? OPEN_CURLY fields += selectJsField ((COMMA | { NotifyErrorListeners(_input.Lt(-1),"Missing ','", null); }) 
					   fields+= selectJsField)* CLOSE_CURLY #JsSelectClause
	| SELECT DISTINCT? { NotifyErrorListeners(_input.Lt(-1), "Missing fields in 'select' clause",null); } #MissingFieldsJsClause;

aliasClause: AS alias = IDENTIFIER 
			| 
			 AS { NotifyErrorListeners(_input.Lt(-1),"Expecting identifier (alias) after 'as' keyword", null); }
			|  alias = IDENTIFIER { NotifyErrorListeners(_input.Lt(-1),"Missing 'as' keyword", null); }
			;

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
			literal #RqlLiteralExpression
		|   PARAMETER #RqlParemeterExpression
		|   IDENTIFIER #RqlIdentifierExpression
		|   instance = 				
				IDENTIFIER 
				( OPEN_BRACKET CLOSE_BRACKET |
				  OPEN_BRACKET { NotifyErrorListeners(_input.Lt(-1),"Missing ']'", null);} |
				  CLOSE_BRACKET { NotifyErrorListeners(_input.Lt(-1),"Missing '['", null);} 
				)
				#RqlCollectionReferenceExpression
		|   instance = IDENTIFIER 
						(
						OPEN_BRACKET
							indexerValue
						CLOSE_BRACKET
						|
						OPEN_BRACKET
							indexerValue
						{ NotifyErrorListeners(_input.Lt(-1),"Missing ']'", null);}
						|
						{ NotifyErrorListeners(_input.Lt(-1),"Missing '['", null);}
							indexerValue
						CLOSE_BRACKET
						) #RqlCollectionIndexerExpression		
		|   instance = expression DOT field = expression #RqlMemberExpression
		|   functionName = IDENTIFIER OPEN_PAREN expressionList? CLOSE_PAREN #RqlMethodExpression
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

indexerValue: 
	literal #LiteralIndexerValue | 
	PARAMETER #ParameterIndexerValue | 
	IDENTIFIER #IdentifierIndexerValue | 
	{ NotifyErrorListeners(_input.Lt(-1),"RQL supports only literals, paremeters or identifiers as indexer values", null);} #InvalidIndexerValue; 



literal:
		BOOLEAN_LITERAL #Boolean
	|	DOUBLE_LITERAL	#Double
	|	LONG_LITERAL    #Long
	|	STRING_LITERAL  #String
	|	NULL_LITERAL	#Null
	;