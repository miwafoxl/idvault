extends Object

## Select items by Item index. If items aren't existent, nothing happens.
func run(__manager: ItemManager, __param: Dictionary) -> bool: 
	var __select_indexes: Array[int]
	var __nothing_selected: bool = false
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_idx" when __value is Array:
				for __id: int in __value:
					if __id is int:
						__select_indexes.append(__id)
			"only_if_nothing_selected" when __value is bool:
				if __value is bool:
					__nothing_selected = __value
			_:
				push_warning("items.select.by_item_index: invalid key '%s'\
				-> item_idx, only_if_nothing_selected" % __key)
	#endregion Parameter processing
	if __nothing_selected:
		if __manager.selected_items.is_empty(): return true
	__manager.select_items_at_stage_index(__select_indexes)
	return true
