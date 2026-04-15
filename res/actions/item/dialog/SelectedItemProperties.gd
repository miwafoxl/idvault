extends Object

## Opens the item properties dialog
func run(__manager: ItemManager, __param: Dictionary) -> bool:
	if __manager.selected_items.is_empty(): return true
	__manager.trigger.emit(Trigger.new(
		Trigger.TriggerTypes.UI_REQUEST,
		&"item_properties", {
			"item": __manager.selected_items[0]} 
	)) # TODO: Support bulk edit
	return true
