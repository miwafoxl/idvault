extends Object

## Deselect items. If items aren't selected, nothing happens.
func run(__mod_item: ItemModule, __param: Dictionary) -> bool: 
	var __item_ids: Array[String]
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_id" when __value is Array:
				for __id: Variant in __value:
					if __id is String:
						__item_ids.append(__id)
			_:
				push_warning("items.deselect.by_item_id: invalid key '%s'\
				-> item_id" % __key)
	#endregion Parameter processing
	var __get_id: Array[Item] = __mod_item.get_item_by_id(__item_ids)
	__mod_item.deselect_items(__get_id)
	return true
