extends Object

## Delete selected items. Run with caution.
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	if __mod_item.selected_items.is_empty():
		push_warning("items.remove.selected: Nothing selected")
		return false
	var __rm_indexes: Array[int]
	for __item: Item in __mod_item.selected_items:
		var __idx: int = __mod_item.unordered_items.find(__item)
		__rm_indexes.append(__idx)
	__mod_item.remove_items_unordered(__mod_item.selected_items)
	__mod_item.selection_updated.emit()
	return true
