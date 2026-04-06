extends Object

## Deselects all selected items
func run(__manager: ItemManager, __param: Dictionary) -> bool:
	__manager.selected_items.clear()
	return true
