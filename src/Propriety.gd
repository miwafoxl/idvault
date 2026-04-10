@abstract
extends Resource
class_name Property

@export var id: String = ""
@export var default: StringName = &"default"
@export var category: StringName = &"general";

func deserialized(__include_prop_id: bool = true) -> Dictionary:
	var __property_dict: Dictionary = {}
	for __dict: Dictionary in self.get_property_list():
		var __usage: int = __dict.get("usage", 0)
		if not __usage == 0x1006: continue
		var __p_name: String = __dict.get("name", "")
		var __p_value: String = self.get(__p_name)
		if (not __include_prop_id) and (__p_name == "id"): continue
		__property_dict.set(__p_name, __p_value)
	return __property_dict

func serialize(__dict: Dictionary) -> void:
	for __key: String in __dict.keys():
		self.set(__key, __dict[__key])

#@abstract
#func deserialize() -> Dictionary
#
#@abstract
#func serialize() -> Property
