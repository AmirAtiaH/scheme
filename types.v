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

pub type NIdent = string
pub type NString = string
pub type NNumber = f64
pub type NBool = bool
pub type NList = []Node
pub type NQuotedList = Node
pub type NNode = NQuotedList | NList | NIdent | NString | NNumber | NBool

pub struct Node {
	pub mut:
	val NNode
	pos u64
}