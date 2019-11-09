parser grammar RqlDocumentQueryParser;
options { tokenVocab = RqlLexer; }

import RqlCommonParser;

documentQuery: EOF?;

