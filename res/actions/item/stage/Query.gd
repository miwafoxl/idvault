extends Object

## Query items and stage them unorderly.
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	var __items: Array[Item] = []
	var __query: String = ""
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"query" when __value is String:
				__query = __value
			"item" when __value is Array:
				for __arg in __value:
					if __arg is Item: __items.append(__arg as Item)
	#endregion Parameter processing
	if __items.is_empty():
		__items = __mod_item.unordered_items
	#__mod_item.stage_items(__items)
	var _q: Query = Query.new(__query, __items, __mod_item, true)
	if not _q.filtered.is_empty():
		__mod_item.stage_items(_q.filtered)
	else:
		printerr("items.stage.query: No items were given by query")
	return true
