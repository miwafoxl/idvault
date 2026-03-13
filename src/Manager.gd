extends Node
class_name Manager

@export var unordered_entries: Array[Entry] = [];

func append_elements_to_entry(__entry_arr_indexes: Array[int], \
		__elements: Array[Element]) -> bool:
	var __err: bool = true
	var __entries_size: int = unordered_entries.size() # Potentially bad to do everytime
	if not __entry_arr_indexes.is_empty():
		for __entry_id: int in __entry_arr_indexes:
			if __entry_id < __entries_size: 
				printerr("Failed to append element to entry %s (larger than \
				entries array size (%s))" % [__entry_id, __entries_size])
				__err = false
				break
			unordered_entries[__entry_id].append_elements(__elements)
	return __err

func append_entries(__entries: Array[Entry]) -> bool:
	if not __entries.is_empty():
		unordered_entries.append_array(__entries)
		return true
	return false

func remove_entries(__entry_arr_indexes: Array[int]) -> bool:
	var __entries_size: int = unordered_entries.size() # Potentially bad to do everytime
	if not __entry_arr_indexes.is_empty():
		for __entry_id: int in __entry_arr_indexes:
			if __entry_id < __entries_size: 
				printerr("Failed to remove entry %s (larger than \
				entries array size (%s))" % [__entry_id, __entries_size])
				return false
			unordered_entries.remove_at(__entry_id)
	return true
