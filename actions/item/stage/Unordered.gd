extends Object

## Stage items as its given, no sorting is performed.
func run(__manager: Manager, __param: Dictionary) -> bool:
	var __items: Array[Item] = []
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item" when __value is Array:
				for __arg in __value:
					if __arg is Item: __items.append(__arg as Item)
				if __items.is_empty(): 
					return false
			_:
				push_warning("item.stage.alphabetical: invalid key '%s'\
				-> item" % __key)
	#endregion Parameter processing
	if __items.is_empty():
		push_warning("items.stage.unordered: No items to stage")
		return false
	__manager.stage_items(__items)
	return true
