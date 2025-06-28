module main

import lexer
import parser
import os

fn main() {
	//println("hi")
	code := os.read_file(os.args[1]) or { panic("can access the file") }
	//println(os.args[1])
	//println(code)
	tokens := lexer.tokenize(code)
	_ := parser.parse(tokens)
	//println(ast)
}
