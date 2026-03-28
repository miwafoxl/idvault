extends Object

## Creates and appends an item with proprietes
func run(__manager: Manager, __args: Array[Variant]) -> bool: # [id, elements..]
	var __id: int = __manager.unordered_items.size()
	if not __args.is_empty() and __args[0] is int:
		__id = int(__args[0])
		__args.pop_front()
	return __manager.append_items([Item.new(__id, __args)])
