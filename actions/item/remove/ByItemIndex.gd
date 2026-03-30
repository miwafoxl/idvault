extends Object

## Removes items by index
func run(__manager: Manager, __args: Array) -> bool: 
	# Each int in the args array is an Item index
	var __indexes: Array[int]
	for __idx: int in __args:
		if __idx is int:
			__indexes.append(__idx)
	return __manager.remove_items(__indexes)
