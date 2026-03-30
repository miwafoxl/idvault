extends Object

## Deselects all selected items
func run(__manager: Manager, __args: Array) -> bool:
	__manager.selected_items.clear()
	return true
