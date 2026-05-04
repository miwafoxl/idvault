extends Object

## Opens the item properties dialog
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	if __mod_item.selected_items.is_empty(): return true
	__mod_item.trigger.emit(Trigger.new(
		Trigger.TriggerTypes.UI_REQUEST,
		&"dialog:item_properties", {
			"item": __mod_item.selected_items[0]} 
	)) # TODO: Support bulk edit
	return true
