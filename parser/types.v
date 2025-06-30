module parser


import strconv { atof_quick }

// parser types
enum NKind as u8 {
	root
	nbool
	nident
	nstring
	nnumber
	nquote
	nslist
	nclist
	eof
}

pub struct Node {
	pub mut:
	typ NKind
	pos u32
	//end u32
}

fn (par Parser) as_ident(i u32) string {
	mut end := i
	for valid_ident_char(par.source[end]) { end++ }
	return par.source[i..end]
}

fn (par Parser) as_string(i u32) string {
	mut end := i
	for par.source[end] != `"` { end++ }
	return par.source[i..end]
}

fn (par Parser) as_number(i u32) f64 {
	mut end := i
	mut dot := false

	for {
		ch := par.source[end]

		if !valid_number_char(ch) {
			break
		}

		if ch == `.` {
			if dot {
				par.throw(end, end + 1, "unexpected second `.` in number")
			}
			dot = true
		}
		if ch == `-` && end != i {
			par.throw(i, i + 1, "unexpected `-` in middle of number")
		}

		end++
	}
	return atof_quick(par.source[i..end])
}

fn (par Parser) as_bool(i u32) bool {
	return match par.source[i + 1] {
		`t` { true }
		`f` { false }
		else {
			par.throw(i, i + 2, "expected `#t` or `#f`, but found `#${par.source[i..i + 2]}`")
		}
	}
}

fn (par Parser) parent(i u32) u32 {
	mut depth := 0
	mut j := i - 1

	for j >= 0 {
		match par.nodes[j].typ {
			.nclist { depth++ }
			.nslist {
				if depth == 0 {
					return j
				}
				depth--
			}
			else {}
		}
		j--
	}

	return 0
}