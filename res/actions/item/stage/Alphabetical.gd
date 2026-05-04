extends Object

func order(a: Item, b: Item) -> bool:
	var a_text: String = a.get_valid_string_display_or_empty()
	var b_text: String = b.get_valid_string_display_or_empty()
	if a_text.is_empty() and b_text.is_empty(): return false # i don't know man
	if a_text.is_empty() and !b_text.is_empty(): return false
	if !a_text.is_empty() and b_text.is_empty(): return true
	
	for i: int in a_text.length():
		var __a_char: int = a_text.unicode_at(i)
		for u: int in b_text.length():
			var __b_char: int = b_text.unicode_at(i)
			if __a_char > __b_char: return true
			else: return false
	return false

## Stage items in alphabetically
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	var __items: Array[Item] = []
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item" when __value is Array:
				for __arg in __value:
					if __arg is Item: __items.append(__arg as Item)
	#endregion Parameter processing
	if __items.is_empty():
		__items = __mod_item.unordered_items
	__items.sort_custom(order)
	__mod_item.stage_items(__items)
	return true
