extends Object


var procedures: Array[Callable] = []

## Adds 100 items and removes all 100 afterwards
func run(__mod_item: ItemModule, __mod_action: ActionModule) -> int:
	#region PROCEDURES
	procedures = [
		__mod_action.run.bindv([&"items.append.testitem", {"count": 100}]),
		func() -> bool: return __mod_item.unordered_items.size() == 100,
		__mod_action.run.bindv([&"items.stage.unordered", {}]),
		__mod_action.run.bindv([&"items.select.by_item_index", {"item_idx": range(100)}]),
		func() -> bool: return __mod_item.selected_items.size() == 100,
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
