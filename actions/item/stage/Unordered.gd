extends Object

## Stage items as its given, no sorting is performed.
func run(__manager: Manager, __args: Array) -> bool:
	var __items: Array[Item] = []
	for __item: Variant in __args:
		if __item is Item:
			__items.append(__item as Item)
	if __items.is_empty():
		push_warning("items.stage.unordered: No items to stage")
		return false
	__manager.stage_items(__items)
	return true
