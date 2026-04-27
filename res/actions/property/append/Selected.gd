extends Object

## Append properties to selected items
func run(__manager: ItemManager, __param: Dictionary) -> bool:
	# Every item in __args is a property
	var __properties: Array[Property] = []
	if __manager.selected_items.is_empty():
		push_warning("items.append.property_to_selected: Nothing selected")
		return false
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"properties" when __value is Array:
				for __property: Variant in __value:
					if __property is Property:
						__properties.append(__property as Property)
				if __properties.is_empty(): 
					return false
			_:
				push_warning("items.append.property_to_selected: invalid key '%s'\
				-> properties" % __key)
	#endregion Parameter processing
	var __success: bool = true
	for __item: Item in __manager.selected_items: # TODO: Make this less destructive in case it fails
		if not __item.append_properties(__properties):
			__success = false
	
	if __success: # TODO: reload_cache only affected items
		__manager.reload_cache(__manager.unordered_items)
		__manager.stage_updated.emit()
		__manager.trigger.emit(Trigger.new(
			Trigger.TriggerTypes.UI_REQUEST,
			&"update_item_properties"
		))
	return __success
