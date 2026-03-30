extends Object

## Deselect items. If items aren't selected, nothing happens.
func run(__manager: Manager, __args: Array) -> bool: 
	# Each int in the args array is an Item ID
	var __item_ids: Array[int]
	for __id: int in __args:
		if __id is int:
			__item_ids.append(__id)
	var __get_id: Array[Item] = __manager.get_item_by_id(__item_ids)
	__manager.deselect_items(__get_id)
	return true
