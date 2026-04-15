extends Object

## Append selection of items by Item ID. If items aren't existent, nothing happens.
func run(__manager: ItemManager, __param: Dictionary) -> bool: 
	var __item_ids: Array[String]
	var __nothing_selected: bool = false
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_id" when __value is Array:
				for __id: Variant in __value:
					if __id is String:
						__item_ids.append(__id)
			"only_if_nothing_selected" when __value is bool:
				if __value is bool:
					__nothing_selected = __value
			_:
				push_warning("items.select.by_item_id_append: invalid key '%s'\
				-> item_id, only_if_nothing_selected" % __key)
	#endregion Parameter processing
	if __nothing_selected:
		if __manager.selected_items.is_empty(): return true
	var __get_id: Array[Item] = __manager.get_item_by_id(__item_ids)
	__manager.select_items(__get_id, true)
	return true
