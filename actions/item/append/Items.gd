extends Object

## Creates and appends a specified amount of empty items
func run(__manager: Manager, __args: Array) -> bool: 
	# [0 = starting id, 1 = count, 2 = proprietes]
	var __id: int = __manager.unordered_items.size()
	var __range: int = 1
	var __init_props: Array[Propriety] = []
	for i: int in __args.size():
		match i:
			0: 
				assert(__args[i] is int)
				if __args[i] <= __id or __args[i] == 0: continue
				__id = __args[i]
			1: 
				assert(__args[i] is int)
				__range = max(1, __args[i] % 1000)
			2:
				assert(__args[i] is Array[Propriety])
				__init_props = __args[i]
	var __ids: Array = range(__id, __id + __range)
	var __items: Array[Item] = []	
	for i: int in __ids:
		__items.append(Item.new(i, __init_props.duplicate(true)))
	return __manager.append_items(__items)
