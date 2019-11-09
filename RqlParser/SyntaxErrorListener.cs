﻿using System;
using System.Collections.Generic;
using System.Text;
using Antlr4.Runtime;

namespace RqlParser
{
    public readonly struct SyntaxError
    {
        public readonly IRecognizer Recognizer;
        public readonly IToken OffendingSymbol;
        public readonly int Line;
        public readonly int CharPositionInLine;
        public readonly string Msg;
        public readonly RecognitionException Exception;

        public SyntaxError(IRecognizer recognizer, IToken offendingSymbol, int line, int charPositionInLine, string msg, RecognitionException exception)
        {
            Recognizer = recognizer;
            OffendingSymbol = offendingSymbol;
            Line = line;
            CharPositionInLine = charPositionInLine;
            Msg = msg;
            Exception = exception;
        }
    }

    public class SyntaxErrorListener : BaseErrorListener
    {
        public readonly List<SyntaxError> Errors = new List<SyntaxError>();
        public override void SyntaxError(IRecognizer recognizer, IToken offendingSymbol, int line, int charPositionInLine, string msg,
            RecognitionException e)
        {
            Errors.Add(new SyntaxError(recognizer, offendingSymbol, line, charPositionInLine, msg, e));
        }
    }
}