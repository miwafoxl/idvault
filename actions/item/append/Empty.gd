extends Object

## Creates and appends a specified amount of empty items
func run(__manager: Manager, __args: Array) -> bool: 
	# [0 = starting id, 1 = count]
	var __id: int = __manager.unordered_items.size()
	var __range: int = 1
	for i: int in __args.size():
		match i:
			0: assert(__args[i] is int); __id = __args[i]
			1: assert(__args[i] is int); __range = __args[i]
	var __ids: Array = range(__id, __id + __range)
	var __items: Array[Item] = []	
	for i: int in __ids:
		__items.append(Item.new(i))
	return __manager.append_items(__items.duplicate(true))
