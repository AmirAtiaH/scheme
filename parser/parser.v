module parser

pub struct Parser {
pub mut:
	source  string
	pos     u32
	nodes   []Node
}

pub fn (mut par Parser) parse() {
	par.nodes = [
		Node {
			typ: .root
			pos: 0
			end: 0
		}
	]

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
					par.throw(tok.pos, tok.end, "unexpected: `)`")
				}
			}
			else {}
		}
		par.lex()
	}

	last := par.nodes.last()
	if bracks > 0 {
		par.throw(last.pos, last.end, "expected: `)` but found `eof`")
	}
}
