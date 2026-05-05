extends Object

## Describe your menu here
func build(__param: Dictionary) -> ContextMenu:
	var __menu: ContextMenu = ContextMenu.new()
	var __item_id: String
	var __param_idx: int
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_id" when __value is String:
				__item_id = __value
			"param_idx" when __value is int:
				__param_idx = __value
			_:
				push_warning("property.menu: invalid key '%s'\
				-> item_id, param_idx" % __key)
	#endregion Parameter processing
	
	__menu.add_item(tr(&"DIALOG.ITEM_PROPERTIES.PROPERTY_MOVE_UP"))
	__menu.set_item_metadata(-1, {&"items.reorder.by_property_index": {
		"item_id": __item_id,
		"param_idx": [__param_idx],
		"new_idx": __param_idx - 1
	} })
	
	__menu.add_item(tr(&"DIALOG.ITEM_PROPERTIES.PROPERTY_MOVE_DOWN"))
	__menu.set_item_metadata(-1, {&"items.reorder.by_property_index": {
		"item_id": __item_id,
		"param_idx": [__param_idx],
		"new_idx": __param_idx + 1
	} })
	
	__menu.add_separator()
	
	__menu.add_item(tr(&"DIALOG.ITEM_PROPERTIES.PROPERTY_SAVE"))
	__menu.set_item_metadata(-1, {&"property.export": {} })

	__menu.add_item(tr(&"DIALOG.ITEM_PROPERTIES.PROPERTY_LOAD"))
	__menu.set_item_metadata(-1, {&"property.load_into.property_id": {} })
	
	__menu.add_separator()
	
	__menu.add_item(tr(&"DIALOG.ITEM_PROPERTIES.PROPERTY_RENAME"))
	__menu.set_item_metadata(-1, {&"property.rename.by_property_id": {} })
	
	__menu.add_item(tr(&"DIALOG.ITEM_PROPERTIES.PROPERTY_DUPLICATE"))
	__menu.set_item_metadata(-1, {&"items.append.properties_to_selected": {} })
	
	__menu.add_item(tr(&"DIALOG.ITEM_PROPERTIES.PROPERTY_DELETE"))
	__menu.set_item_metadata(-1, {&"items.remove.property_id": {} })
	
	return __menu
