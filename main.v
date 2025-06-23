module main

import lexer

fn main() {
	println('Hello World!')
	println(lexer.tokenize('(hi 2342.3bye "hii"bye)'))
}
