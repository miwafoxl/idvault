extends Object

## Creates and appends a specified amount of empty items
func run(__manager: ItemManager, __param: Dictionary) -> bool: 
	var __id: int = __manager.get_stage_size()
	var __range: int = 1
	var __init_props: Array[Property] = []
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_id" when __value is int:
				if __value <= __id or __value == 0: continue
				__id = __value
			"count" when __value is int:
				__range = max(1, __value % 1000)
			"properties" when __value is Array:
				for __property: Variant in __value:
					if __property is Property:
						__init_props.append(__property as Property)
			_:
				push_warning("item.append.items: invalid key '%s'\
				-> item_id, count, properties" % __key)
	#endregion Parameter processing
	var __ids: Array = range(__id, __id + __range)
	var __items: Array[Item] = []	
	for i: int in __ids:
		__items.append(Item.new(i, __init_props.duplicate(true)))
	return __manager.append_items(__items)
