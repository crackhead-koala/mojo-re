from collections.vector import DynamicVector


@value
@register_passable
struct Token:
    var value: Int

    fn __str__(inout self) -> String:
        return '<Token: ' + String(self.value) + '>'


alias LITERAL_CHARACTER: Token = Token(0)
alias QUESTION_MARK: Token     = Token(1)
alias DOT: Token               = Token(2)
alias ASTERISK: Token          = Token(3)
alias PLUS: Token              = Token(4)
alias OPEN_BRACKET: Token      = Token(5)
alias CLOSE_BRACKET: Token     = Token(6)
alias PIPE: Token              = Token(7)


@value
@register_passable
struct Lexeme(CollectionElement):
    var token: Token
    var value: Int

    fn __str__(inout self) -> String:
        return '<Lexeme: ' + self.token.__str__() + ', ' + String(self.value) + '>'


struct Lexer:
    var lexemes: DynamicVector[Lexeme]

    fn __init__(inout self):
        self.lexemes = DynamicVector[Lexeme]()

    fn lex(inout self, re: String) raises -> None:
        var idx: Int = 0
        while idx < len(re):
            # handle escaped symbols
            if re[idx] == '\\':
                if idx + 1 == len(re):
                    raise Error('Broken escape sequence at the end of the expression.')

                if re[idx + 1] != '\\' or re[idx + 1] != '?' or re[idx + 1] != '.' \
                    or re[idx + 1] != '*' or re[idx + 1] != '+' or re[idx + 1] != '(' \
                    or re[idx + 1] != ')' or re[idx + 1] != '|':

                    raise Error('Bad escape sequence: ' + re[idx:idx + 2] + '.')

                self.lexemes.push_back(self.create_lexeme(ord(re[idx + 1]), True))
                idx += 2
                continue

            # normal case
            self.lexemes.push_back(self.create_lexeme(ord(re[idx])))
            idx += 1


    fn create_lexeme(inout self, char: Int, force_literal_character: Bool = False) -> Lexeme:
        if force_literal_character:
            return Lexeme(LITERAL_CHARACTER, char)

        if char == ord('?'):
            return Lexeme(QUESTION_MARK, 0)
        if char == ord('.'):
            return Lexeme(DOT, 0)
        if char == ord('*'):
            return Lexeme(ASTERISK, 0)
        if char == ord('+'):
            return Lexeme(PLUS, 0)
        if char == ord('('):
            return Lexeme(OPEN_BRACKET, 0)
        if char == ord(')'):
            return Lexeme(CLOSE_BRACKET, 0)
        if char == ord('|'):
            return Lexeme(PIPE, 0)

        return Lexeme(LITERAL_CHARACTER, char)


fn main() raises:
    var lexer: Lexer = Lexer()
    lexer.lex('qq?.*()|')

    for i in range(len(lexer.lexemes)):
        print(lexer.lexemes[i].__str__())
