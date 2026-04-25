extends Manager
class_name ItemManager

@export var unordered_items: Array[Item] = [];
@export var selected_items: Array[Item] = [];
@export var item_cache: Dictionary = {}; # [0: item
var staged_items: Dictionary[String, WeakRef] = {};

@warning_ignore("unused_signal")
signal trigger(tr: Trigger)
signal stage_updated()
signal selection_updated()

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
	var __rm_indexes: Array[int] = []
	if not __deselec_items.is_empty():
		for i: int in selected_items.size():
			var __item: Item = selected_items[i]
			if __item in __deselec_items:
				selected_items.set(i, null)
				__rm_indexes.append(i)
	if not __rm_indexes.is_empty():
		for __idx: int in __rm_indexes:
			selected_items.remove_at(__idx)
	selection_updated.emit()

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
	return true 

func remove_items_unordered(__items: Array[Item]) -> void:
	for __item: Item in __items:
		var __unord_idx: int = unordered_items.find(__item)
		if __unord_idx == -1: continue
		unordered_items.set(__unord_idx, null)
		if staged_items.has(__item.id):
			staged_items.erase(__item.id)
	clean_entries()
	reload_cache(unordered_items)

func remove_items_unordered_index(__item_arr_indexes: Array[int]) -> bool:
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
	return true

func remove_items_stage_index(__rm_stage_index: Array[int]) -> bool:
	var __items_size: int = staged_items.size()
	if not __rm_stage_index.is_empty():
		var __items: Array[Item] = get_staged_item_index(__rm_stage_index)
		for __item: Item in __items:
			__item.unreference()
		reload_cache(unordered_items)
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

#endregion ITEM APPENDING AND REMOVAL
#region ITEM CACHEING

func get_from_cache(__cache_library: String, __head: String) -> Array:
	var __head_arr: Array = []
	var __cache_lib: Dictionary
	if not item_cache.has(__cache_library):
		printerr("ItemManager: non-existent cache '%s'. Returning empty array." % __cache_library)
		return []
	__cache_lib = item_cache.get(__cache_library, {})
	if not __cache_lib.is_empty():
		__head_arr = __cache_lib.get(__head, [])
	if __head_arr == []: pass
		#printerr("ItemManager: cache '%s/%s' not found. Returning empty array." % [__cache_library, __head])
	return __head_arr

func get_from_cache_many(__cache_library: String, __head: Array[String]) -> Array:
	if not item_cache.has(__cache_library):
		printerr("ItemManager: Invalid cache library '%s'. Returning empty array." % __cache_library)
		return []
	var __head_arr: Array
	for __header: String in __head:
		var __get: Array = (item_cache.get(__cache_library) as Dictionary).get(__header, [])
		if __get.is_empty():
			printerr("ItemManager: Invalid cache header '%s' in library '%s'. Returning empty array." % \
				[__header, __cache_library])
			continue
		__head_arr.append(__get)
	return __head_arr

func cache_get_matched(__cache_library: String, __match_string: Array) -> Array:
	if not item_cache.has(__cache_library):
		printerr("ItemManager: Invalid link cache library '%s'. Returning empty array." % __cache_library)
		return []
	var __matched_keys: Array = []
	var __head_arr: Array = []
	var __library: Dictionary = item_cache.get(__cache_library)
	for __key: String in __library.keys():
		for __match_str: String in __match_string:
			if __key.matchn(__match_str):
				__matched_keys.push_front(__key)
	for __key: String in __matched_keys:
		var __get: Array = __library.get(__key, [])
		if not __get.is_empty():
			__head_arr.append(__get)
	return __head_arr

func reload_cache(__items: Array[Item]) -> void:
	#item_cache.clear()
	# { Item.id: [Item wref], ... }
	item_cache.set("by_item_id", cache_by_item_id(__items))
	# { Prop.id: [Item wref, Prop wref], ... }
	item_cache.set("by_property_id", cache_by_property_id(__items))
	item_cache.set("by_descriptor_id", cache_by_descriptor_id(__items))
	# { Descriptor.alias: [Item wref, Prop wref, Prop.id], ... }
	item_cache.set("by_descriptor_alias", cache_by_descriptor_alias(__items))
	# { Descriptor.id: Descriptor wref, ... }
	item_cache.set("by_descriptor", cache_by_descriptor(__items))
	# { Param.id: [Item wref, Prop wref, Prop.id], ... }
	item_cache.set("by_parameter_id", cache_by_parameter_id(__items))
	# { Link.from: [Item wref, Prop wref, Prop.id, Link.to], ... }
	item_cache.set("by_links", cache_links(__items))

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
			__cache.set(__prop.id, [weakref(__item), weakref(__prop)])
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
			__cache.set(__prop.id, [weakref(__item), weakref(__prop)])
	return __cache

