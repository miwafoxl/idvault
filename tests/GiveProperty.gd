extends Object


var procedures: Array[Callable] = []

## Adds an item and removes it afterwards
func run(__mod_item: ItemModule, __mod_action: ActionModule) -> int:
	#region PROCEDURES
	procedures = [
		__mod_action.run.bindv([&"items.append.items", {"count": 1}]),
		func() -> bool: return __mod_item.unordered_items.size() > 0,
		__mod_action.run.bindv([&"items.stage.unordered", {}]),
		__mod_action.run.bindv([&"items.select.by_item_index", {"item_idx": [0]}]),
		func() -> bool: return __mod_item.selected_items.size() > 0,
		__mod_action.run.bindv([&"property.append.selected", {"properties" : [
			Display.new("test")]} ]),
		func() -> bool: return __mod_item.selected_items[0].has_display(),
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
