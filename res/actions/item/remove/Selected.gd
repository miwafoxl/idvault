extends Object

## Delete selected items. Run with caution.
func run(__manager: ItemManager, __param: Dictionary) -> bool:
	if __manager.selected_items.is_empty():
		push_warning("items.remove.selected: Nothing selected")
		return false
	var __rm_indexes: Array[int]
	for __item: Item in __manager.selected_items:
		var __idx: int = __manager.unordered_items.find(__item)
		__rm_indexes.append(__idx)
	__manager.selected_items.clear() # Deselects
	__manager.remove_items_unordered(__rm_indexes)
	return true
