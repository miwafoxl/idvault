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
	else:
		__menu.add_item(tr(&"PANEL.ITEMLIST.ITEM_PROPERTIES"))
		__menu.add_item(tr(&"PANEL.ITEMLIST.MANAGE_LINKS"))
		__menu.add_item(tr(&"PANEL.ITEMLIST.DUPLICATE"))
	__menu.add_item(tr(&"PANEL.ITEMLIST.QUERY_LINKED_ITEMS"))
	__menu.add_item(tr(&"PANEL.ITEMLIST.QUERY_UNLINKED_ITEMS"))
	__menu.add_item(tr(&"PANEL.ITEMLIST.DELETE_ITEMS"))
	return __menu
