extends Object

## Removes specific properties from items by property ID
func run(__manager: Manager, __args: Array) -> bool:
	var __items: Array[Item] = []
	var __rm_property_ids: Array[String] = []
	for i: int in __args.size():
		match i:
			0: # Array of Items
				assert(__args[i] is Array)
				for __arg in __args[i]:
					if __arg is Item: __items.append(__arg as Item)
				if __items.is_empty(): 
					return false
			1: # Array of strings (property IDs to remove)
				assert(__args[i] is Array)
				for __arg in __args[i]:
					if __arg is String: 
						__rm_property_ids.append(__arg as String)
				if __rm_property_ids.is_empty():
					return false
	for __item: Item in __items:
		__item.remove_proprieties(__rm_property_ids)
	return true
