/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 by Bart Kiers (original author) and Alexandre Vitorelli (contributor -> ported to CSharp)
 * Copyright (c) 2017 by Ivan Kochurkin (Positive Technologies):
    added ECMAScript 6 support, cleared and transformed to the universal grammar.
 * Copyright (c) 2018 by Juan Alvarez (contributor -> ported to Go)
 * Copyright (c) 2019 by Student Main (contributor -> ES2020)
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
parser grammar JavaScriptParser;
options { tokenVocab = JavaScriptLexer; }

javaScript
    : HashBangLine? sourceElements? EOF
    ;

sourceElement
    : statement
    ;

statement
    : block
    | variableStatement
    | importStatement
    | exportStatement
    | emptyStatement
    | classDeclaration
    | expressionStatement
    | ifStatement
    | iterationStatement
    | continueStatement
    | breakStatement
    | returnStatement
    | yieldStatement
    | withStatement
    | labelledStatement
    | switchStatement
    | throwStatement
    | tryStatement
    | debuggerStatement
    | functionDeclaration
    ;

block
    : OpenBrace statementList? CloseBrace
    ;

statementList
    : statement+
    ;

importStatement
    : Import importFromBlock
    ;

importFromBlock
    : importDefault? (importNamespace | moduleItems) importFrom eos
    | StringLiteral eos
    ;

moduleItems
    : OpenBrace (aliasName Comma)* (aliasName Comma?)? CloseBrace
    ;

importDefault
    : aliasName Comma
    ;

importNamespace
    : Multiply (As identifierName)?
    ;

importFrom
    : From StringLiteral
    ;

aliasName
    : identifierName (As identifierName )?
    ;

exportStatement
    : Export (exportFromBlock | declaration) eos    # ExportDeclaration
    | Export Default singleExpression eos           # ExportDefaultDeclaration
    ;

exportFromBlock
    : importNamespace importFrom eos
    | moduleItems importFrom? eos
    ;

declaration
    : variableStatement
    | classDeclaration
    | functionDeclaration
    ;

variableStatement
    : varModifier variableDeclarationList eos
    ;

variableDeclarationList
    : variableDeclaration (Comma variableDeclaration)*
    ;

variableDeclaration
    : assignable (Assign singleExpression)? // ECMAScript 6: Array & Object Matching
    ;

emptyStatement
    : SemiColon
    ;

expressionStatement
    : expressionSequence eos
    ;

ifStatement
    : If OpenParen expressionSequence CloseParen statement (Else statement)?
    ;


iterationStatement
    : Do statement While OpenParen expressionSequence CloseParen eos                                                                 # DoStatement
    | While OpenParen expressionSequence CloseParen statement                                                                        # WhileStatement
    | For OpenParen (expressionSequence | variableStatement)? SemiColon expressionSequence? SemiColon expressionSequence? CloseParen statement   # ForStatement
    | For OpenParen (singleExpression | variableStatement) In expressionSequence CloseParen statement                                # ForInStatement
    // strange, 'of' is an identifier. and this.p("of") not work in sometime.
    | For Await? OpenParen (singleExpression | variableStatement) Identifier expressionSequence CloseParen statement  # ForOfStatement
    ;

varModifier  // let, const - ECMAScript 6
    : Var
    | Let
    | Const
    ;

continueStatement
    : Continue (Identifier)? eos
    ;

breakStatement
    : Break (Identifier)? eos
    ;

returnStatement
    : Return (expressionSequence)? eos
    ;

yieldStatement
    : Yield (expressionSequence)? eos
    ;

withStatement
    : With OpenParen expressionSequence CloseParen statement
    ;

switchStatement
    : Switch OpenParen expressionSequence CloseParen caseBlock
    ;

caseBlock
    : OpenBrace caseClauses? (defaultClause caseClauses?)? CloseBrace
    ;

caseClauses
    : caseClause+
    ;

caseClause
    : Case expressionSequence Colon statementList?
    ;

defaultClause
    : Default Colon statementList?
    ;

labelledStatement
    : Identifier Colon statement
    ;

throwStatement
    : Throw expressionSequence eos
    ;

tryStatement
    : Try block (catchProduction finallyProduction? | finallyProduction)
    ;

catchProduction
    : Catch (OpenParen assignable? CloseParen)? block
    ;

finallyProduction
    : Finally block
    ;

