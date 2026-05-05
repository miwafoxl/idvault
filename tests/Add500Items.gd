extends Object


var procedures: Array[Callable] = []

## Adds 500 items and removes all 500 afterwards
func run(__mod_item: ItemModule, __mod_action: ActionModule) -> int:
	#region PROCEDURES
	procedures = [
		__mod_action.run.bindv([&"items.append.testitem", {"count": 500}]),
		func() -> bool: return __mod_item.unordered_items.size() == 500,
		__mod_action.run.bindv([&"items.stage.unordered", {}]),
		__mod_action.run.bindv([&"items.select.by_item_index", {"item_idx": range(500)}]),
		func() -> bool: return __mod_item.selected_items.size() == 500,
		__mod_action.run.bindv([&"items.remove.selected", {}]),
		func() -> bool: return __mod_item.unordered_items.size() == 0,
		func() -> bool: return __mod_item.selected_items.size() == 0,
		func() -> bool: return __mod_item.staged_items.size() == 0,
	]
	#endregion PROCEDURES
	#region CALL PROCEDURES
	for i in procedures.size():
		var __call: Callable = procedures[i]
		if __call.call() == false:
			return i
	#endregion CALL PROCEDURES
	return -1
