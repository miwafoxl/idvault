@abstract
extends Resource
class_name Property

@export var id: String = ""
@export var default: StringName = &"default"
@export var category: StringName = &"general";

func flush_id() -> String:
	const __ID_CHARSET: Array[String] = [
		"a", "b", "c", "d", "e", "f", "g", "h", "j", "k", "m", "n", "p", "q",
		"r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E",
		"F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "U",
		"V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
	const __ID_LENGTH: int = 8
	var __id: String = "P_"
	for i: int in range(__ID_LENGTH):
		__id += __ID_CHARSET.pick_random()
	return __id
