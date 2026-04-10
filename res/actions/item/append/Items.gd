extends Object

## Creates and appends a specified amount of empty items
func run(__manager: ItemManager, __param: Dictionary) -> bool: 
	var __range: int = 1
	var __init_props: Array[Property] = []
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"count" when __value is int:
				__range = max(1, __value % 1000)
			"properties" when __value is Array:
				for __property: Variant in __value:
					if __property is Property:
						__init_props.append(__property as Property)
			_:
				push_warning("item.append.items: invalid key '%s'\
				-> count, properties" % __key)
	#endregion Parameter processing
	var __ids: Array = range(__range)
	var __items: Array[Item] = []	
	for i: int in __ids:
		__items.append(Item.new("", __init_props.duplicate(true)))
	return __manager.append_items(__items)
