extends Object

## Describe your menu here
func build(__param: Dictionary) -> ContextMenu:
	var __menu: ContextMenu = ContextMenu.new()
	
	__menu.add_item(tr(&"DIALOG.ITEM_PROPERTIES.PROPERTY_MOVE_UP"))
	__menu.set_item_metadata(-1, {&"items.reorder.property_by_id": {} })
	
	__menu.add_item(tr(&"DIALOG.ITEM_PROPERTIES.PROPERTY_MOVE_DOWN"))
	__menu.set_item_metadata(-1, {&"items.reorder.property_by_id": {} })
	
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
