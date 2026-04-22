extends Property
class_name Link

@export var from_id: String;
@export var to_id: String;
@export var parameters: Dictionary[String, Variant] = {};
@export var user_created: bool = false

func append_parameter(__parameters: Dictionary[String, Variant]) -> bool:
	if not __parameters.is_empty():
		parameters.merge(__parameters)
		return true
	return false

func remove_parameter(__rm_parameter_id: Array[String]) -> bool:
	if not __rm_parameter_id.is_empty():
		for __param_id: String in parameters.keys():
			if __param_id not in __rm_parameter_id: continue
			return parameters.erase(__param_id)
	return true

func get_type_as_string() -> StringName:
	return &"PROPERTY.TYPES.LINK"

func _init(__link_to_id: String, __link_from_id: String = "",
		__parameters: Dictionary[String, Variant] = {},
		__user_created: bool = false) -> void:
	self.from_id = __link_from_id
	self.to_id = __link_to_id
	self.user_created = __user_created
	append_parameter(__parameters)
	self.id = RandomString.new("P_").value
