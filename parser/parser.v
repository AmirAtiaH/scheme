module parser

struct Parser {
mut:
	ast     NList
	source  string
	pos     u32
	peek    Token
}

@[inline]
pub fn (mut par Parser)next() {
	par.peek = par.lex()
}

@[inline]
pub fn (mut par Parser)parse_node() Node {
	mut node := Node {
		pos: par.peek.pos
	}
	match par.peek.typ {
		.start_bracket {
			mut list := []Node{}
			par.next()
			for {
				if par.peek.typ == .close_bracket {
					node.val = NList(list)
					par.next()
					break
				}
				if par.peek.typ == .eof {
					throw(par.peek.pos, "expected `)` but found the end of file")
				}
				list << par.parse_node()
			}
		}
		.quote {
			par.next()
			node.val = NQuoted(par.parse_node())
		}
		.ident {
			node.val = NIdent(par.get_string(par.peek))
			par.next()
		}
		.vstring {
			node.val = NString(par.get_string(par.peek))
			par.next()
		}
		.vnumber {
			node.val = NNumber(par.get_number(par.peek))
			par.next()
		}
		.vbool {
			node.val = NBool(par.get_bool(par.peek))
			par.next()
		}
		else { throw(par.peek.pos, "unexpected: `${par.peek.typ}`") }
	}
	return node
}

pub fn parse(code string) NList {
	mut par := Parser { source: code }
	par.next()
	for par.peek.typ != .eof {
		par.ast << par.parse_node()
	}
	return par.ast
}