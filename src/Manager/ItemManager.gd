extends Manager
class_name ItemManager

@export var unordered_items: Array[Item] = [];
@export var selected_items: Array[Item] = [];
var staged_items: Array[WeakRef] = [];

@warning_ignore("unused_signal")
signal trigger(tr: Trigger)
signal items_updated()
signal selection_updated()

# Context
var descriptors_cx: Array # [0: item ref, 1: descriptor ref, 2: alias]
var parameters_cx: Array # [0: item ref, 1: parameter ref, 2: param id]
var links_cx: Array # [0: item ref, 1: link ref, 2: linked item id]

enum PropertyTypes {
	PROPERTY,
	DESCRIPTOR,
	DISPLAY,
	LINK,
	PARAMETER,
	RANGED_DATE,
}

# TODO: Separate thread
func get_item_by_id(__id: Array[String]) -> Array[Item]:
	var __items: Array[Item] = []
	__items.resize(__id.size())
	if unordered_items.is_empty():
		return __items
	for i: int in unordered_items.size():
		if unordered_items[i].id in __id:
			for u: int in __id.size():
				if __id[u] == unordered_items[i].id:
					__items[u] = unordered_items[i]
	var __nulls: int = 0
	for __item_check: Item in __items: # Check if it's busted
		if __item_check == null:
			__nulls += 1
	if __items.size() == __nulls:
		__items = [] # Yeah, it's busted
	return __items

func append_properties_to_item(__item_arr_indexes: Array[int], \
		__properties: Array[Property]) -> bool:
	var __err: bool = true
	var __items_size: int = unordered_items.size() # Potentially bad to do everytime
	if not __item_arr_indexes.is_empty():
		for __item_id: int in __item_arr_indexes:
			if __item_id < __items_size: 
				printerr("Item Manager: Failed to append property to item %s (larger than \
				items array size (%s))" % [__item_id, __items_size])
				__err = false
				break
			unordered_items[__item_id].append_property(__properties)
	return __err

func select_items(__items: Array[Item], __append: bool = false) -> void:
	if __items.is_empty(): return
	if not __append: selected_items = __items; return
	for __item: Item in __items:
		if __item not in selected_items:
			selected_items.append(__item)

func deselect_items(__deselec_items: Array[Item]) -> void:
	if not __deselec_items.is_empty():
		for __item: Item in selected_items:
			if __item in __deselec_items:
				selected_items.erase(__item)

func select_items_at_stage_index(__stage_index: Array[int], __append: bool = false) -> void:
	if not __stage_index.is_empty():
		if not __append: selected_items.clear()
		var __items: Array[Item] = get_staged_item_index(__stage_index)
		selected_items.append_array(__items)

func deselect_items_at_stage_index(__deselec_stage_index: Array[int]) -> void:
	if not __deselec_stage_index.is_empty():
		var __items: Array[Item] = get_staged_item_index(__deselec_stage_index)
		for __item: Item in __items:
			if __item in selected_items:
				selected_items.erase(__item)

func retrieve_selected_items_id() -> Array[String]:
	var __selected_ids: Array[String] = []
	for __item: Item in selected_items:
		__selected_ids.append(__item.id)
	return __selected_ids

func append_items(__entries: Array[Item]) -> bool:
	if not __entries.is_empty():
		unordered_items += __entries
		descriptors_cx = reload_descriptor_context(unordered_items)
		parameters_cx = reload_parameters_context(unordered_items)
		links_cx = reload_links_context(unordered_items)
		return true
	return false 

func remove_items_unordered(__item_arr_indexes: Array[int]) -> bool:
	var __items_size: int = unordered_items.size() # Potentially bad to do everytime
	if not __item_arr_indexes.is_empty():
		for __item_id: int in __item_arr_indexes:
			if __item_id >= __items_size: 
				printerr("Item Manager: Failed to remove item %s (larger than \
				items array size (%s))" % [__item_id, __items_size])
				return false
			unordered_items.set(__item_id, null)
		clean_entries()
		descriptors_cx = reload_descriptor_context(unordered_items)
		parameters_cx = reload_parameters_context(unordered_items)
		links_cx = reload_links_context(unordered_items)
	return true