func cache_by_descriptor(__items: Array[Item]) -> Dictionary:
	if __items.is_empty(): return {}
	var __cache: Dictionary = {}
	for __item_idx: int in __items.size():
		var __item: Item = __items[__item_idx]
		var __props: Array[Descriptor] = __item.retrieve_descriptors()
		if __props.is_empty(): continue
		for __prop: Property in __props:
			__cache.set(__prop.id, weakref(__prop))
	return __cache

func cache_by_descriptor_alias(__items: Array[Item]) -> Dictionary:
	if __items.is_empty(): return {}
	var __cache: Dictionary = {}
	for __item_idx: int in __items.size():
		var __item: Item = __items[__item_idx]
		var __props: Array[Descriptor] = __item.retrieve_descriptors()
		if __props.is_empty(): continue
		for __prop: Descriptor in __props:
			var __cx: Array = []
			__cx.append_array([weakref(__item), weakref(__prop), __prop.id])
			__cache.set(__prop.alias, __cx)
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

func cache_links(__items: Array[Item]) -> Dictionary:
	if __items.is_empty(): return {}
	var __cache: Dictionary = {}
	for __item_idx: int in __items.size():
		var __item: Item = __items[__item_idx]
		var __props: Array[Link] = __item.retrieve_links()
		if __props.is_empty(): continue
		for __prop: Link in __props:
			var __cx: Array = []
			__cx.append_array([weakref(__item), weakref(__prop), __prop.from_id, __prop.to_id])
			__cache.set("%s@%s" % [__prop.from_id, __prop.to_id], __cx)
			#if __to_from: 
				#__cx.append(__prop.from_id)
				#__cache.set(__prop.to_id, __cx)
			#else:
				#__cx.append(__prop.to_id)
				#__cache.set(__prop.from_id, __cx)
	return __cache

#endregion ITEM CACHEING
#region ITEM STAGING

func stage_items(__items: Array[Item], __append_stage: bool = false) -> void:
	if __items.is_empty(): return
	if not __append_stage: staged_items.clear()
	for __item: Item in __items:
		var __ref: WeakRef = weakref(__item)
		staged_items.set(__item.id, __ref)
	stage_updated.emit()

func get_stage_size() -> int:
	return staged_items.size()

func get_staged_item_index(__indexes: Array) -> Array[Item]:
	var __items: Array[Item] = []
	var __stage_ids: Array[String] = staged_items.keys()
	if __indexes.is_empty(): return __items
	for __idx: int in __indexes:
		var __ref: WeakRef = staged_items.get(__stage_ids[__idx], null)
		var __item: Item = null
		if __ref == null or __ref.get_ref() == null:
			printerr("Item Manager: Failed to get reference for item in stage index %s" % __idx)
			continue
		__item = __ref.get_ref()
		__items.append(__item)
	return __items

func get_staged_item_by_id(__item_ids: Array[String]) -> Array[Item]:
	var __items: Array[Item] = []
	for __id: String in __item_ids:
		var __ref: WeakRef = staged_items.get(__id, null)
		var __item: Item = null
		if __ref == null or __ref.get_ref() == null: 
			printerr("Item Manager: Failed to get reference for staged item id %s" % __id)
			continue
		__item = __ref.get_ref()
		__items.append(__item)
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
#region CACHE LINK NETWORK

func cache_retrieve_link_network(__items: Array[Item]) -> Dictionary:
	var __network: Dictionary = {}
	var __fail: Array = []
	var __size: int = __items.size()
	if __size == 0: return __network
	elif __size == 1: 
		# Get all incoming links that match property IDs.
		var __item: Item = __items[0]
		var __match_ids: Array[String] = __item.retrieve_property_ids()
		var __cache: Array = cache_get_matched("by_links", __match_ids.map(
			func(id: String): return "*@%s" % id )) # Get links linked >TO< __match_ids
		if not __cache.is_empty():
			for __cx: Array in __cache:
				var __item_from_id: String = __cx[2] # Incoming ID
				var __linker_ref: WeakRef = __cx[0]
				var __item_ref: WeakRef = null
				if __item_from_id.begins_with("i_"): # Incoming ID is an item
					var __item_cx: Array = get_from_cache("by_item_id", __item_from_id)
					if __item_cx.is_empty(): continue
					__item_ref = __item_cx[0]
				elif  __item_from_id.begins_with("P_"): # Incoming ID is a property
					var __item_cx: Array = get_from_cache("by_property_id", __item_from_id)
					if __item_cx.is_empty(): continue
					__item_ref = __item_cx[0]
				else:
					__fail.append(__item_from_id) 
					continue
				__network.set(__item_from_id, 
				{
					"linking_item": __item_ref.get_ref(),
					"linker_item_id": __linker_ref.get_ref()
				})
	else: # Get common between all items
		printerr("cache_retrieve_link_network: __size > 1 not implemented")
	if __fail: printerr("ItemManager: Failed to identify ids %s for link network" % __fail)
	return __network

#endregion CACHE LINK NETWORK
