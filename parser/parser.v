module parser

pub struct Parser {
pub mut:
	source  string
	pos     u32
	nodes   []Node
}

pub fn (mut par Parser) parse() {
	par.nodes = []Node{cap: par.source.len / 3}
	par.nodes << Node{
		typ: .root
		pos: 0
	}

	mut bracks := i16(0)
	mut i := u32(1)
	for {
		par.lex()
		tok := par.nodes.last()
		
		match tok.typ {
			.eof {
				break
			}
			.nslist {
				bracks++
			}
			.nclist {
				bracks--
				if bracks < 0 {
					par.throw(tok.pos, tok.pos, "unexpected: `)`")
				}
			}
			.nnumber {
				par.as_number(i)
			}
			.nstring {
				par.as_string(i)
			}
			.nident {
				par.as_ident(i)
			}
			else {}
		}
		i++
	}

	if bracks > 0 {
		last := par.nodes.last()
		par.throw(last.pos, last.pos, "expected: `)` but found `eof`")
	}
}
