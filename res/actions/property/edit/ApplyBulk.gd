extends Object

## Get property changes and apply
func run(__manager: ItemManager, __param: Dictionary) -> bool:
	var __add: Dictionary # {Item.id: [New prop ref]} -> push into
	var __mod: Dictionary # {Prop.id: New prop ref} -> copy into 
	var __rem: Dictionary # {Item.id: [Prop.id]} -> remove_properties
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"add" when __value is Dictionary:
				__add = __value
			"mod" when __value is Dictionary:
				__mod = __value
			"rem" when __value is Dictionary:
				__rem = __value
			_:
				push_warning("property.edit.apply_bulk: invalid key '%s'\
				-> add, mod, rem" % __key)
	#endregion Parameter processing
	var __items_updated: Array[Item] = []
	if __add.is_empty() and __mod.is_empty() and __rem.is_empty(): 
		print("property.edit.apply_bulk: no changes received.")
		return true
	
	# Adding properties
	for __item_id: String in __add:
		var __item_cx: Array = __manager.get_from_cache("by_item_id", __item_id)
		if __item_cx.is_empty():
			push_warning("property.edit.apply_bulk: Failed to " + \
			"get cache for item id '%s' (item might have been deleted)." % [__item_id])
			continue
		var __item: Item = (__item_cx[0] as WeakRef).get_ref()
		if __item == null:
			push_warning("property.edit.apply_bulk: Failed to " + \
			"get reference to item id '%s' (item might have been deleted)." % [__item_id])
			continue
		__item.append_properties(__add[__item_id])
		__items_updated.append(__item)
	
	# Removing properties
	for __item_id: String in __rem:
		var __item_cx: Array = __manager.get_from_cache("by_item_id", __item_id)
		if __item_cx.is_empty():
			push_warning("property.edit.apply_bulk: Failed to " + \
			"get cache for item id '%s' (item might have been deleted)." % [__item_id])
			continue
		var __item: Item = (__item_cx[0] as WeakRef).get_ref()
		if __item == null:
			push_warning("property.edit.apply_bulk: Failed to " + \
			"get reference to item id '%s' (item might have been deleted)." % [__item_id])
			continue
		__item.remove_properties(__rem[__item_id])
		__items_updated.append(__item)
	
	# Modifying existing properties
	for __prop_id: String in __mod:
		var __get_prop: Array = __manager.get_from_cache("by_property_id", __prop_id)
		var __get_modified_prop: Dictionary = __mod[__prop_id]
		var __item: Item = (__get_prop[0] as WeakRef).get_ref()
		var __prop: Property = (__get_prop[1] as WeakRef).get_ref()
		if __prop == null or __item == null:
			push_warning("property.edit.apply_bulk: Failed to " + \
			"get reference to item id or its containg property id '%s'." % [__prop_id])
			continue
		__prop.serialize(__get_modified_prop)
		__items_updated.append(__item)
	
	if __items_updated: 
		__manager.reload_cache(__manager.unordered_items)
		__manager.stage_updated.emit()
	return true
