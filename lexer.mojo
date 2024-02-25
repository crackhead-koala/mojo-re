from collections.optional import Optional
from collections.vector import DynamicVector, CollectionElement


@value
@register_passable
struct Token:
    var __value: Int

    fn __str__(inout self) -> String:
        return '<Token: ' + String(self.__value) + '>'


# hacky Golang-style iota enum, since there is no native Mojo enum yet
struct Iota:
    var __value: Int

    fn __init__(inout self):
        self.__value = 0

    fn __call__(inout self) -> Int:
        let result: Int = self.__value
        self.__value += 1
        return result


var token_enum = Iota()

let LITERAL_CHARACTER : Token = Token(token_enum())
let QUESTION_MARK     : Token = Token(token_enum())
let DOT               : Token = Token(token_enum())
let ASTERISK          : Token = Token(token_enum())
let PLUS              : Token = Token(token_enum())
let OPEN_BRACKET      : Token = Token(token_enum())
let CLOSE_BRACKET     : Token = Token(token_enum())
let PIPE              : Token = Token(token_enum())


@value
@register_passable
struct Lexeme(CollectionElement):
    var token: Token
    var value: Int

    fn __str__(inout self) -> String:
        return '<Lexeme: ' + self.token.__str__() + ', ' + String(self.value) + '>'


struct Lexer:
    var __lexemes: DynamicVector[Lexeme]

    fn __init__(inout self):
        self.__lexemes = DynamicVector[Lexeme]()

    fn lex(inout self, re: String) raises -> None:
        var idx: Int = 0
        while idx < len(re):
            # handle escaped symbols
            if re[idx] == '\\':
                if idx + 1 == len(re):
                    raise Error('Broken escape sequence at the end of the expression.')

                if not (re[idx + 1] == '\\' or re[idx + 1] == '?' or re[idx + 1] == '.' or re[idx + 1] == '*' or re[idx + 1] == '+' or re[idx + 1] == '(' or re[idx + 1] == ')' or re[idx + 1] == '|'):
                    raise Error('Bad escape sequence: ' + re[idx:idx + 2] + '.')

                self.__lexemes.push_back(self.create_lexeme(ord(re[idx + 1]), True))
                idx += 2
                continue

            # normal case
            self.__lexemes.push_back(self.create_lexeme(ord(re[idx])))
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
    lexer.lex('qwerty\a')

    for i in range(len(lexer.__lexemes)):
        print(lexer.__lexemes[i].__str__())
