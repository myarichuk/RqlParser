using System.Linq;
using Antlr4.Runtime;
using Xunit;

namespace RqlParser.Tests.CommonParser
{
    public class LiteralListTests
    {
        [Fact]
        public void Literal_list_should_parse()
        {
            var lexer = new RqlLexer(new AntlrInputStream("1, 2, 3 ,4 "));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var parseResult = parser.literalList();

            var values = parseResult.literal().Select(t => int.Parse(t.GetText())).ToArray();

            Assert.Equal(new[]{1,2,3,4}, values);
        }

        [Fact]
        public void Literal_list_with_missing_first_comma_should_properly_error()
        {
            var lexer = new RqlLexer(new AntlrInputStream("1 2, 3 ,4 "));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.literalList();

            Assert.Single(errorListener.Errors);
            Assert.Equal("1", errorListener.Errors[0].OffendingSymbol.Text);
        }

        [Fact]
        public void Literal_list_with_multiple_missing_commas_should_properly_error()
        {
            var lexer = new RqlLexer(new AntlrInputStream("1 2, 3 4 "));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.literalList();

            Assert.Equal(2, errorListener.Errors.Count);
            Assert.Contains("Missing ','", errorListener.Errors[0].Message);
            Assert.Contains("Missing ','", errorListener.Errors[1].Message);
            Assert.Equal("1", errorListener.Errors[0].OffendingSymbol.Text);
            Assert.Equal("3", errorListener.Errors[1].OffendingSymbol.Text);

        }

        [Fact]
        public void Literal_list_with_missing_literal_at_start_should_properly_error()
        {
            var lexer = new RqlLexer(new AntlrInputStream(",   2, ,4 "));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.literalList();

            Assert.Equal(2, errorListener.Errors.Count);
            Assert.Contains("Missing a value at the start", errorListener.Errors[0].Message);
            Assert.Equal(",", errorListener.Errors[0].OffendingSymbol.Text);
            Assert.Contains("Missing a value", errorListener.Errors[0].Message);
            Assert.Equal(",", errorListener.Errors[1].OffendingSymbol.Text);
        }

        [Fact]
        public void Literal_list_with_missing_literal_should_properly_error()
        {
            var lexer = new RqlLexer(new AntlrInputStream("1,   2, ,4 "));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.literalList();

            Assert.Single(errorListener.Errors);
            Assert.Contains("Missing a value", errorListener.Errors[0].Message);
            Assert.Equal(",", errorListener.Errors[0].OffendingSymbol.Text);
        }

        [Fact]
        public void Literal_list_with_multiple_missing_literals_should_properly_error()
        {
            var lexer = new RqlLexer(new AntlrInputStream("1,   2, ,4, 5, , 6, 7, ,8 "));
            var parser = new RqlParser(new CommonTokenStream(lexer));
            var errorListener = new SyntaxErrorListener();
            parser.AddErrorListener(errorListener);
            var parseResult = parser.literalList();

            Assert.Equal(3, errorListener.Errors.Count);
            foreach (var error in errorListener.Errors)
            {
                Assert.Contains("Missing a value", error.Message);
                Assert.Equal(",", error.OffendingSymbol.Text);
            }
        }
    }
}
