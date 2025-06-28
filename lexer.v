module lexer

import types { None, Token, TokenType }
import strconv { atof_quick }
import errors { throw }

struct Lexer {
pub mut:
	src  string
	pos  u32
	tkns []Token = []
}

@[inline]
fn (mut lxr Lexer) peek(l u16) u8 {
	return lxr.src[lxr.pos + l] or { 0 }
}

@[inline]
fn (mut lxr Lexer) skip(l u16) {
	lxr.pos += l
}

@[inline]
fn (mut lxr Lexer) skip_line() {
	for !(lxr.peek(0) in [`\n`, 0]) {
		lxr.skip(1)
	}
}

@[inline]
fn (mut lxr Lexer) add(typ TokenType) {
	lxr.tkns << Token{
		typ: typ
		val: None{}
		pos: lxr.pos
	}
	lxr.skip(1)
}

@[inline]
fn (mut lxr Lexer) add_bool() {
	mut value := false
	match lxr.peek(1) {
		`t` { value = true }
		`f` { value = false }
		else { throw(lxr.pos, "expected `t` or `f` not: `${lxr.peek(1).ascii_str()}`") }
	}
	lxr.tkns << Token{
		typ: .val_bool
		val: value
		pos: lxr.pos
	}
	lxr.skip(2)
}

@[inline]
fn (mut lxr Lexer) add_string() {
	mut value := ""
	mut pos := u16(1)
	for lxr.peek(pos) != `"` {
		value += lxr.peek(pos).ascii_str()
		pos++
	}
	lxr.tkns << Token{
		typ: .val_string
		val: value
		pos: lxr.pos
	}
	lxr.skip(u16(value.len) + 2)
}

@[inline]
fn (mut lxr Lexer) add_number() {
	mut value := ''
	mut pos := u16(0)
	mut doted := false
	for {
		if lxr.peek(pos) == `.` {
			if !doted {
				doted = true
			} else {
				throw(lxr.pos, "didnt expected anothe `.`")
			}
		} else if !lxr.peek(pos).is_digit() {
			break
		}
		value += lxr.peek(pos).ascii_str()
		pos++
	}
	lxr.tkns << Token{
		typ: .val_number
		val: atof_quick(value)
		pos: lxr.pos
	}
	lxr.skip(u16(value.len))
}

@[inline]
fn valid_ident_char(c u8) bool {
	return c.is_letter() || c.is_digit()
		|| c in [`!`, `$`, `%`, `&`, `*`, `+`, `-`, `.`, `/`, `:`, `<`, `=`, `>`, `?`, `^`, `_`, `~`]
}

@[inline]
fn (mut lxr Lexer) add_ident() {
	mut value := ''
	mut pos := u16(0)
	for valid_ident_char(lxr.peek(pos)) {
		value += lxr.peek(pos).ascii_str()
		pos++
	}
	lxr.tkns << Token{
		typ: .ident
		val: value
		pos: lxr.pos
	}
	lxr.skip(u16(value.len))
}

pub fn tokenize(code string) []Token {
	mut lxr := Lexer{
		src: code
	}
	for {
		match lxr.peek(0) {
			0 { lxr.add(.eof); break }
			`'` { lxr.add(.quote) }
			`(` { lxr.add(.start_bracket) }
			`)` { lxr.add(.close_bracket) }
			`#` { lxr.add_bool() }
			`"` { lxr.add_string() }
			`0`...`9` { lxr.add_number() }
			` `, `\n`, `\t`, `\r` { lxr.skip(1) }
			`;` { lxr.skip_line() }
			else { lxr.add_ident() }
		}
	}
	return lxr.tkns
}
