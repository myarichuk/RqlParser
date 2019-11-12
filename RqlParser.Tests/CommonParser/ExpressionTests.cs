using Antlr4.Runtime;
using Xunit;

namespace RqlParser.Tests.CommonParser
{
    public class ExpressionTests
    {
        [Fact]
        public void DString_can_be_parsed()
        {
            var lexer = new RqlLexer(new AntlrInputStream("\"foobar\""));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.expression();

            Assert.Empty(errorListener.Errors);
            Assert.IsType<RqlParser.StringContext>(parseResult.children[0]);
        }

        [Fact]
        public void SString_can_be_parsed()
        {
            var lexer = new RqlLexer(new AntlrInputStream("'foobar'"));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.expression();

            Assert.Empty(errorListener.Errors);
            Assert.IsType<RqlParser.StringContext>(parseResult.children[0]);
        }

        [Fact]
        public void Int_can_be_parsed()
        {
            var lexer = new RqlLexer(new AntlrInputStream("123"));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.expression();

            Assert.Empty(errorListener.Errors);
            Assert.IsType<RqlParser.LongContext>(parseResult.children[0]);
        }

        [Fact]
        public void Double_can_be_parsed()
        {
            var lexer = new RqlLexer(new AntlrInputStream("123.456"));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.expression();

            Assert.Empty(errorListener.Errors);
            Assert.IsType<RqlParser.DoubleContext>(parseResult.children[0]);
        }

        [Fact]
        public void Identifier_can_be_parsed()
        {
            var lexer = new RqlLexer(new AntlrInputStream("foobar"));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.expression();

            Assert.Empty(errorListener.Errors);
            Assert.IsType<RqlParser.IdentifierExpressionContext>(parseResult);
        }  
        
        [Fact]
        public void Parameter_can_be_parsed()
        {
            var lexer = new RqlLexer(new AntlrInputStream("$foobar"));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.expression();

            Assert.Empty(errorListener.Errors);
            Assert.IsType<RqlParser.ParemeterExpressionContext>(parseResult);
        }
        
        [Fact]
        public void CollectionReference_can_be_parsed()
        {
            var lexer = new RqlLexer(new AntlrInputStream("foobar[]"));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.expression();

            Assert.Empty(errorListener.Errors);
            Assert.IsType<RqlParser.CollectionReferenceExpressionContext>(parseResult);
        }

        [Fact]
        public void CollectionReference_missing_open()
        {
            var lexer = new RqlLexer(new AntlrInputStream("foobar]"));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.expression();

            Assert.Single(errorListener.Errors);
            Assert.Contains("'['", errorListener.Errors[0].Message);
            Assert.Equal("]", errorListener.Errors[0].OffendingSymbol.Text);
            Assert.IsType<RqlParser.CollectionReferenceExpressionContext>(parseResult);
        }

        [Fact]
        public void CollectionReference_missing_closing()
        {
            var lexer = new RqlLexer(new AntlrInputStream("foobar["));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.expression();

            Assert.Single(errorListener.Errors);
            Assert.Contains("']'", errorListener.Errors[0].Message);
            Assert.Equal("[", errorListener.Errors[0].OffendingSymbol.Text);
            Assert.IsType<RqlParser.CollectionReferenceExpressionContext>(parseResult);
        }

        [Fact]
        public void CollectionIndexer_missing_open()
        {
            var lexer = new RqlLexer(new AntlrInputStream("foobar foo]"));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.expression();

            Assert.IsType<RqlParser.CollectionIndexerExpressionContext>(parseResult);
            Assert.Single(errorListener.Errors);
            Assert.Contains("'['", errorListener.Errors[0].Message);
            Assert.Equal("foo", errorListener.Errors[0].OffendingSymbol.Text);
        }

        [Fact]
        public void CollectionIndexer_missing_closing()
        {
            var lexer = new RqlLexer(new AntlrInputStream("foobar[foo"));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.expression();

            Assert.Single(errorListener.Errors);
            Assert.Contains("']'", errorListener.Errors[0].Message);
            Assert.Equal("foo", errorListener.Errors[0].OffendingSymbol.Text);
            Assert.IsType<RqlParser.CollectionIndexerExpressionContext>(parseResult);
        }
    }
}
