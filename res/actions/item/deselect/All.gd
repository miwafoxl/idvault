extends Object

## Deselects all selected items
func run(__manager: Manager, __param: Dictionary) -> bool:
	__manager.selected_items.clear()
	return true
