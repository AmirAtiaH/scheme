module main

import lexer
import parser

fn main() {
	tokens := lexer.tokenize('(display "hello world!") \'#f')
	ast := parser.parse(tokens)
	println(ast)
}
