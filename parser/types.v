module parser


import strconv { atof_quick }


// lexer types
pub enum TokenType as u8 {
	ident
	quote
	vnumber
	vstring
	vbool
	start_bracket
	close_bracket
	eof
}

pub struct Token {
pub:
	typ TokenType
	pos u32
	end u32
}

fn (par Parser) get_ident(token Token) string {
	return par.source[token.pos..token.end]
}

fn (par Parser) get_string(token Token) string {
	return par.source[token.pos + 1..token.end - 1]
}

fn (par Parser) get_number(token Token) f64 {
	mut dot := false
	mut val := par.source[token.pos..token.end]

	for i, ch in val {
		if ch == `.` {
			if dot {
				throw(par.pos, "unexpected second `.` in number")
			}
			dot = true
		}
		if ch == `-` && i != 0 {
			throw(par.pos, "unexpected `-` in middle of number")
		}
	}

	return atof_quick(val)
}

fn (par Parser) get_bool(token Token) bool {
	value := par.source[token.pos + 1]
	if value == `t` { return true }
	if value == `f` { return false }
	throw(par.pos, "expected `#t` or `#f`, but found `#${par.source[token.pos..token.end]}`")
}


// par types
pub type NBool = bool
pub type NIdent = string
pub type NString = string
pub type NNumber = f64
pub type NList = []Node
pub type NQuoted = Node
pub type NNode = NBool | NIdent | NString | NNumber | NList | NQuoted

pub struct Node {
	pub mut:
	val NNode
	pos u32
}










/*

enum NodeType as u8 {
	nbool
	nident
	nstring
	nnumber
	nquoted
	nslist
	nclist
}

pub type NodeValue = string | f64 | bool


pub struct Node {
	pub mut:
	typ NodeType
	val NodeValue
	pos u32
}


struct AST {
	nodes []Node
}
*/