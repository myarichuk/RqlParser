using Antlr4.Runtime;
using System;
using System.Collections.Generic;
using System.Text;
using Xunit;

namespace RqlParser.Tests.CommonParser
{
    public class QueryElementsTest
    {
        [Fact]
        public void Alias_parsing_should_work()
        {
            var lexer = new RqlLexer(new AntlrInputStream("AS foobar"));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.aliasClause();
            Assert.Equal("foobar", parseResult.alias.Text);
            Assert.Empty(errorListener.Errors);
        }

        [Fact]
        public void Alias_missing_keyword_should_error()
        {
            var lexer = new RqlLexer(new AntlrInputStream("foobar"));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.aliasClause();
            
            Assert.Single(errorListener.Errors);
            Assert.IsType<SyntaxError>(errorListener.Errors[0]);
        }

        [Fact]
        public void Alias_missing_alias_should_error()
        {
            var lexer = new RqlLexer(new AntlrInputStream("As"));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.aliasClause();

            Assert.Single(errorListener.Errors);
            Assert.IsType<SyntaxError>(errorListener.Errors[0]);
        }

    }
}
