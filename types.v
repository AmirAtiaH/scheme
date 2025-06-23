module types

pub struct None {}

pub enum TokenType {
	val_number
	val_string
	val_bool
	ident
	quote
	start_bracket
	close_bracket
	eof
}

pub type TokenValue = string | f64 | bool | None

pub struct Token {
pub:
	typ TokenType
	val TokenValue
	pos u32
}

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
	pos u64
}