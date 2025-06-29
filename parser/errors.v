module parser

@[noreturn]
/*pub fn throw(pos u32, end u32, msg string) {
	println("error at: ${pos.str()}")
	println(msg)
	exit(1)
}*/
pub fn (par Parser) throw(pos u32, end u32, msg string) {
	code := par.source
	mut line := 1
	mut col := 1
	mut i := 0
	mut line_start := 0

	// find line and column of pos
	for i < pos && i < code.len {
		if code[i] == `\n` {
			line++
			col = 1
			line_start = i + 1
		} else {
			col++
		}
		i++
	}

	// find end of line for snippet
	mut line_end := line_start
	for line_end < code.len && code[line_end] != `\n` {
		line_end++
	}

	snippet := code[line_start..line_end]
	mut arrow := ' '.repeat(col - 1)
	mut length := if end > pos { end - pos } else { 1 }
	arrow += `^`.repeat(int(length))

	eprintln('[error] at line ${line}, column ${col}:')
	eprintln(snippet)
	eprintln(arrow)
	eprintln('message: $msg')
	exit(1)
}
