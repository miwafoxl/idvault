extends Object

## Select items by Item index. If items aren't existent, nothing happens.
func run(__manager: Manager, __args: Array) -> bool: 
	# Each int in the args array is an Item ID
	var __item_ids: Array[int]
	var __select_indexes: Array[int]
	for __id: int in __args:
		if __id is int:
			__item_ids.append(__id)
	var __get_id: Array[Item] = __manager.get_item_by_id(__item_ids)
	for __item: Item in __get_id:
		var __idx: int = __manager.unordered_items.find(__item)
		__select_indexes.append(__idx)
	__manager.select_items_at_index(__select_indexes, false)
	return true
