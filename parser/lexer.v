module parser


@[inline]
fn (mut prsr Parser) skip_unneeded() {
	for prsr.pos < prsr.source.len {
		ch := prsr.source[prsr.pos]
		if ch in [` `, `\t`, `\n`, `\r`] {
			prsr.pos++
			continue
		}
		if ch == `;` {
			for prsr.pos < prsr.source.len && prsr.source[prsr.pos] != `\n` {
				prsr.pos++
			}
			continue
		}
		break
	}
}

// token
@[inline]
fn (mut par Parser) lex_char(typ TokenType) Token {
	par.pos++
	return Token{
		typ: typ
		pos: par.pos - 1
		end: par.pos
	}
}

// bool
@[inline]
fn (mut par Parser) lex_bool() Token {
	par.pos += 2
	return Token{
		typ: .vbool
		pos: par.pos - 2
		end: par.pos
	}
}

// number
@[inline]
fn valid_number_char(ch u8) bool {
	return ch.is_digit() || match ch {
		`.`, `-` { true }
		else { false }
	}
}

@[inline]
fn (mut par Parser) lex_number() Token {
	//mut dot := false
	mut start := par.pos

	for {
		ch := par.source[par.pos]

		if !valid_number_char(ch) {
			break
		}

		par.pos++
	}

	return Token{
		typ: .vnumber
		pos: start
		end: par.pos
	}
}

// string
@[inline]
fn (mut par Parser) lex_string() Token {
	par.pos++
	mut start := par.pos

	for par.pos < par.source.len && par.source[par.pos] != `"` {
		par.pos++
	}

	if par.pos >= par.source.len {
		throw(start, "unterminated string")
	}

	par.pos ++
	return Token{
		typ: .vstring
		pos: start - 1
		end: par.pos
	}
}

// identifier
@[inline]
fn valid_ident_char(ch u8) bool {
	return match ch {
		`(`, `)`, `'`, `#` { false }
		else               { true }
	}
}

@[inline]
fn (mut par Parser) lex_ident() Token {
	mut start := par.pos
	for valid_ident_char(par.source[par.pos]) {
		par.pos++
	}
	
	return Token {
		typ: .ident
		pos: start
		end: par.pos
	}
}


pub fn (mut par Parser) lex() Token {
	par.skip_unneeded()
	ch := par.source[par.pos] or { 0 }
	return match ch {
		0         { par.lex_char(.eof) }
		`'`       { par.lex_char(.quote) }
		`(`       { par.lex_char(.start_bracket) }
		`)`       { par.lex_char(.close_bracket) }
		`#`       { par.lex_bool() }
		`"`       { par.lex_string() }
		`0`...`9` { par.lex_number() }
		else      { par.lex_ident() }
	}
}
