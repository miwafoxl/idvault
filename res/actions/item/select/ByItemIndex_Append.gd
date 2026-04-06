extends Object

## Append items to selection by Item index. If items aren't existent, nothing happens.
func run(__manager: ItemManager, __param: Dictionary) -> bool: 
	# Each int in the args array is an Item ID
	var __item_ids: Array[int]
	var __select_indexes: Array[int]
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_idx" when __value is Array:
				for __id: int in __value:
					if __id is int:
						__item_ids.append(__id)
			_:
				push_warning("items.select.by_item_index_append: invalid key '%s'\
				-> item_idx" % __key)
	#endregion Parameter processing
	__manager.select_items_at_stage_index(__select_indexes)
	return true
