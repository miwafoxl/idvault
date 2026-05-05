extends Object

## Delete selected items. Run with caution.
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	if __mod_item.selected_items.is_empty():
		push_warning("items.remove.selected: Nothing selected")
		return false
	__mod_item.remove_items_unordered(__mod_item.selected_items.duplicate())
	__mod_item.selection_updated.emit()
	return true
