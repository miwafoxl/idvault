extends Manager
class_name ItemManager

@export var unordered_items: Array[Item] = [];
@export var selected_items: Array[Item] = [];
@export var item_cache: Dictionary = {}; # [0: item
var staged_items: Array[WeakRef] = [];

@warning_ignore("unused_signal")
signal trigger(tr: Trigger)
signal items_updated()
signal selection_updated()

# DEPRECATED: Context
var descriptors_cx: Array # [0: item ref, 1: descriptor ref, 2: alias]
var parameters_cx: Array # [0: item ref, 1: parameter ref, 2: param id, 3: params]
var links_cx: Array # [0: item ref, 1: link ref, 2: linked item id]
var property_cx: Array # [0: item ref, 1: property ref, 2: prop id]

enum PropertyTypes {
	PROPERTY,
	DESCRIPTOR,
	DISPLAY,
	LINK,
	PARAMETER,
	RANGED_DATE,
}

#region HACKS

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

#endregion HACKS
#region ITEM SELECTING

func select_items(__items: Array[Item], __append: bool = false) -> void:
	var __changed: bool = false
	if __items.is_empty(): return
	if __append: 
		for __item: Item in __items:
			if __item not in selected_items:
				selected_items.append(__item)
				__changed = true
	else:
		selected_items = __items;
		__changed = true
	if __changed: selection_updated.emit()

func deselect_items(__deselec_items: Array[Item]) -> void:
	var __changed: bool = false
	if not __deselec_items.is_empty():
		for __item: Item in selected_items:
			if __item in __deselec_items:
				selected_items.erase(__item)
				__changed = true
	if __changed: selection_updated.emit()

func select_items_at_stage_index(__stage_index: Array[int], \
		__append: bool = false) -> void:
	var __changed: bool = false
	if not __stage_index.is_empty():
		if not __append: selected_items.clear()
		var __items: Array[Item] = get_staged_item_index(__stage_index)
		selected_items.append_array(__items)
		__changed = true
	if __changed: selection_updated.emit()

func deselect_items_at_stage_index(__deselec_stage_index: Array[int]) -> void:
	var __changed: bool = false
	if not __deselec_stage_index.is_empty():
		var __items: Array[Item] = get_staged_item_index(__deselec_stage_index)
		for __item: Item in __items:
			if __item in selected_items:
				selected_items.erase(__item)
				__changed = true
	if __changed: selection_updated.emit()

func retrieve_selected_items_id() -> Array[String]:
	var __selected_ids: Array[String] = []
	for __item: Item in selected_items:
		__selected_ids.append(__item.id)
	return __selected_ids

#endregion ITEM SELECTING
#region ITEM APPENDING AND REMOVAL

func append_items(__entries: Array[Item]) -> bool:
	if __entries.is_empty(): return false
	unordered_items += __entries
	reload_cache(unordered_items)
	items_updated.emit()
	return true 

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
		reload_cache(unordered_items)
		items_updated.emit()
	return true

func remove_items_stage_index(__rm_stage_index: Array[int]) -> bool:
	var __items_size: int = staged_items.size()
	if not __rm_stage_index.is_empty():
		var __items: Array[Item] = get_staged_item_index(__rm_stage_index)
		for __item: Item in __items:
			__item.unreference()
		#reload_context(unordered_items)
		reload_cache(unordered_items)
		clean_entries()
		items_updated.emit()
	return true

func clean_entries() -> void:
	var __rm_indexes: Array[int] = []
	for __item_id: int in unordered_items.size():
		if unordered_items[__item_id] == null:
			__rm_indexes.append(__item_id)
	__rm_indexes.reverse()
	for __index: int in __rm_indexes:
		unordered_items.remove_at(__index)

#endregion ITEM APPENDING AND REMOVAL
#region ITEM CACHEING

func get_from_cache(__cache_library: String, __head: String) -> Array:
	if not item_cache.has(__cache_library):
		printerr("ItemManager: Invalid cache library '%s'. Returning empty array." % __cache_library)
		return []
	var __head_arr: Array = (item_cache.get(__cache_library) \
			as Dictionary).get(__head, null)
	if __head_arr == null:
		printerr("ItemManager: Invalid cache header '%s' in library '%s'. Returning empty array." % \
				[__head, __cache_library])
		return []
	return __head_arr

