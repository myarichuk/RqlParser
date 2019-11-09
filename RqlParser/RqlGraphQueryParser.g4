parser grammar RqlGraphQueryParser;
options { tokenVocab = RqlLexer; }

import RqlCommonParser;

graphQuery: DOT EOF?;