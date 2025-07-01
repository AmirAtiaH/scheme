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



@[inline]
fn (par Parser) as_ident(i u32) string {
	node := par.nodes[i]
	return par.source[node.pos..node.end]
}

@[inline]
fn (par Parser) as_string(i u32) string {
	node := par.nodes[i]
	return par.source[node.pos + 1..node.end - 1]
}

@[inline]
fn (par Parser) as_number(i u32) f64 {
	node := par.nodes[i]
	return atof_quick(par.source[node.pos..node.end])
}


/*@[inline]
fn (par Parser) as_ident(i u32) string {
	mut j := i
	for valid_ident_char(par.source[j]) {
		j++
	}
	return par.source[i..j]
}

@[inline]
fn (par Parser) as_string(i u32) string {
	mut j := i
	for par.source[j] != `"` {
		j++
	}
	return par.source[i..j]
}

@[inline]
fn (par Parser) as_number(i u32) f64 {
	mut j := i
	src := par.source

	for {
		ch := src[j]
		if ch >= `0` && ch <= `9` && ch == `.` && ch == `-` {
			j++
		}
		break
	}
	return atof_quick(src[i..j])
}

@[inline]
fn (par Parser) as_bool(i u32) bool {
	ch := par.source[i + 1]
	return if ch == `t` {
		true
	} else if ch == `f` {
		false
	} else {
		par.throw(i, i + 2, "expected `#t` or `#f`, but found `#${par.source[i..i + 2]}`")
	}
}

@[inline]
fn (par Parser) parent(i u32) u32 {
	mut d := 0
	mut j := i - 1
	nodes := par.nodes

	for j >= 0 {
		t := nodes[j].typ
		if t == .nclist {
			d++
		} else if t == .nslist {
			if d == 0 {
				return j
			}
			d--
		}
		j--
	}
	return 0
}
*/