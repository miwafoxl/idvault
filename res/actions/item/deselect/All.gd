extends Object

## Deselects all selected items
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	__mod_item.selected_items.clear()
	return true
