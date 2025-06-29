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
fn (mut par Parser) lex_char(typ NKind) Node {
	par.pos++
	return Node{
		typ: typ
		pos: par.pos - 1
		end: par.pos
	}
}

// bool
@[inline]
fn (mut par Parser) lex_bool() Node {
	par.pos += 2
	return Node{
		typ: .nbool
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
fn (mut par Parser) lex_number() Node {
	mut start := par.pos
	mut dot := false

	for i := par.pos; i < par.source.len; i++ {
		ch := par.source[i]

		if !valid_number_char(ch) {
			break
		}

		if ch == `.` {
			if dot {
				par.throw(i, i + 1, "unexpected second `.` in number")
			}
			dot = true
		}
		if ch == `-` && i != start {
			par.throw(i, i + 1, "unexpected `-` in middle of number")
		}

		par.pos++
	}

	return Node{
		typ: .nnumber
		pos: start
		end: par.pos
	}
}

// string
@[inline]
fn (mut par Parser) lex_string() Node {
	par.pos++
	mut start := par.pos

	for par.pos < par.source.len && par.source[par.pos] != `"` {
		par.pos++
	}

	par.pos ++

	if par.pos >= par.source.len {
		par.throw(start, par.pos, "unterminated string")
	}

	return Node{
		typ: .nstring
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
fn (mut par Parser) lex_ident() Node {
	mut start := par.pos
	for valid_ident_char(par.source[par.pos]) {
		par.pos++
	}
	
	return Node {
		typ: .nident
		pos: start
		end: par.pos
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
