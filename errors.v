module errors

pub fn throw(pos u32, msg string) {
	println("error at: ${pos.str()}")
	println(msg)
	exit(1)
}