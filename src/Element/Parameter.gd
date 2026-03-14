extends Element
class_name Parameter

@export var id: String = "";
@export var order: int = 0;
@export var type: ParameterTypes = ParameterTypes.PARAMETER;

enum ParameterTypes {
	PARAMETER,
	STRING,
	NUMBER,
}

func flush_id() -> String:
	const __ID_CHARSET: Array[String] = [
		"a", "b", "c", "d", "e", "f", "g", "h", "j", "k", "m", "n", "p", "q",
		"r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E",
		"F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "U",
		"V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
	const __ID_LENGTH: int = 8
	var __id: String = "p_"
	for i: int in range(__ID_LENGTH):
		__id += __ID_CHARSET.pick_random()
	return __id

func _init(__type: ParameterTypes = ParameterTypes.NUMBER, __order: int = 0, \
		__id: String = flush_id()):
	self.id = __id
	self.order = __order
	self.type = __type
