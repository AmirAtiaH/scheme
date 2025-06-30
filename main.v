module main

import parser
import os
import time
import math

fn main() {

	code := os.read_file(os.args[1]) or { panic("can access the file") }
	
	start := time.now().unix_nano()

	mut par := parser.Parser{
		source: code
	}
	par.parse()

	close := time.now().unix_nano()

	//unsafe { free(ast) }
	println((code.count('\n') / ((close - start) / math.pow(10, 9)))/ 1000 )
	//println((close - start)/ 1000 )
}