extends Object

## Remove properties to selected items by their index
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	# Every item in __args is a property
	var __rm_idx: Array[int] = []
	if __mod_item.selected_items.is_empty():
		push_warning("property.remove.selected_index: Nothing selected")
		return false
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"prop_idx" when __value is Array:
				for __idx: Variant in __value:
					if __idx is int:
						__rm_idx.append(int(__idx))
				if __rm_idx.is_empty(): 
					return false
			_:
				push_warning("property.remove.selected_index:: invalid key '%s'\
				-> prop_idx" % __key)
	#endregion Parameter processing
	var __success: bool = true
	for __item: Item in __mod_item.selected_items:
		if not __item.remove_properties_index(__rm_idx):
			__success = false
	
	return __success
