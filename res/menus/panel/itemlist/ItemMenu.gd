extends Object

## Describe your menu here
func build(__param: Dictionary) -> ContextMenu:
	var __menu: ContextMenu = ContextMenu.new()
	var __items_id: Array[int] = []
	var __items_size: int
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_id" when __value is Array:
				for __id: int in __value:
					if __id is int:
						__items_id.append(__id)
			_:
				push_warning("panel.itemlist.item_Menu: invalid key '%s'\
				-> item_id" % __key)
	#endregion Parameter processing
	__items_size =__items_id.size() 
	if __items_size > 1:
		__menu.add_item(tr(&"PANEL.ITEMLIST.MANAGE_COMMON_LINKS"))
		__menu.set_item_metadata(-1, {&"items.open_dialog.editor_common_links": {} })
	else:
		__menu.add_item(tr(&"PANEL.ITEMLIST.ITEM_PROPERTIES"))
		__menu.set_item_metadata(-1, {&"items.open_dialog.editor_item_properties": {} })
		
		__menu.add_item(tr(&"PANEL.ITEMLIST.MANAGE_LINKS"))
		__menu.set_item_metadata(-1, {&"items.open_dialog.editor_links": {} })
	__menu.add_separator()

	__menu.add_item(tr(&"PANEL.ITEMLIST.QUERY_LINKED_ITEMS_WITH_TAGS"))
	__menu.set_item_metadata(-1, {&"items.query.selected_tagged": {} })
	
	__menu.add_item(tr(&"PANEL.ITEMLIST.QUERY_UNLINKED_ITEMS_WITH_TAGS"))
	__menu.set_item_metadata(-1, {&"items.query.selected_tagged_negate": {} })
		
	__menu.add_item(tr(&"PANEL.ITEMLIST.QUERY_LINKED_ITEMS"))
	__menu.set_item_metadata(-1, {&"items.query.selected": {} })
	
	__menu.add_item(tr(&"PANEL.ITEMLIST.QUERY_UNLINKED_ITEMS"))
	__menu.set_item_metadata(-1, {&"items.query.selected_negate": {} })
	
	
	__menu.add_separator()
	
	__menu.add_item(tr(&"PANEL.ITEMLIST.CLIPBOARD_SELECTED_ITEM_TEXT"))
	__menu.set_item_metadata(-1, {&"items.to_clipboard.selected_display": {} })
	
	__menu.add_item(tr(&"PANEL.ITEMLIST.CLIPBOARD_SELECTED_LINKED_TAGS"))
	__menu.set_item_metadata(-1, {&"items.to_clipboard.selected_linked_tags": {} })
	
	__menu.add_separator()
	
	__menu.add_item(tr(&"PANEL.ITEMLIST.DUPLICATE_ITEMS"))
	__menu.set_item_metadata(-1, {&"items.duplicate.selected": {"select": false} })
	__menu.add_item(tr(&"PANEL.ITEMLIST.DUPLICATE_ITEMS_AND_SELECT"))
	__menu.set_item_metadata(-1, {&"items.duplicate.selected": {"select": true} })
	
	__menu.add_item(tr(&"PANEL.ITEMLIST.DELETE_ITEMS"))
	__menu.set_item_metadata(-1, {&"items.remove.selected": {} })
	return __menu
