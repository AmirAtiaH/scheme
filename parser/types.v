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
	end u32
}


fn (par Parser) as_ident(i u32) string {
	return par.source[par.nodes[i].pos..par.nodes[i].end]
}

fn (par Parser) as_string(i u32) string {
	return par.source[par.nodes[i].pos + 1..par.nodes[i].end - 1]
}

fn (par Parser) as_number(i u32) f64 {
	mut val := par.source[par.nodes[i].pos..par.nodes[i].end]
	return atof_quick(val)
}

fn (par Parser) as_bool(i u32) bool {
	value := par.source[par.nodes[i].pos + 1]
	if value == `t` { return true }
	if value == `f` { return false }
	par.throw(par.nodes[i].pos, par.nodes[i].end, "expected `#t` or `#f`, but found `#${par.source[par.nodes[i].pos..par.nodes[i].end]}`")
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