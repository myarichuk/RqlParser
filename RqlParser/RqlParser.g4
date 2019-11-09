parser grammar RqlParser;
options { tokenVocab = RqlLexer; }

import RqlCommonParser, //stuff common to all parsers like 'where' clause handling
	   RqlDocumentQueryParser, //stuff specific to document queries
       RqlGraphQueryParser; //stuff specific to graph queries

query: (graphQuery | documentQuery) EOF;