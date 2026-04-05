extends Object

## Removes specific properties from items by property ID
func run(__manager: Manager, __param: Dictionary) -> bool:
	var __items: Array[Item] = []
	var __rm_property_ids: Array[String] = []
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item" when __value is Array:
				for __arg in __value:
					if __arg is Item: __items.append(__arg as Item)
				if __items.is_empty(): 
					return false
			"property_id" when __value is Array:
				for __arg in __value:
					if __arg is String: 
						__rm_property_ids.append(__arg as String)
				if __rm_property_ids.is_empty():
					return false
			_:
				push_warning("item.remove.property_id: invalid key '%s'\
				-> item, property_id" % __key)
	#endregion Parameter processing
	for __item: Item in __items:
		__item.remove_properties(__rm_property_ids)
	return true
