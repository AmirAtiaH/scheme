module main

import parser
import os
import time

fn main() {
	
	start := time.now().unix_nano()


	ast := parser.parse(os.read_file(os.args[1]) or { panic("can access the file") })


	close := time.now().unix_nano()

	println((close - start)/1000000)
	unsafe { free(ast) }
}
