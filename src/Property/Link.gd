extends Property
class_name Link

@export var to: Array[int] = [];
@export var parameters: Dictionary[String, Variant] = {};

# TODO: remove possibility of adding multiple of the same link
func append_to_linked_id_arr(__linking: Array[int]) -> bool:
	if not __linking.is_empty():
		to.append_array(__linking)
		return true
	return false

func remove_from_linked_id_arr(__rm_indexes: Array[int]) -> bool:
	var __links: int = to.size()
	if not __rm_indexes.is_empty():
		for __linked_item_id: int in __rm_indexes:
			if __linked_item_id > __links: 
				printerr("Failed to remove property %s (larger than \
				proprieties size (%s))" % [__linked_item_id, __links])
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

func _init(__link_item_id: Array[int], \
		__parameters: Dictionary[String, Variant] = {}) -> void:
	self.to = __link_item_id
	append_parameter(__parameters)
	self.id = super.flush_id()
