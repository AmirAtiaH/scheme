module parser

pub struct Parser {
pub mut:
	source  string
	pos     u32
	nodes   []Node
}

pub fn (mut par Parser) parse() {
	par.nodes = []Node{ cap: par.source.len / 3 }
	par.nodes << Node {
		typ: .root
		pos: 0
	}

	mut bracks := i16(0)
	par.lex()

	for {
		tok := par.nodes.last()
		if tok.typ == .eof {
			break
		}
		match tok.typ {
			.nslist { bracks++ }
			.nclist { 
				bracks-- 
				if bracks < 0 {
					par.throw(tok.pos, tok.pos, "unexpected: `)`")
				}
			}
			else {}
		}
		par.lex()
	}

	last := par.nodes.last()
	if bracks > 0 {
		par.throw(last.pos, last.pos, "expected: `)` but found `eof`")
	}
}
