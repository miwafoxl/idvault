extends Object

## Creates and appends an empty item
func run(__manager: ItemManager, __param: Dictionary) -> bool:
	return __manager.append_items([Item.new("", [
		Display.new(RandomString.new("", 12).value, "first test here"\
		.repeat(randi() % 2))
	])])
