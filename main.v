module main

import parser
import os
import time
import math

fn main() {

	code := os.read_file(os.args[1]) or { panic("can access the file") }
	
	start := time.now().unix_nano()

	_ := parser.parse(code)

	close := time.now().unix_nano()

	//unsafe { free(ast) }
	println((code.count('\n') / ((close - start) / math.pow(10, 9)))/ 1000 )
}