func reload_cache(__items: Array[Item]) -> void:
	#item_cache.clear()
	# { Item.id: [Item wref], ... }
	item_cache.set("by_item_id", cache_by_item_id(__items))
	# { Prop.id: [Item wref, Prop wref], ... }
	item_cache.set("by_property_id", cache_by_property_id(__items))
	item_cache.set("by_descriptor_id", cache_by_descriptor_id(__items))
	# { Param.id: [Item wref, Prop wref, Prop.id], ... }
	item_cache.set("by_parameter_id", cache_by_parameter_id(__items))
	# { Link.from: [Item wref, Prop wref, Prop.id], ... }
	item_cache.set("by_link_from_id", cache_links(__items, false))
	# { Link.to: [Item wref, Prop wref, Prop.id], ... }
	item_cache.set("by_link_to_id", cache_links(__items, true))

func cache_by_item_id(__items: Array[Item]) -> Dictionary:
	if __items.is_empty(): return {}
	var __cache: Dictionary = {}
	for __item_idx: int in __items.size():
		var __cx: Array = []
		var __item: Item = __items[__item_idx]
		if __item.properties.is_empty(): continue
		__cx.append_array([weakref(__item)])
		__cache.set(__item.id, __cx)
	return __cache

func cache_by_property_id(__items: Array[Item]) -> Dictionary:
	if __items.is_empty(): return {}
	var __cache: Dictionary = {}
	for __item_idx: int in __items.size():
		var __item: Item = __items[__item_idx]
		if __item.properties.is_empty(): continue
		for __prop: Property in __item.properties:
			var __cx: Array = []
			__cx.append_array([weakref(__item), weakref(__prop)])
			__cache.set(__prop.id, __cx)
	return __cache

func cache_by_descriptor_id(__items: Array[Item]) -> Dictionary:
	if __items.is_empty(): return {}
	var __cache: Dictionary = {}
	for __item_idx: int in __items.size():
		var __item: Item = __items[__item_idx]
		var __props: Array[Descriptor] = __item.retrieve_descriptors()
		if __props.is_empty(): continue
		for __prop: Property in __props:
			var __cx: Array = []
			__cx.append_array([weakref(__item), weakref(__prop)])
			__cache.set(__prop.id, __cx)
	return __cache

func cache_by_parameter_id(__items: Array[Item]) -> Dictionary:
	if __items.is_empty(): return {}
	var __cache: Dictionary = {}
	for __item_idx: int in __items.size():
		var __item: Item = __items[__item_idx]
		var __props: Array[Parameter] = __item.retrieve_parameters()
		if __props.is_empty(): continue
		for __prop: Parameter in __props:
			var __cx: Array = []
			__cx.append_array([weakref(__item), weakref(__prop), __prop.id])
			__cache.set(__prop.param_id, __cx)
	return __cache

func cache_links(__items: Array[Item], \
		__to_from: bool = false) -> Dictionary:
	if __items.is_empty(): return {}
	var __cache: Dictionary = {}
	for __item_idx: int in __items.size():
		var __item: Item = __items[__item_idx]
		var __props: Array[Link] = __item.retrieve_links()
		if __props.is_empty(): continue
		for __prop: Link in __props:
			var __cx: Array = []
			__cx.append_array([weakref(__item), weakref(__prop), __prop.id])
			if __to_from: __cache.set(__prop.to, __cx)
			else: 		  __cache.set(__prop.from, __cx)
	return __cache

#endregion ITEM CACHEING
#region CONTEXT RELOADING

# DEPRECATED
func reload_context(__items: Array[Item]) -> void:
	property_cx = reload_property_context(__items)
	descriptors_cx = reload_descriptor_context(__items)
	parameters_cx = reload_parameters_context(__items)
	links_cx = reload_links_context(__items)

# DEPRECATED
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

# DEPRECATED
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

# DEPRECATED
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

# DEPRECATED
func reload_property_context(__items: Array[Item]) \
		-> Array: # links_cx model
	var __cx: Array
	if not __items.is_empty():
		for __item_idx: int in __items.size():
			var __item: Item = __items[__item_idx]
			if __item.properties.is_empty(): continue
			for __prop: Property in __item.properties:
				__cx.append([weakref(__item), weakref(__prop), __prop.id])
	return __cx

#endregion CONTEXT RELOADING
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
