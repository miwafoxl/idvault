extends Resource
class_name RandomString

const __ID_CHARSET: Array[String] = [
	"a", "b", "c", "d", "e", "f", "g", "h", "j", "k", "m", "n", "p", "q",
	"r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E",
	"F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "U",
	"V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

var length: int = 8
var prefix: String = ""
var value: String = ""

func regenerate() -> String:
	var __id: String = prefix
	seed(Time.get_ticks_usec())
	for i: int in range(length):
		__id += __ID_CHARSET.pick_random()
	return __id

func _init(__prefix: String = prefix, __length: int = length) -> void:
	self.prefix = __prefix
	self.length = __length
	self.value = regenerate()
