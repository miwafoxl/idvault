extends Object

## Toggle selection for items by Item ID. If items aren't existent, nothing happens.
func run(__manager: ItemManager, __param: Dictionary) -> bool: 
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
				push_warning("items.select.by_item_id: invalid key '%s'\
				-> item_id" % __key)
	#endregion Parameter processing
	var __cached: Array = __manager.get_from_cache_many("by_item_id", __item_ids)
	var __deselect: Array[Item]
	var __select: Array[Item]
	for __item_cx: Array in __cached:
		var __item: Item = (__item_cx[0] as WeakRef).get_ref()
		if __item == null: continue
		__deselect.append(__item)
	for i: int in __deselect.size():
		var __item: Item = __deselect[i]
		if __item not in __manager.selected_items:
			__select.append(__item)
			__deselect.set(i, null)
	__manager.select_items(__select, true)
	__manager.deselect_items(__deselect)
	return true
