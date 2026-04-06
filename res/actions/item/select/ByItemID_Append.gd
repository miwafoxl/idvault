extends Object

## Append selection of items by Item ID. If items aren't existent, nothing happens.
func run(__manager: ItemManager, __param: Dictionary) -> bool: 
	# Each int in the args array is an Item ID
	var __item_ids: Array[int]
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_id" when __value is Array:
				for __id: int in __value:
					if __id is int:
						__item_ids.append(__id)
			_:
				push_warning("items.select.by_item_id_append: invalid key '%s'\
				-> item_id" % __key)
	#endregion Parameter processing
	var __get_id: Array[Item] = __manager.get_item_by_id(__item_ids)
	__manager.select_items(__get_id, true)
	return true
