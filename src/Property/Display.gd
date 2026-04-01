extends Property
class_name Display

@export var text: String = "";
@export var alt: String = "";
@export var iso_639_1: String = "";

func _init(__text: String = "", __alt: String = "", \
		__iso_639_1: String = "") -> void:
	self.text = __text
	self.alt = __alt
	self.iso_639_1 = __iso_639_1
	self.id = super.flush_id()
