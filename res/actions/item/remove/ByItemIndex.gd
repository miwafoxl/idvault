extends Object

## Removes items by index
func run(__manager: Manager, __param: Dictionary) -> bool: 
	var __indexes: Array[int]
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_idx" when __value is Array:
				for __id: int in __value:
					if __id is int:
						__indexes.append(__id)
			_:
				push_warning("items.remove.by_item_index: invalid key '%s'\
				-> item_idx" % __key)
	#endregion Parameter processing
	return __manager.remove_items_stage_index(__indexes)
