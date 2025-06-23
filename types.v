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
