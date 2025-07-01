module main

import parser
import os
import time
import strconv { atof_quick }

fn main() {

	code := os.read_file(os.args[2]) or { panic("can access the file") }

	mut arr := []f64 {}
	times:= u32(atof_quick(os.args[1]))
	
	for _ in 0..times {
		start := time.now().unix_nano()

		mut par := parser.Parser{
			source: code
		}
		par.parse()

		close := time.now().unix_nano()

		lines := code.count('\n')
		seconds := f64(close - start) / 1e9
		speed := f64(lines) / seconds

		arr << speed
	}
	
	mut total := f64(0)
	for i, val in arr {
		total += val
		println("${i+1}th speed: ${val:.2f} l/s")
	}
	avg := total / f64(arr.len)

	println("average speed: ${avg:.2f} lines/second")
	
}