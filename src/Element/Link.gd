extends Element
class_name Link

@export var to: Array[Entry] = [];

# TODO: remove possibility of adding multiple of the same link
func append_to_linked_entries(__linking: Array[Entry]) -> bool:
	if not __linking.is_empty():
		to.append_array(__linking)
		return true
	return false

func remove_from_linked_entries(__linking: Array[int]) -> bool:
	var __links: int = to.size()
	if not __linking.is_empty():
		for __linked_entry_id: int in __linking:
			if __linked_entry_id < __links: 
				printerr("Failed to remove element %s (larger than \
				elements size (%s))" % [__linked_entry_id, __links])
				return false
			to.remove_at(__linked_entry_id)
	return true

func _init(__link_to: Array[Entry]) -> void:
	pass
