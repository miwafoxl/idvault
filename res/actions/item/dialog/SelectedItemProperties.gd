extends Object

## Opens the item properties dialog
func run(__manager: ItemManager, __param: Dictionary) -> bool:
	__manager.trigger_dialog.emit(&"item_properties", {
		"item": __manager.selected_items[0]}) # TODO: Support bulk edit
	return true