debuggerStatement
    : Debugger eos
    ;

functionDeclaration
    : Async? Function Multiply? Identifier OpenParen formalParameterList? CloseParen OpenBrace functionBody CloseBrace
    ;

classDeclaration
    : Class Identifier classTail
    ;

classTail
    : (Extends singleExpression)? OpenBrace classElement* CloseBrace
    ;

classElement
    : (Static | Identifier | Async)* methodDefinition
    | emptyStatement
    | Hashtag? propertyName Assign singleExpression
    ;

methodDefinition
    : Multiply? Hashtag? propertyName OpenParen formalParameterList? CloseParen OpenBrace functionBody CloseBrace
    | Multiply? Hashtag? getter OpenParen CloseParen OpenBrace functionBody CloseBrace
    | Multiply? Hashtag? setter OpenParen formalParameterList? CloseParen OpenBrace functionBody CloseBrace
    ;

formalParameterList
    : formalParameterArg (Comma formalParameterArg)* (Comma lastFormalParameterArg)?
    | lastFormalParameterArg
    ;

formalParameterArg
    : assignable (Assign singleExpression)?      // ECMAScript 6: Initialization
    ;

lastFormalParameterArg                        // ECMAScript 6: Rest Parameter
    : Ellipsis singleExpression
    ;

functionBody
    : sourceElements?
    ;

sourceElements
    : sourceElement+
    ;

arrayLiteral
    : (OpenBracket elementList CloseBracket)
    ;

elementList
    : Comma* arrayElement? (Comma+ arrayElement)* Comma* // Yes, everything is optional
    ;

arrayElement
    : Ellipsis? singleExpression
    ;

objectLiteral
    : OpenBrace (propertyAssignment (Comma propertyAssignment)*)? Comma? CloseBrace
    ;

propertyAssignment
    : propertyName Colon singleExpression                                             # PropertyExpressionAssignment
    | OpenBracket singleExpression CloseBracket Colon singleExpression                                 # ComputedPropertyExpressionAssignment
    | Async? Multiply? propertyName OpenParen formalParameterList?  CloseParen  OpenBrace functionBody CloseBrace  # FunctionProperty
    | getter OpenParen CloseParen OpenBrace functionBody CloseBrace                                           # PropertyGetter
    | setter OpenParen formalParameterArg CloseParen OpenBrace functionBody CloseBrace                        # PropertySetter
    | Ellipsis? singleExpression                                                    # PropertyShorthand
    ;

propertyName
    : identifierName
    | StringLiteral
    | numericLiteral
    | OpenBracket singleExpression CloseBracket
    ;

arguments
    : OpenParen (argument (Comma argument)* Comma?)? CloseParen
    ;

argument
    : Ellipsis? (singleExpression | Identifier)
    ;

expressionSequence
    : singleExpression (Comma singleExpression)*
    ;