func remove_items_stage_index(__rm_stage_index: Array[int]) -> bool:
	var __items_size: int = staged_items.size()
	if not __rm_stage_index.is_empty():
		var __items: Array[Item] = get_staged_item_index(__rm_stage_index)
		for __item: Item in __items:
			__item.unreference()
		descriptors_cx = reload_descriptor_context(unordered_items)
		parameters_cx = reload_parameters_context(unordered_items)
		links_cx = reload_links_context(unordered_items)
	clean_entries()
	return true

func clean_entries() -> void:
	var __rm_indexes: Array[int] = []
	for __item_id: int in unordered_items.size():
		if unordered_items[__item_id] == null:
			__rm_indexes.append(__item_id)
	__rm_indexes.reverse()
	for __index: int in __rm_indexes:
		unordered_items.remove_at(__index)

# TODO: Separate thread
func reload_descriptor_context(__items: Array[Item]) \
		-> Array: # descriptors_cx model
	var __cx: Array
	if not __items.is_empty():
		for __item_idx: int in __items.size():
			var __item: Item = __items[__item_idx]
			if not __item.has_descriptor(): continue
			for __descriptor: Descriptor in __item.retrieve_descriptors():
				__cx.append([weakref(__item), weakref(__descriptor), \
				__descriptor.alias])
	return __cx

# TODO: Separate thread
func reload_parameters_context(__items: Array[Item]) \
		-> Array: # parameters_cx model
	var __cx: Array
	if not __items.is_empty():
		for __item_idx: int in __items.size():
			var __item: Item = __items[__item_idx]
			if not __item.has_parameters(): continue
			for __param: Parameter in __item.retrieve_parameters():
				__cx.append([weakref(__item), weakref(__param), __param.id])
	return __cx

# TODO: Separate thread
func reload_links_context(__items: Array[Item]) \
		-> Array: # links_cx model
	var __cx: Array
	if not __items.is_empty():
		for __item_idx: int in __items.size():
			var __item: Item = __items[__item_idx]
			if not __item.has_parameters(): continue
			for __link: Link in __item.retrieve_links():
				__cx.append([weakref(__item), weakref(__link), 
				__link.to, __link.parameters])
	return __cx

#region ITEM STAGING

func stage_items(__items: Array[Item], __append_stage: bool = false) -> void:
	if __items.is_empty(): return
	if not __append_stage: staged_items.clear()
	for __item: Item in __items:
		var __ref: WeakRef = weakref(__item)
		staged_items.append(__ref)

func reverse_staged() -> void:
	return staged_items.reverse()

func get_stage_size() -> int:
	return staged_items.size()

func get_staged_item_index(__indexes: Array) -> Array[Item]:
	var __items: Array[Item] = []
	var __stage_size: int = get_stage_size() - 1
	if __indexes.is_empty(): return __items
	for __idx: int in __indexes:
		if __idx > __stage_size: 
			printerr("Item Manager: Tried to access stage index %s greater than stage size %s" % \
					[__idx, __stage_size])
			continue
		var __deref_item: Item = staged_items[__idx].get_ref()
		if __deref_item == null:
			printerr("Item Manager: Failed to get reference for item in stage index %s" % __idx)
			continue
		__items.append(__deref_item)
	return __items
	
func get_staged_items_pages(__page_size: int = 0, __page_index: int = 0) -> Array[Item]:
	var __stage: Array[Item] = []
	var __max_pages: int = 1 # TODO: Unused
	var __stage_size: int = get_stage_size()
	if staged_items.is_empty(): return __stage
	if (__page_size == 0) or (__page_size > 0 and __page_size > __stage_size):
		var __items: Array[Item] = get_staged_item_index(range(0, __stage_size))
		__stage.append_array(__items)
	else:
		__max_pages = ceil(float(__stage_size) / float(__page_size))
		var __items: Array[Item] = get_staged_item_index(range(__page_size * __page_index, \
				(__page_size * __page_index) + __page_size))
		__stage.append_array(__items)
	return __stage

#endregion ITEM STAGING
