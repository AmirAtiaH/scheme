module main

import parser
import os
import time
import math

fn main() {

	code := os.read_file(os.args[1]) or { panic("can access the file") }

	mut arr := []int

	for 1 in 0..100 {
		start := time.now().unix_nano()

		mut par := parser.Parser{
			source: code
		}
		par.parse()

		close := time.now().unix_nano()

		arr << (code.count('\n') / ((close - start) / math.pow(10, 9)))/ 1000
	}
	
	println( )
	
}