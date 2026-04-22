extends Object

## Removes items by ID
func run(__manager: ItemManager, __param: Dictionary) -> bool: 
	var __item_ids: Array[String]
	var __rm_indexes: Array[int]
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_id" when __value is Array:
				for __id: Variant in __value:
					if __id is String:
						__item_ids.append(__id)
			_:
				push_warning("items.remove.by_item_id: invalid key '%s'\
				-> item_id" % __key)
	#endregion Parameter processing
	var __get_id: Array[Item] = __manager.get_item_by_id(__item_ids)
	for __item: Item in __get_id:
		var __idx: int = __manager.unordered_items.find(__item)
		__rm_indexes.append(__idx)
	return __manager.remove_items_unordered_index(__rm_indexes)
