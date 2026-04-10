extends Object

## Deselect items. If items aren't selected, nothing happens.
func run(__manager: ItemManager, __param: Dictionary) -> bool: 
	var __item_ids: Array[int]
	var __deselect_indexes: Array[int]
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_idx" when __value is Array:
				for __id: int in __value:
					if __id is int:
						__item_ids.append(__id)
			_:
				push_warning("items.deselect.by_item_index: invalid key '%s'\
				-> item_idx" % __key)
	#endregion Parameter processing
	__manager.deselect_items_at_stage_index(__deselect_indexes)
	return true
