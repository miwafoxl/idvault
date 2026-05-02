extends Object

## Get property changes and apply
func run(__manager: ItemManager, __param: Dictionary) -> bool:
	var __append: Dictionary # {Item.id: [New prop ref]} -> push into
	var __modify: Dictionary # {Prop.id: New prop ref} -> copy into 
	var __remove: Dictionary # {Item.id: [Prop.id]} -> remove_properties
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"ap" when __value is Dictionary:
				__append = __value
			"md" when __value is Dictionary:
				__modify = __value
			"rm" when __value is Dictionary:
				__remove = __value
			_:
				push_warning("property.edit.apply_bulk: invalid key '%s'\
				-> ap, md, rm" % __key)
	#endregion Parameter processing
	var __items_updated: Array[Item] = []
	if __append.is_empty() and __modify.is_empty() and __remove.is_empty(): 
		print("property.edit.apply_bulk: no changes received.")
		return true
	
	# Appending properties
	if __append:
		for __op_id: String in __append:
			var __item_id: String = __op_id.get_slice("@", 1)
			var __item_cx: Array = __manager.get_from_cache("by_item_id", __item_id)
			var __append_prop: Property = __append[__op_id][0]
			if __item_cx.is_empty():
				push_warning("property.edit.apply_bulk: Failed to " + \
				"get cache for item id '%s' (item might have been deleted)." % [__item_id])
				continue
			var __item: Item = (__item_cx[0] as WeakRef).get_ref()
			if __item == null:
				push_warning("property.edit.apply_bulk: Failed to " + \
				"get reference to item id '%s' (item might have been deleted)." % [__item_id])
				continue
			__item.append_properties([__append_prop])
			__items_updated.append(__item)
	
	# Removing properties
	if __remove:
		for __op_id: String in __remove:
			var __item_id: String = __op_id.get_slice("@", 1)
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
			__item.remove_properties(__remove[__op_id])
			__items_updated.append(__item)
	
	# Modifying existing properties
	if __modify:
		for __op_id: String in __modify:
			var __prop_id: String = __op_id.get_slice("@", 1)
			var __get_prop: Array = __manager.get_from_cache("by_property_id", __prop_id)
			var __get_modified_prop: Dictionary = __modify[__op_id]
			var __item: Item = (__get_prop[0] as WeakRef).get_ref()
			var __prop: Property = (__get_prop[1] as WeakRef).get_ref()
			if __prop == null or __item == null:
				push_warning("property.edit.apply_bulk: Failed to " + \
				"get reference to item id or its containg property id '%s'." % [__prop_id])
				continue
			__prop.serialize(__get_modified_prop)
			__items_updated.append(__item)
	
	if __items_updated:  # TODO: reload_cache only affected items
		__manager.reload_cache(__manager.unordered_items)
		__manager.stage_updated.emit()
		__manager.trigger.emit(Trigger.new(  # TODO: Temporary. Actions shoudn't trigger UI
			Trigger.TriggerTypes.UI_REQUEST, # requests directly, but not calling this trigger
			&"dialog:item_properties"))      # here won't update the item_preperties window.
	return true
