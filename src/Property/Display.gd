extends Property
class_name Display

@export var header: String = "";
@export var alt: String = "";
@export var brief: String = "";
@export var text: String = "";
@export var iso_639_1: String = "";

func get_any_valid_str() -> String:
	var __strings: Array[String] = [header, alt, brief, text]
	for __text: String in __strings:
		if not __text.is_empty(): 
			return __text.left(150)
	return ""

func get_type_as_string() -> StringName:
	return &"PROPERTY.TYPES.DISPLAY"

func _init(__header: String, __alt: String = "", __brief: String = "", \
		__text: String = "", __iso_639_1: String = "") -> void:
	self.header = __header
	self.alt = __alt
	self.text = __text
	self.brief = __brief
	self.iso_639_1 = __iso_639_1
	self.id = RandomString.new("P_").value
