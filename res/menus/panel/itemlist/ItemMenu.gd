extends Object

## Describe your menu here
func build() -> PopupMenu:
	var __menu: PopupMenu = PopupMenu.new()
	__menu.add_item("PANEL.ITEMLIST.ITEM_PROPERTIES")
	__menu.add_item("PANEL.ITEMLIST.MANAGE_LINKS")
	__menu.add_item("PANEL.ITEMLIST.QUERY_LINKED_ITEMS")
	__menu.add_item("PANEL.ITEMLIST.QUERY_UNLINKED_ITEMS")
	__menu.add_item("PANEL.ITEMLIST.QUERY_DELETE_ITEM")
	return __menu
