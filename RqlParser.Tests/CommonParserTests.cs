using System.Linq;
using Antlr4.Runtime;
using Xunit;

namespace RqlParser.Tests
{
    public class CommonParserTests
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

        }
    }
}
