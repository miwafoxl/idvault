extends Node
class_name Manager

@export var unordered_entries: Array[Entry] = [];
var descriptor_entries: Dictionary[int, WeakRef] = {};
var parameter_list: Dictionary[String, WeakRef] = {};

# TODO: Separate thread
func get_entry_by_id(__id: Array[int]) -> Array[Entry]:
	var __entries: Array[Entry] = []
	__entries.resize(__id.size())
	if unordered_entries.is_empty():
		return __entries
	for i: int in unordered_entries.size():
		if unordered_entries[i].id in __id:
			for u: int in __id.size():
				if __id[u] == unordered_entries[i].id:
					__entries[u] = unordered_entries[i]
	var __nulls: int = 0
	for __entry_check: Entry in __entries: # Check if it's busted
		if __entry_check == null:
			__nulls += 1
	if __entries.size() == __nulls:
		__entries = []
	return __entries

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
		descriptor_entries.merge(reload_descriptor_entries(__entries), true)
		parameter_list.merge(reload_parameter_list(__entries), true)
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
		clean_entries()
		descriptor_entries = reload_descriptor_entries(unordered_entries)
		parameter_list = reload_parameter_list(unordered_entries)
	return true

func clean_entries() -> void:
	var __rm_indexes: Array[int] = []
	for __entry_id: int in unordered_entries.size():
		if unordered_entries[__entry_id] == null:
			__rm_indexes.append(__entry_id)
	__rm_indexes.reverse()
	for __index: int in __rm_indexes:
		unordered_entries.remove_at(__index)

# TODO: Separate thread
func reload_descriptor_entries(__entries: Array[Entry]) \
		-> Dictionary[int, WeakRef]:
	var __descriptor_refs: Dictionary[int, WeakRef] = {}
	if not __entries.is_empty():
		for __entry_idx: int in __entries.size():
			var __entry: Entry = __entries[__entry_idx]
			if __entry.has_descriptor():
				var __ref: WeakRef = weakref(__entry)
				__descriptor_refs.set(__entry_idx, __ref)
	return __descriptor_refs

# TODO: Separate thread
func reload_parameter_list(__entries: Array[Entry]) \
		-> Dictionary[String, WeakRef]:
	var __parameters: Dictionary[String, WeakRef] = {}
	if not __entries.is_empty():
		for __entry: Entry in __entries:
			if not __entry.has_parameters(): continue
			for __param: Parameter in __entry.retrieve_parameters():
				__parameters.set(__param.id, weakref(__param))
	return __parameters
