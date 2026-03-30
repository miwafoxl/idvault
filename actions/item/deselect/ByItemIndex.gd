extends Object

## Deselect items. If items aren't selected, nothing happens.
func run(__manager: Manager, __args: Array) -> bool: 
	# Each int in the args array is an Item ID
	var __item_ids: Array[int]
	var __deselect_indexes: Array[int]
	for __id: int in __args:
		if __id is int:
			__item_ids.append(__id)
	var __get_id: Array[Item] = __manager.get_item_by_id(__item_ids)
	for __item: Item in __get_id:
		var __idx: int = __manager.unordered_items.find(__item)
		__deselect_indexes.append(__idx)
	__manager.deselect_items_at_index(__deselect_indexes)
	return true
