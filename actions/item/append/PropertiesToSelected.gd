extends Object

## Append proprieties to selected items
func run(__manager: Manager, __args: Array) -> bool:
	# Every item in __args is a property
	if __manager.selected_items.is_empty():
		push_warning("items.append.property_to_selected: Nothing selected")
		return false
	var __properties: Array[Property] = []
	for __prop: Variant in __args:
		if __prop is Property:
			__properties.append(__prop as Property)
	var __success: bool = true
	for __item: Item in __manager.selected_items: # TODO: Make this less destructive in case it fails
		if not __item.append_proprieties(__properties):
			__success = false
	return __success
