extends Node
class_name Manager

@export var unordered_entries: Array[Entry] = [];
var descriptor_entries: Dictionary[int, WeakRef] = {};

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
		descriptor_entries = reload_descriptor_entries(unordered_entries)
		return true
	return false 

func remove_entries(__entry_arr_indexes: Array[int]) -> bool:
	var __entries_size: int = unordered_entries.size() # Potentially bad to do everytime
	if not __entry_arr_indexes.is_empty():
		for __entry_id: int in __entry_arr_indexes:
			if __entry_id > __entries_size: 
				printerr("Failed to remove entry %s (larger than \
				entries array size (%s))" % [__entry_id, __entries_size])
				return false
			unordered_entries.set(__entry_id, null)
		descriptor_entries = reload_descriptor_entries(unordered_entries)
		clean_entries()
	return true

func clean_entries() -> void:
	var __rm_indexes: Array[int] = []
	for __entry_id: int in unordered_entries.size():
		if unordered_entries[__entry_id] == null:
			__rm_indexes.append(__entry_id)
	__rm_indexes.reverse()
	for __index: int in __rm_indexes:
		unordered_entries.remove_at(__index)

# TODO: This probably needs to be ran in a separate thread
func reload_descriptor_entries(__entries: Array[Entry]) \
		-> Dictionary[int, WeakRef]:
	var __descriptor_refs: Dictionary[int, WeakRef] = {}
	for __entry_id: int in __entries.size():
		var __entry: Entry = __entries[__entry_id]
		if __entry.has_descriptor():
			var __ref: WeakRef = weakref(__entry)
			__descriptor_refs.set(__entry_id, __ref)
	print_debug(__descriptor_refs)
	return __descriptor_refs
