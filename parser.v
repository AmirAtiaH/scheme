module parser

import types { Node NNode NQuoted NList NIdent NString NNumber NBool }
import errors { throw }


struct Parser {
mut:
	tkns []types.Token
	pos u16
	ast NList
}

pub fn parse(tkns []types.Token) NList {
	mut prsr := Parser {
		tkns: tkns
	}
	for prsr.peek(0).typ != .eof {
		prsr.ast << prsr.parse_node()
	}
	return prsr.ast
}

@[inline]
pub fn (mut prsr Parser)peek(l u8) types.Token {
	return prsr.tkns[prsr.pos + l]
}

@[inline]
pub fn (mut prsr Parser)skip(l u8) {
	prsr.pos += l
}

@[inline]
pub fn (mut prsr Parser)parse_node() Node {
	mut node := Node {
		pos: prsr.peek(0).pos
	}
	match prsr.peek(0).typ {
		.start_bracket {
			mut list := []Node{}
			prsr.skip(1)
			for {
				if prsr.peek(0).typ == .close_bracket {
					node.val = NList(list)
					prsr.skip(1)
					break
				}
				if prsr.peek(0).typ == .eof {
					throw(prsr.peek(0).pos, "expected `)` but found the end of file")
				}
				list << prsr.parse_node()
			}
		}
		.quote {
			prsr.skip(1)
			node.val = NQuoted(prsr.parse_node())
		}
		.ident {
			node.val = NIdent(prsr.peek(0).val as string)
			prsr.skip(1)
		}
		.val_string {
			node.val = NString(prsr.peek(0).val as string)
			prsr.skip(1)
		}
		.val_number {
			node.val = NNumber(prsr.peek(0).val as f64)
			prsr.skip(1)
		}
		.val_bool {
			node.val = NBool(prsr.peek(0).val as bool)
			prsr.skip(1)
		}
		else { throw(prsr.peek(0).pos, "unexpected: `${prsr.peek(0).typ}`") }
	}
	return node
}