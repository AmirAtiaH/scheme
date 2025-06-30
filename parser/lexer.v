module parser

@[inline]
fn (mut prsr Parser) skip_unneeded() {
	mut i := prsr.pos
	src := prsr.source
	len := src.len

	for i < len {
		ch := src[i]
		match ch {
			` `, `\t`, `\r`, `\n` {
				i++
			}
			`;` {
				for i < len && src[i] != `\n` {
					i++
				}
			}
			else { break }
		}
	}

	prsr.pos = i
}

// token
@[inline]
fn (mut par Parser) lex_char(typ NKind) Node {
	par.pos++
	return Node{
		typ: typ
		pos: par.pos - 1
	}
}

// bool
@[inline]
fn (mut par Parser) lex_bool() Node {
	par.pos += 2
	return Node{
		typ: .nbool
		pos: par.pos - 2
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
fn (mut par Parser) lex_number() Node {
	mut start := par.pos

	for valid_number_char(par.source[par.pos]) {
		par.pos++
	}

	return Node{
		typ: .nnumber
		pos: start
	}
}

@[inline]
fn (mut par Parser) lex_string() Node {
	mut start := par.pos
	par.pos++

	for par.pos < par.source.len && par.source[par.pos] != `"` {
		par.pos++
	}

	if par.pos >= par.source.len {
		par.throw(start, par.pos, "unterminated string")
	}

	par.pos++

	return Node{
		typ: .nstring
		pos: start
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
fn (mut par Parser) lex_ident() Node {
	mut start := par.pos

	for valid_ident_char(par.source[par.pos]) {
		par.pos++
	}
	
	return Node {
		typ: .nident
		pos: start
	}
}


pub fn (mut par Parser) lex() {
	par.skip_unneeded()
	ch := par.source[par.pos] or { 0 }
	par.nodes << match ch {
		0         { par.lex_char(.eof) }
		`'`       { par.lex_char(.nquote) }
		`(`       { par.lex_char(.nslist) }
		`)`       { par.lex_char(.nclist) }
		`#`       { par.lex_bool() }
		`"`       { par.lex_string() }
		`0`...`9` { par.lex_number() }
		else      { par.lex_ident() }
	}
}
