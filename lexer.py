from typing import List
from enum import Enum, auto
from pprint import pprint


SPECIAL_CHARACTERS: str = r'\?.*+()|'


class Token(Enum):
    LITERAL_CHARACTER = auto()
    QUESTION_MARK     = auto()
    DOT               = auto()
    ASTERISK          = auto()
    PLUS              = auto()
    OPEN_BRACKET      = auto()
    CLOSE_BRACKET     = auto()
    PIPE              = auto()

    def __repr__(self) -> str:
        return f'{self.__class__.__name__}.{self.name}'


class Lexeme:
    token: Token
    value: int | None

    def __init__(self, token: Token, value: int | None = None) -> None:
        self.token = token
        self.value = value

    def __repr__(self) -> str:
        if self.value is None:
            return f'Lexeme({self.token!r})'
        return f'Lexeme({self.token!r}: `{chr(self.value)}` [{self.value}])'


class Lexer:
    __tokens: List[Lexeme] = []

    def lex(self, re: str) -> None:
        idx: int = 0
        while idx < len(re):
            # handle escaped symbols
            if re[idx] == '\\':
                if idx + 1 == len(re):
                    raise Exception('Broken escape sequence at the end of the expression.')

                if re[idx + 1] not in SPECIAL_CHARACTERS:
                    raise Exception(f'Unknown escape sequence: "{re[idx:idx + 2]}".')

                self.__tokens.append(self.create_lexeme(ord(re[idx + 1]), True))
                idx += 2
                continue

            # normal case
            self.__tokens.append(self.create_lexeme(ord(re[idx])))
            idx += 1

    def create_lexeme(self, char: int, force_literal_character: bool = False) -> Lexeme:
        if force_literal_character:
            return Lexeme(Token.LITERAL_CHARACTER, char)

        if char == ord('?'):
            return Lexeme(Token.QUESTION_MARK)
        if char == ord('.'):
            return Lexeme(Token.DOT)
        if char == ord('*'):
            return Lexeme(Token.ASTERISK)
        if char == ord('+'):
            return Lexeme(Token.PLUS)
        if char == ord('('):
            return Lexeme(Token.OPEN_BRACKET)
        if char == ord(')'):
            return Lexeme(Token.CLOSE_BRACKET)
        if char == ord('|'):
            return Lexeme(Token.PIPE)

        return Lexeme(Token.LITERAL_CHARACTER, char)

    @property
    def tokens(self) -> List[Lexeme]:
        return self.__tokens

    def clear(self) -> None:
        self.__tokens = []


class EasyRe:
    __lexemes: List[Lexeme]

    def __init__(self, lexemes: List[Lexeme]) -> None:
        self.__lexemes = lexemes

    def compile(self) -> None:
        pass

    def match(self) -> bool:
        return True


if __name__ == '__main__':
    lexer = Lexer()
    while (text := input('~> ')) != 'exit':
        print(f'Expression: "{text}"')

        lexer.lex(text)
        print('Lexed expression:')
        pprint(lexer.tokens)

        lexer.clear()
