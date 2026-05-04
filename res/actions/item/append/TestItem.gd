extends Object

## Creates and appends an empty item
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	var __random_props: Array[Property] = [
		Display.new(RandomString.new("", 12).value, "first test here".repeat(randi() % 3)),
		#Date.new(Vector3i(1999, 2, 1)),
		#RangedDate.new([Vector3i(1999, 1, 1), Vector3i.ZERO])
	]
	var __props: Array[Property] = [__random_props.pick_random()]
	if __mod_item.unordered_items.size() > 0 and true:
		var __descriptors: Dictionary = __mod_item.item_cache.get("by_descriptor", {})
		var __descriptors_id: Array
		if not __descriptors.is_empty(): 
			__descriptors_id = __descriptors.keys()
			__props.append(Link.new(
				__mod_item.unordered_items.pick_random().id, # FROM ID
				__descriptors_id.pick_random(), # TO ID
		))
	
	var __items: Array[Item]
	if __mod_item.unordered_items.size() == 0:
		__props.append(Descriptor.new(["abc", "def", "ghj"].pick_random()))
	__items.append(Item.new("", __props))
	
	return __mod_item.append_items(__items)
