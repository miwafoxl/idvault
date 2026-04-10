extends Property
class_name Link

@export var from: Array[String] = [];
@export var to: Array[String] = [];
@export var parameters: Dictionary[String, Variant] = {};

# TODO: remove possibility of adding multiple of the same link
func append_linking_from_id(__linking_id: Array[int]) -> bool:
	if not __linking_id.is_empty():
		from.append_array(__linking_id)
		return true
	return false

func append_linked_to_id(__linked_to: Array[int]) -> bool:
	if not __linked_to.is_empty():
		to.append_array(__linked_to)
		return true
	return false

func remove_linked_to_id(__rm_indexes: Array[int]) -> bool:
	var __links: int = to.size()
	if not __rm_indexes.is_empty():
		for __linked_item_id: int in __rm_indexes:
			if __linked_item_id > __links: 
				printerr("Failed to remove property %s (larger than \
				properties size (%s))" % [__linked_item_id, __links])
				return false
			to.remove_at(__linked_item_id)
	return true

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

func _init(__link_item_id: Array[String], \
		__parameters: Dictionary[String, Variant] = {}) -> void:
	self.to = __link_item_id
	append_parameter(__parameters)
	self.id = RandomString.new("P_").value
