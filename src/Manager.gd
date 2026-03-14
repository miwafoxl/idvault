extends Node
class_name Manager

@export var unordered_entries: Array[Entry] = [];
var descriptors_cx: Array # [0: entry ref, 1: descriptor ref, 2: alias]
var parameters_cx: Array # [0: entry ref, 1: parameter ref, 2: param id]
var links_cx: Array # [0: entry ref, 1: link ref, 2: linked entry id]

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
		__entries = [] # Yeah, it's busted
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
		descriptors_cx.append(reload_descriptor_context(__entries))
		parameters_cx.append(reload_parameters_context(__entries))
		links_cx.append(reload_links_context(__entries))
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
		descriptors_cx = reload_descriptor_context(unordered_entries)
		parameters_cx = reload_parameters_context(unordered_entries)
		links_cx = reload_links_context(unordered_entries)
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
func reload_descriptor_context(__entries: Array[Entry]) \
		-> Array: # descriptors_cx model
	var __cx: Array[Array]
	if not __entries.is_empty():
		for __entry_idx: int in __entries.size():
			var __entry: Entry = __entries[__entry_idx]
			if not __entry.has_descriptor(): continue
			for __descriptor: Descriptor in __entry.retrieve_descriptors():
				__cx.append([weakref(__entry), weakref(__descriptor), \
				__descriptor.alias])
	return __cx

# TODO: Separate thread
func reload_parameters_context(__entries: Array[Entry]) \
		-> Array: # parameters_cx model
	var __cx: Array[Array]
	if not __entries.is_empty():
		for __entry_idx: int in __entries.size():
			var __entry: Entry = __entries[__entry_idx]
			if not __entry.has_parameters(): continue
			for __param: Parameter in __entry.retrieve_parameters():
				__cx.append([weakref(__entry), weakref(__param), __param.id])
	return __cx

# TODO: Separate thread
func reload_links_context(__entries: Array[Entry]) \
		-> Array: # links_cx model
	var __cx: Array[Array]
	if not __entries.is_empty():
		for __entry_idx: int in __entries.size():
			var __entry: Entry = __entries[__entry_idx]
			if not __entry.has_link(): continue
			for __link: Link in __entry.retrieve_links():
				__cx.append([weakref(__entry), weakref(__link), 
				__link.to, __link.parameters])
	return __cx