singleExpression
    : anoymousFunction                                                      # FunctionExpression
    | Class Identifier? classTail                                           # ClassExpression
    | singleExpression OpenBracket expressionSequence CloseBracket                           # MemberIndexExpression
    | singleExpression QuestionMark? Dot Hashtag? identifierName                         # MemberDotExpression
    | singleExpression arguments                                            # ArgumentsExpression
    | New singleExpression arguments?                                       # NewExpression
    | New Dot Identifier                                                    # MetaExpression // new.target
    | singleExpression PlusPlus							                        # PostIncrementExpression
    | singleExpression MinusMinus													# PostDecreaseExpression
    | Delete singleExpression                                               # DeleteExpression
    | Void singleExpression                                                 # VoidExpression
    | Typeof singleExpression                                               # TypeofExpression
    | PlusPlus singleExpression                                                 # PreIncrementExpression
    | MinusMinus singleExpression                                                 # PreDecreaseExpression
    | Plus singleExpression                                                  # UnaryPlusExpression
    | Minus singleExpression                                                  # UnaryMinusExpression
    | BitNot singleExpression                                                  # BitNotExpression
    | Not singleExpression                                                  # NotExpression
    | Await singleExpression                                                # AwaitExpression
    | <assoc=right> singleExpression Power singleExpression                  # PowerExpression
    | singleExpression (Multiply | Divide | Modulus) singleExpression                   # MultiplicativeExpression
    | singleExpression (Plus | Minus) singleExpression                         # AdditiveExpression
    | singleExpression NullCoalesce singleExpression                                # CoalesceExpression
    | singleExpression (LeftShiftArithmetic | RightShiftArithmetic | RightShiftLogical) singleExpression               # BitShiftExpression
    | singleExpression (LessThan | MoreThan | LessThanEquals | GreaterThanEquals) singleExpression           # RelationalExpression
    | singleExpression Instanceof singleExpression                          # InstanceofExpression
    | singleExpression In singleExpression                                  # InExpression
    | singleExpression (Equals_ | NotEquals | IdentityEquals | IdentityNotEquals) singleExpression       # EqualityExpression
    | singleExpression BitAnd singleExpression                                 # BitAndExpression
    | singleExpression BitXOr singleExpression                                 # BitXOrExpression
    | singleExpression BitOr singleExpression                                 # BitOrExpression
    | singleExpression And singleExpression                                # LogicalAndExpression
    | singleExpression Or singleExpression                                # LogicalOrExpression
    | singleExpression QuestionMark singleExpression Colon singleExpression            # TernaryExpression
    | <assoc=right> singleExpression Assign singleExpression                   # AssignmentExpression
    | <assoc=right> singleExpression assignmentOperator singleExpression    # AssignmentOperatorExpression
    | Import OpenParen singleExpression CloseParen                                       # ImportExpression
    | singleExpression TemplateStringLiteral                                # TemplateStringExpression  // ECMAScript 6
    | yieldStatement                                                        # YieldExpression // ECMAScript 6
    | This                                                                  # ThisExpression
    | Identifier                                                            # IdentifierExpression
    | Super                                                                 # SuperExpression
    | literal                                                               # LiteralExpression
    | arrayLiteral                                                          # ArrayLiteralExpression
    | objectLiteral                                                         # ObjectLiteralExpression
    | OpenParen expressionSequence CloseParen                                            # ParenthesizedExpression
    ;

assignable
    : Identifier
    | arrayLiteral
    | objectLiteral
    ;

anoymousFunction
    : functionDeclaration                                                       # FunctionDecl
    | Async? Function Multiply? OpenParen formalParameterList? CloseParen OpenBrace functionBody CloseBrace    # AnoymousFunctionDecl
    | Async? arrowFunctionParameters ARROW arrowFunctionBody                     # ArrowFunction
    ;

arrowFunctionParameters
    : Identifier
    | OpenParen formalParameterList? CloseParen
    ;

arrowFunctionBody
    : singleExpression
    | OpenBrace functionBody CloseBrace
    ;

assignmentOperator
    : MultiplyAssign
    | DivideAssign
    | ModulusAssign
    | PlusAssign
    | MinusAssign
    | LeftShiftArithmeticAssign
    | RightShiftArithmeticAssign
    | RightShiftLogicalAssign
    | BitAndAssign
    | BitXorAssign
    | BitOrAssign
    | PowerAssign
    ;

literal
    : NullLiteral
    | BooleanLiteral
    | StringLiteral
    | TemplateStringLiteral
    | RegularExpressionLiteral
    | numericLiteral
    | bigintLiteral
    ;

numericLiteral
    : DecimalLiteral
    | HexIntegerLiteral
    | OctalIntegerLiteral
    | OctalIntegerLiteral2
    | BinaryIntegerLiteral
    ;

bigintLiteral
    : BigDecimalIntegerLiteral
    | BigHexIntegerLiteral
    | BigOctalIntegerLiteral
    | BigBinaryIntegerLiteral
    ;

identifierName
    : Identifier
    | reservedWord
    ;

reservedWord
    : keyword
    | NullLiteral
    | BooleanLiteral
    ;

keyword
    : Break
    | Do
    | Instanceof
    | Typeof
    | Case
    | Else
    | New
    | Var
    | Catch
    | Finally
    | Return
    | Void
    | Continue
    | For
    | Switch
    | While
    | Debugger
    | Function
    | This
    | With
    | Default
    | If
    | Throw
    | Delete
    | In
    | Try

    | Class
    | Enum
    | Extends
    | Super
    | Const
    | Export
    | Import
    | Implements
    | Let
    | Private
    | Public
    | Interface
    | Package
    | Protected
    | Static
    | Yield
    | Async
    | Await
    | From
    | As
    ;

getter
    : Identifier propertyName
    ;

setter
    : Identifier propertyName
    ;

eos
    : SemiColon
    | EOF
    ;