module main

import lexer
import parser

fn main() {
	println("hi")
	tokens := lexer.tokenize('(hi 2342.3bye "hii"bye)')
	println(tokens)
	println(parser.parse(tokens))
}
