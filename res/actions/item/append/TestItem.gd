extends Object

## Creates and appends an empty item
func run(__manager: ItemManager, __param: Dictionary) -> bool:
	var __random_props: Array[Property] = [
		Display.new(RandomString.new("", 12).value, "first test here".repeat(randi() % 3)),
		Date.new(Vector3i(1999, 2, 1)),
		RangedDate.new([Vector3i(1999, 1, 1), Vector3i.ZERO])
	]
	if __manager.unordered_items.size() > 0 and true:
		var __descriptors: Dictionary = __manager.item_cache.get("by_descriptor", {})
		var __descriptors_id: Array
		if not __descriptors.is_empty(): 
			__descriptors_id = __descriptors.keys()
			__random_props.append(Link.new(
				__descriptors_id.pick_random(), # TO ID
				__manager.unordered_items.pick_random().id # FROM ID
		))
	
	var __items: Array[Item]
	var __props: Array[Property] = [__random_props.pick_random()]
	if __manager.unordered_items.size() == 0:
		__props.append(Descriptor.new(["abc", "def", "ghj"].pick_random()))
	__items.append(Item.new("", __props))
	
	return __manager.append_items(__items)
