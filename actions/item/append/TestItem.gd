extends Object

## Creates and appends an empty item
func run(__manager: Manager, __args: Array[Variant]) -> bool:
	return __manager.append_items([Item.new(__manager.unordered_items.size(), [
		Display.new("a".repeat(randi() % 10), "first test here".repeat(randi() % 2))
	])])
