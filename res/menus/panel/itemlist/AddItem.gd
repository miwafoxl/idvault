extends Object

## Menu in ItemListPanel 
func build(__param: Dictionary) -> ContextMenu:
	var __menu: ContextMenu = ContextMenu.new()
	__menu.add_item(tr(&"PANEL.ITEMLIST.NEW_ITEM_EMPTY"))
	__menu.set_item_metadata(-1, {&"items.append.items": {"open_properties": true} })
	
	__menu.add_item(tr(&"PANEL.ITEMLIST.NEW_ITEM_DESCRIPTOR"))
	__menu.set_item_metadata(-1, {&"items.append.items": {
		"properties": [Descriptor.new("")],
		"open_properties": true} })

	__menu.add_item(tr(&"PANEL.ITEMLIST.NEW_ITEM_TEST"))
	__menu.set_item_metadata(-1, {&"items.append.testitem": {} })
	
	__menu.add_item(tr(&"PANEL.ITEMLIST.LOAD_ITEM_FILE"))
	__menu.set_item_metadata(-1, {&"items.append.testitem": {} })
	__menu.set_item_disabled(-1, true)

	__menu.add_separator()

	__menu.add_item(tr(&"PANEL.ITEMLIST.EDIT_ITEM_SELECTED"))
	__menu.set_item_metadata(-1, {&"items.dialog.selected_item_properties": {} })

	__menu.add_item(tr(&"PANEL.ITEMLIST.EXPORT_ITEM_SELECTED"))
	__menu.set_item_metadata(-1, {&"items.dialog.selected_item_export": {} })

	__menu.add_item(tr(&"PANEL.ITEMLIST.DELETE_ITEM_SELECTED"))
	__menu.set_item_metadata(-1, {&"items.remove.selected": {} })
	return __menu
