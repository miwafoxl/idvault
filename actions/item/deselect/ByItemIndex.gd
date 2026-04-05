extends Object

## Deselect items. If items aren't selected, nothing happens.
func run(__manager: Manager, __param: Dictionary) -> bool: 
	# Each int in the args array is an Item ID
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
	var __get_id: Array[Item] = __manager.get_item_by_id(__item_ids)
	for __item: Item in __get_id:
		var __idx: int = __manager.unordered_items.find(__item)
		__deselect_indexes.append(__idx)
	__manager.deselect_items_at_index(__deselect_indexes)
	return true
